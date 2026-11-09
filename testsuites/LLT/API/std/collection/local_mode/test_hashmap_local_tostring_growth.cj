/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args
// EXEC: %run %run_opt %output H 4000 %run_args
// EXEC: %run %run_opt %output QH 4000 %run_args
// EXEC: %run %run_opt %output QL 4000 %run_args
// EXEC: %run %run_opt %output L 4000 %run_args
// T001: default covers H/QH/QL/L times sizes 0,1,8.
// T002/T003: select one scenario with <mode> <size> in an independent process.
// Modes: H=heap, QH=local?(heap), QL=local?(local!), L=local!.
// Size representative domain: 0,1,8,512,1000,2000,4000.
// A fatal rendering error remains a test failure. An LLT runner may stop at the
// first failed EXEC; use the selector to observe every mode/size independently.
// The expected output comes from the current map's public iterator and a heap
// StringBuilder, without assuming iteration order across different maps.
// Repeated growing-prefix concatenation suggests quadratic copying in the local
// implementation; this regression does not measure allocations or execution time.

import std.collection.*

class Counts {
    var cases: Int64 = 0
    var assertions: Int64 = 0
    var failed: Int64 = 0
}

func checkCount(label: String, context: String, want: Int64, got: Int64,
    counts: Counts): Unit {
    counts.assertions++
    if (want != got) {
        counts.failed++
        println("MISMATCH ${label} ${context}: want ${want} got ${got}")
    }
}

func formatExpected(map: HashMap<Int64, Int64> @local?, size: Int64,
    context: String, counts: Counts): String {
    let builder: StringBuilder @~local = StringBuilder()
    builder.append("[")
    var seen: Int64 = 0
    for ((key, value) in map) {
        if (seen > 0) { builder.append(", ") }
        builder.append("(")
        builder.append(key)
        builder.append(", ")
        builder.append(value)
        builder.append(")")
        seen++
    }
    builder.append("]")
    checkCount("oracle-entry-count", context, size, seen, counts)
    builder.toString()
}

func checkOutput(got: String @local?, want: String, context: String,
    counts: Counts): Unit {
    checkCount("output-length", context, want.size, got.size, counts)
    let common = if (got.size < want.size) { got.size } else { want.size }
    var byteFailures: Int64 = 0
    for (index in 0..common) {
        counts.assertions++
        let wantByte = want[index]
        let gotByte = got[index]
        if (wantByte != gotByte) {
            counts.failed++
            byteFailures++
            if (byteFailures <= 16) {
                println("MISMATCH output-byte ${context} index=${index}: want ${wantByte} got ${gotByte}")
            }
        }
    }
    if (byteFailures > 16) {
        println("DETAILS ${context}: byte-mismatches=${byteFailures} shown=16")
    }
}

func checkContents(map: HashMap<Int64, Int64> @local?, size: Int64,
    context: String, counts: Counts): Unit {
    checkCount("source-size", context, size, map.size, counts)
    for (key in 0..size) {
        counts.assertions++
        match (map.get(key)) {
            case Some(value) =>
                if (value != key) {
                    counts.failed++
                    println("MISMATCH source-value ${context} key=${key}: want ${key} got ${value}")
                }
            case None =>
                counts.failed++
                println("MISMATCH source-key ${context}: want present key=${key} got absent")
        }
    }
}

func complete(got: String @local?, want: String, map: HashMap<Int64, Int64> @local?,
    size: Int64, context: String, before: Int64, counts: Counts): Unit {
    checkOutput(got, want, context, counts)
    checkContents(map, size, context, counts)
    counts.cases++
    println("RESULT ${context} want-bytes=${want.size} got-bytes=${got.size} " +
        "failed=${counts.failed - before}")
}

func renderHeap(map: HashMap<Int64, Int64> @~local, size: Int64, counts: Counts): Unit {
    let context = "mode=H size=${size}"
    let before = counts.failed
    let want = formatExpected(map, size, context, counts)
    print("START ${context} want-bytes=${want.size} phase=render\n", flush: true)
    let got: String @~local = map.toString()
    complete(got, want, map, size, context, before, counts)
}

func renderShared(map: HashMap<Int64, Int64> @local?, mode: String,
    size: Int64, counts: Counts): Unit {
    let context = "mode=${mode} size=${size}"
    let before = counts.failed
    let want = formatExpected(map, size, context, counts)
    print("START ${context} want-bytes=${want.size} phase=render\n", flush: true)
    let got: String @local! = map.toString()
    complete(got, want, map, size, context, before, counts)
}

// The static local! receiver has no dedicated toString overload; it selects the
// local? overload. Keep the direct call here rather than widening the parameter.
exclave func renderOwned(map: HashMap<Int64, Int64> @local!, size: Int64,
    counts: Counts): Unit {
    let context = "mode=L size=${size}"
    let before = counts.failed
    let want = formatExpected(map, size, context, counts)
    print("START ${context} want-bytes=${want.size} phase=render\n", flush: true)
    let got: String @local! = map.toString()
    complete(got, want, map, size, context, before, counts)
}

func runScenario(mode: String, size: Int64, counts: Counts): Unit {
    if (mode == "H" || mode == "QH") {
        let map: HashMap<Int64, Int64> @~local = HashMap<Int64, Int64>(size)
        for (key in 0..size) { map.add(key, key) }
        if (mode == "H") {
            renderHeap(map, size, counts)
        } else {
            let view: HashMap<Int64, Int64> @local? = map
            renderShared(view, mode, size, counts)
        }
    } else {
        // Construct the local map itself; a heap alias cannot stand in for local!.
        let map: HashMap<Int64, Int64> @local! = HashMap<Int64, Int64>(size) @local!
        for (key in 0..size) { map.add(key, key) }
        if (mode == "L") {
            renderOwned(map, size, counts)
        } else {
            let view: HashMap<Int64, Int64> @local? = map
            renderShared(view, mode, size, counts)
        }
    }
}

func selectedSize(value: String): Int64 {
    match (value) {
        case "0" => 0
        case "1" => 1
        case "8" => 8
        case "512" => 512
        case "1000" => 1000
        case "2000" => 2000
        case "4000" => 4000
        case _ => -1
    }
}

func validMode(mode: String): Bool {
    mode == "H" || mode == "QH" || mode == "QL" || mode == "L"
}

func finish(planned: Int64, counts: Counts): Int64 {
    checkCount("completed-cases", "summary", planned, counts.cases, counts)
    println("SUMMARY planned=${planned} executed=${counts.cases} " +
        "assertions=${counts.assertions} failed=${counts.failed} disabled=0")
    // Preserve the exact count above while preventing successful 8-bit truncation.
    if (counts.failed > 255) { return 255 }
    counts.failed
}

main(args: Array<String>): Int64 {
    let counts = Counts()
    if (args.size == 0) {
        for (mode in ["H", "QH", "QL", "L"]) {
            for (size in [0, 1, 8]) { runScenario(mode, size, counts) }
        }
        return finish(12, counts)
    }
    if (args.size == 2) {
        let size = selectedSize(args[1])
        if (validMode(args[0]) && size >= 0) {
            runScenario(args[0], size, counts)
            return finish(1, counts)
        }
    }
    println("USAGE: <program> <H|QH|QL|L> <0|1|8|512|1000|2000|4000>; no arguments runs 12 small scenarios")
    2
}

// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// TIMEOUT: 90
// EXEC: %compiler %cmp_opt -g -O2 %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan checked exceptions: 4096/4096
// ASSERT: scan concurrent spawn creator pass

import std.runtime.*
import std.sync.*

let PRODUCER_COUNT: Int64 = 16
let BATCH_COUNT: Int64 = 8
let BATCH_SIZE: Int64 = 32

// Catch locally so thousands of exceptions do not flood the test log.
func throwAndCatch(id: Int64): Exception {
    try {
        throw IllegalArgumentException("storm-${id}")
    } catch (e: Exception) {
        return e
    }
}

func spawnA(id: Int64): Future<Exception> {
    return spawn { throwAndCatch(id) }
}

func spawnB(id: Int64): Future<Exception> {
    return spawn { throwAndCatch(id) }
}

func validException(error: Exception, id: Int64, useA: Bool): Bool {
    if (error.message != "storm-${id}") {
        return false
    }
    let trace = error.getStackTrace()
    var creatorCount = 0
    for (frame in trace) {
        if ((frame.methodName == "spawnA(Int64)" || frame.methodName == "spawnB(Int64)") &&
            frame.fileName.endsWith("08_concurrent_spawn.cj")) {
            creatorCount++
        }
    }
    if (trace.isEmpty()) {
        return false
    }
    let creator = trace[trace.size - 1]
    let expectedName = if (useA) { "spawnA(Int64)" } else { "spawnB(Int64)" }
    let expectedLine: Int64 = if (useA) { 30 } else { 34 }
    return creatorCount == 1 && creator.declaringClass == "default" &&
        creator.methodName == expectedName &&
        creator.fileName.endsWith("08_concurrent_spawn.cj") && creator.lineNumber == expectedLine
}

func produce(producerId: Int64, start: SyncCounter): Int64 {
    start.waitUntilZero(timeout: 10 * Duration.second)
    if (start.count != 0) {
        return 0
    }
    var checked: Int64 = 0
    for (batch in 0..BATCH_COUNT) {
        let baseId = (producerId * BATCH_COUNT + batch) * BATCH_SIZE
        let children = Array<Future<Exception>>(BATCH_SIZE, { index =>
            if (index % 2 == 0) {
                blackBox(spawnA)(baseId + index)
            } else {
                blackBox(spawnB)(baseId + index)
            }
        })
        for (index in 0..BATCH_SIZE) {
            let error = children[index].get(30 * Duration.second)
            if (validException(error, baseId + index, index % 2 == 0)) {
                checked++
            }
        }
    }
    return checked
}

main(): Int64 {
    let start = SyncCounter(1)
    let producers = Array<Future<Int64>>(PRODUCER_COUNT, { id => spawn { produce(id, start) } })
    start.dec()
    var checked: Int64 = 0
    for (producer in producers) {
        checked += producer.get(60 * Duration.second)
    }
    let expected = PRODUCER_COUNT * BATCH_COUNT * BATCH_SIZE
    println("checked exceptions: ${checked}/${expected}")
    if (checked == expected) {
        println("concurrent spawn creator pass")
        return 0
    }
    return 1
}

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
// T001: exhaust a 14-member representative domain, not the full String domain.
// Every ordered pair runs in 9 static mode combinations and 16 source combinations:
// @local? is tested separately with heap and genuinely constructed local! sources.
// String.compare is the semantic baseline: lexical bytes and length, independent of
// String comparison operators. Ordering is decoded by match, never by Ordering.==.
// String has a total order; NaN/Inf/Int64.Min are inapplicable to this input type.

class Counts {
    var executed: Int64 = 0
    var assertions: Int64 = 0
    var failed: Int64 = 0
    var disabled: Int64 = 0
}

func decodeOrdering(value: Ordering): Int64 {
    match (value) {
        case LT => -1
        case EQ => 0
        case GT => 1
    }
}

func record(op: String, context: String, want: Bool, got: Bool,
    details: String, counts: Counts): Unit {
    counts.assertions++
    if (want != got) {
        counts.failed++
        println("MISMATCH ${op} ${context}: want ${want} got ${got} ${details}")
    }
}

func recordResults(lt: Bool, le: Bool, gt: Bool, ge: Bool, eq: Bool, ne: Bool,
    order: Int64, context: String, counts: Counts): Unit {
    counts.executed++
    let wantLt = order < 0
    let wantLe = order <= 0
    let wantGt = order > 0
    let wantGe = order >= 0
    let wantEq = order == 0
    let wantNe = order != 0
    let details = "want(<,<=,>,>=)=(${wantLt},${wantLe},${wantGt},${wantGe}) " +
        "got(<,<=,>,>=)=(${lt},${le},${gt},${ge}) got(==,!=)=(${eq},${ne})"
    record("<", context, wantLt, lt, details, counts)
    record("<=", context, wantLe, le, details, counts)
    record(">", context, wantGt, gt, details, counts)
    record(">=", context, wantGe, ge, details, counts)
    record("==", context, wantEq, eq, details, counts)
    record("!=", context, wantNe, ne, details, counts)
    // Derive family checks from cached results, without executing operators again.
    record(">= iff !<", context, !lt, ge, details, counts)
    record("> iff !<=", context, !le, gt, details, counts)
    record("<= iff < || ==", context, lt || eq, le, details, counts)
    record(">= iff > || ==", context, gt || eq, ge, details, counts)
    record("!= iff !(==)", context, !eq, ne, details, counts)
}

// Keep each operator expression in its exact static-mode helper. In particular,
// local!/local! selects specialized == and !=, while its ordering uses local?.
func checkHH(a: String @~local, b: String @~local, order: Int64,
    context: String, counts: Counts): Unit {
    let lt = a < b
    let le = a <= b
    let gt = a > b
    let ge = a >= b
    let eq = a == b
    let ne = a != b
    recordResults(lt, le, gt, ge, eq, ne, order, context, counts)
}

func checkHQ(a: String @~local, b: String @local?, order: Int64,
    context: String, counts: Counts): Unit {
    let lt = a < b
    let le = a <= b
    let gt = a > b
    let ge = a >= b
    let eq = a == b
    let ne = a != b
    recordResults(lt, le, gt, ge, eq, ne, order, context, counts)
}

exclave func checkHL(a: String @~local, b: String @local!, order: Int64,
    context: String, counts: Counts): Unit {
    let lt = a < b
    let le = a <= b
    let gt = a > b
    let ge = a >= b
    let eq = a == b
    let ne = a != b
    recordResults(lt, le, gt, ge, eq, ne, order, context, counts)
}

func checkQH(a: String @local?, b: String @~local, order: Int64,
    context: String, counts: Counts): Unit {
    let lt = a < b
    let le = a <= b
    let gt = a > b
    let ge = a >= b
    let eq = a == b
    let ne = a != b
    recordResults(lt, le, gt, ge, eq, ne, order, context, counts)
}

func checkQQ(a: String @local?, b: String @local?, order: Int64,
    context: String, counts: Counts): Unit {
    let lt = a < b
    let le = a <= b
    let gt = a > b
    let ge = a >= b
    let eq = a == b
    let ne = a != b
    recordResults(lt, le, gt, ge, eq, ne, order, context, counts)
}

exclave func checkQL(a: String @local?, b: String @local!, order: Int64,
    context: String, counts: Counts): Unit {
    let lt = a < b
    let le = a <= b
    let gt = a > b
    let ge = a >= b
    let eq = a == b
    let ne = a != b
    recordResults(lt, le, gt, ge, eq, ne, order, context, counts)
}

exclave func checkLH(a: String @local!, b: String @~local, order: Int64,
    context: String, counts: Counts): Unit {
    let lt = a < b
    let le = a <= b
    let gt = a > b
    let ge = a >= b
    let eq = a == b
    let ne = a != b
    recordResults(lt, le, gt, ge, eq, ne, order, context, counts)
}

exclave func checkLQ(a: String @local!, b: String @local?, order: Int64,
    context: String, counts: Counts): Unit {
    let lt = a < b
    let le = a <= b
    let gt = a > b
    let ge = a >= b
    let eq = a == b
    let ne = a != b
    recordResults(lt, le, gt, ge, eq, ne, order, context, counts)
}

exclave func checkLL(a: String @local!, b: String @local!, order: Int64,
    context: String, counts: Counts): Unit {
    let lt = a < b
    let le = a <= b
    let gt = a > b
    let ge = a >= b
    let eq = a == b
    let ne = a != b
    recordResults(lt, le, gt, ge, eq, ne, order, context, counts)
}

func checkCount(label: String, want: Int64, got: Int64, counts: Counts): Unit {
    if (want != got) {
        counts.failed++
        println("MISMATCH count ${label}: want ${want} got ${got}")
    }
}

main(): Int64 {
    // Equal content from literal and Rune-array construction is deliberately kept
    // as distinct domain members. The last pair differs after a 33-byte prefix.
    let domain = ["", "a", "ab", String([r'a', r'b']), "abc", "a\u{0000}",
        "a\u{0000}b", "é", "e\u{0301}", "¢", "仓", "\u{1F600}",
        "012345678901234567890123456789012a", "012345678901234567890123456789012b"]
    let labels = ["empty", "a", "ab-literal", "ab-runes", "abc", "a\\u{0000}",
        "a\\u{0000}b", "\\u{00E9}-NFC", "e\\u{0301}-NFD", "\\u{00A2}", "\\u{4ED3}",
        "\\u{1F600}", "012345678901234567890123456789012a", "012345678901234567890123456789012b"]
    let counts = Counts()
    let planned = domain.size * domain.size * 16
    let plannedAssertions = planned * 11
    checkCount("domain", 14, domain.size, counts)
    checkCount("labels", domain.size, labels.size, counts)
    for (i in 0..domain.size) {
        for (j in 0..domain.size) {
            let heapA: String @~local = domain[i]
            let heapB: String @~local = domain[j]
            let order = decodeOrdering(heapA.compare(heapB))
            // These constructors create actual local! Strings; no heap-to-local cast.
            let localA: String @local! = String(heapA) @local!
            let localB: String @local! = String(heapB) @local!
            let qHeapA: String @local? = heapA
            let qHeapB: String @local? = heapB
            let qLocalA: String @local? = localA
            let qLocalB: String @local? = localB
            let inputs = "${i}:${labels[i]} vs ${j}:${labels[j]}"
            checkHH(heapA, heapB, order, "@~local/@~local " + inputs, counts)
            checkHQ(heapA, qHeapB, order, "@~local/@local?(heap) " + inputs, counts)
            checkHQ(heapA, qLocalB, order, "@~local/@local?(local!) " + inputs, counts)
            checkHL(heapA, localB, order, "@~local/@local! " + inputs, counts)
            checkQH(qHeapA, heapB, order, "@local?(heap)/@~local " + inputs, counts)
            checkQQ(qHeapA, qHeapB, order, "@local?(heap)/@local?(heap) " + inputs, counts)
            checkQQ(qHeapA, qLocalB, order, "@local?(heap)/@local?(local!) " + inputs, counts)
            checkQL(qHeapA, localB, order, "@local?(heap)/@local! " + inputs, counts)
            checkQH(qLocalA, heapB, order, "@local?(local!)/@~local " + inputs, counts)
            checkQQ(qLocalA, qHeapB, order, "@local?(local!)/@local?(heap) " + inputs, counts)
            checkQQ(qLocalA, qLocalB, order, "@local?(local!)/@local?(local!) " + inputs, counts)
            checkQL(qLocalA, localB, order, "@local?(local!)/@local! " + inputs, counts)
            checkLH(localA, heapB, order, "@local!/@~local " + inputs, counts)
            checkLQ(localA, qHeapB, order, "@local!/@local?(heap) " + inputs, counts)
            checkLQ(localA, qLocalB, order, "@local!/@local?(local!) " + inputs, counts)
            checkLL(localA, localB, order, "@local!/@local! " + inputs, counts)
        }
    }
    checkCount("executed", planned, counts.executed, counts)
    checkCount("assertions", plannedAssertions, counts.assertions, counts)
    checkCount("disabled", 0, counts.disabled, counts)
    println("String representative-domain=${domain.size} planned=${planned} executed=${counts.executed} " +
        "assertions-planned=${plannedAssertions} assertions=${counts.assertions} " +
        "failed=${counts.failed} disabled=${counts.disabled}")
    // Print the exact failure count, but saturate the exit status so it cannot
    // become a successful process status after an 8-bit exit-code truncation.
    if (counts.failed > 255) { return 255 }
    counts.failed
}

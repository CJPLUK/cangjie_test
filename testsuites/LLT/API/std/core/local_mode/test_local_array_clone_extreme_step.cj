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

// P001/P002: positive/negative open and closed ranges, including empty bounds.
// P003/P004: unit-step bulk copy and general/extreme-step paths.
// P005: heap/local! direct arrays and offset=2 slices. P006: exact bounds error.
// T001/S001-S003: all legal explicit endpoints in [-1,size], sizes 0/1/2/5,
// ten signed steps, both receiver modes and layouts: 2480 legal cases.
// T002/S004: the other 3760 endpoint cases require IndexOutOfBoundsException.
// Omitted bounds and local? signature capability are outside this runtime test.
// Range's hasStart/hasEnd input flags below are literals; no expected payload
// or expected result is a handwritten truth table.

var executed: Int64 = 0
var executedLegal: Int64 = 0
var executedInvalid: Int64 = 0
var failed: Int64 = 0
var failedLegal: Int64 = 0
var failedInvalid: Int64 = 0
var checksExecuted: Int64 = 0
var oracleMismatches: Int64 = 0
var unexpectedExceptions: Int64 = 0
var missingExpectedExceptions: Int64 = 0
var wrongExceptionTypes: Int64 = 0
var sourceMutations: Int64 = 0
var backingMutations: Int64 = 0

func payload(position: Int64): Int64 { 1000 + 13 * position }

// Explicit endpoint legality, independently written as boundary inequalities.
// Empty reverse ranges may use start=-1; a closed empty interval may end one
// position beyond its start. No implementation length formula is used here.
func legalBounds(size: Int64, start: Int64, end: Int64, step: Int64, closed: Bool): Bool {
    if (step > 0) {
        if (closed) {
            return 0 <= start && start <= size && -1 <= end && end < size && start <= end + 1
        }
        return 0 <= start && start <= end && end <= size
    }
    if (closed) {
        return -1 <= start && start < size && 0 <= end && end <= size && end <= start + 1
    }
    -1 <= end && end <= start && start < size
}

// Enumerate only small source indices. No Range iterator, adding step, abs(step),
// negating Int64.Min, or ceil-div length arithmetic participates in the oracle.
// candidate-start is between -6 and 6, including for Int64.Min strides.
func expectedPayload(size: Int64, offset: Int64, start: Int64, end: Int64,
    step: Int64, closed: Bool): Array<Int64> {
    let selected = Array<Int64>(size, repeat: 0)
    var count: Int64 = 0
    var cursor: Int64 = 0
    while (cursor < size) {
        let candidate = if (step > 0) { cursor } else { size - 1 - cursor }
        let within = if (step > 0) {
            candidate >= start && (if (closed) { candidate <= end } else { candidate < end })
        } else {
            candidate <= start && (if (closed) { candidate >= end } else { candidate > end })
        }
        if (within && (candidate - start) % step == 0) {
            selected[count] = payload(offset + candidate)
            count++
        }
        cursor++
    }
    selected.slice(0, count)
}

func describeHeap(values: Array<Int64>): String {
    var text = "["
    var i: Int64 = 0
    while (i < values.size) {
        if (i > 0) { text += "," }
        let value: Int64 = values[i]
        text += value.toString()
        i++
    }
    text + "]"
}

func samePayloadHeap(actual: Array<Int64>, expected: Array<Int64>): Bool {
    let sizeMatches = actual.size == expected.size
    if (!sizeMatches) { return sizeMatches }
    var i: Int64 = 0
    while (i < expected.size) {
        let value: Int64 = actual[i]
        let matches = value == expected[i]
        if (!matches) { return matches }
        i++
    }
    i == expected.size
}

func preservedHeap(values: Array<Int64>, size: Int64, physicalStart: Int64): Bool {
    let sizeMatches = values.size == size
    if (!sizeMatches) { return sizeMatches }
    var i: Int64 = 0
    while (i < size) {
        let value: Int64 = values[i]
        let matches = value == payload(physicalStart + i)
        if (!matches) { return matches }
        i++
    }
    i == size
}

exclave func describeLocal(values: Array<Int64> @local!): String {
    var text = "["
    var i: Int64 = 0
    while (i < values.size) {
        if (i > 0) { text += "," }
        let value: Int64 = values[i]
        text += value.toString()
        i++
    }
    text + "]"
}

exclave func samePayloadLocal(actual: Array<Int64> @local!, expected: Array<Int64>): Bool {
    let sizeMatches = actual.size == expected.size
    if (!sizeMatches) { return sizeMatches }
    var i: Int64 = 0
    while (i < expected.size) {
        let value: Int64 = actual[i]
        let matches = value == expected[i]
        if (!matches) { return matches }
        i++
    }
    i == expected.size
}

exclave func preservedLocal(values: Array<Int64> @local!, size: Int64, physicalStart: Int64): Bool {
    let sizeMatches = values.size == size
    if (!sizeMatches) { return sizeMatches }
    var i: Int64 = 0
    while (i < size) {
        let value: Int64 = values[i]
        let matches = value == payload(physicalStart + i)
        if (!matches) { return matches }
        i++
    }
    i == size
}

func recordCase(mode: String, size: Int64, offset: Int64, range: Range<Int64>, legal: Bool,
    want: String, got: String, resultFailures: Int64, sourceOkay: Bool, backingOkay: Bool): Unit {
    executed++
    // Direct arrays share source and backing, so check that storage only once.
    checksExecuted += if (offset == 0) { 2 } else { 3 }
    if (legal) { executedLegal++ } else { executedInvalid++ }
    if (!sourceOkay) { sourceMutations++ }
    if (offset != 0 && !backingOkay) { backingMutations++ }
    if (resultFailures > 0 || !sourceOkay || !backingOkay) {
        failed++
        if (legal) { failedLegal++ } else { failedInvalid++ }
        println("MISMATCH clone(range) ${mode} size=${size} offset=${offset} " +
            "start=${range.start} end=${range.end} step=${range.step} closed=${range.isClosed} " +
            "legal=${legal}: want ${want} got ${got}; sourcePreserved=${sourceOkay} backingPreserved=${backingOkay}")
    }
}

func runHeap(size: Int64, offset: Int64, range: Range<Int64>, legal: Bool): Unit {
    // Fixed small literal fixtures keep this regression independent of dynamic
    // Array initializer behavior. The zero-offset cases use the array
    // directly; offset=2 cases retain sentinel payloads on both sides.
    let backing: Array<Int64> = match (size + 2 * offset) {
        case 0 => []
        case 1 => [payload(0)]
        case 2 => [payload(0), payload(1)]
        case 4 => [payload(0), payload(1), payload(2), payload(3)]
        case 5 => [payload(0), payload(1), payload(2), payload(3), payload(4)]
        case 6 => [payload(0), payload(1), payload(2), payload(3), payload(4), payload(5)]
        case 9 => [payload(0), payload(1), payload(2), payload(3), payload(4), payload(5),
            payload(6), payload(7), payload(8)]
        case _ => throw IllegalArgumentException("fixture size outside the finite test domain")
    }
    let source: Array<Int64> = if (offset == 0) { backing } else { backing.slice(offset, size) }
    let expected = expectedPayload(size, offset, range.start, range.end, range.step, range.isClosed)
    let want = if (legal) { "size=${expected.size} payload=" + describeHeap(expected) } else { "IndexOutOfBoundsException" }
    var got = ""
    var resultFailures: Int64 = 0
    try {
        let actual: Array<Int64> = source.clone(range)
        got = "size=${actual.size} payload=" + describeHeap(actual)
        if (legal) {
            if (!samePayloadHeap(actual, expected)) { resultFailures++; oracleMismatches++ }
        } else {
            resultFailures++
            missingExpectedExceptions++
        }
    } catch (e: IndexOutOfBoundsException) {
        got = "THREW " + e.toString()
        if (legal) { resultFailures++; unexpectedExceptions++ }
    } catch (e: Exception) {
        got = "THREW " + e.toString()
        resultFailures++
        if (legal) { unexpectedExceptions++ } else { wrongExceptionTypes++ }
    }
    let sourceOkay = preservedHeap(source, size, offset)
    let backingOkay = if (offset == 0) { sourceOkay } else {
        preservedHeap(backing, size + 2 * offset, 0)
    }
    recordCase("@~local", size, offset, range, legal, want, got, resultFailures,
        sourceOkay, backingOkay)
}

func runLocal(size: Int64, offset: Int64, range: Range<Int64>, legal: Bool): Unit {
    // Fixed small literal fixtures keep this regression independent of dynamic
    // local Array initializer behavior. The zero-offset cases use the array
    // directly; offset=2 cases retain sentinel payloads on both sides.
    let backing: Array<Int64> @local! = match (size + 2 * offset) {
        case 0 => []
        case 1 => [payload(0)]
        case 2 => [payload(0), payload(1)]
        case 4 => [payload(0), payload(1), payload(2), payload(3)]
        case 5 => [payload(0), payload(1), payload(2), payload(3), payload(4)]
        case 6 => [payload(0), payload(1), payload(2), payload(3), payload(4), payload(5)]
        case 9 => [payload(0), payload(1), payload(2), payload(3), payload(4), payload(5),
            payload(6), payload(7), payload(8)]
        case _ => throw IllegalArgumentException("fixture size outside the finite test domain")
    }
    let source: Array<Int64> @local! = if (offset == 0) { backing } else { backing.slice(offset, size) }
    let expected = expectedPayload(size, offset, range.start, range.end, range.step, range.isClosed)
    let want = if (legal) { "size=${expected.size} payload=" + describeHeap(expected) } else { "IndexOutOfBoundsException" }
    var got = ""
    var resultFailures: Int64 = 0
    try {
        let actual: Array<Int64> @local! = source.clone(range)
        got = "size=${actual.size} payload=" + describeLocal(actual)
        if (legal) {
            if (!samePayloadLocal(actual, expected)) { resultFailures++; oracleMismatches++ }
        } else {
            resultFailures++
            missingExpectedExceptions++
        }
    } catch (e: IndexOutOfBoundsException) {
        got = "THREW " + e.toString()
        if (legal) { resultFailures++; unexpectedExceptions++ }
    } catch (e: Exception) {
        got = "THREW " + e.toString()
        resultFailures++
        if (legal) { unexpectedExceptions++ } else { wrongExceptionTypes++ }
    }
    let sourceOkay = preservedLocal(source, size, offset)
    let backingOkay = if (offset == 0) { sourceOkay } else {
        preservedLocal(backing, size + 2 * offset, 0)
    }
    recordCase("@local!", size, offset, range, legal, want, got, resultFailures,
        sourceOkay, backingOkay)
}

main(): Int64 {
    let sizes: Array<Int64> = [0, 1, 2, 5]
    let steps: Array<Int64> = [1, -1, 7, -7, Int64.Max, Int64.Max - 1, Int64.Max - 2,
        Int64.Min, Int64.Min + 1, Int64.Min + 2]
    let layouts: Array<Int64> = [0, 2]
    let receiverCount: Int64 = 2
    let closureCount: Int64 = 2
    var planned: Int64 = 0
    var plannedLegal: Int64 = 0
    for (size in sizes) {
        let endpointCount = size + 2
        planned += endpointCount * endpointCount * steps.size * closureCount * layouts.size * receiverCount
        // Per sign and closure there are (size+1)*(size+2)/2 legal endpoint pairs.
        let legalEndpointPairs = (size + 1) * (size + 2) / 2
        plannedLegal += legalEndpointPairs * steps.size * closureCount * layouts.size * receiverCount
    }
    let plannedInvalid = planned - plannedLegal
    // Two checks for every case; sliced layouts also check distinct backing storage.
    let checksPlanned = planned * 2 + planned / layouts.size
    let disabled: Int64 = 0

    // Keep all invalid-range contract checks in their own second group.
    var group: Int64 = 0
    while (group < 2) {
        let legalGroup = group == 0
        for (size in sizes) {
            for (offset in layouts) {
                for (step in steps) {
                    var closedFlag: Int64 = 0
                    while (closedFlag < closureCount) {
                        let closed = closedFlag == 1
                        var start: Int64 = -1
                        while (start <= size) {
                            var end: Int64 = -1
                            while (end <= size) {
                                let legal = legalBounds(size, start, end, step, closed)
                                if (legal == legalGroup) {
                                    let range: Range<Int64> @~local = Range<Int64>(start, end, step, true, true, closed)
                                    runHeap(size, offset, range, legal)
                                    runLocal(size, offset, range, legal)
                                }
                                end++
                            }
                            start++
                        }
                        closedFlag++
                    }
                }
            }
        }
        group++
    }

    if (executed != planned || executedLegal != plannedLegal || executedInvalid != plannedInvalid ||
        checksExecuted != checksPlanned) {
        failed++
        println("MISMATCH counts: want total=${planned} legal=${plannedLegal} invalid=${plannedInvalid} " +
            "checks=${checksPlanned} got total=${executed} legal=${executedLegal} " +
            "invalid=${executedInvalid} checks=${checksExecuted}")
    }
    println("planned=${planned} executed=${executed} failed=${failed} disabled=${disabled}")
    println("plannedLegal=${plannedLegal} executedLegal=${executedLegal} failedLegal=${failedLegal} " +
        "plannedInvalid=${plannedInvalid} executedInvalid=${executedInvalid} failedInvalid=${failedInvalid}")
    println("checksPlanned=${checksPlanned} checksExecuted=${checksExecuted} oracleMismatches=${oracleMismatches} " +
        "unexpectedExceptions=${unexpectedExceptions} missingExpectedExceptions=${missingExpectedExceptions} " +
        "wrongExceptionTypes=${wrongExceptionTypes} sourceMutations=${sourceMutations} backingMutations=${backingMutations}")
    if (failed != 0 && failed % 256 == 0) { return 1 }
    failed
}

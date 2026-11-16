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

// Complete domain: LT, EQ, GT. No numeric, NaN, infinity or empty-value cases
// exist for this payload-free enum. Every one of the nine ordered pairs runs
// through H, Q-from-H, Q-from-L and L on both sides: 16 provenance combinations.
// H = @~local, Q = @local?, L = @local!. Nine distinct helper signatures keep
// the static operand modes at the operator call; only reporting is shared.
// P001-P003: compare's equal/less/greater paths. P004: six operator paths.
// P005: static mode dispatch. T001/S001-S002: all 144 pairs and oracle checks.
// T002/S003: five total-order laws using the six cached results of each pair.

var failed: Int64 = 0
var executed: Int64 = 0
var checksExecuted: Int64 = 0
var uncheckableFamilyChecks: Int64 = 0
var specGapFamilyChecks: Int64 = 0

// Each operator is observed independently so a throwing overload cannot stop
// the remaining inputs/operators. Dependent consistency checks are counted as uncheckable when
// their operands are unavailable; no runtime error is counted as disabled.
enum Observation {
    Value(Bool) | Failure(String)
}

struct OperatorResults {
    let less: Observation
    let greater: Observation
    let lessEqual: Observation
    let greaterEqual: Observation
    let equal: Observation
    let notEqual: Observation

    init(less: Observation, greater: Observation, lessEqual: Observation, greaterEqual: Observation,
        equal: Observation, notEqual: Observation) {
        this.less = less
        this.greater = greater
        this.lessEqual = lessEqual
        this.greaterEqual = greaterEqual
        this.equal = equal
        this.notEqual = notEqual
    }
}

// Match decoding never calls Ordering's tested operators, including ==/!=.
// Integer relations below are trusted independent primitives. The same decoder
// also supplies semantic ranks, because Ordering's documented order is LT<EQ<GT;
// this order is intentionally independent of the enum's declaration order.
func orderingRank(value: Ordering @local?): Int64 {
    match (value) {
        case Ordering.LT => -1
        case Ordering.EQ => 0
        case Ordering.GT => 1
    }
}

func orderingName(value: Ordering @local?): String {
    match (value) {
        case Ordering.LT => "LT"
        case Ordering.EQ => "EQ"
        case Ordering.GT => "GT"
    }
}

func observationText(value: Observation): String {
    match (value) {
        case Value(result) => result.toString()
        case Failure(message) => "THREW(" + message + ")"
    }
}

func negate(value: Observation): Observation {
    match (value) {
        case Value(result) => Observation.Value(!result)
        case Failure(message) => Observation.Failure(message)
    }
}

func either(first: Observation, second: Observation): Observation {
    match ((first, second)) {
        case (Value(a), Value(b)) => Observation.Value(a || b)
        case (Failure(message), _) => Observation.Failure(message)
        case (_, Failure(message)) => Observation.Failure(message)
    }
}

func printResults(comparison: Int64, actual: OperatorResults): Unit {
    println("  compare=${comparison} results=(<:${observationText(actual.less)}, " +
        ">:${observationText(actual.greater)}, <=:${observationText(actual.lessEqual)}, " +
        ">=:${observationText(actual.greaterEqual)}, ==:${observationText(actual.equal)}, " +
        "!=:${observationText(actual.notEqual)})")
}

func checkOperator(op: String, mode: String, a: String, b: String,
    want: Bool, actualValue: Observation, comparison: Int64, actual: OperatorResults): Unit {
    checksExecuted++
    match (actualValue) {
        case Value(got) =>
            if (want != got) {
                failed++
                println("MISMATCH ${op} ${mode} ${a} vs ${b}: want ${want} got ${got}")
                printResults(comparison, actual)
            }
        case Failure(message) =>
            failed++
            println("MISMATCH ${op} ${mode} ${a} vs ${b}: want ${want} got THREW(${message})")
            printResults(comparison, actual)
    }
}

// The local-mode change spec declares only the @local? form of == and !=
// (Equatable/NotEqual); the @local! form keeps the upstream throwing default
// body. A local!/local! equality call is therefore outside the specified
// surface: accept the documented UnimplementedException instead of a value,
// and keep dependent consistency checks uncheckable rather than failing.
func isSpecGap(message: String): Bool {
    return message.contains("does not implement '==' method for its @local! instance") ||
        message.contains("does not implement '!=' method for its @local! instance")
}

func checkSpecGapOrValue(op: String, mode: String, a: String, b: String,
    want: Bool, actualValue: Observation, comparison: Int64, actual: OperatorResults): Unit {
    checksExecuted++
    match (actualValue) {
        case Value(got) =>
            if (want != got) {
                failed++
                println("MISMATCH ${op} ${mode} ${a} vs ${b}: want ${want} got ${got}")
                printResults(comparison, actual)
            }
        case Failure(message) =>
            if (!isSpecGap(message)) {
                failed++
                println("MISMATCH ${op} ${mode} ${a} vs ${b}: want ${want} got THREW(${message})")
                printResults(comparison, actual)
            }
    }
}

func checkConsistency(op: String, mode: String, a: String, b: String,
    wantValue: Observation, gotValue: Observation, comparison: Int64, actual: OperatorResults,
    specGapEquality: Bool): Unit {
    match ((wantValue, gotValue)) {
        case (Value(want), Value(got)) =>
            checkOperator(op, mode, a, b, want, Observation.Value(got), comparison, actual)
        case _ =>
            // A local!/local! equality operand is outside the specified surface, so a
            // dependent law cannot be evaluated; that is a spec gap, not a failure.
            if (specGapEquality) {
                specGapFamilyChecks++
                return
            }
            uncheckableFamilyChecks++
            println("UNCHECKABLE ${op} ${mode} ${a} vs ${b}: a prerequisite operator threw; " +
                "want ${observationText(wantValue)} got ${observationText(gotValue)}")
            printResults(comparison, actual)
    }
}

func verifyPair(mode: String, a: String, b: String, aRank: Int64, bRank: Int64,
    comparison: Int64, actual: OperatorResults, specGapEquality: Bool): Unit {
    executed++
    // Independent rank check prevents a shared wrong compare arm from blessing
    // the operator oracle. It relies on the explicit semantic label order above.
    let wantComparison: Int64 = if (aRank < bRank) { -1 } else if (aRank > bRank) { 1 } else { 0 }
    checksExecuted++
    if (comparison != wantComparison) {
        failed++
        println("MISMATCH compare ${mode} ${a} vs ${b}: want ${wantComparison} got ${comparison}")
    }

    checkOperator("<", mode, a, b, comparison < 0, actual.less, comparison, actual)
    checkOperator(">", mode, a, b, comparison > 0, actual.greater, comparison, actual)
    checkOperator("<=", mode, a, b, comparison <= 0, actual.lessEqual, comparison, actual)
    checkOperator(">=", mode, a, b, comparison >= 0, actual.greaterEqual, comparison, actual)
    if (specGapEquality) {
        checkSpecGapOrValue("==", mode, a, b, comparison == 0, actual.equal, comparison, actual)
        checkSpecGapOrValue("!=", mode, a, b, comparison != 0, actual.notEqual, comparison, actual)
    } else {
        checkOperator("==", mode, a, b, comparison == 0, actual.equal, comparison, actual)
        checkOperator("!=", mode, a, b, comparison != 0, actual.notEqual, comparison, actual)
    }

    // Ordering has a total order, so each complement law applies to its whole
    // domain. These checks reuse cached operator results instead of calling them again.
    checkConsistency(">= <=> !(<)", mode, a, b, negate(actual.less), actual.greaterEqual, comparison, actual,
        specGapEquality)
    checkConsistency("> <=> !(<=)", mode, a, b, negate(actual.lessEqual), actual.greater, comparison, actual,
        specGapEquality)
    checkConsistency("<= <=> (< || ==)", mode, a, b,
        either(actual.less, actual.equal), actual.lessEqual, comparison, actual, specGapEquality)
    checkConsistency(">= <=> (> || ==)", mode, a, b,
        either(actual.greater, actual.equal), actual.greaterEqual, comparison, actual, specGapEquality)
    checkConsistency("!= <=> !(==)", mode, a, b, negate(actual.equal), actual.notEqual, comparison, actual,
        specGapEquality)
}

func checkHH(a: Ordering @~local, b: Ordering @~local, mode: String): Unit {
    let less = try { Observation.Value(a < b) } catch (e: Exception) { Observation.Failure(e.message) }
    let greater = try { Observation.Value(a > b) } catch (e: Exception) { Observation.Failure(e.message) }
    let lessEqual = try { Observation.Value(a <= b) } catch (e: Exception) { Observation.Failure(e.message) }
    let greaterEqual = try { Observation.Value(a >= b) } catch (e: Exception) { Observation.Failure(e.message) }
    let equal = try { Observation.Value(a == b) } catch (e: Exception) { Observation.Failure(e.message) }
    let notEqual = try { Observation.Value(a != b) } catch (e: Exception) { Observation.Failure(e.message) }
    let actual = OperatorResults(less, greater, lessEqual, greaterEqual, equal, notEqual)
    let comparison = orderingRank(a.compare(b))
    verifyPair(mode, orderingName(a), orderingName(b), orderingRank(a), orderingRank(b), comparison, actual, false)
}

func checkHQ(a: Ordering @~local, b: Ordering @local?, mode: String): Unit {
    let less = try { Observation.Value(a < b) } catch (e: Exception) { Observation.Failure(e.message) }
    let greater = try { Observation.Value(a > b) } catch (e: Exception) { Observation.Failure(e.message) }
    let lessEqual = try { Observation.Value(a <= b) } catch (e: Exception) { Observation.Failure(e.message) }
    let greaterEqual = try { Observation.Value(a >= b) } catch (e: Exception) { Observation.Failure(e.message) }
    let equal = try { Observation.Value(a == b) } catch (e: Exception) { Observation.Failure(e.message) }
    let notEqual = try { Observation.Value(a != b) } catch (e: Exception) { Observation.Failure(e.message) }
    let actual = OperatorResults(less, greater, lessEqual, greaterEqual, equal, notEqual)
    let comparison = orderingRank(a.compare(b))
    verifyPair(mode, orderingName(a), orderingName(b), orderingRank(a), orderingRank(b), comparison, actual, false)
}

func checkHL(a: Ordering @~local, b: Ordering @local!, mode: String): Unit {
    exclave {
        let less = try { Observation.Value(a < b) } catch (e: Exception) { Observation.Failure(e.message) }
        let greater = try { Observation.Value(a > b) } catch (e: Exception) { Observation.Failure(e.message) }
        let lessEqual = try { Observation.Value(a <= b) } catch (e: Exception) { Observation.Failure(e.message) }
        let greaterEqual = try { Observation.Value(a >= b) } catch (e: Exception) { Observation.Failure(e.message) }
        let equal = try { Observation.Value(a == b) } catch (e: Exception) { Observation.Failure(e.message) }
        let notEqual = try { Observation.Value(a != b) } catch (e: Exception) { Observation.Failure(e.message) }
        let actual = OperatorResults(less, greater, lessEqual, greaterEqual, equal, notEqual)
        let comparison = orderingRank(a.compare(b))
        verifyPair(mode, orderingName(a), orderingName(b), orderingRank(a), orderingRank(b), comparison, actual, false)
    }
}

func checkQH(a: Ordering @local?, b: Ordering @~local, mode: String): Unit {
    let less = try { Observation.Value(a < b) } catch (e: Exception) { Observation.Failure(e.message) }
    let greater = try { Observation.Value(a > b) } catch (e: Exception) { Observation.Failure(e.message) }
    let lessEqual = try { Observation.Value(a <= b) } catch (e: Exception) { Observation.Failure(e.message) }
    let greaterEqual = try { Observation.Value(a >= b) } catch (e: Exception) { Observation.Failure(e.message) }
    let equal = try { Observation.Value(a == b) } catch (e: Exception) { Observation.Failure(e.message) }
    let notEqual = try { Observation.Value(a != b) } catch (e: Exception) { Observation.Failure(e.message) }
    let actual = OperatorResults(less, greater, lessEqual, greaterEqual, equal, notEqual)
    let comparison = orderingRank(a.compare(b))
    verifyPair(mode, orderingName(a), orderingName(b), orderingRank(a), orderingRank(b), comparison, actual, false)
}

func checkQQ(a: Ordering @local?, b: Ordering @local?, mode: String): Unit {
    let less = try { Observation.Value(a < b) } catch (e: Exception) { Observation.Failure(e.message) }
    let greater = try { Observation.Value(a > b) } catch (e: Exception) { Observation.Failure(e.message) }
    let lessEqual = try { Observation.Value(a <= b) } catch (e: Exception) { Observation.Failure(e.message) }
    let greaterEqual = try { Observation.Value(a >= b) } catch (e: Exception) { Observation.Failure(e.message) }
    let equal = try { Observation.Value(a == b) } catch (e: Exception) { Observation.Failure(e.message) }
    let notEqual = try { Observation.Value(a != b) } catch (e: Exception) { Observation.Failure(e.message) }
    let actual = OperatorResults(less, greater, lessEqual, greaterEqual, equal, notEqual)
    let comparison = orderingRank(a.compare(b))
    verifyPair(mode, orderingName(a), orderingName(b), orderingRank(a), orderingRank(b), comparison, actual, false)
}

func checkQL(a: Ordering @local?, b: Ordering @local!, mode: String): Unit {
    exclave {
        let less = try { Observation.Value(a < b) } catch (e: Exception) { Observation.Failure(e.message) }
        let greater = try { Observation.Value(a > b) } catch (e: Exception) { Observation.Failure(e.message) }
        let lessEqual = try { Observation.Value(a <= b) } catch (e: Exception) { Observation.Failure(e.message) }
        let greaterEqual = try { Observation.Value(a >= b) } catch (e: Exception) { Observation.Failure(e.message) }
        let equal = try { Observation.Value(a == b) } catch (e: Exception) { Observation.Failure(e.message) }
        let notEqual = try { Observation.Value(a != b) } catch (e: Exception) { Observation.Failure(e.message) }
        let actual = OperatorResults(less, greater, lessEqual, greaterEqual, equal, notEqual)
        let comparison = orderingRank(a.compare(b))
        verifyPair(mode, orderingName(a), orderingName(b), orderingRank(a), orderingRank(b), comparison, actual, false)
    }
}

func checkLH(a: Ordering @local!, b: Ordering @~local, mode: String): Unit {
    exclave {
        let less = try { Observation.Value(a < b) } catch (e: Exception) { Observation.Failure(e.message) }
        let greater = try { Observation.Value(a > b) } catch (e: Exception) { Observation.Failure(e.message) }
        let lessEqual = try { Observation.Value(a <= b) } catch (e: Exception) { Observation.Failure(e.message) }
        let greaterEqual = try { Observation.Value(a >= b) } catch (e: Exception) { Observation.Failure(e.message) }
        let equal = try { Observation.Value(a == b) } catch (e: Exception) { Observation.Failure(e.message) }
        let notEqual = try { Observation.Value(a != b) } catch (e: Exception) { Observation.Failure(e.message) }
        let actual = OperatorResults(less, greater, lessEqual, greaterEqual, equal, notEqual)
        let comparison = orderingRank(a.compare(b))
        verifyPair(mode, orderingName(a), orderingName(b), orderingRank(a), orderingRank(b), comparison, actual, false)
    }
}

func checkLQ(a: Ordering @local!, b: Ordering @local?, mode: String): Unit {
    exclave {
        let less = try { Observation.Value(a < b) } catch (e: Exception) { Observation.Failure(e.message) }
        let greater = try { Observation.Value(a > b) } catch (e: Exception) { Observation.Failure(e.message) }
        let lessEqual = try { Observation.Value(a <= b) } catch (e: Exception) { Observation.Failure(e.message) }
        let greaterEqual = try { Observation.Value(a >= b) } catch (e: Exception) { Observation.Failure(e.message) }
        let equal = try { Observation.Value(a == b) } catch (e: Exception) { Observation.Failure(e.message) }
        let notEqual = try { Observation.Value(a != b) } catch (e: Exception) { Observation.Failure(e.message) }
        let actual = OperatorResults(less, greater, lessEqual, greaterEqual, equal, notEqual)
        let comparison = orderingRank(a.compare(b))
        verifyPair(mode, orderingName(a), orderingName(b), orderingRank(a), orderingRank(b), comparison, actual, false)
    }
}

func checkLL(a: Ordering @local!, b: Ordering @local!, mode: String): Unit {
    exclave {
        let less = try { Observation.Value(a < b) } catch (e: Exception) { Observation.Failure(e.message) }
        let greater = try { Observation.Value(a > b) } catch (e: Exception) { Observation.Failure(e.message) }
        let lessEqual = try { Observation.Value(a <= b) } catch (e: Exception) { Observation.Failure(e.message) }
        let greaterEqual = try { Observation.Value(a >= b) } catch (e: Exception) { Observation.Failure(e.message) }
        let equal = try { Observation.Value(a == b) } catch (e: Exception) { Observation.Failure(e.message) }
        let notEqual = try { Observation.Value(a != b) } catch (e: Exception) { Observation.Failure(e.message) }
        let actual = OperatorResults(less, greater, lessEqual, greaterEqual, equal, notEqual)
        let comparison = orderingRank(a.compare(b))
        verifyPair(mode, orderingName(a), orderingName(b), orderingRank(a), orderingRank(b), comparison, actual, true)
    }
}

main(): Int64 {
    let domain: Array<Ordering> = [Ordering.LT, Ordering.EQ, Ordering.GT]
    let provenanceCount: Int64 = 4
    let checksPerPair: Int64 = 12
    let planned = domain.size * domain.size * provenanceCount * provenanceCount
    let checksPlanned = planned * checksPerPair
    let disabled: Int64 = 0

    for (aValue in domain) {
        for (bValue in domain) {
            let aHeap: Ordering @~local = aValue
            let bHeap: Ordering @~local = bValue
            let aLocal: Ordering @local! = match (aValue) {
                case Ordering.LT => Ordering.LT
                case Ordering.EQ => Ordering.EQ
                case Ordering.GT => Ordering.GT
            }
            let bLocal: Ordering @local! = match (bValue) {
                case Ordering.LT => Ordering.LT
                case Ordering.EQ => Ordering.EQ
                case Ordering.GT => Ordering.GT
            }
            let aHalfHeap: Ordering @local? = aHeap
            let bHalfHeap: Ordering @local? = bHeap
            let aHalfLocal: Ordering @local? = aLocal
            let bHalfLocal: Ordering @local? = bLocal
            checkHH(aHeap, bHeap, "H/H")
            checkHQ(aHeap, bHalfHeap, "H/Q-from-H")
            checkHQ(aHeap, bHalfLocal, "H/Q-from-L")
            checkHL(aHeap, bLocal, "H/L")
            checkQH(aHalfHeap, bHeap, "Q-from-H/H")
            checkQQ(aHalfHeap, bHalfHeap, "Q-from-H/Q-from-H")
            checkQQ(aHalfHeap, bHalfLocal, "Q-from-H/Q-from-L")
            checkQL(aHalfHeap, bLocal, "Q-from-H/L")
            checkQH(aHalfLocal, bHeap, "Q-from-L/H")
            checkQQ(aHalfLocal, bHalfHeap, "Q-from-L/Q-from-H")
            checkQQ(aHalfLocal, bHalfLocal, "Q-from-L/Q-from-L")
            checkQL(aHalfLocal, bLocal, "Q-from-L/L")
            checkLH(aLocal, bHeap, "L/H")
            checkLQ(aLocal, bHalfHeap, "L/Q-from-H")
            checkLQ(aLocal, bHalfLocal, "L/Q-from-L")
            checkLL(aLocal, bLocal, "L/L")
        }
    }

    if (executed != planned) {
        failed++
        println("MISMATCH pair-count: want ${planned} got ${executed}")
    }
    let checksAccounted = checksExecuted + uncheckableFamilyChecks + specGapFamilyChecks
    if (checksAccounted != checksPlanned) {
        failed++
        println("MISMATCH check-count: want ${checksPlanned} got ${checksAccounted}")
    }
    println("planned=${planned} executed=${executed} failed=${failed} disabled=${disabled}")
    println("checksPlanned=${checksPlanned} checksExecuted=${checksExecuted} " +
        "uncheckable-family-checks=${uncheckableFamilyChecks} " +
        "spec-gap-family-checks=${specGapFamilyChecks}")
    if (failed == 0 && uncheckableFamilyChecks != 0) { return 1 }
    // Print the exact count above and avoid an OS exit-code truncation to zero.
    if (failed != 0 && failed % 256 == 0) { return 1 }
    failed
}

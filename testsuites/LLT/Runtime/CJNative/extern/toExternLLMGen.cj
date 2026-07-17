// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args


import std.collection.HashMap

struct Pair {
    let left: Int64
    let right: Int64

    public Pair(left: Int64, right: Int64) {
        this.left = left
        this.right = right
    }
}

struct Envelope {
    let name: String
    let score: Int64
    let enabled: Bool

    public Envelope(name: String, score: Int64, enabled: Bool) {
        this.name = name
        this.score = score
        this.enabled = enabled
    }
}

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(_: Extern<DummyRT>, _: String): Extern<DummyRT> {
        throw Exception("memberAccess not implemented")
    }
    public static func indexedAccess(_: Extern<DummyRT>, _: Any): Extern<DummyRT> {
        throw Exception("indexedAccess not implemented")
    }
    public static func memberUpdate(_: Extern<DummyRT>, _: String, _: Any): Unit {
        throw Exception("memberUpdate not implemented")
    }
    public static func indexedUpdate(_: Extern<DummyRT>, _: Any, _: Any): Unit {
        throw Exception("indexedUpdate not implemented")
    }
    public static func functionCall(_: Extern<DummyRT>, _: Array<Any>): Extern<DummyRT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        match (None<R>) {
            case _: Option<Int64> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<Float64> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<Bool> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<String> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<Pair> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<Envelope> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<Array<Int64>> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<HashMap<String, Int64>> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _ => throw ExternConversionException("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
}

func unwrapInt(e: Extern<DummyRT>): Int64 {
    DummyRT.fromExtern<Int64>(e)
}

func unwrapString(e: Extern<DummyRT>): String {
    DummyRT.fromExtern<String>(e)
}

func genericWrap<T>(v: T): Extern<DummyRT> {
    let e: Extern<DummyRT> = v
    e
}

func genericExtern<T, R>(v: R): Extern<T> where T <: ForeignRuntime<T> {
    let e: Extern<T> = v
    e
}

func select(flag: Bool, a: Extern<DummyRT>, b: Extern<DummyRT>): Extern<DummyRT> {
    if (flag) {
        a
    } else {
        b
    }
}

func sumArray(e: Extern<DummyRT>): Int64 {
    let payload = DummyRT.fromExtern<Array<Int64>>(e)
    payload[0] + payload[1] + payload[2] + payload[3]
}

func mapValue(e: Extern<DummyRT>, key: String): Int64 {
    DummyRT.fromExtern<HashMap<String, Int64>>(e)[key]
}

func assertInt(name: String, actual: Int64, expected: Int64) {
    if (actual != expected) {
        throw Exception(name)
    }
}

func assertBool(name: String, actual: Bool, expected: Bool) {
    if (actual != expected) {
        throw Exception(name)
    }
}

func assertString(name: String, actual: String, expected: String) {
    if (actual != expected) {
        throw Exception(name)
    }
}

func expectBadStringConversion(e: Extern<DummyRT>) {
    try {
        DummyRT.fromExtern<String>(e)
        throw Exception("bad String conversion did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }
}


func pairTotal(e: Extern<DummyRT>): Int64 {
    let p = DummyRT.fromExtern<Pair>(e)
    p.left + p.right
}

func pairDifference(e: Extern<DummyRT>): Int64 {
    let p = DummyRT.fromExtern<Pair>(e)
    p.right - p.left
}

func envelopeLabel(e: Extern<DummyRT>): String {
    DummyRT.fromExtern<Envelope>(e).name
}

func envelopeIsLarge(e: Extern<DummyRT>): Bool {
    DummyRT.fromExtern<Envelope>(e).score > 10
}

func makeScoreMap(a: Int64, b: Int64): Extern<DummyRT> {
    let values = HashMap<String, Int64>()
    values["a"] = a
    values["b"] = b
    values["sum"] = a + b
    values
}

func choosePayload(flag: Bool): Extern<DummyRT> {
    if (flag) {
        Pair(8, 13)
    } else {
        Envelope("fallback", 5, false)
    }
}

func arrayFromPair(e: Extern<DummyRT>): Extern<DummyRT> {
    let p = DummyRT.fromExtern<Pair>(e)
    [p.left, p.right, p.left + p.right, p.right - p.left]
}

func mapFromEnvelope(e: Extern<DummyRT>): Extern<DummyRT> {
    let env = DummyRT.fromExtern<Envelope>(e)
    let values = HashMap<String, Int64>()
    values["score"] = env.score
    values["enabled"] = if (env.enabled) { 1 } else { 0 }
    values
}

main () {
    let implicitInt: Extern<DummyRT> = 41
    assertInt("implicit Int64 literal", unwrapInt(implicitInt), 41)

    let explicitFloat: Extern<DummyRT> = 8.5
    if (DummyRT.fromExtern<Float64>(explicitFloat) != 8.5) {
        throw Exception("implicit Float64 literal")
    }

    let fromBool: Extern<DummyRT> = true
    assertBool("implicit Bool literal", DummyRT.fromExtern<Bool>(fromBool), true)

    let fromString: Extern<DummyRT> = "extern"
    assertString("implicit String literal", unwrapString(fromString), "extern")

    assertInt("argument coercion", unwrapInt(99), 99)
    assertString("argument String coercion", unwrapString("direct"), "direct")

    let genericInt = genericWrap<Int64>(-12)
    assertInt("generic wrap Int64", unwrapInt(genericInt), -12)

    let genericString = genericWrap<String>("generic")
    assertString("generic wrap String", unwrapString(genericString), "generic")

    let genericRuntime = genericExtern<DummyRT, Int64>(77)
    assertInt("generic runtime wrap", unwrapInt(genericRuntime), 77)

    let chosenLeft = select(true, 5, 6)
    let chosenRight = select(false, 5, 6)
    assertInt("selected left", unwrapInt(chosenLeft), 5)
    assertInt("selected right", unwrapInt(chosenRight), 6)

    let pairExtern: Extern<DummyRT> = Pair(3, 9)
    let pair = DummyRT.fromExtern<Pair>(pairExtern)
    assertInt("pair left", pair.left, 3)
    assertInt("pair right", pair.right, 9)

    let arrayExtern: Extern<DummyRT> = [2, 4, 6, 8]
    assertInt("array payload sum", sumArray(arrayExtern), 20)

    let arrayFromGeneric = genericWrap<Array<Int64>>([1, 1, 2, 3])
    assertInt("generic array payload sum", sumArray(arrayFromGeneric), 7)

    let scores = HashMap<String, Int64>()
    scores["low"] = -3
    scores["mid"] = 10
    scores["high"] = 42
    let mapExtern: Extern<DummyRT> = scores
    assertInt("map low", mapValue(mapExtern, "low"), -3)
    assertInt("map high", mapValue(mapExtern, "high"), 42)

    let nestedExtern: Extern<DummyRT> = genericWrap<Pair>(Pair(mapValue(mapExtern, "mid"), sumArray(arrayExtern)))
    let nestedPair = DummyRT.fromExtern<Pair>(nestedExtern)
    assertInt("nested pair left", nestedPair.left, 10)
    assertInt("nested pair right", nestedPair.right, 20)

    expectBadStringConversion(123)
    expectBadStringConversion(arrayExtern)

    try {
        DummyRT.fromExtern<HashMap<String, Int64>>(Extern<DummyRT>(Pair(0, 1)))
        throw Exception("bad map conversion did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }


    let matrixLike0: Extern<DummyRT> = [mapValue(mapExtern, "mid"), sumArray(arrayExtern), nestedPair.left, nestedPair.right]
    assertInt("matrix-like payload", sumArray(matrixLike0), 60)

    let envelope0: Extern<DummyRT> = Envelope("primary", mapValue(mapExtern, "high"), true)
    let env0 = DummyRT.fromExtern<Envelope>(envelope0)
    assertString("envelope name", env0.name, "primary")
    assertInt("envelope score", env0.score, 42)
    assertBool("envelope enabled", env0.enabled, true)

    var rolling: Extern<DummyRT> = genericWrap<Int64>(1)
    assertInt("rolling initial", unwrapInt(rolling), 1)
    rolling = select(unwrapInt(rolling) == 1, genericWrap<Int64>(2), genericWrap<Int64>(3))
    assertInt("rolling selected", unwrapInt(rolling), 2)
    rolling = genericWrap<Int64>(unwrapInt(rolling) * mapValue(mapExtern, "mid"))
    assertInt("rolling multiplied", unwrapInt(rolling), 20)

    let computedPair: Extern<DummyRT> = Pair(unwrapInt(select(true, 4, 5)), sumArray(genericWrap<Array<Int64>>([3, 3, 3, 3])))
    let computedPayload = DummyRT.fromExtern<Pair>(computedPair)
    assertInt("computed pair left", computedPayload.left, 4)
    assertInt("computed pair right", computedPayload.right, 12)

    let nestedScores = HashMap<String, Int64>()
    nestedScores["fromEnvelope"] = env0.score
    nestedScores["fromPair"] = nestedPair.left + nestedPair.right
    let nestedScoresExtern: Extern<DummyRT> = nestedScores
    assertInt("nested scores pair", mapValue(nestedScoresExtern, "fromPair"), 30)
    assertInt("nested scores envelope", mapValue(nestedScoresExtern, "fromEnvelope"), 42)

    let selectedArray = select(false, genericWrap<Array<Int64>>([0, 0, 0, 0]), matrixLike0)
    assertInt("selected array sum", sumArray(selectedArray), 60)

    let genericEnvelope = genericWrap<Envelope>(Envelope(unwrapString("secondary"), unwrapInt(8), false))
    let genericEnvPayload = DummyRT.fromExtern<Envelope>(genericEnvelope)
    assertString("generic envelope name", genericEnvPayload.name, "secondary")
    assertInt("generic envelope score", genericEnvPayload.score, 8)
    assertBool("generic envelope enabled", genericEnvPayload.enabled, false)

    try {
        DummyRT.fromExtern<Envelope>(arrayExtern)
        throw Exception("array as envelope did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<Array<Int64>>(envelope0)
        throw Exception("envelope as array did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }


    assertInt("helper pair total", pairTotal(Pair(21, 34)), 55)
    assertInt("helper pair difference", pairDifference(Pair(21, 34)), 13)
    assertString("helper envelope label", envelopeLabel(Envelope("helper", 15, true)), "helper")
    assertBool("helper envelope large", envelopeIsLarge(Envelope("helper", 15, true)), true)
    assertBool("helper envelope small", envelopeIsLarge(Envelope("helper", 5, true)), false)

    let scoreMap = makeScoreMap(30, 12)
    assertInt("helper map a", mapValue(scoreMap, "a"), 30)
    assertInt("helper map b", mapValue(scoreMap, "b"), 12)
    assertInt("helper map sum", mapValue(scoreMap, "sum"), 42)

    assertInt("chosen pair total", pairTotal(choosePayload(true)), 21)
    assertString("chosen envelope label", envelopeLabel(choosePayload(false)), "fallback")

    let pairArray = arrayFromPair(Pair(5, 9))
    assertInt("array from pair sum", sumArray(pairArray), 32)

    let envelopeMap = mapFromEnvelope(Envelope("mapped", 17, true))
    assertInt("envelope map score", mapValue(envelopeMap, "score"), 17)
    assertInt("envelope map enabled", mapValue(envelopeMap, "enabled"), 1)

    var changing: Extern<DummyRT> = Envelope("first", 1, false)
    assertString("changing envelope first", envelopeLabel(changing), "first")
    changing = Pair(1, 2)
    assertInt("changing pair total", pairTotal(changing), 3)
    changing = makeScoreMap(2, 5)
    assertInt("changing map sum", mapValue(changing, "sum"), 7)

    try {
        pairTotal(Envelope("not-pair", 0, false))
        throw Exception("envelope as pair total did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        envelopeLabel(Pair(1, 2))
        throw Exception("pair as envelope did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }


    let indirectMap = makeScoreMap(pairTotal(Pair(2, 3)), pairDifference(Pair(5, 11)))
    assertInt("indirect map a", mapValue(indirectMap, "a"), 5)
    assertInt("indirect map b", mapValue(indirectMap, "b"), 6)
    assertInt("indirect map sum", mapValue(indirectMap, "sum"), 11)

    let envelopeArray: Array<Int64> = [DummyRT.fromExtern<Envelope>(Envelope("array", 1, true)).score, pairTotal(Pair(3, 4)), pairDifference(Pair(8, 13)), 9]
    assertInt("array built from extern conversions", sumArray(envelopeArray), 22)

    let branchPayload = if (envelopeIsLarge(Envelope("branch", 20, true))) { Pair(20, 22) } else { Pair(1, 1) }
    assertInt("branch payload total", pairTotal(branchPayload), 42)

    var stagedMap = makeScoreMap(1, 2)
    assertInt("staged map first", mapValue(stagedMap, "sum"), 3)
    stagedMap = makeScoreMap(mapValue(stagedMap, "sum"), 4)
    assertInt("staged map second", mapValue(stagedMap, "sum"), 7)
    stagedMap = makeScoreMap(mapValue(stagedMap, "sum"), pairTotal(Pair(10, 25)))
    assertInt("staged map third", mapValue(stagedMap, "sum"), 42)

    let envFromBranch: Extern<DummyRT> = if (mapValue(stagedMap, "sum") == 42) { Envelope("ok", 42, true) } else { Envelope("bad", 0, false) }
    assertString("env from branch name", envelopeLabel(envFromBranch), "ok")
    assertBool("env from branch large", envelopeIsLarge(envFromBranch), true)

    try {
        sumArray(makeScoreMap(1, 2))
        throw Exception("map as array did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }


    let finalEnvelopeA: Extern<DummyRT> = Envelope("final-a", pairTotal(Pair(1, 2)), true)
    let finalEnvelopeB: Extern<DummyRT> = Envelope("final-b", pairDifference(Pair(2, 9)), false)
    let finalEnvelopeC: Extern<DummyRT> = Envelope("final-c", mapValue(makeScoreMap(6, 7), "sum"), true)
    assertString("final envelope a name", envelopeLabel(finalEnvelopeA), "final-a")
    assertInt("final envelope a score", DummyRT.fromExtern<Envelope>(finalEnvelopeA).score, 3)
    assertBool("final envelope a enabled", DummyRT.fromExtern<Envelope>(finalEnvelopeA).enabled, true)
    assertString("final envelope b name", envelopeLabel(finalEnvelopeB), "final-b")
    assertInt("final envelope b score", DummyRT.fromExtern<Envelope>(finalEnvelopeB).score, 7)
    assertBool("final envelope b enabled", DummyRT.fromExtern<Envelope>(finalEnvelopeB).enabled, false)
    assertString("final envelope c name", envelopeLabel(finalEnvelopeC), "final-c")
    assertInt("final envelope c score", DummyRT.fromExtern<Envelope>(finalEnvelopeC).score, 13)
    assertBool("final envelope c enabled", DummyRT.fromExtern<Envelope>(finalEnvelopeC).enabled, true)

    let finalArrayA: Extern<DummyRT> = [pairTotal(Pair(1, 1)), pairTotal(Pair(2, 2)), pairTotal(Pair(3, 3)), pairTotal(Pair(4, 4))]
    let finalArrayB: Extern<DummyRT> = [pairDifference(Pair(1, 2)), pairDifference(Pair(2, 5)), pairDifference(Pair(3, 8)), pairDifference(Pair(4, 11))]
    assertInt("final array a sum", sumArray(finalArrayA), 20)
    assertInt("final array b sum", sumArray(finalArrayB), 16)

    let finalMapA = makeScoreMap(sumArray(finalArrayA), sumArray(finalArrayB))
    assertInt("final map a left", mapValue(finalMapA, "a"), 20)
    assertInt("final map a right", mapValue(finalMapA, "b"), 16)
    assertInt("final map a sum", mapValue(finalMapA, "sum"), 36)

    var finalChanging: Extern<DummyRT> = finalEnvelopeA
    assertString("final changing envelope", envelopeLabel(finalChanging), "final-a")
    finalChanging = finalArrayA
    assertInt("final changing array", sumArray(finalChanging), 20)
    finalChanging = finalMapA
    assertInt("final changing map", mapValue(finalChanging, "sum"), 36)

    0
}

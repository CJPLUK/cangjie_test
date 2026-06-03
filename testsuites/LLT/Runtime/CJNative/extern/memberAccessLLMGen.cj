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

public class DummyRT <: Runtime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        let payload = getPayload(e)
        match (field) {
            case "id" => e
            case "left" => Extern<DummyRT>((payload as Pair).getOrThrow().left)
            case "right" => Extern<DummyRT>((payload as Pair).getOrThrow().right)
            case "sum" =>
                let pair = (payload as Pair).getOrThrow()
                Extern<DummyRT>(pair.left + pair.right)
            case "swap" =>
                let pair = (payload as Pair).getOrThrow()
                Extern<DummyRT>(Pair(pair.right, pair.left))
            case "delta" =>
                let pair = (payload as Pair).getOrThrow()
                Extern<DummyRT>(pair.right - pair.left)
            case "first" => Extern<DummyRT>((payload as Array<Int64>).getOrThrow()[0])
            case "second" => Extern<DummyRT>((payload as Array<Int64>).getOrThrow()[1])
            case "third" => Extern<DummyRT>((payload as Array<Int64>).getOrThrow()[2])
            case "asPair" =>
                let values = (payload as Array<Int64>).getOrThrow()
                Extern<DummyRT>(Pair(values[0], values[1]))
            case "answer" => Extern<DummyRT>((payload as HashMap<String, Int64>).getOrThrow()["answer"])
            case "asAnswerPair" =>
                let values = (payload as HashMap<String, Int64>).getOrThrow()
                Extern<DummyRT>(Pair(values["answer"], values["bonus"]))
            case "vector" =>
                let pair = (payload as Pair).getOrThrow()
                Extern<DummyRT>([pair.left, pair.right, pair.left + pair.right])
            case "isBalanced" =>
                let pair = (payload as Pair).getOrThrow()
                Extern<DummyRT>(pair.left == pair.right)
            case "not" => Extern<DummyRT>(!(payload as Bool).getOrThrow())
            case "suffix" => Extern<DummyRT>((payload as String).getOrThrow() + "-suffix")
            case "negative" => Extern<DummyRT>(0 - (payload as Int64).getOrThrow())
            case "twice" => Extern<DummyRT>((payload as Int64).getOrThrow() * 2)
            case "positive" => Extern<DummyRT>((payload as Bool).getOrThrow())
            case "name" => Extern<DummyRT>((payload as String).getOrThrow())
            case "pi" => Extern<DummyRT>(3.14)
            case _ => throw MemberAccessException("memberAccess not implemented")
        }
    }
    public static func indexAccess(_: Extern<DummyRT>, _: Any): Extern<DummyRT> {
        throw Exception("indexAccess not implemented")
    }
    public static func memberUpdate(_: Extern<DummyRT>, _: String, _: Any): Unit {
        throw Exception("memberUpdate not implemented")
    }
    public static func indexUpdate(_: Extern<DummyRT>, _: Any, _: Any): Unit {
        throw Exception("indexUpdate not implemented")
    }
    public static func functionCall(_: Extern<DummyRT>, _: Array<Any>): Extern<DummyRT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        match (None<R>) {
            case _: Option<Int64> => (getPayload(h) as R).getOrThrow()
            case _: Option<Float64> => (getPayload(h) as R).getOrThrow()
            case _: Option<Bool> => (getPayload(h) as R).getOrThrow()
            case _: Option<String> => (getPayload(h) as R).getOrThrow()
            case _: Option<Pair> => (getPayload(h) as R).getOrThrow()
            case _: Option<Array<Int64>> => (getPayload(h) as R).getOrThrow()
            case _ => throw ExternConversionException("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
}

func pass(e: Extern<DummyRT>): Extern<DummyRT> {
    e
}

func assertInt(name: String, actual: Int64, expected: Int64) {
    if (actual != expected) {
        throw Exception(name)
    }
}

func assertString(name: String, actual: String, expected: String) {
    if (actual != expected) {
        throw Exception(name)
    }
}

func assertBool(name: String, actual: Bool, expected: Bool) {
    if (actual != expected) {
        throw Exception(name)
    }
}

func expectMissing(e: Extern<DummyRT>) {
    try {
        DummyRT.fromExtern<Int64>(e.missing)
        throw Exception("missing member did not throw")
    } catch (e: MemberAccessException) {
        // Expected
    }
}

func expectWrongPayload(e: Extern<DummyRT>) {
    try {
        DummyRT.fromExtern<Int64>(e.left)
        throw Exception("wrong payload did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }
}


func memberScore(e: Extern<DummyRT>): Int64 {
    DummyRT.fromExtern<Int64>(e.sum.twice)
}

func vectorTail(e: Extern<DummyRT>): Int64 {
    let values = DummyRT.fromExtern<Array<Int64>>(e.vector)
    values[2]
}

func pairFromAnswer(answer: Int64, bonus: Int64): Extern<DummyRT> {
    let values = HashMap<String, Int64>()
    values["answer"] = answer
    values["bonus"] = bonus
    Extern<DummyRT>(values).asAnswerPair
}

func suffixTwice(e: Extern<DummyRT>): String {
    DummyRT.fromExtern<String>(e.suffix.suffix)
}

func isSymmetricAfterSwap(e: Extern<DummyRT>): Bool {
    DummyRT.fromExtern<Bool>(e.swap.isBalanced)
}

main () {
    let pair = Extern<DummyRT>(Pair(5, 12))
    assertInt("pair left", DummyRT.fromExtern<Int64>(pair.left), 5)
    assertInt("pair right", DummyRT.fromExtern<Int64>(pair.right), 12)
    assertInt("pair sum", DummyRT.fromExtern<Int64>(pair.sum), 17)
    assertInt("pair delta", DummyRT.fromExtern<Int64>(pair.delta), 7)
    assertInt("swapped left", DummyRT.fromExtern<Int64>(pair.swap.left), 12)
    assertInt("swapped right", DummyRT.fromExtern<Int64>(pair.swap.right), 5)
    assertInt("double swap sum", DummyRT.fromExtern<Int64>(pair.swap.swap.sum), 17)

    let fromArray = Extern<DummyRT>([4, 8, 15])
    assertInt("array first", DummyRT.fromExtern<Int64>(fromArray.first), 4)
    assertInt("array second", DummyRT.fromExtern<Int64>(fromArray.second), 8)
    assertInt("array third", DummyRT.fromExtern<Int64>(fromArray.third), 15)
    assertInt("array as pair sum", DummyRT.fromExtern<Int64>(fromArray.asPair.sum), 12)
    assertInt("array as pair swap delta", DummyRT.fromExtern<Int64>(fromArray.asPair.swap.delta), -4)

    let numbers = HashMap<String, Int64>()
    numbers["answer"] = 42
    let fromMap = Extern<DummyRT>(numbers)
    assertInt("map member", DummyRT.fromExtern<Int64>(fromMap.answer), 42)
    assertInt("map member through pass", DummyRT.fromExtern<Int64>(pass(fromMap).answer), 42)

    assertInt("numeric negative", DummyRT.fromExtern<Int64>(Extern<DummyRT>(9).negative), -9)
    assertInt("numeric twice", DummyRT.fromExtern<Int64>(Extern<DummyRT>(9).twice), 18)
    assertInt("numeric chained", DummyRT.fromExtern<Int64>(Extern<DummyRT>(9).twice.negative.twice), -36)

    assertBool("bool member", DummyRT.fromExtern<Bool>(Extern<DummyRT>(true).positive), true)
    assertString("string member", DummyRT.fromExtern<String>(Extern<DummyRT>("runtime").name), "runtime")

    if (DummyRT.fromExtern<Float64>(pair.left.pi) != 3.14) {
        throw Exception("pi after Int64 member")
    }

    expectMissing(pair)
    expectMissing(fromArray.asPair)
    expectWrongPayload(Extern<DummyRT>(99))

    try {
        DummyRT.fromExtern<Pair>(fromMap.answer)
        throw Exception("bad Pair conversion did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }


    let balanced = Extern<DummyRT>(Pair(6, 6))
    let unbalanced = Extern<DummyRT>(Pair(4, 9))
    assertBool("balanced pair", DummyRT.fromExtern<Bool>(balanced.isBalanced), true)
    assertBool("unbalanced pair", DummyRT.fromExtern<Bool>(unbalanced.isBalanced), false)
    assertBool("negated balance", DummyRT.fromExtern<Bool>(unbalanced.isBalanced.not), true)

    let vectorPayload = DummyRT.fromExtern<Array<Int64>>(unbalanced.vector)
    assertInt("vector first", vectorPayload[0], 4)
    assertInt("vector second", vectorPayload[1], 9)
    assertInt("vector sum", vectorPayload[2], 13)
    assertInt("vector as pair via member", DummyRT.fromExtern<Int64>(unbalanced.vector.asPair.sum), 13)

    let derivedMap = HashMap<String, Int64>()
    derivedMap["answer"] = 20
    derivedMap["bonus"] = 22
    let derivedMapExtern = Extern<DummyRT>(derivedMap)
    assertInt("map answer pair left", DummyRT.fromExtern<Int64>(derivedMapExtern.asAnswerPair.left), 20)
    assertInt("map answer pair right", DummyRT.fromExtern<Int64>(derivedMapExtern.asAnswerPair.right), 22)
    assertInt("map answer pair sum", DummyRT.fromExtern<Int64>(derivedMapExtern.asAnswerPair.sum), 42)

    assertString("string suffix", DummyRT.fromExtern<String>(Extern<DummyRT>("base").suffix), "base-suffix")
    assertString("string double suffix", DummyRT.fromExtern<String>(Extern<DummyRT>("base").suffix.suffix), "base-suffix-suffix")

    let pairThroughPass = pass(Extern<DummyRT>(Pair(10, -3))).swap.vector.asPair
    assertInt("pass swap vector pair sum", DummyRT.fromExtern<Int64>(pairThroughPass.sum), 7)
    assertInt("pass swap vector delta", DummyRT.fromExtern<Int64>(pairThroughPass.delta), 13)

    try {
        DummyRT.fromExtern<Array<Int64>>(Extern<DummyRT>(true).vector)
        throw Exception("bool vector did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<Pair>(Extern<DummyRT>("x").asAnswerPair)
        throw Exception("string as answer pair did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }


    assertInt("helper member score", memberScore(Extern<DummyRT>(Pair(10, 11))), 42)
    assertInt("helper vector tail", vectorTail(Extern<DummyRT>(Pair(4, 6))), 10)
    assertInt("helper pair from answer left", DummyRT.fromExtern<Int64>(pairFromAnswer(12, 30).left), 12)
    assertInt("helper pair from answer sum", DummyRT.fromExtern<Int64>(pairFromAnswer(12, 30).sum), 42)
    assertString("helper suffix twice", suffixTwice(Extern<DummyRT>("root")), "root-suffix-suffix")
    assertBool("helper symmetric true", isSymmetricAfterSwap(Extern<DummyRT>(Pair(5, 5))), true)
    assertBool("helper symmetric false", isSymmetricAfterSwap(Extern<DummyRT>(Pair(5, 6))), false)

    let memberDerived = pairFromAnswer(DummyRT.fromExtern<Int64>(Extern<DummyRT>(5).twice), DummyRT.fromExtern<Int64>(Extern<DummyRT>(16).twice))
    assertInt("member derived left", DummyRT.fromExtern<Int64>(memberDerived.left), 10)
    assertInt("member derived right", DummyRT.fromExtern<Int64>(memberDerived.right), 32)
    assertInt("member derived sum", DummyRT.fromExtern<Int64>(memberDerived.sum), 42)

    try {
        vectorTail(Extern<DummyRT>(true))
        throw Exception("bool vectorTail did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        suffixTwice(Extern<DummyRT>(Pair(1, 2)))
        throw Exception("pair suffix did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }


    var memberStage = Extern<DummyRT>(Pair(1, 2))
    assertInt("member stage pair", memberScore(memberStage), 6)
    memberStage = pairFromAnswer(10, 11)
    assertInt("member stage map pair", memberScore(memberStage), 42)
    memberStage = memberStage.swap
    assertInt("member stage swapped", DummyRT.fromExtern<Int64>(memberStage.delta), -1)

    let suffixSource = Extern<DummyRT>("seed")
    let suffixed = DummyRT.fromExtern<String>(suffixSource.suffix)
    assertString("suffixed intermediate", suffixed, "seed-suffix")
    assertString("suffixed rewrapped", suffixTwice(Extern<DummyRT>(suffixed)), "seed-suffix-suffix-suffix")

    let boolFromPair = Extern<DummyRT>(Pair(memberScore(Extern<DummyRT>(Pair(1, 2))), 6)).isBalanced
    assertBool("bool from pair expression", DummyRT.fromExtern<Bool>(boolFromPair), true)
    assertBool("bool from pair expression not", DummyRT.fromExtern<Bool>(boolFromPair.not), false)

    let chainedVector = pairFromAnswer(3, 4).vector.asPair.swap.vector
    let chainedVectorPayload = DummyRT.fromExtern<Array<Int64>>(chainedVector)
    assertInt("chained vector first", chainedVectorPayload[0], 4)
    assertInt("chained vector second", chainedVectorPayload[1], 3)
    assertInt("chained vector total", chainedVectorPayload[2], 7)

    try {
        DummyRT.fromExtern<Bool>(Extern<DummyRT>("not-bool").not)
        throw Exception("string not did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<String>(Extern<DummyRT>(false).suffix)
        throw Exception("bool suffix did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }


    let finalBalanced = Extern<DummyRT>(Pair(12, 12))
    let finalUnbalanced = Extern<DummyRT>(Pair(3, 30))
    assertBool("final balanced member", DummyRT.fromExtern<Bool>(finalBalanced.isBalanced), true)
    assertBool("final balanced not member", DummyRT.fromExtern<Bool>(finalBalanced.isBalanced.not), false)
    assertBool("final unbalanced member", DummyRT.fromExtern<Bool>(finalUnbalanced.isBalanced), false)
    assertBool("final unbalanced not member", DummyRT.fromExtern<Bool>(finalUnbalanced.isBalanced.not), true)

    let finalVectorA = DummyRT.fromExtern<Array<Int64>>(finalBalanced.vector)
    assertInt("final vector a left", finalVectorA[0], 12)
    assertInt("final vector a right", finalVectorA[1], 12)
    assertInt("final vector a sum", finalVectorA[2], 24)
    let finalVectorB = DummyRT.fromExtern<Array<Int64>>(finalUnbalanced.swap.vector)
    assertInt("final vector b left", finalVectorB[0], 30)
    assertInt("final vector b right", finalVectorB[1], 3)
    assertInt("final vector b sum", finalVectorB[2], 33)

    let finalAnswerMap = HashMap<String, Int64>()
    finalAnswerMap["answer"] = DummyRT.fromExtern<Int64>(finalBalanced.sum)
    finalAnswerMap["bonus"] = DummyRT.fromExtern<Int64>(finalUnbalanced.delta)
    let finalAnswerExtern = Extern<DummyRT>(finalAnswerMap)
    assertInt("final answer pair left", DummyRT.fromExtern<Int64>(finalAnswerExtern.asAnswerPair.left), 24)
    assertInt("final answer pair right", DummyRT.fromExtern<Int64>(finalAnswerExtern.asAnswerPair.right), 27)
    assertInt("final answer pair sum", DummyRT.fromExtern<Int64>(finalAnswerExtern.asAnswerPair.sum), 51)

    let finalSuffixA = Extern<DummyRT>("a")
    let finalSuffixB = Extern<DummyRT>(DummyRT.fromExtern<String>(finalSuffixA.suffix))
    assertString("final suffix a", DummyRT.fromExtern<String>(finalSuffixA.suffix), "a-suffix")
    assertString("final suffix b", DummyRT.fromExtern<String>(finalSuffixB.suffix), "a-suffix-suffix")

    try {
        DummyRT.fromExtern<Pair>(finalSuffixA.suffix)
        throw Exception("final suffix as pair did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<Array<Int64>>(finalAnswerExtern.answer)
        throw Exception("final answer as array did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    0
}

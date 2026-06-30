// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args


import std.collection.HashMap

class Boxed {
    Boxed(public var value: Any) {}
}

struct Pair {
    let left: Int64
    let right: Int64

    public Pair(left: Int64, right: Int64) {
        this.left = left
        this.right = right
    }
}

var countIncs: Int64 = 0
var countAdds: Int64 = 0
var countSets: Int64 = 0
var countStrings: Int64 = 0
var countMaps: Int64 = 0

public class DummyRT <: Runtime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        let box = (Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow()
        match (field) {
            case "id" => e
            case "inc" =>
                countIncs = countIncs + 1
                Extern<DummyRT>(Boxed((box.value as Int64).getOrThrow() + 1))
            case "dec" => Extern<DummyRT>(Boxed((box.value as Int64).getOrThrow() - 1))
            case "clone" => Extern<DummyRT>(Boxed(box.value))
            case "leftBox" =>
                let pair = (box.value as Pair).getOrThrow()
                Extern<DummyRT>(Boxed(pair.left))
            case "rightBox" =>
                let pair = (box.value as Pair).getOrThrow()
                Extern<DummyRT>(Boxed(pair.right))
            case "sumBox" =>
                let pair = (box.value as Pair).getOrThrow()
                Extern<DummyRT>(Boxed(pair.left + pair.right))
            case "textLen" => Extern<DummyRT>(Boxed((box.value as String).getOrThrow().size))
            case _ => throw MemberAccessException("memberAccess not implemented")
        }
    }
    public static func indexAccess(_: Extern<DummyRT>, _: Any): Extern<DummyRT> {
        throw Exception("indexAccess not implemented")
    }
    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any): Unit {
        let box = (Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow()
        match (field) {
            case "add" =>
                countAdds = countAdds + 1
                box.value = (box.value as Int64).getOrThrow() + (value as Int64).getOrThrow()
            case "sub" =>
                box.value = (box.value as Int64).getOrThrow() - (value as Int64).getOrThrow()
            case "mul" =>
                box.value = (box.value as Int64).getOrThrow() * (value as Int64).getOrThrow()
            case "set" =>
                countSets = countSets + 1
                box.value = value
            case "pairLeft" =>
                let pair = (box.value as Pair).getOrThrow()
                box.value = Pair((value as Int64).getOrThrow(), pair.right)
            case "pairRight" =>
                let pair = (box.value as Pair).getOrThrow()
                box.value = Pair(pair.left, (value as Int64).getOrThrow())
            case "pairShift" =>
                let pair = (box.value as Pair).getOrThrow()
                let delta = (value as Int64).getOrThrow()
                box.value = Pair(pair.left + delta, pair.right - delta)
            case "pairSwap" =>
                let pair = (box.value as Pair).getOrThrow()
                if ((value as Bool).getOrThrow()) {
                    box.value = Pair(pair.right, pair.left)
                }
            case "pairMerge" =>
                let pair = (box.value as Pair).getOrThrow()
                let other = (value as Pair).getOrThrow()
                box.value = Pair(pair.left + other.left, pair.right + other.right)
            case "resetIf" =>
                if ((value as Bool).getOrThrow()) {
                    box.value = 0
                }
            case "prepend" =>
                countStrings = countStrings + 1
                box.value = (value as String).getOrThrow() + (box.value as String).getOrThrow()
            case "replaceFirst" =>
                countStrings = countStrings + 1
                let s = (box.value as String).getOrThrow()
                let c = (value as Rune).getOrThrow()
                box.value = String([c]) + s[1..]
            case "toggle" =>
                box.value = !(box.value as Bool).getOrThrow()
            case "put" =>
                countMaps = countMaps + 1
                let m = (box.value as HashMap<String, Int64>).getOrThrow()
                let pair = (value as Pair).getOrThrow()
                m["left"] = pair.left
                m["right"] = pair.right
                m["sum"] = pair.left + pair.right
            case "mergeMap" =>
                countMaps = countMaps + 1
                let m = (box.value as HashMap<String, Int64>).getOrThrow()
                let other = (value as HashMap<String, Int64>).getOrThrow()
                m["left"] = m["left"] + other["left"]
                m["right"] = m["right"] + other["right"]
                m["sum"] = m["left"] + m["right"]
            case _ => throw MemberAccessException("memberUpdate not implemented")
        }
    }
    public static func indexUpdate(_: Extern<DummyRT>, _: Any, _: Any): Unit {
        throw Exception("indexUpdate not implemented")
    }
    public static func functionCall(_: Extern<DummyRT>, _: Array<Any>): Extern<DummyRT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        match (None<R>) {
            case _: Option<Int64> => ((Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow().value as R).getOrThrow()
            case _: Option<String> => ((Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow().value as R).getOrThrow()
            case _: Option<Bool> => ((Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow().value as R).getOrThrow()
            case _: Option<Pair> => ((Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow().value as R).getOrThrow()
            case _: Option<HashMap<String, Int64>> => ((Extern<DummyRT>.getPayload(e) as Boxed).getOrThrow().value as R).getOrThrow()
            case _ => throw ExternConversionException("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(_: R): Extern<DummyRT> {
        throw Exception("toExtern not implemented")
    }
}

func boxed(v: Any): Extern<DummyRT> {
    Extern<DummyRT>(Boxed(v))
}

func pass(e: Extern<DummyRT>): Extern<DummyRT> {
    e
}

func choose(flag: Bool, a: Extern<DummyRT>, b: Extern<DummyRT>): Extern<DummyRT> {
    if (flag) { a } else { b }
}

func intValue(e: Extern<DummyRT>): Int64 {
    DummyRT.fromExtern<Int64>(e)
}

func stringValue(e: Extern<DummyRT>): String {
    DummyRT.fromExtern<String>(e)
}

func pairValue(e: Extern<DummyRT>): Pair {
    DummyRT.fromExtern<Pair>(e)
}

func assertInt(name: String, actual: Int64, expected: Int64) {
    if (actual != expected) { throw Exception(name) }
}

func assertString(name: String, actual: String, expected: String) {
    if (actual != expected) { throw Exception(name) }
}

func assertBool(name: String, actual: Bool, expected: Bool) {
    if (actual != expected) { throw Exception(name) }
}

func assertPair(name: String, p: Pair, left: Int64, right: Int64) {
    if (p.left != left || p.right != right) { throw Exception(name) }
}

func expectMissingMember(e: Extern<DummyRT>) {
    try {
        e.unknown = 1
        throw Exception("missing member update did not throw")
    } catch (e: MemberAccessException) {
        // Expected
    }
}

func expectWrongPayload(e: Extern<DummyRT>) {
    try {
        e.add = 1
        throw Exception("wrong payload update did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }
}

main () {
    let numeric = boxed(10)
    numeric.add = 5
    assertInt("basic add", intValue(numeric), 15)
    numeric.sub = 3
    assertInt("basic sub", intValue(numeric), 12)
    numeric.mul = 4
    assertInt("basic mul", intValue(numeric), 48)
    pass(numeric).set = 7
    assertInt("set through pass", intValue(numeric), 7)
    choose(true, numeric, boxed(0)).add = 8
    assertInt("update through choose left", intValue(numeric), 15)

    var currentIncs = countIncs
    pass(numeric.inc).add = 1
    if (countIncs - currentIncs != 1) { throw Exception("inc count") }
    assertInt("update through pass inc", intValue(numeric), 15)

    let other = boxed(100)
    choose(false, boxed(0), other).sub = intValue(numeric)
    assertInt("update through choose right", intValue(other), 85)

    currentIncs = countIncs
    let currentAdds = countAdds
    numeric.inc.inc.add = 10
    assertInt("inc chain should not update original", intValue(numeric), 15)
    if (countIncs - currentIncs != 2) { throw Exception("inc count") }
    if (countAdds - currentAdds != 1) { throw Exception("add count") }

    numeric.id.add = 2
    assertInt("id chain updates original", intValue(numeric), 17)
    numeric.clone.add = 100
    assertInt("clone chain leaves original", intValue(numeric), 17)

    let pairBox = boxed(Pair(1, 9))
    pairBox.pairLeft = 4
    assertPair("pair left update", pairValue(pairBox), 4, 9)
    pairBox.pairRight = intValue(numeric)
    assertPair("pair right update", pairValue(pairBox), 4, 17)
    pairBox.pairShift = 3
    assertPair("pair shift update", pairValue(pairBox), 7, 14)
    pairBox.id.pairLeft = pairValue(pairBox).right
    assertPair("pair id left update", pairValue(pairBox), 14, 14)
    pairBox.clone.pairRight = 99
    assertPair("pair clone right leaves original", pairValue(pairBox), 14, 14)

    let leftOnly = pairBox.leftBox
    leftOnly.add = 6
    assertInt("left box temp update", intValue(leftOnly), 20)
    assertPair("left temp leaves pair", pairValue(pairBox), 14, 14)
    let sumBox = pairBox.sumBox
    sumBox.mul = 2
    assertInt("sum box update", intValue(sumBox), 56)

    let text = boxed("world")
    text.prepend = "hello-"
    assertString("prepend string", stringValue(text), "hello-world")
    text.replaceFirst = r'H'
    assertString("replace first", stringValue(text), "Hello-world")
    text.id.prepend = "say:"
    assertString("id prepend", stringValue(text), "say:Hello-world")
    text.clone.prepend = "lost:"
    assertString("clone prepend leaves original", stringValue(text), "say:Hello-world")
    let lenBox = text.textLen
    lenBox.add = 1
    assertInt("textLen temp update", intValue(lenBox), 16)

    let flag = boxed(true)
    flag.toggle = false
    assertBool("toggle ignores value", DummyRT.fromExtern<Bool>(flag), false)
    flag.id.toggle = true
    assertBool("toggle through id", DummyRT.fromExtern<Bool>(flag), true)

    let map = HashMap<String, Int64>()
    map["left"] = 0
    map["right"] = 0
    map["sum"] = 0
    let mapBox = boxed(map)
    mapBox.put = Pair(7, 11)
    let mapPayload = DummyRT.fromExtern<HashMap<String, Int64>>(mapBox)
    assertInt("map put left", mapPayload["left"], 7)
    assertInt("map put right", mapPayload["right"], 11)
    assertInt("map put sum", mapPayload["sum"], 18)
    mapBox.id.put = Pair(intValue(numeric), intValue(other))
    assertInt("map id put left", mapPayload["left"], 17)
    assertInt("map id put right", mapPayload["right"], 85)
    assertInt("map id put sum", mapPayload["sum"], 102)

    let staged = boxed(1)
    staged.add = 1
    staged.mul = intValue(staged) + 3
    staged.sub = intValue(numeric) - 10
    assertInt("staged rhs expressions", intValue(staged), 3)

    let selectedForUpdate = choose(intValue(staged) == 3, staged, numeric)
    selectedForUpdate.set = Pair(intValue(numeric), intValue(other))
    assertPair("selected set pair", pairValue(staged), 17, 85)

    expectMissingMember(staged)
    expectWrongPayload(boxed("not-number"))
    try {
        text.pairLeft = 1
        throw Exception("string pairLeft did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        mapBox.add = 1
        throw Exception("map add did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    if (countSets < 2) { throw Exception("set count too low") }
    if (countStrings < 3) { throw Exception("string count too low") }
    if (countMaps < 2) { throw Exception("map count too low") }


    let finalNumber = boxed(2)
    finalNumber.add = intValue(numeric)
    assertInt("final add from numeric", intValue(finalNumber), 19)
    finalNumber.mul = pairValue(pairBox).left
    assertInt("final multiply from pair", intValue(finalNumber), 266)
    finalNumber.sub = DummyRT.fromExtern<Int64>(sumBox)
    assertInt("final subtract temp sum", intValue(finalNumber), 210)

    let finalPair = boxed(Pair(0, 0))
    finalPair.pairLeft = intValue(finalNumber)
    finalPair.pairRight = intValue(other)
    assertPair("final pair from extern values", pairValue(finalPair), 210, 85)
    finalPair.pairShift = 5
    assertPair("final pair shift", pairValue(finalPair), 215, 80)

    let finalText = boxed("core")
    finalText.prepend = stringValue(text)
    assertString("final text prepend extern", stringValue(finalText), "say:Hello-worldcore")
    finalText.replaceFirst = r'S'
    assertString("final text replace", stringValue(finalText), "Say:Hello-worldcore")

    let finalFlag = boxed(false)
    finalFlag.toggle = true
    assertBool("final flag toggle once", DummyRT.fromExtern<Bool>(finalFlag), true)
    finalFlag.toggle = false
    assertBool("final flag toggle twice", DummyRT.fromExtern<Bool>(finalFlag), false)

    let finalMap = HashMap<String, Int64>()
    finalMap["left"] = -1
    finalMap["right"] = -1
    finalMap["sum"] = -1
    let finalMapBox = boxed(finalMap)
    finalMapBox.put = pairValue(finalPair)
    assertInt("final map pair left", finalMap["left"], 215)
    assertInt("final map pair right", finalMap["right"], 80)
    assertInt("final map pair sum", finalMap["sum"], 295)

    let finalSelected = choose(finalMap["sum"] > 100, finalNumber, numeric)
    finalSelected.set = finalMap["sum"]
    assertInt("final selected set", intValue(finalNumber), 295)
    assertInt("final selected leaves numeric", intValue(numeric), 17)

    try {
        finalPair.prepend = "bad"
        throw Exception("pair prepend did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        finalFlag.put = Pair(1, 2)
        throw Exception("bool put did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }


    let receiverArray: Array<Extern<DummyRT>> = [boxed(1), boxed(Pair(2, 3)), boxed("tail")]
    receiverArray[0].add = 41
    assertInt("array receiver member update", intValue(receiverArray[0]), 42)
    receiverArray[1].pairMerge = Pair(intValue(receiverArray[0]), 10)
    assertPair("array receiver pair merge", pairValue(receiverArray[1]), 44, 13)
    receiverArray[1].pairSwap = true
    assertPair("array receiver pair swap", pairValue(receiverArray[1]), 13, 44)
    receiverArray[2].prepend = stringValue(text)
    assertString("array receiver string prepend", stringValue(receiverArray[2]), "say:Hello-worldtail")

    let receiverMap = HashMap<String, Extern<DummyRT>>()
    receiverMap["n"] = boxed(5)
    receiverMap["p"] = boxed(Pair(1, 1))
    receiverMap["s"] = boxed("map")
    receiverMap["n"].mul = receiverArray.size
    assertInt("map receiver numeric mul", intValue(receiverMap["n"]), 15)
    receiverMap["p"].pairMerge = Pair(intValue(receiverMap["n"]), intValue(receiverArray[0]))
    assertPair("map receiver pair merge", pairValue(receiverMap["p"]), 16, 43)
    receiverMap["s"].prepend = "from-"
    assertString("map receiver string prepend", stringValue(receiverMap["s"]), "from-map")

    let conditionalReceiver = if (intValue(receiverMap["n"]) == 15) { receiverMap["n"] } else { receiverArray[0] }
    conditionalReceiver.resetIf = true
    assertInt("conditional receiver reset", intValue(receiverMap["n"]), 0)
    assertInt("conditional receiver other unchanged", intValue(receiverArray[0]), 42)

    let mergeLeft = HashMap<String, Int64>()
    mergeLeft["left"] = 1
    mergeLeft["right"] = 2
    mergeLeft["sum"] = 3
    let mergeRight = HashMap<String, Int64>()
    mergeRight["left"] = intValue(receiverArray[0])
    mergeRight["right"] = intValue(receiverMap["n"])
    mergeRight["sum"] = 0
    let mergeBox = boxed(mergeLeft)
    mergeBox.mergeMap = mergeRight
    let merged = DummyRT.fromExtern<HashMap<String, Int64>>(mergeBox)
    assertInt("merge map left", merged["left"], 43)
    assertInt("merge map right", merged["right"], 2)
    assertInt("merge map sum", merged["sum"], 45)

    try {
        receiverArray[0].pairSwap = true
        throw Exception("numeric pairSwap did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        mergeBox.mergeMap = Pair(1, 2)
        throw Exception("mergeMap pair did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    0
}

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
var countIndexAdds: Int64 = 0
var countStringUpdates: Int64 = 0
var countArrayUpdates: Int64 = 0
var countMapUpdates: Int64 = 0

public class DummyRT <: Runtime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        let box = (getPayload(e) as Boxed).getOrThrow()
        match (field) {
            case "id" => e
            case "inc" =>
                countIncs = countIncs + 1
                Extern<DummyRT>(Boxed((box.value as Int64).getOrThrow() + 1))
            case "clone" => Extern<DummyRT>(Boxed(box.value))
            case "leftBox" =>
                let pair = (box.value as Pair).getOrThrow()
                Extern<DummyRT>(Boxed(pair.left))
            case "row" =>
                let m = (box.value as HashMap<String, Array<Int64>>).getOrThrow()
                Extern<DummyRT>(Boxed(m["row"]))
            case _ => throw MemberAccessException("memberAccess not implemented")
        }
    }
    public static func indexAccess(e: Extern<DummyRT>, index: Any): Extern<DummyRT> {
        let box = (getPayload(e) as Boxed).getOrThrow()
        match (index) {
            case i: Int64 => Extern<DummyRT>(Boxed((box.value as Array<Int64>).getOrThrow()[i]))
            case field: String =>
                if (box.value is HashMap<String, Array<Int64>>) {
                    Extern<DummyRT>(Boxed((box.value as HashMap<String, Array<Int64>>).getOrThrow()[field]))
                } else if (box.value is HashMap<String, Int64>) {
                    Extern<DummyRT>(Boxed((box.value as HashMap<String, Int64>).getOrThrow()[field]))
                } else {
                    let pair = (box.value as Pair).getOrThrow()
                    match (field) {
                        case "left" => Extern<DummyRT>(Boxed(pair.left))
                        case "right" => Extern<DummyRT>(Boxed(pair.right))
                        case "sum" => Extern<DummyRT>(Boxed(pair.left + pair.right))
                        case _ => throw IndexAccessException("unknown pair field")
                    }
                }
            case flag: Bool =>
                let pair = (box.value as Pair).getOrThrow()
                if (flag) { Extern<DummyRT>(Boxed(pair.left)) } else { Extern<DummyRT>(Boxed(pair.right)) }
            case _ => throw IndexAccessException("indexAccess not implemented")
        }
    }
    public static func memberUpdate(_: Extern<DummyRT>, _: String, _: Any): Unit {
        throw Exception("memberUpdate not implemented")
    }
    public static func indexUpdate(e: Extern<DummyRT>, index: Any, value: Any): Unit {
        let box = (getPayload(e) as Boxed).getOrThrow()
        match (index) {
            case field: String => match (field) {
                case "add" =>
                    countIndexAdds = countIndexAdds + 1
                    box.value = (box.value as Int64).getOrThrow() + (value as Int64).getOrThrow()
                case "set" => box.value = value
                case "prepend" =>
                    countStringUpdates = countStringUpdates + 1
                    box.value = (value as String).getOrThrow() + (box.value as String).getOrThrow()
                case "replaceFirst" =>
                    countStringUpdates = countStringUpdates + 1
                    let s = (box.value as String).getOrThrow()
                    let c = (value as Rune).getOrThrow()
                    box.value = String([c]) + s[1..]
                case "pairLeft" =>
                    let pair = (box.value as Pair).getOrThrow()
                    box.value = Pair((value as Int64).getOrThrow(), pair.right)
                case "pairRight" =>
                    let pair = (box.value as Pair).getOrThrow()
                    box.value = Pair(pair.left, (value as Int64).getOrThrow())
                case "put" =>
                    countMapUpdates = countMapUpdates + 1
                    let m = (box.value as HashMap<String, Int64>).getOrThrow()
                    let pair = (value as Pair).getOrThrow()
                    m["left"] = pair.left
                    m["right"] = pair.right
                    m["sum"] = pair.left + pair.right
                case "mergeMap" =>
                    countMapUpdates = countMapUpdates + 1
                    let m = (box.value as HashMap<String, Int64>).getOrThrow()
                    let other = (value as HashMap<String, Int64>).getOrThrow()
                    m["left"] = m["left"] + other["left"]
                    m["right"] = m["right"] + other["right"]
                    m["sum"] = m["left"] + m["right"]
                case _ => throw IndexAccessException("string index update not implemented")
            }
            case i: Int64 =>
                countArrayUpdates = countArrayUpdates + 1
                let array = (box.value as Array<Int64>).getOrThrow()
                array[i] = (value as Int64).getOrThrow()
            case i: Int32 =>
                countArrayUpdates = countArrayUpdates + 1
                let array = (box.value as Array<Int64>).getOrThrow()
                array[Int64(i)] = (value as Int64).getOrThrow()
            case flag: Bool =>
                let pair = (box.value as Pair).getOrThrow()
                if (flag) {
                    box.value = Pair((value as Int64).getOrThrow(), pair.right)
                } else {
                    box.value = Pair(pair.left, (value as Int64).getOrThrow())
                }
            case _ => throw IndexAccessException("indexUpdate not implemented")
        }
    }
    public static func functionCall(_: Extern<DummyRT>, _: Array<Any>): Extern<DummyRT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        match (None<R>) {
            case _: Option<Int64> => ((getPayload(e) as Boxed).getOrThrow().value as R).getOrThrow()
            case _: Option<String> => ((getPayload(e) as Boxed).getOrThrow().value as R).getOrThrow()
            case _: Option<Pair> => ((getPayload(e) as Boxed).getOrThrow().value as R).getOrThrow()
            case _: Option<Array<Int64>> => ((getPayload(e) as Boxed).getOrThrow().value as R).getOrThrow()
            case _: Option<HashMap<String, Int64>> => ((getPayload(e) as Boxed).getOrThrow().value as R).getOrThrow()
            case _: Option<HashMap<String, Array<Int64>>> => ((getPayload(e) as Boxed).getOrThrow().value as R).getOrThrow()
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

func arrayValue(e: Extern<DummyRT>): Array<Int64> {
    DummyRT.fromExtern<Array<Int64>>(e)
}

func assertInt(name: String, actual: Int64, expected: Int64) {
    if (actual != expected) { throw Exception(name) }
}

func assertString(name: String, actual: String, expected: String) {
    if (actual != expected) { throw Exception(name) }
}

func assertPair(name: String, p: Pair, left: Int64, right: Int64) {
    if (p.left != left || p.right != right) { throw Exception(name) }
}

func expectBadIndex(e: Extern<DummyRT>, index: Int64) {
    try {
        e[index] = 1
        throw Exception("bad index did not throw")
    } catch (e: IndexOutOfBoundsException) {
        // Expected
    }
}

func expectMissingStringIndex(e: Extern<DummyRT>) {
    try {
        e["missing"] = 1
        throw Exception("missing index update did not throw")
    } catch (e: IndexAccessException) {
        // Expected
    }
}

main () {
    let numeric = boxed(0)
    numeric["add"] = 10
    assertInt("string add", intValue(numeric), 10)
    numeric["add"] = 5
    assertInt("string add again", intValue(numeric), 15)
    numeric["set"] = 3
    assertInt("string set", intValue(numeric), 3)
    pass(numeric)["add"] = 7
    assertInt("pass string add", intValue(numeric), 10)
    choose(true, numeric, boxed(0))["add"] = 2
    assertInt("choose left string add", intValue(numeric), 12)
    // TODO: compiler assertion in RecoverToSubscriptExpr when the index-update receiver
    // is a call whose argument is an extern subscript expression:
    // pass(numeric["add"])["set"] = 1

    let currentIncs = countIncs
    let currentAdds = countIndexAdds
    numeric.inc.inc["add"] = 100
    assertInt("inc chain index update leaves original", intValue(numeric), 12)
    if (countIncs - currentIncs != 2) { throw Exception("inc count") }
    if (countIndexAdds - currentAdds != 1) { throw Exception("index add count") }

    numeric.id["add"] = 8
    assertInt("id string add updates original", intValue(numeric), 20)
    numeric.clone["add"] = 100
    assertInt("clone string add leaves original", intValue(numeric), 20)

    let text = boxed("world")
    text["prepend"] = "hello-"
    assertString("prepend index string", stringValue(text), "hello-world")
    text["replaceFirst"] = r'H'
    assertString("replace first index string", stringValue(text), "Hello-world")
    text.id["prepend"] = "say:"
    assertString("id prepend index string", stringValue(text), "say:Hello-world")
    text.clone["prepend"] = "lost:"
    assertString("clone prepend leaves original", stringValue(text), "say:Hello-world")

    let pairBox = boxed(Pair(1, 9))
    pairBox["pairLeft"] = 4
    assertPair("string pair left", pairValue(pairBox), 4, 9)
    pairBox["pairRight"] = intValue(numeric)
    assertPair("string pair right", pairValue(pairBox), 4, 20)
    pairBox[true] = 7
    assertPair("bool pair left", pairValue(pairBox), 7, 20)
    pairBox[false] = 14
    assertPair("bool pair right", pairValue(pairBox), 7, 14)
    pairBox.id[false] = 21
    assertPair("id bool pair right", pairValue(pairBox), 7, 21)
    pairBox.clone[true] = 99
    assertPair("clone bool pair leaves original", pairValue(pairBox), 7, 21)

    let leftBox = pairBox.leftBox
    leftBox["add"] = 5
    assertInt("leftBox temp index update", intValue(leftBox), 12)
    assertPair("leftBox leaves pair", pairValue(pairBox), 7, 21)

    let array: Array<Int64> = [1, 2, 3, 4, 5]
    let arrayBox = boxed(array)
    arrayBox[0] = 10
    assertInt("array index zero", array[0], 10)
    arrayBox[2] = intValue(numeric)
    assertInt("array index rhs extern", array[2], 20)
    let i32: Int32 = 3
    arrayBox[i32] = 30
    assertInt("array Int32 index", array[3], 30)
    pass(arrayBox)[4] = 40
    assertInt("array pass index", array[4], 40)
    arrayBox.clone[1] = 200
    assertInt("array clone shares payload", array[1], 200)

    let rows = HashMap<String, Array<Int64>>()
    rows["row"] = [3, 6, 9]
    let rowsBox = boxed(rows)
    rowsBox.row[1] = 60
    let rowPayload = DummyRT.fromExtern<HashMap<String, Array<Int64>>>(rowsBox)["row"]
    assertInt("row member index update", rowPayload[1], 60)

    let map = HashMap<String, Int64>()
    map["left"] = 0
    map["right"] = 0
    map["sum"] = 0
    let mapBox = boxed(map)
    mapBox["put"] = Pair(array[0], array[2])
    assertInt("map put left", map["left"], 10)
    assertInt("map put right", map["right"], 20)
    assertInt("map put sum", map["sum"], 30)
    mapBox.id["put"] = Pair(intValue(numeric), rowPayload[1])
    assertInt("map id put left", map["left"], 20)
    assertInt("map id put right", map["right"], 60)
    assertInt("map id put sum", map["sum"], 80)

    let selected = choose(false, boxed(0), numeric)
    selected["set"] = Pair(map["left"], map["right"])
    assertPair("selected index set pair", pairValue(numeric), 20, 60)

    expectBadIndex(arrayBox, 99)
    expectMissingStringIndex(numeric)
    try {
        text[0] = 1
        throw Exception("string numeric index did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }
    try {
        pairBox["add"] = 1
        throw Exception("pair add index did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    if (countStringUpdates < 3) { throw Exception("string update count") }
    if (countArrayUpdates < 6) { throw Exception("array update count") }
    if (countMapUpdates < 2) { throw Exception("map update count") }


    let finalArray: Array<Int64> = [0, 0, 0, 0]
    let finalArrayBox = boxed(finalArray)
    finalArrayBox[0] = intValue(numeric.leftBox)
    finalArrayBox[1] = rowPayload[1]
    finalArrayBox[2] = map["sum"]
    finalArrayBox[3] = pairValue(numeric).right
    assertInt("final array first", finalArray[0], 20)
    assertInt("final array second", finalArray[1], 60)
    assertInt("final array third", finalArray[2], 80)
    assertInt("final array fourth", finalArray[3], 60)

    let finalPair = boxed(Pair(0, 0))
    finalPair[true] = finalArray[0] + finalArray[1]
    finalPair[false] = finalArray[2] + finalArray[3]
    assertPair("final bool pair update", pairValue(finalPair), 80, 140)

    let finalText = boxed("tail")
    finalText["prepend"] = stringValue(text)
    assertString("final index text prepend", stringValue(finalText), "say:Hello-worldtail")
    finalText["replaceFirst"] = r'S'
    assertString("final index text replace", stringValue(finalText), "Say:Hello-worldtail")

    let finalMap = HashMap<String, Int64>()
    finalMap["left"] = 0
    finalMap["right"] = 0
    finalMap["sum"] = 0
    let finalMapBox = boxed(finalMap)
    finalMapBox["put"] = pairValue(finalPair)
    assertInt("final index map left", finalMap["left"], 80)
    assertInt("final index map right", finalMap["right"], 140)
    assertInt("final index map sum", finalMap["sum"], 220)

    let finalRows = HashMap<String, Array<Int64>>()
    finalRows["row"] = [1, 2, 3]
    let finalRowsBox = boxed(finalRows)
    finalRowsBox.row[0] = finalMap["left"]
    finalRowsBox.row[2] = finalMap["sum"]
    assertInt("final row first", finalRows["row"][0], 80)
    assertInt("final row last", finalRows["row"][2], 220)

    let finalChoice = choose(finalRows["row"][2] > 100, finalPair, numeric)
    finalChoice[false] = finalRows["row"][0]
    assertPair("final choice updates pair", pairValue(finalPair), 80, 80)

    try {
        finalMapBox[0] = 1
        throw Exception("map numeric index did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        finalArrayBox["put"] = Pair(1, 2)
        throw Exception("array put did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }


    let indexedReceivers: Array<Extern<DummyRT>> = [boxed(2), boxed(Pair(3, 4)), boxed([9, 8, 7])]
    indexedReceivers[0]["add"] = 40
    assertInt("array receiver index add", intValue(indexedReceivers[0]), 42)
    indexedReceivers[1][true] = intValue(indexedReceivers[0])
    indexedReceivers[1][false] = 24
    assertPair("array receiver bool pair", pairValue(indexedReceivers[1]), 42, 24)
    indexedReceivers[2][1] = pairValue(indexedReceivers[1]).right
    assertInt("array receiver nested array", DummyRT.fromExtern<Array<Int64>>(indexedReceivers[2])[1], 24)

    let indexedMap = HashMap<String, Extern<DummyRT>>()
    indexedMap["number"] = boxed(1)
    indexedMap["pair"] = boxed(Pair(5, 6))
    indexedMap["array"] = boxed([0, 0, 0])
    indexedMap["number"]["set"] = intValue(indexedReceivers[0])
    assertInt("map receiver index set", intValue(indexedMap["number"]), 42)
    indexedMap["pair"][false] = intValue(indexedMap["number"])
    assertPair("map receiver bool right", pairValue(indexedMap["pair"]), 5, 42)
    indexedMap["array"][2] = pairValue(indexedMap["pair"]).right
    assertInt("map receiver array index", DummyRT.fromExtern<Array<Int64>>(indexedMap["array"])[2], 42)

    let indexMergeLeft = HashMap<String, Int64>()
    indexMergeLeft["left"] = 10
    indexMergeLeft["right"] = 20
    indexMergeLeft["sum"] = 30
    let indexMergeRight = HashMap<String, Int64>()
    indexMergeRight["left"] = 1
    indexMergeRight["right"] = 2
    indexMergeRight["sum"] = 0
    let indexMergeBox = boxed(indexMergeLeft)
    indexMergeBox["mergeMap"] = indexMergeRight
    assertInt("index merge left", indexMergeLeft["left"], 11)
    assertInt("index merge right", indexMergeLeft["right"], 22)
    assertInt("index merge sum", indexMergeLeft["sum"], 33)

    let selectedIndexReceiver = if (indexMergeLeft["sum"] == 33) { indexedMap["array"] } else { indexedReceivers[2] }
    selectedIndexReceiver[0] = indexMergeLeft["sum"]
    assertInt("selected index receiver update", DummyRT.fromExtern<Array<Int64>>(indexedMap["array"])[0], 33)
    assertInt("selected index receiver other", DummyRT.fromExtern<Array<Int64>>(indexedReceivers[2])[0], 9)

    try {
        indexedMap["pair"][9] = 1
        throw Exception("pair numeric index update did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        indexMergeBox["mergeMap"] = Pair(1, 2)
        throw Exception("index mergeMap pair did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    0
}

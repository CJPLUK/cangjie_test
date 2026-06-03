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
    public static func memberAccess(_: Extern<DummyRT>, _: String): Extern<DummyRT> {
        throw Exception("memberAccess not implemented")
    }
    public static func indexAccess(e: Extern<DummyRT>, index: Any): Extern<DummyRT> {
        let payload = getPayload(e)
        if (index is Int64) {
            if (payload is Array<Int64>) {
                Extern<DummyRT>((payload as Array<Int64>).getOrThrow()[(index as Int64).getOrThrow()])
            } else {
                Extern<DummyRT>((payload as Array<String>).getOrThrow()[(index as Int64).getOrThrow()])
            }
        } else if (index is UInt32) {
            Extern<DummyRT>((payload as Array<Pair>).getOrThrow()[Int64((index as UInt32).getOrThrow())])
        } else if (index is Int32) {
            if (payload is Array<Int64>) {
                Extern<DummyRT>((payload as Array<Int64>).getOrThrow()[Int64((index as Int32).getOrThrow())])
            } else {
                Extern<DummyRT>((payload as Array<String>).getOrThrow()[Int64((index as Int32).getOrThrow())])
            }
        } else if (index is IntNative) {
            if (payload is Array<Int64>) {
                Extern<DummyRT>((payload as Array<Int64>).getOrThrow()[Int64((index as IntNative).getOrThrow())])
            } else {
                Extern<DummyRT>((payload as Array<String>).getOrThrow()[Int64((index as IntNative).getOrThrow())])
            }
        } else if (index is String) {
            if (payload is Pair) {
                let pair = (payload as Pair).getOrThrow()
                match ((index as String).getOrThrow()) {
                    case "left" => Extern<DummyRT>(pair.left)
                    case "right" => Extern<DummyRT>(pair.right)
                    case "sum" => Extern<DummyRT>(pair.left + pair.right)
                    case _ => throw NoneValueException()
                }
            } else if (payload is HashMap<String, Int64>) {
                Extern<DummyRT>((payload as HashMap<String, Int64>).getOrThrow()[(index as String).getOrThrow()])
            } else {
                Extern<DummyRT>((payload as HashMap<String, Array<Int64>>).getOrThrow()[(index as String).getOrThrow()])
            }
        } else if (index is Bool) {
            let pair = (payload as Pair).getOrThrow()
            if ((index as Bool).getOrThrow()) {
                Extern<DummyRT>(pair.left)
            } else {
                Extern<DummyRT>(pair.right)
            }
        } else if (index is Extern<DummyRT>) {
            let key = getPayload((index as Extern<DummyRT>).getOrThrow())
            if (key is String) {
                Extern<DummyRT>((payload as HashMap<String, Int64>).getOrThrow()[(key as String).getOrThrow()])
            } else {
                Extern<DummyRT>((payload as Array<Int64>).getOrThrow()[(key as Int64).getOrThrow()])
            }
        } else {
            throw Exception("indexAccess not implemented")
        }
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

func key(name: String): Extern<DummyRT> {
    Extern<DummyRT>(name)
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

func idx(v: Int64): Int64 {
    v
}

func genericIndex(): Extern<DummyRT> {
    Extern<DummyRT>(3)
}

func expectNoKey(e: Extern<DummyRT>, k: String) {
    try {
        DummyRT.fromExtern<Int64>(e[k])
        throw Exception("missing key did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }
}

func expectBadIndex(e: Extern<DummyRT>, i: Int64) {
    try {
        DummyRT.fromExtern<Int64>(e[i])
        throw Exception("bad index did not throw")
    } catch (e: IndexOutOfBoundsException) {
        // Expected
    }
}


func nestedLookup(e: Extern<DummyRT>, row: String, col: Int64): Int64 {
    DummyRT.fromExtern<Int64>(e[row][col])
    (getPayload(e) as HashMap<String, Array<Int64>>).getOrThrow()[row][col]
}

func pairLookup(e: Extern<DummyRT>, field: String): Int64 {
    DummyRT.fromExtern<Int64>(e[field])
    let pair = (getPayload(e) as Pair).getOrThrow()
    if (field == "right") {
        pair.right
    } else if (field == "sum") {
        pair.left + pair.right
    } else if (field == "left") {
        pair.left
    } else {
        throw NoneValueException()
    }
}

func externKeyLookup(e: Extern<DummyRT>, name: String): Int64 {
    DummyRT.fromExtern<Int64>(e[name])
    (getPayload(e) as HashMap<String, Int64>).getOrThrow()[name]
}

func chooseIndex(flag: Bool): Int64 {
    if (flag) { 0 } else { 2 }
}

main () {
    let ints = Extern<DummyRT>([10, 20, 30, 40])
    assertInt("int index zero", DummyRT.fromExtern<Int64>(ints[0]), 10)
    assertInt("int index from helper", DummyRT.fromExtern<Int64>(ints[idx(2)]), 30)
    assertInt("int index nested expression", DummyRT.fromExtern<Int64>(ints[DummyRT.fromExtern<Int64>(Extern<DummyRT>(3))]), 40)

    let words = Extern<DummyRT>(["zero", "one", "two"])
    assertString("string array zero", DummyRT.fromExtern<String>(words[0]), "zero")
    assertString("string array two", DummyRT.fromExtern<String>(words[2]), "two")

    let pairs: Array<Pair> = [Pair(1, 2), Pair(3, 5), Pair(8, 13)]
    let pairExtern = Extern<DummyRT>(pairs)
    let firstPair = DummyRT.fromExtern<Pair>(pairExtern[UInt32(0)])
    let lastPair = DummyRT.fromExtern<Pair>(pairExtern[UInt32(2)])
    assertInt("pair array first left", firstPair.left, 1)
    assertInt("pair array last right", lastPair.right, 13)

    let byName = HashMap<String, Int64>()
    byName["alpha"] = 7
    byName["beta"] = 11
    byName["gamma"] = 19
    let mapExtern = Extern<DummyRT>(byName)
    assertInt("map alpha", DummyRT.fromExtern<Int64>(mapExtern["alpha"]), 7)
    assertInt("map beta extern key", DummyRT.fromExtern<Int64>(mapExtern[key("beta")]), 11)
    assertInt("map beta direct key", DummyRT.fromExtern<Int64>(mapExtern["beta"]), 11)
    assertInt("map gamma direct", DummyRT.fromExtern<Int64>(mapExtern["gamma"]), 19)

    let table = HashMap<String, Array<Int64>>()
    table["row0"] = [1, 2, 3]
    table["row1"] = [4, 5, 6]
    table["row2"] = [7, 8, 9]
    let tableExtern = Extern<DummyRT>(table)
    assertInt("nested row0 col1", DummyRT.fromExtern<Int64>(tableExtern["row0"][1]), 2)
    assertInt("nested row1 col2", DummyRT.fromExtern<Int64>(tableExtern["row1"][2]), 6)
    assertInt("nested row2 col0", DummyRT.fromExtern<Int64>(tableExtern["row2"][0]), 7)

    let pair = Extern<DummyRT>(Pair(123, 456))
    assertInt("bool true index", DummyRT.fromExtern<Int64>(pair[true]), 123)
    assertInt("bool false index", DummyRT.fromExtern<Int64>(pair[false]), 456)

    expectNoKey(mapExtern, "missing")
    expectNoKey(tableExtern, "missing")
    expectBadIndex(ints, 4)
    expectBadIndex(words, 3)

    try {
        DummyRT.fromExtern<Pair>(mapExtern["alpha"])
        throw Exception("bad pair conversion did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    let extraInts0 = Extern<DummyRT>([5, 6, 7, 8])
    assertInt("extra int idx first 0", DummyRT.fromExtern<Int64>(extraInts0[idx(0)]), 5)
    assertInt("extra int idx second 0", DummyRT.fromExtern<Int64>(extraInts0[idx(1)]), 6)
    assertInt("extra int idx third 0", DummyRT.fromExtern<Int64>(extraInts0[idx(2)]), 7)
    assertInt("extra int idx fourth 0", DummyRT.fromExtern<Int64>(extraInts0[idx(3)]), 8)

    let extraInts1 = Extern<DummyRT>([-4, -3, -2, -1])
    assertInt("extra int idx first 1", DummyRT.fromExtern<Int64>(extraInts1[idx(0)]), -4)
    assertInt("extra int idx second 1", DummyRT.fromExtern<Int64>(extraInts1[idx(1)]), -3)
    assertInt("extra int idx third 1", DummyRT.fromExtern<Int64>(extraInts1[idx(2)]), -2)
    assertInt("extra int idx fourth 1", DummyRT.fromExtern<Int64>(extraInts1[idx(3)]), -1)

    let extraInts2 = Extern<DummyRT>([100, 101, 102, 103])
    assertInt("extra int idx first 2", DummyRT.fromExtern<Int64>(extraInts2[idx(0)]), 100)
    assertInt("extra int idx second 2", DummyRT.fromExtern<Int64>(extraInts2[idx(1)]), 101)
    assertInt("extra int idx third 2", DummyRT.fromExtern<Int64>(extraInts2[idx(2)]), 102)
    assertInt("extra int idx fourth 2", DummyRT.fromExtern<Int64>(extraInts2[idx(3)]), 103)

    let extraInts3 = Extern<DummyRT>([0, 10, 20, 30])
    assertInt("extra int idx first 3", DummyRT.fromExtern<Int64>(extraInts3[idx(0)]), 0)
    assertInt("extra int idx second 3", DummyRT.fromExtern<Int64>(extraInts3[idx(1)]), 10)
    assertInt("extra int idx third 3", DummyRT.fromExtern<Int64>(extraInts3[idx(2)]), 20)
    assertInt("extra int idx fourth 3", DummyRT.fromExtern<Int64>(extraInts3[idx(3)]), 30)

    let extraWords0 = Extern<DummyRT>(["a", "b", "c"])
    assertString("extra words zero 0", DummyRT.fromExtern<String>(extraWords0[0]), "a")
    assertString("extra words one 0", DummyRT.fromExtern<String>(extraWords0[1]), "b")
    assertString("extra words two 0", DummyRT.fromExtern<String>(extraWords0[2]), "c")

    let extraWords1 = Extern<DummyRT>(["red", "green", "blue"])
    assertString("extra words zero 1", DummyRT.fromExtern<String>(extraWords1[0]), "red")
    assertString("extra words one 1", DummyRT.fromExtern<String>(extraWords1[1]), "green")
    assertString("extra words two 1", DummyRT.fromExtern<String>(extraWords1[2]), "blue")

    let extraWords2 = Extern<DummyRT>(["x", "y", "z"])
    assertString("extra words zero 2", DummyRT.fromExtern<String>(extraWords2[0]), "x")
    assertString("extra words one 2", DummyRT.fromExtern<String>(extraWords2[1]), "y")
    assertString("extra words two 2", DummyRT.fromExtern<String>(extraWords2[2]), "z")

    let extraPairs0: Array<Pair> = [Pair(1, 9), Pair(2, 8)]
    let extraPairExtern0 = Extern<DummyRT>(extraPairs0)
    let extraPairLeft0 = DummyRT.fromExtern<Pair>(extraPairExtern0[UInt32(0)])
    let extraPairRight0 = DummyRT.fromExtern<Pair>(extraPairExtern0[UInt32(1)])
    assertInt("extra pair UInt32 left 0", extraPairLeft0.left, 1)
    assertInt("extra pair UInt32 right 0", extraPairRight0.right, 8)

    let extraPairs1: Array<Pair> = [Pair(-1, 1), Pair(-2, 2)]
    let extraPairExtern1 = Extern<DummyRT>(extraPairs1)
    let extraPairLeft1 = DummyRT.fromExtern<Pair>(extraPairExtern1[UInt32(0)])
    let extraPairRight1 = DummyRT.fromExtern<Pair>(extraPairExtern1[UInt32(1)])
    assertInt("extra pair UInt32 left 1", extraPairLeft1.left, -1)
    assertInt("extra pair UInt32 right 1", extraPairRight1.right, 2)

    let extraPairs2: Array<Pair> = [Pair(30, 40), Pair(50, 60)]
    let extraPairExtern2 = Extern<DummyRT>(extraPairs2)
    let extraPairLeft2 = DummyRT.fromExtern<Pair>(extraPairExtern2[UInt32(0)])
    let extraPairRight2 = DummyRT.fromExtern<Pair>(extraPairExtern2[UInt32(1)])
    assertInt("extra pair UInt32 left 2", extraPairLeft2.left, 30)
    assertInt("extra pair UInt32 right 2", extraPairRight2.right, 60)

    let extraPairs3: Array<Pair> = [Pair(7, 11), Pair(13, 17)]
    let extraPairExtern3 = Extern<DummyRT>(extraPairs3)
    let extraPairLeft3 = DummyRT.fromExtern<Pair>(extraPairExtern3[UInt32(0)])
    let extraPairRight3 = DummyRT.fromExtern<Pair>(extraPairExtern3[UInt32(1)])
    assertInt("extra pair UInt32 left 3", extraPairLeft3.left, 7)
    assertInt("extra pair UInt32 right 3", extraPairRight3.right, 17)

    let extraMap0 = HashMap<String, Int64>()
    extraMap0["k0"] = 0
    extraMap0["other"] = 1
    let extraMapExtern0 = Extern<DummyRT>(extraMap0)
    assertInt("extra direct key 0", DummyRT.fromExtern<Int64>(extraMapExtern0["k0"]), 0)
    assertInt("extra extern key 0", DummyRT.fromExtern<Int64>(extraMapExtern0[key("other")]), 1)
    assertInt("extra direct other key 0", DummyRT.fromExtern<Int64>(extraMapExtern0["other"]), 1)

    let extraMap1 = HashMap<String, Int64>()
    extraMap1["k1"] = 10
    extraMap1["other"] = 11
    let extraMapExtern1 = Extern<DummyRT>(extraMap1)
    assertInt("extra direct key 1", DummyRT.fromExtern<Int64>(extraMapExtern1["k1"]), 10)
    assertInt("extra extern key 1", DummyRT.fromExtern<Int64>(extraMapExtern1[key("other")]), 11)
    assertInt("extra direct other key 1", DummyRT.fromExtern<Int64>(extraMapExtern1["other"]), 11)

    let extraMap2 = HashMap<String, Int64>()
    extraMap2["k2"] = 20
    extraMap2["other"] = 21
    let extraMapExtern2 = Extern<DummyRT>(extraMap2)
    assertInt("extra direct key 2", DummyRT.fromExtern<Int64>(extraMapExtern2["k2"]), 20)
    assertInt("extra extern key 2", DummyRT.fromExtern<Int64>(extraMapExtern2[key("other")]), 21)
    assertInt("extra direct other key 2", DummyRT.fromExtern<Int64>(extraMapExtern2["other"]), 21)

    let extraMap3 = HashMap<String, Int64>()
    extraMap3["k3"] = 30
    extraMap3["other"] = 31
    let extraMapExtern3 = Extern<DummyRT>(extraMap3)
    assertInt("extra direct key 3", DummyRT.fromExtern<Int64>(extraMapExtern3["k3"]), 30)
    assertInt("extra extern key 3", DummyRT.fromExtern<Int64>(extraMapExtern3[key("other")]), 31)
    assertInt("extra direct other key 3", DummyRT.fromExtern<Int64>(extraMapExtern3["other"]), 31)

    let extraMap4 = HashMap<String, Int64>()
    extraMap4["k4"] = 40
    extraMap4["other"] = 41
    let extraMapExtern4 = Extern<DummyRT>(extraMap4)
    assertInt("extra direct key 4", DummyRT.fromExtern<Int64>(extraMapExtern4["k4"]), 40)
    assertInt("extra extern key 4", DummyRT.fromExtern<Int64>(extraMapExtern4[key("other")]), 41)
    assertInt("extra direct other key 4", DummyRT.fromExtern<Int64>(extraMapExtern4["other"]), 41)

    let extraBoolPair0 = Extern<DummyRT>(Pair(1, 2))
    assertInt("extra bool true 0", DummyRT.fromExtern<Int64>(extraBoolPair0[true]), 1)
    assertInt("extra bool false 0", DummyRT.fromExtern<Int64>(extraBoolPair0[false]), 2)

    let extraBoolPair1 = Extern<DummyRT>(Pair(-5, 5))
    assertInt("extra bool true 1", DummyRT.fromExtern<Int64>(extraBoolPair1[true]), -5)
    assertInt("extra bool false 1", DummyRT.fromExtern<Int64>(extraBoolPair1[false]), 5)

    let extraBoolPair2 = Extern<DummyRT>(Pair(100, 200))
    assertInt("extra bool true 2", DummyRT.fromExtern<Int64>(extraBoolPair2[true]), 100)
    assertInt("extra bool false 2", DummyRT.fromExtern<Int64>(extraBoolPair2[false]), 200)

    let extraBoolPair3 = Extern<DummyRT>(Pair(0, 9))
    assertInt("extra bool true 3", DummyRT.fromExtern<Int64>(extraBoolPair3[true]), 0)
    assertInt("extra bool false 3", DummyRT.fromExtern<Int64>(extraBoolPair3[false]), 9)

    try {
        DummyRT.fromExtern<Int64>(Extern<DummyRT>([0, 1])[idx(4)])
        throw Exception("extra bad computed index 0")
    } catch (e: IndexOutOfBoundsException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<Int64>(Extern<DummyRT>([1, 2])[idx(4)])
        throw Exception("extra bad computed index 1")
    } catch (e: IndexOutOfBoundsException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<Int64>(Extern<DummyRT>([2, 3])[idx(4)])
        throw Exception("extra bad computed index 2")
    } catch (e: IndexOutOfBoundsException) {
        // Expected
    }


    let pairByString = Extern<DummyRT>(Pair(30, 12))
    assertInt("pair string left", DummyRT.fromExtern<Int64>(pairByString["left"]), 30)
    assertInt("pair string right", DummyRT.fromExtern<Int64>(pairByString["right"]), 12)
    assertInt("pair string sum", DummyRT.fromExtern<Int64>(pairByString["sum"]), 42)
    assertInt("pair bool left fallback", DummyRT.fromExtern<Int64>(pairByString[true]), 30)
    assertInt("pair bool right fallback", DummyRT.fromExtern<Int64>(pairByString[false]), 12)

    let externIndexArray = Extern<DummyRT>([100, 200, 300, 400])
    assertInt("extern numeric key", DummyRT.fromExtern<Int64>(externIndexArray[Extern<DummyRT>(2)]), 300)
    assertInt("extern numeric key expression", DummyRT.fromExtern<Int64>(externIndexArray[genericIndex()]), 400)

    let jagged = HashMap<String, Array<Int64>>()
    jagged["small"] = [1, 1, 2]
    jagged["large"] = [8, 13, 21]
    let jaggedExtern = Extern<DummyRT>(jagged)
    let chosenRow = if (DummyRT.fromExtern<Int64>(pairByString["sum"]) == 42) { "large" } else { "small" }
    assertInt("conditional row index", DummyRT.fromExtern<Int64>(jaggedExtern[chosenRow][idx(1)]), 13)

    let keyedValues = HashMap<String, Int64>()
    keyedValues["left"] = DummyRT.fromExtern<Int64>(pairByString["left"])
    keyedValues["right"] = DummyRT.fromExtern<Int64>(pairByString["right"])
    let keyedExtern = Extern<DummyRT>(keyedValues)
    assertInt("extern key after pair selector", DummyRT.fromExtern<Int64>(keyedExtern[key("left")]), 30)
    assertInt("direct key after pair selector", DummyRT.fromExtern<Int64>(keyedExtern["left"]), 30)
    assertInt("extern key direct after pair selector", DummyRT.fromExtern<Int64>(keyedExtern["right"]), 12)

    try {
        DummyRT.fromExtern<Int64>(pairByString["missing"])
        throw Exception("missing pair string selector")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<Int64>(externIndexArray[Extern<DummyRT>(9)])
        throw Exception("extern numeric key out of bounds")
    } catch (e: IndexOutOfBoundsException) {
        // Expected
    }


    let helperTable = HashMap<String, Array<Int64>>()
    helperTable["front"] = [10, 11, 12]
    helperTable["back"] = [20, 21, 22]
    let helperTableExtern = Extern<DummyRT>(helperTable)
    assertInt("helper nested lookup front", nestedLookup(helperTableExtern, "front", chooseIndex(true)), 10)
    assertInt("helper nested lookup back", nestedLookup(helperTableExtern, "back", chooseIndex(false)), 22)

    let helperPair = Extern<DummyRT>(Pair(14, 28))
    assertInt("helper pair left string", pairLookup(helperPair, "left"), 14)
    assertInt("helper pair right string", pairLookup(helperPair, "right"), 28)
    assertInt("helper pair sum string", pairLookup(helperPair, "sum"), 42)

    let helperMap = HashMap<String, Int64>()
    helperMap["direct"] = 31
    helperMap["extern"] = 42
    let helperMapExtern = Extern<DummyRT>(helperMap)
    assertInt("helper extern key lookup", externKeyLookup(helperMapExtern, "extern"), 42)
    assertInt("helper direct key lookup", DummyRT.fromExtern<Int64>(helperMapExtern["direct"]), 31)

    try {
        nestedLookup(helperTableExtern, "front", 9)
        throw Exception("helper nested bad index")
    } catch (e: IndexOutOfBoundsException) {
        // Expected
    }

    try {
        pairLookup(helperPair, "missing")
        throw Exception("helper pair missing selector")
    } catch (e: NoneValueException) {
        // Expected
    }


    let conditionalIndexArray = Extern<DummyRT>([5, 10, 15, 20])
    let conditionalIndex = if (pairLookup(Extern<DummyRT>(Pair(1, 2)), "sum") == 3) { 3 } else { 0 }
    assertInt("conditional index array", DummyRT.fromExtern<Int64>(conditionalIndexArray[conditionalIndex]), 20)

    let nestedKeyTable = HashMap<String, Array<Int64>>()
    nestedKeyTable["left"] = [1, 3, 5]
    nestedKeyTable["right"] = [2, 4, 6]
    let nestedKeyTableExtern = Extern<DummyRT>(nestedKeyTable)
    let selectedNestedKey = if (DummyRT.fromExtern<Int64>(helperPair["sum"]) == 42) { "right" } else { "left" }
    assertInt("selected nested key", nestedLookup(nestedKeyTableExtern, selectedNestedKey, 2), 6)
    let selectedNestedKey2 = if (DummyRT.fromExtern<Int64>(helperPair[true]) == 14) { "right" } else { "left" }
    assertInt("selected nested key", nestedLookup(nestedKeyTableExtern, selectedNestedKey2, 2), 6)

    let externIndexMap = HashMap<String, Int64>()
    externIndexMap["computed"] = DummyRT.fromExtern<Int64>(conditionalIndexArray[Extern<DummyRT>(1)]) + pairLookup(helperPair, "left")
    externIndexMap["computed"] = DummyRT.fromExtern<Int64>(conditionalIndexArray[1]) + pairLookup(helperPair, "left")
    let externIndexMapExtern = Extern<DummyRT>(externIndexMap)
    assertInt("extern index map computed", externKeyLookup(externIndexMapExtern, "computed"), 24)

    try {
        DummyRT.fromExtern<Int64>(nestedKeyTableExtern["left"])
        throw Exception("array row as int did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    0
}

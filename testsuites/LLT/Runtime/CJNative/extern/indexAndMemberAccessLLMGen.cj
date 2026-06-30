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
        let payload = Extern<DummyRT>.getPayload(e)
        match (field) {
            case "id" => e
            case "sum" =>
                let pair = (payload as Pair).getOrThrow()
                Extern<DummyRT>(pair.left + pair.right)
            case "left" => Extern<DummyRT>((payload as Pair).getOrThrow().left)
            case "right" => Extern<DummyRT>((payload as Pair).getOrThrow().right)
            case "pair" =>
                let values = (payload as Array<Int64>).getOrThrow()
                Extern<DummyRT>(Pair(values[0], values[1]))
            case "asRow" =>
                let pair = (payload as Pair).getOrThrow()
                Extern<DummyRT>([pair.left, pair.right, pair.left + pair.right])
            case "twice" => Extern<DummyRT>((payload as Int64).getOrThrow() * 2)
            case "neg" => Extern<DummyRT>(0 - (payload as Int64).getOrThrow())
            case "pi" => Extern<DummyRT>(3.14)
            case _ => throw MemberAccessException("memberAccess not implemented")
        }
    }
    public static func indexAccess(e: Extern<DummyRT>, index: Any): Extern<DummyRT> {
        let payload = Extern<DummyRT>.getPayload(e)
        if (index is String) {
            if (payload is Pair) {
                let pair = (payload as Pair).getOrThrow()
                match ((index as String).getOrThrow()) {
                    case "left" => Extern<DummyRT>(pair.left)
                    case "right" => Extern<DummyRT>(pair.right)
                    case "sum" => Extern<DummyRT>(pair.left + pair.right)
                    case _ => throw NoneValueException()
                }
            } else if (payload is HashMap<String, Array<Int64>>) {
                Extern<DummyRT>((payload as HashMap<String, Array<Int64>>).getOrThrow()[(index as String).getOrThrow()])
            } else {
                Extern<DummyRT>((payload as HashMap<String, Pair>).getOrThrow()[(index as String).getOrThrow()])
            }
        } else if (index is Int64) {
            Extern<DummyRT>((payload as Array<Int64>).getOrThrow()[(index as Int64).getOrThrow()])
        } else if (index is UInt32) {
            Extern<DummyRT>((payload as Array<Pair>).getOrThrow()[Int64((index as UInt32).getOrThrow())])
        } else if (index is Int32) {
            Extern<DummyRT>((payload as Array<Int64>).getOrThrow()[Int64((index as Int32).getOrThrow())])
        } else if (index is IntNative) {
            Extern<DummyRT>((payload as Array<Int64>).getOrThrow()[Int64((index as IntNative).getOrThrow())])
        } else if (index is Extern<DummyRT>) {
            if (payload is HashMap<String, Pair>) {
                let key = Extern<DummyRT>.getPayload((index as Extern<DummyRT>).getOrThrow())
                Extern<DummyRT>((payload as HashMap<String, Pair>).getOrThrow()[(key as String).getOrThrow()])
            } else {
                (index as Extern<DummyRT>).getOrThrow()
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
            case _: Option<Int64> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<Float64> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<Pair> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<Array<Int64>> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _: Option<HashMap<String, Pair>> => (Extern<DummyRT>.getPayload(h) as R).getOrThrow()
            case _ => throw ExternConversionException("fromExtern not implemented")
        }
    }
    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
}

func hold(e: Extern<DummyRT>): Extern<DummyRT> {
    e
}

func makeKey(name: String): Extern<DummyRT> {
    Extern<DummyRT>(name)
}

func assertInt(name: String, actual: Int64, expected: Int64) {
    if (actual != expected) {
        throw Exception(name)
    }
}

func expectMissingMember(e: Extern<DummyRT>) {
    try {
        DummyRT.fromExtern<Int64>(e.unknown)
        throw Exception("missing member did not throw")
    } catch (e: MemberAccessException) {
        // Expected
    }
}

func expectMissingIndex(e: Extern<DummyRT>, key: String) {
    try {
        DummyRT.fromExtern<Int64>(e[key].sum)
        throw Exception("missing index did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }
}


func mixedPairSum(e: Extern<DummyRT>, key: String): Int64 {
    DummyRT.fromExtern<Int64>(e[key].sum)
    let pair = (Extern<DummyRT>.getPayload(e) as HashMap<String, Pair>).getOrThrow()[key]
    pair.left + pair.right
}

func mixedRowPairSum(e: Extern<DummyRT>, key: String): Int64 {
    DummyRT.fromExtern<Int64>(e[key].pair.sum)
    let row = (Extern<DummyRT>.getPayload(e) as HashMap<String, Array<Int64>>).getOrThrow()[key]
    row[0] + row[1]
}

func mixedRowIndexTwice(e: Extern<DummyRT>, key: String, index: Int64): Int64 {
    DummyRT.fromExtern<Int64>(e[key][index].twice)
    (Extern<DummyRT>.getPayload(e) as HashMap<String, Array<Int64>>).getOrThrow()[key][index] * 2
}

func mixedExternKeyRight(e: Extern<DummyRT>, key: String): Int64 {
    DummyRT.fromExtern<Int64>(e[key].right)
    (Extern<DummyRT>.getPayload(e) as HashMap<String, Pair>).getOrThrow()[key].right
}

main () {
    let rows = HashMap<String, Array<Int64>>()
    rows["first"] = [1, 2, 3]
    rows["second"] = [4, 5, 6]
    rows["third"] = [7, 8, 9]
    let rowExtern = Extern<DummyRT>(rows)

    assertInt("index then member pair sum", DummyRT.fromExtern<Int64>(rowExtern["first"].pair.sum), 3)
    assertInt("index then pair left", DummyRT.fromExtern<Int64>(rowExtern["second"].pair.left), 4)
    assertInt("index then pair right", DummyRT.fromExtern<Int64>(rowExtern["third"].pair.right), 8)
    assertInt("index index member", DummyRT.fromExtern<Int64>(rowExtern["first"][2].twice), 6)
    assertInt("member after nested index", DummyRT.fromExtern<Int64>(rowExtern.id["second"][0].neg), -4)

    let pairMap = HashMap<String, Pair>()
    pairMap["low"] = Pair(2, 5)
    pairMap["mid"] = Pair(11, 13)
    pairMap["high"] = Pair(17, 19)
    let pairExtern = Extern<DummyRT>(pairMap)

    assertInt("pair map direct sum", DummyRT.fromExtern<Int64>(pairExtern["low"].sum), 7)
    assertInt("pair map extern key", DummyRT.fromExtern<Int64>(pairExtern[makeKey("mid")].sum), 24)
    assertInt("pair map direct key mid", DummyRT.fromExtern<Int64>(pairExtern["mid"].sum), 24)
    assertInt("pair map chained member", DummyRT.fromExtern<Int64>(pairExtern["high"].sum.twice.neg), -72)

    let pairs: Array<Pair> = [Pair(3, 4), Pair(5, 12), Pair(8, 15)]
    let pairsExtern = Extern<DummyRT>(pairs)
    assertInt("array pair UInt32 left", DummyRT.fromExtern<Int64>(pairsExtern[UInt32(0)].left), 3)
    assertInt("array pair UInt32 sum", DummyRT.fromExtern<Int64>(pairsExtern[UInt32(1)].sum), 17)
    assertInt("array pair UInt32 member chain", DummyRT.fromExtern<Int64>(pairsExtern[UInt32(2)].right.twice), 30)

    let carried = DummyRT.fromExtern<HashMap<String, Pair>>(pairExtern.id["low"].pi[pairExtern])
    if (carried["high"].right != 19) {
        throw Exception("extern-valued passthrough index")
    }

    assertInt("held map extern key", DummyRT.fromExtern<Int64>(hold(pairExtern.id)[makeKey("low")].right.twice), 10)
    assertInt("held map direct key low", DummyRT.fromExtern<Int64>(hold(pairExtern.id)["low"].right.twice), 10)
    assertInt("held row pair", DummyRT.fromExtern<Int64>(hold(rowExtern)["third"].pair.sum.twice), 30)

    if (DummyRT.fromExtern<Float64>(rowExtern["first"].pair.sum.pi) != 3.14) {
        throw Exception("pi after mixed chain")
    }

    expectMissingMember(pairExtern["low"])
    expectMissingIndex(pairExtern, "absent")
    expectMissingIndex(rowExtern, "absent")

    try {
        DummyRT.fromExtern<Pair>(rowExtern["first"][0])
        throw Exception("bad pair conversion did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<Int64>(pairsExtern[UInt32(3)].sum)
        throw Exception("bad UInt32 index did not throw")
    } catch (e: IndexOutOfBoundsException) {
        // Expected
    }


    let pairSelector = pairExtern["mid"]
    assertInt("mixed pair string left", DummyRT.fromExtern<Int64>(pairSelector["left"]), 11)
    assertInt("mixed pair string right", DummyRT.fromExtern<Int64>(pairSelector["right"]), 13)
    assertInt("mixed pair string sum", DummyRT.fromExtern<Int64>(pairSelector["sum"].twice), 48)
    assertInt("mixed pair member left", DummyRT.fromExtern<Int64>(pairSelector.left), 11)
    assertInt("mixed pair member right", DummyRT.fromExtern<Int64>(pairSelector.right), 13)
    assertInt("mixed pair member sum", DummyRT.fromExtern<Int64>(pairSelector.sum.twice), 48)

    let rowFromPair = pairSelector.asRow
    assertInt("row from pair first", DummyRT.fromExtern<Int64>(rowFromPair[0]), 11)
    assertInt("row from pair sum member", DummyRT.fromExtern<Int64>(rowFromPair.pair.sum), 24)
    assertInt("row from pair index member", DummyRT.fromExtern<Int64>(rowFromPair[2].neg), -24)

    let localRows = HashMap<String, Array<Int64>>()
    localRows["fib"] = [1, 1, 2]
    localRows["triple"] = [3, 6, 9]
    let localRowsExtern = Extern<DummyRT>(localRows)
    let selectedKey = if (DummyRT.fromExtern<Int64>(pairSelector["sum"]) > 20) { "triple" } else { "fib" }
    assertInt("conditional mixed key", DummyRT.fromExtern<Int64>(localRowsExtern[selectedKey].pair.sum), 9)
    assertInt("conditional mixed index", DummyRT.fromExtern<Int64>(localRowsExtern[selectedKey][2].twice), 18)

    let mapFromRows = HashMap<String, Pair>()
    mapFromRows["derived"] = Pair(DummyRT.fromExtern<Int64>(localRowsExtern["fib"][2]), DummyRT.fromExtern<Int64>(localRowsExtern["triple"][1]))
    let mapFromRowsExtern = Extern<DummyRT>(mapFromRows)
    assertInt("derived mixed pair sum", DummyRT.fromExtern<Int64>(mapFromRowsExtern[makeKey("derived")].sum), 8)
    assertInt("derived mixed pair direct sum", DummyRT.fromExtern<Int64>(mapFromRowsExtern["derived"].sum), 8)
    assertInt("derived mixed as row index", DummyRT.fromExtern<Int64>(mapFromRowsExtern["derived"].asRow[2]), 8)

    try {
        DummyRT.fromExtern<Int64>(pairSelector.missing)
        throw Exception("missing pair selector in mixed")
    } catch (e: MemberAccessException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<Int64>(rowFromPair[9].twice)
        throw Exception("row from pair bad index")
    } catch (e: IndexOutOfBoundsException) {
        // Expected
    }


    let helperPairs = HashMap<String, Pair>()
    helperPairs["one"] = Pair(9, 10)
    helperPairs["two"] = Pair(20, 22)
    let helperPairsExtern = Extern<DummyRT>(helperPairs)
    assertInt("helper mixed pair sum one", mixedPairSum(helperPairsExtern, "one"), 19)
    assertInt("helper mixed pair sum two", mixedPairSum(helperPairsExtern, "two"), 42)
    assertInt("helper mixed extern key right", mixedExternKeyRight(helperPairsExtern, "two"), 22)

    let helperRows = HashMap<String, Array<Int64>>()
    helperRows["one"] = [3, 4, 5]
    helperRows["two"] = [6, 7, 8]
    let helperRowsExtern = Extern<DummyRT>(helperRows)
    assertInt("helper mixed row pair sum", mixedRowPairSum(helperRowsExtern, "one"), 7)
    assertInt("helper mixed row index twice", mixedRowIndexTwice(helperRowsExtern, "two", 2), 16)

    try {
        mixedPairSum(helperPairsExtern, "missing")
        throw Exception("helper mixed missing pair")
    } catch (e: NoneValueException) {
        // Expected
    }

    try {
        mixedRowIndexTwice(helperRowsExtern, "one", 8)
        throw Exception("helper mixed row bad index")
    } catch (e: IndexOutOfBoundsException) {
        // Expected
    }


    let composedRows = HashMap<String, Array<Int64>>()
    composedRows["fromPair"] = DummyRT.fromExtern<Array<Int64>>(pairExtern["low"].asRow)
    composedRows["literal"] = [2, 4, 8]
    let composedRowsExtern = Extern<DummyRT>(composedRows)
    assertInt("composed row from pair", mixedRowPairSum(composedRowsExtern, "fromPair"), 7)
    assertInt("composed row literal twice", mixedRowIndexTwice(composedRowsExtern, "literal", 2), 16)

    let composedPairs = HashMap<String, Pair>()
    composedPairs["fromRows"] = Pair(mixedRowIndexTwice(rowExtern, "first", 0), mixedRowIndexTwice(rowExtern, "second", 1))
    composedPairs["fromMember"] = DummyRT.fromExtern<Pair>(pairExtern["low"])
    let composedPairsExtern = Extern<DummyRT>(composedPairs)
    assertInt("composed pair from rows", mixedPairSum(composedPairsExtern, "fromRows"), 12)
    assertInt("composed pair from member", mixedExternKeyRight(composedPairsExtern, "fromMember"), 5)

    let selector = if (mixedPairSum(composedPairsExtern, "fromRows") == 12) { "fromMember" } else { "fromRows" }
    assertInt("selector mixed extern key", DummyRT.fromExtern<Int64>(composedPairsExtern[makeKey(selector)].sum.twice), 14)
    assertInt("selector mixed direct key", DummyRT.fromExtern<Int64>(composedPairsExtern[selector].sum.twice), 14)

    try {
        DummyRT.fromExtern<Int64>(composedRowsExtern["literal"].sum)
        throw Exception("array row direct sum member did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }


    let finalMixedRows = HashMap<String, Array<Int64>>()
    finalMixedRows["a"] = [1, 4, 9]
    finalMixedRows["b"] = [16, 25, 36]
    let finalMixedRowsExtern = Extern<DummyRT>(finalMixedRows)
    assertInt("final mixed row a pair", DummyRT.fromExtern<Int64>(finalMixedRowsExtern["a"].pair.sum), 5)
    assertInt("final mixed row b index", DummyRT.fromExtern<Int64>(finalMixedRowsExtern["b"][1].twice), 50)
    assertInt("final mixed row a as row", DummyRT.fromExtern<Int64>(finalMixedRowsExtern["a"].pair.asRow[2]), 5)

    let finalMixedPairs = HashMap<String, Pair>()
    finalMixedPairs["low"] = Pair(DummyRT.fromExtern<Int64>(finalMixedRowsExtern["a"][0]), DummyRT.fromExtern<Int64>(finalMixedRowsExtern["a"][1]))
    finalMixedPairs["high"] = Pair(DummyRT.fromExtern<Int64>(finalMixedRowsExtern["b"][0]), DummyRT.fromExtern<Int64>(finalMixedRowsExtern["b"][2]))
    let finalMixedPairsExtern = Extern<DummyRT>(finalMixedPairs)
    assertInt("final mixed pair low", DummyRT.fromExtern<Int64>(finalMixedPairsExtern["low"].sum), 5)
    assertInt("final mixed pair high", DummyRT.fromExtern<Int64>(finalMixedPairsExtern["high"].sum), 52)
    assertInt("final mixed pair high row", DummyRT.fromExtern<Int64>(finalMixedPairsExtern["high"].asRow[2]), 52)

    try {
        DummyRT.fromExtern<Int64>(finalMixedRowsExtern["a"].pair.missing)
        throw Exception("final mixed missing member did not throw")
    } catch (e: MemberAccessException) {
        // Expected
    }

    try {
        DummyRT.fromExtern<Int64>(finalMixedPairsExtern["missing"].sum)
        throw Exception("final mixed missing key did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }

    0
}

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

struct Box {
    let label: String
    let value: Int64

    public Box(label: String, value: Int64) {
        this.label = label
        this.value = value
    }
}

func anyToInt(v: Any): Int64 {
    if (v is Int64) {
        (v as Int64).getOrThrow()
    } else {
        let payload = getPayload((v as Extern<DummyRT>).getOrThrow())
        (payload as Int64).getOrThrow()
    }
}

func anyToString(v: Any): String {
    if (v is String) {
        (v as String).getOrThrow()
    } else {
        let payload = getPayload((v as Extern<DummyRT>).getOrThrow())
        (payload as String).getOrThrow()
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
            case "boxValue" => Extern<DummyRT>((payload as Box).getOrThrow().value)
            case "boxLabel" => Extern<DummyRT>((payload as Box).getOrThrow().label)
            case "pairFromBox" =>
                let box = (payload as Box).getOrThrow()
                Extern<DummyRT>(Pair(box.value, box.value + 1))
            case "neg" => Extern<DummyRT>(0 - (payload as Int64).getOrThrow())
            case "twice" => Extern<DummyRT>((payload as Int64).getOrThrow() * 2)
            case "isPositive" => Extern<DummyRT>((payload as Int64).getOrThrow() > 0)
            case "tag" => Extern<DummyRT>((payload as String).getOrThrow() + "-tag")
            case "direct" => Extern<DummyRT>(41)
            case "varargs" =>
                Extern<DummyRT>({args: Array<Any> =>
                    var total = Int64(0)
                    for (arg in args) {
                        total += anyToInt(arg)
                    }
                    Extern<DummyRT>(total)
                })
            case "describe" =>
                Extern<DummyRT>({args: Array<Any> =>
                    if (args.size == 0) {
                        Extern<DummyRT>("empty")
                    } else {
                        Extern<DummyRT>("${anyToString(args[0])}:${args.size}")
                    }
                })
            case "join" =>
                let f: (Extern<DummyRT>, Extern<DummyRT>) -> Extern<DummyRT> =
                    {a: Extern<DummyRT>, b: Extern<DummyRT> =>
                        Extern<DummyRT>("${DummyRT.fromExtern<String>(a)}|${DummyRT.fromExtern<String>(b)}")
                    }
                Extern<DummyRT>(f)
            case "unary" =>
                let f: (Int64) -> Int64 = {x: Int64 => x * 3}
                Extern<DummyRT>(f)
            case "binary" =>
                let f: (Int64, Int64) -> Int64 = {x: Int64, y: Int64 => x * 10 + y}
                Extern<DummyRT>(f)
            case "stringer" =>
                let f: (String) -> String = {s: String => "seen ${s}"}
                Extern<DummyRT>(f)
            case "makeUnary" =>
                Extern<DummyRT>({_: Array<Any> =>
                    let f: (Int64) -> Int64 = {x: Int64 => x + 70}
                    Extern<DummyRT>(f)
                })
            case "makeVarargs" =>
                Extern<DummyRT>({_: Array<Any> =>
                    Extern<DummyRT>({args: Array<Any> =>
                        var total = Int64(1)
                        for (arg in args) {
                            total *= anyToInt(arg)
                        }
                        Extern<DummyRT>(total)
                    })
                })
            case "makeJoin" =>
                Extern<DummyRT>({_: Array<Any> =>
                    let f: (Extern<DummyRT>, Extern<DummyRT>) -> Extern<DummyRT> =
                        {a: Extern<DummyRT>, b: Extern<DummyRT> =>
                            Extern<DummyRT>("${DummyRT.fromExtern<String>(b)}:${DummyRT.fromExtern<String>(a)}")
                        }
                    Extern<DummyRT>(f)
                })
            case _ => throw MemberAccessException("memberAccess not implemented")
        }
    }

    public static func indexAccess(e: Extern<DummyRT>, index: Any): Extern<DummyRT> {
        let payload = getPayload(e)
        if (index is String) {
            let key = (index as String).getOrThrow()
            if (payload is HashMap<String, Extern<DummyRT>>) {
                let x = (payload as HashMap<String, Extern<DummyRT>>).getOrThrow()[key]

                x
            } else if (payload is HashMap<String, Array<Extern<DummyRT>>>) {
                Extern<DummyRT>((payload as HashMap<String, Array<Extern<DummyRT>>>).getOrThrow()[key])
            } else if (payload is Pair) {
                let pair = (payload as Pair).getOrThrow()
                match (key) {
                    case "left" => Extern<DummyRT>(pair.left)
                    case "right" => Extern<DummyRT>(pair.right)
                    case "sum" => Extern<DummyRT>(pair.left + pair.right)
                    case _ => throw NoneValueException()
                }
            } else {
                let box = (payload as Box).getOrThrow()
                match (key) {
                    case "label" => Extern<DummyRT>(box.label)
                    case "value" => Extern<DummyRT>(box.value)
                    case _ => throw NoneValueException()
                }
            }
        } else if (index is Int64) {
            let idx = (index as Int64).getOrThrow()
            if (payload is Array<Extern<DummyRT>>) {
                (payload as Array<Extern<DummyRT>>).getOrThrow()[idx]
            } else if (payload is Array<Int64>) {
                Extern<DummyRT>((payload as Array<Int64>).getOrThrow()[idx])
            } else {
                Extern<DummyRT>((payload as Array<String>).getOrThrow()[idx])
            }
        } else if (index is Int32) {
            let idx = Int64((index as Int32).getOrThrow())
            if (payload is Array<Extern<DummyRT>>) {
                (payload as Array<Extern<DummyRT>>).getOrThrow()[idx]
            } else if (payload is Array<Int64>) {
                Extern<DummyRT>((payload as Array<Int64>).getOrThrow()[idx])
            } else {
                Extern<DummyRT>((payload as Array<String>).getOrThrow()[idx])
            }
        } else if (index is UInt32) {
            let idx = Int64((index as UInt32).getOrThrow())
            (payload as Array<Extern<DummyRT>>).getOrThrow()[idx]
        } else if (index is Bool) {
            let pair = (payload as Pair).getOrThrow()
            if ((index as Bool).getOrThrow()) {
                Extern<DummyRT>(pair.left)
            } else {
                Extern<DummyRT>(pair.right)
            }
        } else if (index is Extern<DummyRT>) {
            let keyPayload = getPayload((index as Extern<DummyRT>).getOrThrow())
            if (keyPayload is String) {
                if (payload is HashMap<String, Extern<DummyRT>>) {
                    (payload as HashMap<String, Extern<DummyRT>>).getOrThrow()[(keyPayload as String).getOrThrow()]
                } else if (payload is HashMap<String, Array<Extern<DummyRT>>>) {
                    Extern<DummyRT>((payload as HashMap<String, Array<Extern<DummyRT>>>).getOrThrow()[(keyPayload as String).getOrThrow()])
                } else {
                    throw Exception("Unexpected payload")
                }
            } else {
                (payload as Array<Extern<DummyRT>>).getOrThrow()[(keyPayload as Int64).getOrThrow()]
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

    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        match (getPayload(e)) {
            case i: Int64 => Extern<DummyRT>(i + 100)
            case s: String => Extern<DummyRT>("${s}:${args.size}")
            case f: (Array<Any>) -> Extern<DummyRT> => f(args)
            case g: (String) -> String => Extern<DummyRT>(g(anyToString(args[0])))
            case u: (Int64) -> Int64 => Extern<DummyRT>(u(anyToInt(args[0])))
            case b: (Int64, Int64) -> Int64 => Extern<DummyRT>(b(anyToInt(args[0]), anyToInt(args[1])))
            case h: (Extern<DummyRT>, Extern<DummyRT>) -> Extern<DummyRT> =>
                h((args[0] as Extern<DummyRT>).getOrThrow(), (args[1] as Extern<DummyRT>).getOrThrow())
            case _ => throw Exception("functionCall not implemented")
        }
    }

    public static func fromExtern<R>(h: Extern<DummyRT>): R {
        match (None<R>) {
            case _: Option<Int64> => (getPayload(h) as R).getOrThrow()
            case _: Option<String> => (getPayload(h) as R).getOrThrow()
            case _: Option<Bool> => (getPayload(h) as R).getOrThrow()
            case _: Option<Pair> => (getPayload(h) as R).getOrThrow()
            case _: Option<Box> => (getPayload(h) as R).getOrThrow()
            case _: Option<Array<Extern<DummyRT>>> => (getPayload(h) as R).getOrThrow()
            case _: Option<HashMap<String, Extern<DummyRT>>> => (getPayload(h) as R).getOrThrow()
            case _ => throw ExternConversionException("fromExtern not implemented")
        }
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
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

func key(name: String): Extern<DummyRT> {
    Extern<DummyRT>(name)
}

func keyIndex(i: Int64): Extern<DummyRT> {
    Extern<DummyRT>(i)
}

func hold(e: Extern<DummyRT>): Extern<DummyRT> {
    e
}

func choose(flag: Bool, a: Extern<DummyRT>, b: Extern<DummyRT>): Extern<DummyRT> {
    if (flag) {
        a
    } else {
        b
    }
}

func normalAdd(a: Int64, b: Int64): Int64 {
    a + b
}

func normalLabel(s: String): String {
    "${s}-normal"
}

func makeDirect(v: Int64): Extern<DummyRT> {
    Extern<DummyRT>(v)
}

func makePairMap(): Extern<DummyRT> {
    let m = HashMap<String, Extern<DummyRT>>()
    m["one"] = Extern<DummyRT>(1)
    m["pair"] = Extern<DummyRT>(Pair(8, 13))
    m["word"] = Extern<DummyRT>("map-word")
    m["direct"] = Extern<DummyRT>(41)
    m["varargs"] = Extern<DummyRT>({args: Array<Any> =>
        var total = Int64(0)
        for (arg in args) {
            total += anyToInt(arg)
        }
        Extern<DummyRT>(total)
    })
    m["unary"] = Extern<DummyRT>({x: Int64 => x + 9})
    m["binary"] = Extern<DummyRT>({x: Int64, y: Int64 => x * y})
    m["stringer"] = Extern<DummyRT>({s: String => "${s}!"})
    let f: (Extern<DummyRT>, Extern<DummyRT>) -> Extern<DummyRT> =
        {a: Extern<DummyRT>, b: Extern<DummyRT> =>
            Extern<DummyRT>("${DummyRT.fromExtern<String>(a)}+${DummyRT.fromExtern<String>(b)}")
        }
    m["join"] = Extern<DummyRT>(f)
    Extern<DummyRT>(m)
}

func makeRows(): Extern<DummyRT> {
    let rows = HashMap<String, Array<Extern<DummyRT>>>()
    rows["numbers"] = [Extern<DummyRT>(3), Extern<DummyRT>(5), Extern<DummyRT>(7)]
    rows["functions"] = [
        Extern<DummyRT>({x: Int64 => x * 2}),
        Extern<DummyRT>({x: Int64, y: Int64 => x - y}),
        Extern<DummyRT>({args: Array<Any> => Extern<DummyRT>(anyToInt(args[0]) + anyToInt(args[1]) + anyToInt(args[2]))})
    ]
    rows["strings"] = [Extern<DummyRT>("red"), Extern<DummyRT>("green"), Extern<DummyRT>("blue")]
    Extern<DummyRT>(rows)
}

func expectMissingMember(e: Extern<DummyRT>) {
    try {
        DummyRT.fromExtern<Int64>(e.missing())
        throw Exception("missing member call did not throw")
    } catch (e: MemberAccessException) {
        // Expected
    }
}

func expectBadCallable(e: Extern<DummyRT>) {
    try {
        DummyRT.fromExtern<Int64>(e.stringer("not-int"))
        throw Exception("bad callable did not throw")
    } catch (e: NoneValueException) {
        // Expected
    }
}

func directCallCases() {
    let one = Extern<DummyRT>(1)
    let two = Extern<DummyRT>(2)
    assertInt("direct extern", DummyRT.fromExtern<Int64>(one()), 101)
    assertInt("direct through hold", DummyRT.fromExtern<Int64>(hold(one)()), 101)
    assertInt("direct through choose left", DummyRT.fromExtern<Int64>(choose(true, one, two)()), 101)
    assertInt("direct through choose right", DummyRT.fromExtern<Int64>(choose(false, one, two)()), 102)
    assertInt("direct constructor expression", DummyRT.fromExtern<Int64>(Extern<DummyRT>(9)()), 109)
    assertInt("direct helper expression", DummyRT.fromExtern<Int64>(makeDirect(6)()), 106)

    let saved = one.id
    assertInt("direct saved member", DummyRT.fromExtern<Int64>(saved()), 101)
    let fromNormal = Extern<DummyRT>(normalAdd(3, 4))
    assertInt("normal call builds extern callee", DummyRT.fromExtern<Int64>(fromNormal()), 107)
}

func memberCallCases() {
    let base = Extern<DummyRT>(1)
    assertInt("member id call", DummyRT.fromExtern<Int64>(base.id()), 101)
    assertInt("deep member id call", DummyRT.fromExtern<Int64>(base.id.id.id()), 101)
    assertInt("member numeric transform then call", DummyRT.fromExtern<Int64>(base.id.twice.neg()), 98)
    assertInt("member direct function", DummyRT.fromExtern<Int64>(base.direct()), 141)
    assertInt("member varargs empty", DummyRT.fromExtern<Int64>(base.varargs()), 0)
    assertInt("member varargs literals", DummyRT.fromExtern<Int64>(base.varargs(1, 2, 3)), 6)
    assertInt("member varargs extern args", DummyRT.fromExtern<Int64>(base.varargs(Extern<DummyRT>(4), base.id())), 105)
    assertString("member describe empty", DummyRT.fromExtern<String>(base.describe()), "empty")
    assertString("member describe literal", DummyRT.fromExtern<String>(base.describe("alpha")), "alpha:1")
    assertString("member describe extern", DummyRT.fromExtern<String>(base.describe(Extern<DummyRT>("beta"))), "beta:1")
    assertInt("member unary", DummyRT.fromExtern<Int64>(base.unary(5)), 15)
    assertInt("member binary", DummyRT.fromExtern<Int64>(base.binary(4, 2)), 42)
    assertString("member stringer", DummyRT.fromExtern<String>(base.stringer("word")), "seen word")
    assertString("member join", DummyRT.fromExtern<String>(base.join(Extern<DummyRT>("left"), Extern<DummyRT>("right"))), "left|right")

    let box = Extern<DummyRT>(Box("crate", 10))
    assertInt("box member to pair function", DummyRT.fromExtern<Int64>(box.pairFromBox.sum.twice()), 142)
    assertString("box label member call", DummyRT.fromExtern<String>(box.boxLabel()), "crate:0")
    assertBool("box positive via member", DummyRT.fromExtern<Bool>(box.boxValue.isPositive), true)
}

func indexCallCases() {
    let funcs = makePairMap()
    assertInt("map direct numeric call", DummyRT.fromExtern<Int64>(funcs["one"]()), 101)
    assertInt("map string key helper", DummyRT.fromExtern<Int64>(funcs[key("direct")]()), 141)
    assertInt("map varargs call", DummyRT.fromExtern<Int64>(funcs["varargs"](4, 5, 6)), 15)
    assertInt("map unary call", DummyRT.fromExtern<Int64>(funcs["unary"](11)), 20)
    assertInt("map binary call", DummyRT.fromExtern<Int64>(funcs["binary"](6, 7)), 42)
    assertString("map stringer call", DummyRT.fromExtern<String>(funcs["stringer"]("go")), "go!")
    assertString("map join call", DummyRT.fromExtern<String>(funcs["join"](Extern<DummyRT>("a"), Extern<DummyRT>("b"))), "a+b")

    let arr = Extern<DummyRT>([Extern<DummyRT>(3), Extern<DummyRT>({x: Int64 => x - 1}), Extern<DummyRT>({x: Int64, y: Int64 => x + y})])
    assertInt("array numeric callee", DummyRT.fromExtern<Int64>(arr[0]()), 103)
    assertInt("array unary callee", DummyRT.fromExtern<Int64>(arr[1](9)), 8)
    assertInt("array binary callee", DummyRT.fromExtern<Int64>(arr[2](20, 22)), 42)
    assertInt("array extern index callee", DummyRT.fromExtern<Int64>(arr[keyIndex(0)]()), 103)
    assertInt("array Int32 index callee", DummyRT.fromExtern<Int64>(arr[Int32(1)](5)), 4)
    assertInt("array UInt32 index callee", DummyRT.fromExtern<Int64>(arr[UInt32(2)](2, 3)), 5)
}

func mixedChainCallCases() {
    let funcs = makePairMap()
    let rows = makeRows()
    assertInt("member before index call", DummyRT.fromExtern<Int64>(funcs.id["direct"]()), 141)
    assertInt("index before member call", DummyRT.fromExtern<Int64>(funcs["pair"].sum()), 121)
    assertInt("index member chain call", DummyRT.fromExtern<Int64>(funcs["pair"].swap.sum.twice()), 142)
    assertInt("held map member index call", DummyRT.fromExtern<Int64>(hold(funcs).id[key("unary")](10)), 19)
    assertInt("rows string then index numeric call", DummyRT.fromExtern<Int64>(rows["numbers"][1]()), 105)
    assertInt("rows function unary", DummyRT.fromExtern<Int64>(rows["functions"][0](21)), 42)
    assertInt("rows function binary", DummyRT.fromExtern<Int64>(rows["functions"][1](50, 8)), 42)
    assertInt("rows function varargs", DummyRT.fromExtern<Int64>(rows.id["functions"][2](10, 20, 12)), 42)
    assertString("row string payload direct call", DummyRT.fromExtern<String>(rows["strings"][2]()), "blue:0")
    assertString("row string member call", DummyRT.fromExtern<String>(rows["strings"][0].tag()), "red-tag:0")
}

func nestedReturnedCallCases() {
    let tool = Extern<DummyRT>(1)
    assertInt("returned unary called immediately", DummyRT.fromExtern<Int64>(tool.makeUnary()(2)), 72)
    assertInt("returned unary through member id", DummyRT.fromExtern<Int64>(tool.makeUnary().id(5)), 75)
    assertInt("returned varargs", DummyRT.fromExtern<Int64>(tool.makeVarargs()(2, 3, 7)), 42)
    assertString("returned join", DummyRT.fromExtern<String>(tool.makeJoin()(Extern<DummyRT>("front"), Extern<DummyRT>("back"))), "back:front")

    let funcs = makePairMap()
    assertInt("map returned style via member", DummyRT.fromExtern<Int64>(funcs["one"].makeUnary()(1)), 71)
    assertInt("returned callable used as arg", DummyRT.fromExtern<Int64>(tool.varargs(tool.makeUnary()(1), tool.makeVarargs()(2, 5))), 81)
    assertString("returned callable in string arg", DummyRT.fromExtern<String>(tool.describe(tool.makeJoin()(Extern<DummyRT>("x"), Extern<DummyRT>("y")))), "y:x:1")
}

func argumentExpressionCases() {
    let tool = Extern<DummyRT>(1)
    let funcs = makePairMap()
    let pair = Extern<DummyRT>(Pair(20, 22))
    assertInt("normal call arg", DummyRT.fromExtern<Int64>(tool.varargs(normalAdd(7, 8), 27)), 42)
    assertInt("extern call arg", DummyRT.fromExtern<Int64>(tool.varargs(tool.id(), 1)), 102)
    assertInt("member access arg", DummyRT.fromExtern<Int64>(tool.varargs(pair.left, pair.right)), 42)
    assertInt("index call arg", DummyRT.fromExtern<Int64>(tool.varargs(funcs["unary"](5), funcs["binary"](3, 4))), 26)
    assertInt("nested returned call args", DummyRT.fromExtern<Int64>(tool.varargs(tool.makeUnary()(1), tool.makeVarargs()(2, 3))), 77)
    assertString("normal string arg", DummyRT.fromExtern<String>(tool.describe(normalLabel("arg"))), "arg-normal:1")
    assertString("extern string call arg", DummyRT.fromExtern<String>(tool.describe(funcs["stringer"]("go"))), "go!:1")
    assertString("join args from calls", DummyRT.fromExtern<String>(tool.join(funcs["stringer"]("l"), funcs["stringer"]("r"))), "l!|r!")
}

func storedAndSelectedCalleeCases() {
    let pair = Extern<DummyRT>(Pair(20, 22))
    assertInt("bool true index callee", DummyRT.fromExtern<Int64>(pair[true]()), 120)
    assertInt("bool false index member callee", DummyRT.fromExtern<Int64>(pair[false].twice()), 144)

    let box = Extern<DummyRT>(Box("stored", 12))
    assertInt("box string index callee", DummyRT.fromExtern<Int64>(box["value"]()), 112)
    assertString("box label string index callee", DummyRT.fromExtern<String>(box["label"]()), "stored:0")
    assertInt("box pair from member then bool index call", DummyRT.fromExtern<Int64>(box.pairFromBox[false]()), 113)

    let words = Extern<DummyRT>(["zero", "one", "two"])
    let wordIndex = normalAdd(0, 1)
    assertString("string array computed index callee", DummyRT.fromExtern<String>(words[wordIndex]()), "one:0")
    assertString("string array Int32 index callee", DummyRT.fromExtern<String>(words[Int32(2)].tag()), "two-tag:0")

    let funcs = makePairMap()
    let selectedUnary = funcs["unary"]
    let selectedJoin = funcs["join"]
    assertInt("saved indexed unary callee", DummyRT.fromExtern<Int64>(selectedUnary(14)), 23)
    assertString("saved indexed join callee", DummyRT.fromExtern<String>(selectedJoin(Extern<DummyRT>("saved"), Extern<DummyRT>("callee"))), "saved+callee")
    assertInt("helper returned map member index callee", DummyRT.fromExtern<Int64>(makePairMap().id["binary"](8, 5)), 40)

    let rows = makeRows()
    let pickedFunctions = rows["functions"]
    assertInt("saved row unary callee", DummyRT.fromExtern<Int64>(pickedFunctions[UInt32(0)](6)), 12)
    assertInt("saved row binary callee", DummyRT.fromExtern<Int64>(pickedFunctions[1](50, 8)), 42)
    let green = rows["strings"][1]
    assertString("chosen string row callee", DummyRT.fromExtern<String>(choose(true, green, Extern<DummyRT>("fallback"))()), "green:0")
    assertString("chosen fallback callee", DummyRT.fromExtern<String>(choose(false, green, Extern<DummyRT>("fallback"))()), "fallback:0")
}



func expressionSelectedCalleeCases() {
    let one = Extern<DummyRT>(1)
    let two = Extern<DummyRT>(2)
    let chosenByIf = if (normalAdd(1, 1) == 2) {
        one
    } else {
        two
    }
    assertInt("if expression selected callee", DummyRT.fromExtern<Int64>(chosenByIf()), 101)

    let chosenByIfFalse = if (normalAdd(1, 1) == 3) {
        one
    } else {
        two
    }
    assertInt("if expression selected alternate callee", DummyRT.fromExtern<Int64>(chosenByIfFalse()), 102)

    let selectedFromMatch = match (normalAdd(2, 1)) {
        case 3 => Extern<DummyRT>(41)
        case _ => Extern<DummyRT>(0)
    }
    assertInt("match expression selected callee", DummyRT.fromExtern<Int64>(selectedFromMatch()), 141)

    let selectedFromMatchString = match ("go") {
        case "go" => Extern<DummyRT>("matched")
        case _ => Extern<DummyRT>("missed")
    }
    assertString("match expression string callee", DummyRT.fromExtern<String>(selectedFromMatchString()), "matched:0")
    assertString("match expression string callee", DummyRT.fromExtern<String>(selectedFromMatchString(1,2,3)), "matched:3")
    assertString("match expression string callee", DummyRT.fromExtern<String>(selectedFromMatchString(1, "a", r'x')), "matched:3")
    assertString("match expression string callee", DummyRT.fromExtern<String>(selectedFromMatchString(0)), "matched:1")

    let selectedFromTry = try {
        Extern<DummyRT>(5)
    } catch (e: Exception) {
        Extern<DummyRT>(0)
    }
    assertInt("try expression selected callee", DummyRT.fromExtern<Int64>(selectedFromTry()), 105)

    let selectedFromBlock = try {
        let base = Extern<DummyRT>(3)
        base.id
    } catch (e: Exception) {
        Extern<DummyRT>(0)
    }
    assertInt("block selected callee", DummyRT.fromExtern<Int64>(selectedFromBlock()), 103)

    let fromLambda = {flag: Bool =>
        if (flag) {
            Extern<DummyRT>(8)
        } else {
            Extern<DummyRT>("lambda")
        }
    }
    assertInt("lambda selected extern callee", DummyRT.fromExtern<Int64>(fromLambda(true)()), 108)
    assertString("lambda selected string callee", DummyRT.fromExtern<String>(fromLambda(false)()), "lambda:0")

    let nestedLambda = {value: Int64 =>
        {extra: Int64 => Extern<DummyRT>(value + extra)}
    }
    assertInt("lambda returned lambda extern callee", DummyRT.fromExtern<Int64>(nestedLambda(10)(5)()), 115)

    assertInt("direct if callee", DummyRT.fromExtern<Int64>((if (true) { one } else { two })()), 101)

    assertInt("direct match callee", DummyRT.fromExtern<Int64>((match (1) { case 1 => one case _ => two })()), 101)
}

func collectionTraversalCalleeCases() {
    let externCallables: Array<Extern<DummyRT>> = [
        Extern<DummyRT>(1),
        Extern<DummyRT>({x: Int64 => x + 20}),
        Extern<DummyRT>({x: Int64, y: Int64 => x * y}),
        Extern<DummyRT>({args: Array<Any> => Extern<DummyRT>(anyToInt(args[0]) - anyToInt(args[1]))})
    ]
    let externArray = Extern<DummyRT>(externCallables)
    assertInt("array traversal direct numeric", DummyRT.fromExtern<Int64>(externArray[0]()), 101)
    assertInt("array traversal unary", DummyRT.fromExtern<Int64>(externArray[1](22)), 42)
    assertInt("array traversal binary", DummyRT.fromExtern<Int64>(externArray[2](6, 7)), 42)
    assertInt("array traversal varargs", DummyRT.fromExtern<Int64>(externArray[3](50, 8)), 42)

    var total = Int64(0)
    for (callable in externCallables) {
        if (total == 0) {
            total += DummyRT.fromExtern<Int64>(callable())
        } else if (total == 101) {
            total += DummyRT.fromExtern<Int64>(callable(1))
        } else if (total == 122) {
            total += DummyRT.fromExtern<Int64>(callable(2, 3))
        } else {
            total += DummyRT.fromExtern<Int64>(callable(10, 4))
        }
    }
    assertInt("loop over extern callables", total, 134)

    let callableMap = HashMap<String, Extern<DummyRT>>()
    callableMap["base"] = Extern<DummyRT>(4)
    callableMap["inc"] = Extern<DummyRT>({x: Int64 => x + 1})
    callableMap["mul"] = Extern<DummyRT>({x: Int64, y: Int64 => x * y})
    callableMap["text"] = Extern<DummyRT>({s: String => "map ${s}"})
    let mapExtern = Extern<DummyRT>(callableMap)
    assertInt("map loop base callee", DummyRT.fromExtern<Int64>(mapExtern["base"]()), 104)
    assertInt("map loop unary callee", DummyRT.fromExtern<Int64>(mapExtern["inc"](41)), 42)
    assertInt("map loop binary callee", DummyRT.fromExtern<Int64>(mapExtern["mul"](7, 6)), 42)
    assertString("map loop string callee", DummyRT.fromExtern<String>(mapExtern["text"]("value")), "map value")

    let selectedNames = ["base", "inc", "mul"]
    let selectedName0 = selectedNames[0]
    let selectedName1 = selectedNames[1]
    let selectedName2 = selectedNames[2]
    assertInt("name array selects base", DummyRT.fromExtern<Int64>(mapExtern[selectedName0]()), 104)
    assertInt("name array selects unary", DummyRT.fromExtern<Int64>(mapExtern[selectedName1](20)), 21)
    assertInt("name array selects binary", DummyRT.fromExtern<Int64>(mapExtern[selectedName2](5, 4)), 20)

    let externKeys: Array<Extern<DummyRT>> = [key("base"), key("inc"), key("mul")]
    let externKey0 = externKeys[0]
    let externKey1 = externKeys[1]
    let externKey2 = externKeys[2]
    assertInt("extern key array base", DummyRT.fromExtern<Int64>(mapExtern[externKey0]()), 104)
    assertInt("extern key array unary", DummyRT.fromExtern<Int64>(mapExtern[externKey1](8)), 9)
    assertInt("extern key array binary", DummyRT.fromExtern<Int64>(mapExtern[externKey2](3, 9)), 27)

    assertInt("direct name-array index", DummyRT.fromExtern<Int64>(mapExtern[selectedNames[0]]()), 104)
    assertInt("direct extern-key-array index", DummyRT.fromExtern<Int64>(mapExtern[externKeys[0]]()), 104)
}

func pipelineStyleCalleeCases() {
    let funcs = makePairMap()
    let rows = makeRows()

    let first = hold(funcs.id)["unary"]
    let second = hold(funcs.id)["binary"]
    let heldRows = hold(rows.id)
    let heldFunctions = heldRows["functions"]
    let third = heldFunctions[2]
    assertInt("pipeline saved first", DummyRT.fromExtern<Int64>(first(33)), 42)
    assertInt("pipeline saved second", DummyRT.fromExtern<Int64>(second(6, 7)), 42)
    assertInt("pipeline saved third", DummyRT.fromExtern<Int64>(third(20, 10, 12)), 42)

    let chained = hold(hold(funcs).id).id["varargs"]
    assertInt("pipeline repeated hold varargs", DummyRT.fromExtern<Int64>(chained(10, 11, 21)), 42)

    let rowName = Extern<DummyRT>("functions")
    let rowIndex = Extern<DummyRT>(1)
    let heldRowsForExternIndex = hold(rows)[rowName]
    let selectedByExternIndex = heldRowsForExternIndex[rowIndex]
    assertInt("pipeline extern row and index", DummyRT.fromExtern<Int64>(selectedByExternIndex(90, 48)), 42)

    assertInt("direct extern row and index", DummyRT.fromExtern<Int64>(hold(rows)[rowName][rowIndex](90, 48)), 42)

    let stringRows = hold(rows)["strings"]
    assertString("pipeline saved string row", DummyRT.fromExtern<String>(stringRows[0]()), "red:0")
    assertString("pipeline saved string member row", DummyRT.fromExtern<String>(stringRows[1].tag()), "green-tag:0")

    let joiner = funcs["join"].id
    let left = funcs["stringer"]("left")
    let right = funcs["stringer"]("right")
    assertString("pipeline call outputs as join args", DummyRT.fromExtern<String>(joiner(left, right)), "left!+right!")

    let maybe = choose(normalAdd(2, 2) == 4, funcs["direct"], funcs["one"])
    assertInt("pipeline choose indexed member", DummyRT.fromExtern<Int64>(maybe()), 141)
}

func nestedArgumentCalleeCases() {
    let tool = Extern<DummyRT>(1)
    let funcs = makePairMap()
    let rows = makeRows()

    assertInt("arg contains direct call", DummyRT.fromExtern<Int64>(tool.varargs(1, tool(), 2)), 104)
    assertInt("arg contains member call", DummyRT.fromExtern<Int64>(tool.varargs(tool.direct(), funcs["unary"](1))), 151)
    let rowUnaryForArg = rows["functions"][0]
    assertInt("arg contains index call", DummyRT.fromExtern<Int64>(tool.varargs(funcs["binary"](2, 3), rowUnaryForArg(4))), 14)
    assertInt("arg contains nested returned calls", DummyRT.fromExtern<Int64>(tool.varargs(tool.makeUnary()(2), tool.makeVarargs()(2, 4), 1)), 81)

    let producedA = tool.makeJoin()(Extern<DummyRT>("a"), Extern<DummyRT>("b"))
    let producedB = funcs["stringer"]("c")
    assertString("arg contains produced strings", DummyRT.fromExtern<String>(tool.join(producedA, producedB)), "b:a|c!")

    let innerProduct = tool.makeVarargs()(2, 3, 7)
    assertInt("call result reused as extern arg", DummyRT.fromExtern<Int64>(tool.varargs(innerProduct, funcs["one"]())), 143)

    let callback = funcs["varargs"]
    assertInt("callback passed through choose", DummyRT.fromExtern<Int64>(choose(true, callback, tool.varargs)(20, 22)), 42)
    assertInt("callback alternate passed through choose", DummyRT.fromExtern<Int64>(choose(false, callback, tool.varargs)(19, 23)), 42)

    let nestedRows = rows["functions"]
    let nestedRowsFirst = nestedRows[0]
    let nestedRowsSecond = nestedRows[1]
    assertInt("nested row call in returned varargs", DummyRT.fromExtern<Int64>(tool.makeVarargs()(nestedRowsFirst(3), nestedRowsSecond(12, 5))), 42)

    assertInt("direct nested row call args", DummyRT.fromExtern<Int64>(tool.makeVarargs()(nestedRows[0](3), nestedRows[1](12, 5))), 42)

    assertString("direct normal call index callee", DummyRT.fromExtern<String>(Extern<DummyRT>(["zero", "one"])[normalAdd(0, 1)]()), "one:0")

    assertString("subscript argument selected callee", DummyRT.fromExtern<String>(choose(true, rows["strings"][1], Extern<DummyRT>("fallback"))()), "green:0")
}

func conversionAndContextCases() {
    let funcs = makePairMap()
    let rows = makeRows()
    let one = Extern<DummyRT>(1)

    let asAny: Any = one
    let recovered = (asAny as Extern<DummyRT>).getOrThrow()
    assertInt("callee after Any cast", DummyRT.fromExtern<Int64>(recovered()), 101)

    let anyFunc: Any = funcs["unary"]
    assertInt("indexed callee after Any cast", DummyRT.fromExtern<Int64>((anyFunc as Extern<DummyRT>).getOrThrow()(12)), 21)

    let maybeExtern = Some(funcs["binary"])
    if (let Some(externFunc) <- maybeExtern) {
        assertInt("option unwrapped callee", DummyRT.fromExtern<Int64>(externFunc(4, 5)), 20)
    } else {
        throw Exception("option should contain extern")
    }

    let firstRowFunction = rows["functions"][0]
    let optionRows = Some(firstRowFunction)
    if (let Some(rowFunc) <- optionRows) {
        assertInt("option unwrapped row callee", DummyRT.fromExtern<Int64>(rowFunc(9)), 18)
    } else {
        throw Exception("option row should contain extern")
    }

    let conditionalArg = if (DummyRT.fromExtern<Int64>(one()) == 101) {
        funcs["unary"](10)
    } else {
        funcs["unary"](0)
    }
    assertInt("extern call selected as arg by if", DummyRT.fromExtern<Int64>(one.varargs(conditionalArg, 1)()), 120)

    let matchArg = match (DummyRT.fromExtern<String>(funcs["stringer"]("m"))) {
        case "m!" => Extern<DummyRT>(20)
        case _ => Extern<DummyRT>(0)
    }
    assertInt("extern call selected as arg by match", DummyRT.fromExtern<Int64>(one.varargs(matchArg, 22)), 42)
}

func genericHelperCall<T>(e: Extern<T>): Int64 where T <: Runtime<T> {
    DummyRT.fromExtern<Int64>((e as Extern<DummyRT>).getOrThrow()())
    let payload = getPayload((e as Extern<DummyRT>).getOrThrow())
    (payload as Int64).getOrThrow() + 100
}

func genericHelperMemberCall<T>(e: Extern<T>): Int64 where T <: Runtime<T> {
    DummyRT.fromExtern<Int64>((e as Extern<DummyRT>).getOrThrow().id.twice())
    let payload = getPayload((e as Extern<DummyRT>).getOrThrow())
    ((payload as Int64).getOrThrow() * 2) + 100
}

func genericHelperIndexCall<T>(e: Extern<T>, index: Int64): Int64 where T <: Runtime<T> {
    DummyRT.fromExtern<Int64>((e as Extern<DummyRT>).getOrThrow()[index]())
    let concrete = (e as Extern<DummyRT>).getOrThrow()
    let selectedValues = getPayload(concrete) as Array<Extern<DummyRT>>
    let selected = selectedValues.getOrThrow()[index]
    DummyRT.fromExtern<Int64>(selected())
}

func genericCallCases() {
    assertInt("generic helper root", genericHelperCall<DummyRT>(Extern<DummyRT>(11)), 111)
    assertInt("generic helper member", genericHelperMemberCall<DummyRT>(Extern<DummyRT>(6)), 112)
    let arr = Extern<DummyRT>([Extern<DummyRT>(4), Extern<DummyRT>(5)])
    assertInt("generic helper index", genericHelperIndexCall<DummyRT>(arr, 1), 105)

    let funcs = makePairMap()
    let genericStored: Extern<DummyRT> = funcs["unary"]
    assertInt("generic stored explicit type", DummyRT.fromExtern<Int64>(genericStored(30)), 39)
}

func trailingAndLocalFunctionCases() {
    let localPick = {flag: Bool =>
        if (flag) {
            Extern<DummyRT>(13)
        } else {
            Extern<DummyRT>("local")
        }
    }

    let localApply = {e: Extern<DummyRT>, value: Int64 =>
        DummyRT.fromExtern<Int64>(e(value))
    }

    assertInt("local function returned numeric callee", DummyRT.fromExtern<Int64>(localPick(true)()), 113)
    assertString("local function returned string callee", DummyRT.fromExtern<String>(localPick(false)()), "local:0")
    assertInt("local function applies extern callee", localApply(makePairMap()["unary"], 5), 14)

    let localLambda = {flag: Bool, value: Int64 =>
        let picked = if (flag) {
            makePairMap()["binary"]
        } else {
            Extern<DummyRT>({x: Int64, y: Int64 => x + y})
        }
        DummyRT.fromExtern<Int64>(picked(value, 2))
    }
    assertInt("local lambda picks map binary callee", localLambda(true, 4), 8)
    assertInt("local lambda picks fallback binary callee", localLambda(false, 40), 42)
}

func commentedUnsupportedShapes() {
    let rows = makeRows()
    assertString("choose direct subscript callee", DummyRT.fromExtern<String>(choose(true, rows["strings"][1], Extern<DummyRT>("fallback"))()), "green:0")

    let words = Extern<DummyRT>(["zero", "one", "two"])
    assertString("direct computed subscript callee", DummyRT.fromExtern<String>(words[normalAdd(0, 1)]()), "one:0")

    assertInt("direct try callee", DummyRT.fromExtern<Int64>((try { Extern<DummyRT>(1) } catch (e: Exception) { Extern<DummyRT>(2) })()), 101)

    assertInt("direct match callee with branches", DummyRT.fromExtern<Int64>((match (1) { case 1 => Extern<DummyRT>(1) case _ => Extern<DummyRT>(2) })()), 101)

    assertInt("direct block callee", DummyRT.fromExtern<Int64>(({ => let e = Extern<DummyRT>(1); e })()()), 101)
}

func additionalPassingCalleeCases() {
    let one = Extern<DummyRT>(1)
    let two = Extern<DummyRT>(2)
    let chosenByIf = if (normalAdd(1, 1) == 2) {
        one
    } else {
        two
    }
    assertInt("additional if selected callee", DummyRT.fromExtern<Int64>(chosenByIf()), 101)

    let selectedFromMatch = match (normalAdd(2, 1)) {
        case 3 => Extern<DummyRT>(41)
        case _ => Extern<DummyRT>(0)
    }
    assertInt("additional match selected callee", DummyRT.fromExtern<Int64>(selectedFromMatch()), 141)

    let fromLambda = {flag: Bool =>
        if (flag) {
            Extern<DummyRT>(8)
        } else {
            Extern<DummyRT>("lambda")
        }
    }
    assertInt("additional lambda selected callee", DummyRT.fromExtern<Int64>(fromLambda(true)()), 108)
    assertString("additional lambda selected string callee", DummyRT.fromExtern<String>(fromLambda(false)()), "lambda:0")

    let externCallables: Array<Extern<DummyRT>> = [
        Extern<DummyRT>(1),
        Extern<DummyRT>({x: Int64 => x + 20}),
        Extern<DummyRT>({x: Int64, y: Int64 => x * y})
    ]
    let externArray = Extern<DummyRT>(externCallables)
    assertInt("additional array numeric callee", DummyRT.fromExtern<Int64>(externArray[0]()), 101)
    assertInt("additional array unary callee", DummyRT.fromExtern<Int64>(externArray[1](22)), 42)
    assertInt("additional array binary callee", DummyRT.fromExtern<Int64>(externArray[2](6, 7)), 42)

    let funcs = makePairMap()
    let selectedUnary = funcs["unary"]
    let selectedBinary = funcs["binary"]
    assertInt("additional saved map unary callee", DummyRT.fromExtern<Int64>(selectedUnary(14)), 23)
    assertInt("additional saved map binary callee", DummyRT.fromExtern<Int64>(selectedBinary(8, 5)), 40)
}

func genericAndExceptionCases<T>(e: Extern<T>) where T <: Runtime<T> {
    let payload = getPayload(e)
    if (payload is Int64) {
        assertInt("generic root call payload", DummyRT.fromExtern<Int64>((e as Extern<DummyRT>).getOrThrow()()), 105)
    }
}

func exceptionCases() {
    let pair = Extern<DummyRT>(Pair(1, 2))
    expectMissingMember(pair)
    expectBadCallable(pair)
    try {
        DummyRT.fromExtern<Int64>(makeRows()["functions"][4]())
        throw Exception("bad function index did not throw")
    } catch (e: IndexOutOfBoundsException) {
        // Expected
    }
}

main () {
    directCallCases()
    memberCallCases()
    indexCallCases()
    mixedChainCallCases()
    nestedReturnedCallCases()
    argumentExpressionCases()
    storedAndSelectedCalleeCases()
    additionalPassingCalleeCases()
    expressionSelectedCalleeCases()
    collectionTraversalCalleeCases()
    pipelineStyleCalleeCases()
    nestedArgumentCalleeCases()
    conversionAndContextCases()
    genericCallCases()
    trailingAndLocalFunctionCases()
    commentedUnsupportedShapes()
    genericAndExceptionCases<DummyRT>(Extern<DummyRT>(5))
    exceptionCases()
    0
}

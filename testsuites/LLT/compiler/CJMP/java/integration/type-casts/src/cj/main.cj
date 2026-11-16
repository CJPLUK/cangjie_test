// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.JObject

@Java["com.java.lib.JBase"]
public open foreign class JBase {
    public init()
}

@Java["com.java.lib.JDer"]
public open foreign class JDer <: JBase {
    public init()
}

@Java["com.java.lib.JDerValue"]
public open foreign class JDerValue <: JBase {
    public init(value: Int32)
    public func getValue(): Int32
}

@Java
public class CjDerValue <: JBase {
    public CjDerValue(private var value: Int32) {}

    public func getValue(): Int32 { value }
}

@Java
public class CjDer <: JDer {
    public let x: Int32

    public init() {
        x = -1
    }

    public init(x: Int32) {
        this.x = x
    }
}

@Java
public class CjBaseDer <: JBase {
    public let x: Int32

    public init() {
        x = -1
    }

    public init(x: Int32) {
        this.x = x
    }
}

func tf(b: Bool) { if (b) { "T" } else { "F" } }

func isJBase(o: JBase): String { tf(o is JBase) }
func isJDer(o: JBase): String { tf(o is JDer) }
func isCjDer(o: JBase): String { tf(o is CjDer)}
func isCjBaseDer(o: JBase): String { tf(o is CjBaseDer)}

func isAnyJBase(o: Any): String { tf(o is JBase) }
func isAnyJDer(o: Any): String { tf(o is JDer) }
func isAnyCjDer(o: Any): String { tf(o is CjDer)}
func isAnyCjBaseDer(o: Any): String { tf(o is CjBaseDer)}

func asJBase(o: JBase): String { tf((o as JBase).isSome()) }
func asJDer(o: JBase): String { tf((o as JDer).isSome()) }
func asCjDer(o: JBase): String { tf((o as CjDer).isSome()) }
func asCjBaseDer(o: JBase): String { tf((o as CjBaseDer).isSome()) }

func asAnyJBase(o: Any): String { tf((o as JBase).isSome()) }
func asAnyJDer(o: Any): String { tf((o as JDer).isSome()) }
func asAnyCjDer(o: Any): String { tf((o as CjDer).isSome()) }
func asAnyCjBaseDer(o: Any): String { tf((o as CjBaseDer).isSome()) }

@Java["com.java.lib.Exe"]
public open foreign class Exe {
    public init()

    public static func getJBase(t: Int32): JBase
    public static func getJDer(t: Int32): JDer
    public static func getCj(t: Int32, x: Int32): JBase
    public static func getJDerValue(x: Int32): JBase
    public static func getCjDerValue(x: Int32): JBase
}

@Java
public class CjExe <: Exe {
    public init(doTest: Bool) {
        if (!doTest) { return }
        unsafe {
            testIs()
            testAsIsSome()
            testAs()
            testIsAsCjTypes()
            testMatch()
            testMatchValue()
        }
    }

    static func testMatchValue(): Unit {
        println("================ TEST match_value ================")
        let check = { obj: JBase =>
            match (obj) {
                case v : JDer => println("[0] JDer")
                case v : CjDerValue => println("[1] value = ${v.getValue()}")
                case v : JDerValue => println("[2] value = ${v.getValue()}") 
                case _ => println("[3] not JDerValue")
            }
            match (obj) {
                case v : CjDerValue where v.getValue() == 20 => println("[4] value = ${v.getValue()}")
                case v : CjDerValue where v.getValue() == 10 => println("[5] value = ${v.getValue()}")
                case v : CjDerValue => println("[6] value = ${v.getValue()}")
                case v : JDerValue where v.getValue() == 20 => println("[7] value = ${v.getValue()}") 
                case v : JDerValue where v.getValue() == 10 => println("[8] value = ${v.getValue()}") 
                case v : JDerValue => println("[9] value = ${v.getValue()}")
                case _ => println("[10] not JDerValue")
            }
        }
        check(getJDerValue(10))
        check(getJDerValue(15))
        check(getCjDerValue(10))
        check(getCjDerValue(15))
    }

    static unsafe func testMatch(): Unit {
        println("================ TEST match ======================")
        let check = { b: Option<(Any, Option<JBase>)> =>
            match (b) {
                case Some((_: CjBaseDer, Some(_ : JDer))) => "CjBaseDer,JDer"
                case Some((a: CjBaseDer, Some(_ : CjBaseDer))) => "CjBaseDer,CjBaseDer"
                case Some((a: CjDer, Some(b : CjBaseDer))) => "CjDer,CjBaseDer"
                case Some((a: JObject, Some(b : JBase))) => "JObject,JBase"
                case Some((a: JBase, None)) => "JBase"
                case Some((a: Any, Some(_ : JBase))) => "Any,JBase"
                case _ => "NO"
            }
        }
        let mk = { a: Any, b: Option<JBase> => Some<(Any, Option<JBase>)>((a, b)) }
        println("CjBaseDer,CjDer: ${check(mk(getJBase(3), Some(getJDer(2))))}")
        println("CjBaseDer,CjBaseDer: ${check(mk(getJBase(3), Some(getJBase(3))))}")
        println("CjDer,CjBaseDer: ${check(mk(getJDer(2), Some(getJBase(3))))}")
        println("CjDer,CjDer: ${check(mk(getJBase(2), Some(getJDer(2))))}")
        println("JDer: ${check(mk(getJDer(1), None))}")
        println("JBase: ${check(mk(getJBase(0), None))}")
        println("Int64,JDer: ${check(mk(10, Some(getJBase(1))))}")
    }

    static unsafe func testIsAsCjTypes(): Unit {
        println("================ TEST is/as ======================")
        let a = getJBase(2)
        println("Object: ${a is Object}, ${(a as Object).isSome()}")
        println("Any: ${a is Any}, ${(a as Any).isSome()}")
    }

    static func testAs(): Unit {
        println("================ TEST as =========================")
        let a = getCj(1, 42)
        let b = getCj(1, 69)
        let c = getCj(3, 54)
        let d = getCj(3, 37)
        let e = getJDerValue(1337);

        println("test a: ${(a as CjDer).getOrThrow().x == 42}")
        println("test b: ${(b as CjDer).getOrThrow().x == 69}")
        println("test c: ${(c as CjBaseDer).getOrThrow().x == 54}")
        println("test d: ${(d as CjBaseDer).getOrThrow().x == 37}")
        println("test e: ${(e as JDerValue).getOrThrow().getValue() == 1337}")
    }

    static unsafe func testAsIsSome(): Unit {
        println("================ TEST JBase ======================")
        println("             as | JBase | JDer | CjDer | CjBaseDer")
        println("new JBase()     | ${asJBase(getJBase(0))}     | ${asJDer(getJBase(0))}    | ${asCjDer(getJBase(0))}     | ${asCjBaseDer(getJBase(0))}") 
        println("new JDer()      | ${asJBase(getJBase(1))}     | ${asJDer(getJBase(1))}    | ${asCjDer(getJBase(1))}     | ${asCjBaseDer(getJBase(1))}") 
        println("new CjDer()     | ${asJBase(getJBase(2))}     | ${asJDer(getJBase(2))}    | ${asCjDer(getJBase(2))}     | ${asCjBaseDer(getJBase(2))}") 
        println("new CjBaseDer() | ${asAnyJBase(getJBase(3))}     | ${asAnyJDer(getJBase(3))}    | ${asAnyCjDer(getJBase(3))}     | ${asAnyCjBaseDer(getJBase(3))}") 

        println("================ TEST JBase Upcast to Any ========")
        println("             as | JBase | JDer | CjDer | CjBaseDer")
        println("new JBase()     | ${asAnyJBase(getJBase(0))}     | ${asAnyJDer(getJBase(0))}    | ${asAnyCjDer(getJBase(0))}     | ${asAnyCjBaseDer(getJBase(0))}") 
        println("new JDer()      | ${asAnyJBase(getJBase(1))}     | ${asAnyJDer(getJBase(1))}    | ${asAnyCjDer(getJBase(1))}     | ${asAnyCjBaseDer(getJBase(1))}") 
        println("new CjDer()     | ${asAnyJBase(getJBase(2))}     | ${asAnyJDer(getJBase(2))}    | ${asAnyCjDer(getJBase(2))}     | ${asAnyCjBaseDer(getJBase(2))}") 
        println("new CjBaseDer() | ${asAnyJBase(getJBase(3))}     | ${asAnyJDer(getJBase(3))}    | ${asAnyCjDer(getJBase(3))}     | ${asAnyCjBaseDer(getJBase(3))}") 

        println("================ TEST JDer Upcast to JBase ====")
        println("         as | JBase | JDer | CjDer | CjBaseDer")
        println("new JDer()  | ${asJBase(getJDer(1))}     | ${asJDer(getJDer(1))}    | ${asCjDer(getJDer(1))}     | ${asCjBaseDer(getJDer(1))}") 
        println("new CjDer() | ${asJBase(getJDer(2))}     | ${asJDer(getJDer(2))}    | ${asCjDer(getJDer(2))}     | ${asCjBaseDer(getJDer(2))}") 
    }

    static unsafe func testIs(): Unit {
        println("================ TEST JBase ======================")
        println("             is | JBase | JDer | CjDer | CjBaseDer")
        println("new JBase()     | ${isJBase(getJBase(0))}     | ${isJDer(getJBase(0))}    | ${isCjDer(getJBase(0))}     | ${isCjBaseDer(getJBase(0))}") 
        println("new JDer()      | ${isJBase(getJBase(1))}     | ${isJDer(getJBase(1))}    | ${isCjDer(getJBase(1))}     | ${isCjBaseDer(getJBase(1))}") 
        println("new CjDer()     | ${isJBase(getJBase(2))}     | ${isJDer(getJBase(2))}    | ${isCjDer(getJBase(2))}     | ${isCjBaseDer(getJBase(2))}") 
        println("new CjBaseDer() | ${isAnyJBase(getJBase(3))}     | ${isAnyJDer(getJBase(3))}    | ${isAnyCjDer(getJBase(3))}     | ${isAnyCjBaseDer(getJBase(3))}") 

        println("================ TEST JBase Upcast to Any ========")
        println("             is | JBase | JDer | CjDer | CjBaseDer")
        println("new JBase()     | ${isAnyJBase(getJBase(0))}     | ${isAnyJDer(getJBase(0))}    | ${isAnyCjDer(getJBase(0))}     | ${isAnyCjBaseDer(getJBase(0))}") 
        println("new JDer()      | ${isAnyJBase(getJBase(1))}     | ${isAnyJDer(getJBase(1))}    | ${isAnyCjDer(getJBase(1))}     | ${isAnyCjBaseDer(getJBase(1))}") 
        println("new CjDer()     | ${isAnyJBase(getJBase(2))}     | ${isAnyJDer(getJBase(2))}    | ${isAnyCjDer(getJBase(2))}     | ${isAnyCjBaseDer(getJBase(2))}") 
        println("new CjBaseDer() | ${isAnyJBase(getJBase(3))}     | ${isAnyJDer(getJBase(3))}    | ${isAnyCjDer(getJBase(3))}     | ${isAnyCjBaseDer(getJBase(3))}") 

        println("================ TEST JDer Upcast to JBase ====")
        println("         is | JBase | JDer | CjDer | CjBaseDer")
        println("new JDer()  | ${isJBase(getJDer(1))}     | ${isJDer(getJDer(1))}    | ${isCjDer(getJDer(1))}     | ${isCjBaseDer(getJDer(1))}") 
        println("new CjDer() | ${isJBase(getJDer(2))}     | ${isJDer(getJDer(2))}    | ${isCjDer(getJDer(2))}     | ${isCjBaseDer(getJDer(2))}") 
    }
}

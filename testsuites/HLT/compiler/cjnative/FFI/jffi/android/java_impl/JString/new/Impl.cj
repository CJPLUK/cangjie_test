/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// (Android) DEPENDENCE: com MainInstrumentedTest.java 
// (Android) EXEC: %javac com/*.java %java_interop_util/Logger.java
// (Android) EXEC: %java %java_mirror_gen com.Inherit
// (Android) EXEC: %java %java_mirror_gen com.SimpleJavaClass
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f %java_interop_util/logger.cj UNNAMED/src/*.cj
// (Android) EXEC: %ndk_root/bin/llvm-readelf -d ./libUNNAMED.so
// (Android) RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// (Android) ASSERT: scan hello world!

package UNNAMED

import java.lang.*
import std.runtime.*

// 如果创建全局变量即会导致crash
public let g0: Impl = Impl()

// @Java实例被间接保存在全局
public let g1: CangjieClass = CangjieClass()
public let g2: CangjieStruct = CangjieStruct()
public let g3: CangjieEnum = CangjieEnum.A(Impl())

let _ = {
    =>
        // 同上，全局静态初始化
        Logger.println("global lambda call")
        ()
}()

public func acceptingTop(a: Any): Unit {
    Logger.println("acceptingTop")
    Logger.println("a is Impl == ${a is Impl}")
    if (let Some(i) <- (a as Impl)) {
        i.simple()
    }
}

// 仓颉class中使用@Java/@JavaMirror作为成员
public class CangjieClass {
    static init() {
        // 同上，全局静态初始化
        Logger.println("CangjieClass.static")
        let gs0: Impl = Impl()
        let gs1: SimpleJavaClass = SimpleJavaClass()
    }
    // 实例成员变量
    public let v: Impl = Impl()
    public let v1: JObject = Impl()
    public var v5: JString = JString("hello")
    public var v6: JArray<JString> = JArray<JString>(10)

    // 静态成员变量
    // BUG: 目前静态成员变量都会导致crash
    public static var sv0: Impl = Impl()
    public static let sv1: SimpleJavaClass = SimpleJavaClass()
    public static var sv2: JArray<JString> = JArray<JString>(10)

    // 实例成员属性
    public prop p: Impl {
        get() {
            this.v
        }
    }
    public let v2: SimpleJavaClass = SimpleJavaClass()
    public let v3: JObject = SimpleJavaClass()
    public let v4: Any = SimpleJavaClass()

    public func testJavaImpl(): Unit {
        // @Java
        // 实例成员变量
        this.v.simple()
        (this.v1 as Impl).getOrThrow().simple()
        // 实例成员属性
        this.p.simple()
        // 静态成员变量
        CangjieClass.sv0.simple()
    }
    public func testJavaMirror(): Unit {
        // @JavaMirror
        // 实例成员变量
        this.v2.foo()
        // (this.v3 as SimpleJavaClass).getOrThrow().foo()
        // (this.v4 as SimpleJavaClass).getOrThrow().foo()
        // 静态成员变量
        // CangjieClass.sv1.foo()
    }
    public func testBuiltIn(): Unit {
        Logger.println("this.v5 = ${this.v5.toString()}")
        Logger.println("v6.length = ${v6.length}")
    }
    public func test(): Unit {
        Logger.println("=== CangjieClass.test ===")
        this.testJavaImpl()
        this.testJavaMirror()
    }
}

// 仓颉struct中使用@Java作为成员
public struct CangjieStruct {
    public let v: Impl = Impl()
    public let v1: JObject = Impl()
    // BUG: ICE 7
    // public let v2: JArray<?Int64> = JArray(10)
    public func test(): Unit {
        Logger.println("=== CangjieStruct.test ===")
        this.v.simple()
    }
}

// 仓颉enum中使用@Java作为成员
public enum CangjieEnum {
    | A(Impl)
    | B(Impl, SimpleJavaClass)
    | C(JString, JArray<?JString>, JObject)

    public func test(): Unit {
        match (this) {
            case A(c0) => c0.simple()
            case B(c0, c1) =>
                c0.simple()
                c1.foo()
            case C(a, b, c) => ()
        }
    }
}

@Java
public class Impl <: Inherit {
    public let m: SimpleJavaClass = SimpleJavaClass()
    public init() {
        super(1)
        // super.aByte // BUG，访问的话会crash
        super.foo()
        Inherit.goo()
        Logger.println("Impl.init")
    }
    protected init(i: Int32) {
        super(1)
        Logger.println("Impl.init(${i})")
    }
    public prop p: String {
        get() {
            "p"
        }
    }
    public prop p1: JString {
        get() {
            JString("p1")
        }
    }
    public var v0: String = "v0"
    public var v1: JString = JString("v1")
    public override func javaProtectedFunc(): Unit {
        Logger.println("Impl.javaProtectedFunc")
        super.javaProtectedFunc()
    }
    public func testProtectedFuncFromJava(): Unit {
        Logger.println("=== testProtectedFuncFromJava ===")
        this.javaProtectedFunc()
    }
    public func bar(s0: String): JString {
        JString(s0)
    }
    public func bar1(s0: JString): String {
        s0.toString()
    }
    public func protectedFunc(): Int64 {
        println("Impl.protectedFunc")
        1
    }
    public func simple(): Unit {
        Logger.println("simple")
    }
    private func callLambda(f: () -> Unit): Unit {
        Logger.println("callLambda")
        f()
    }
    public func checkGlobalVar(): Unit {
        Logger.println("=== checkGlobalVar ===")
        // 当前发现如果定义全局变量将导致crash，故注释
        g0.simple()
        // (Android) ASSERT: scan g0.bar checkEscape s
        Logger.println(g0.bar("g0.bar checkEscape s").toString())
    }
    public func checkLambdaClosure(): Unit {
        Logger.println("=== checkLambdaClosure ===")
        // 检查lambda捕获@Java
        let ci = Impl()
        let s = SimpleJavaClass()
        let l = {
            =>
                Logger.println("lambda")
                ci.simple()
                s.foo()
        }
        this.callLambda(l)
    }
    public func checkCangjieClass(): Unit {
        Logger.println("=== checkCangjieClass ===")
        let cc = CangjieClass()
        cc.test()
    }
    public func checkCangjieStruct(): Unit {
        Logger.println("=== checkCangjieStruct ===")
        let cs = CangjieStruct()
        cs.test()
    }
    public func checkCangjieEnum(): Unit {
        Logger.println("=== checkCangjieEnum ===")
        let c = Impl()
        let s = SimpleJavaClass()
        var ce = CangjieEnum.A(c)
        ce.test()
        ce = CangjieEnum.B(c, s)
        ce.test()
        ce = CangjieEnum.C(JString("hello"), JArray<?JString>(10), JObject())
        ce.test()
    }
    public func checkSpawn(): Unit {
        Logger.println("=== checkSpawn ===")
        let ci = Impl()
        let s = SimpleJavaClass()
        spawn {
            Logger.println("inside spawn")
            ci.simple()
            s.foo()
        }
    }
    public func checkUpCast(): Unit {
        Logger.println("=== checkUpCast ===")
        // 隐式转换为Any
        let ci: Impl = Impl()
        // 通过函数传参实现的隐式类型转换
        acceptingTop(ci)
        // 先显式转换为JObject然后再隐式转换为Any
        acceptingTop((ci as JObject).getOrThrow())
        // 通过赋值操作实现的隐式类型转换
        // implicit up-cast
        let ci1: Any = Impl()

        // as操作符
        // (Android) ASSERT: scan ci1 as Any = true
        // (Android) ASSERT: scan ci1 as Object = true
        // (Android) ASSERT: scan ci1 as JObject = true
        // (Android) ASSERT: scan ci1 as CangjieClass = false
        Logger.println("ci1 as Any = ${(ci1 as Any).isSome()}")
        Logger.println("ci1 as Object = ${(ci1 as Object).isSome()}")
        Logger.println("ci1 as JObject = ${(ci1 as JObject).isSome()}")
        Logger.println("ci1 as CangjieClass = ${(ci1 as CangjieClass).isSome()}")

        // is操作符
        // (Android) ASSERT: scan ci1 is Any = true
        // (Android) ASSERT: scan ci1 is Object = true
        // (Android) ASSERT: scan ci1 is JObject = true
        // (Android) ASSERT: scan ci1 is CangjieClass = false
        Logger.println("ci1 is Any = ${ci1 is Any}")
        Logger.println("ci1 is Object = ${ci1 is Object}")
        Logger.println("ci1 is JObject = ${ci1 is JObject}")
        Logger.println("ci1 is CangjieClass = ${ci1 is CangjieClass}")

        // 通过match实现的隐式类型转换
        // (Android) ASSERT: scan match(Impl()): Any
        // (Android) ASSERT: scan match(Impl()): Object
        // (Android) ASSERT: scan match(Impl()): JObject
        // (Android) ASSERT: scan match(Impl()): CangjieClass
        match (Impl()) {
            case i: Any => Logger.println("match(Impl()): Any")
            case _ => ()
        }
        match (Impl()) {
            case i: Object => Logger.println("match(Impl()): Object")
            case _ => ()
        }
        match (Impl()) {
            case i: JObject => Logger.println("match(Impl()): JObject")
            case _ => ()
        }
        match (Impl()) {
            case i: CangjieClass => ()
            case _ => Logger.println("match(Impl()): CangjieClass")
        }

        // 通过if-let实现的隐式类型转换
        // (Android) ASSERT: scan if (let i: Any <- Impl())
        // (Android) ASSERT: scan if (let i: Object <- Impl())
        // (Android) ASSERT: scan if (let i: JObject <- Impl())
        // (Android) ASSERT: scan if (let i: CangjieClass <- Impl())
        if (let i: Any <- Impl()) {
            Logger.println("if (let i: Any <- Impl())")
        }
        if (let i: Object <- Impl()) {
            Logger.println("if (let i: Object <- Impl())")
        }
        if (let i: JObject <- Impl()) {
            Logger.println("if (let i: JObject <- Impl())")
        }
        if (let i: CangjieClass <- Impl()) {
        } else {
            Logger.println("if (let i: CangjieClass <- Impl())")
        }
    }
    public func checkEscape(): Unit {
        Logger.println("=== checkEscape ===")
        this.checkGlobalVar()
        this.checkCangjieClass()
        this.checkCangjieStruct()
        this.checkCangjieEnum()
        this.checkLambdaClosure()
        // 目前spawn仅支持编译通过，但运行时如果在spawn中对@Java实例进行操作将导致crash，故暂时注释，等到真正支持后再放开
        // this.checkSpawn()
        this.checkUpCast()
    }
    public static func callCangjieGC(): Unit {
        gc(heavy: true)
    }
}

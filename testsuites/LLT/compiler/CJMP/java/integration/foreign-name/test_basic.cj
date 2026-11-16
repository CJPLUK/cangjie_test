// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) DEPENDENCE: ./java
// (CJNATIVE and not Windows) RUN-EXEC-0: cjc %compile_shared_lib_opt %f %import_java_interop --output-javagen-dir=java/cj
// (CJNATIVE and not Windows) RUN-EXEC-0: %javac %cp_cj_loader_java_interop java/com/java/lib/*.java java/cj/*.java -h ./ -d ./
// (CJNATIVE and not Windows) RUN-EXEC-PIPE: %java %cp_cj_loader_java_interop -Djava.library.path=./ cj.Main 2>& 1 | compare %f
package cj


import java.lang.*

@Java["com.java.lib.JBase"]
public open foreign class JBase {
    public init()

    @ForeignName["idStatic"]
    public static var myIdStaticVar: Int32

    @ForeignName["idStatic"]
    public static let myIdStaticLet: Int32

    @ForeignName["id"]
    public var myIdVar: Int32

    @ForeignName["id"]
    public let myIdLet: Int32

    @ForeignName["getClassName"]
    public static func myGetClassName(): String

    @ForeignName["getName"]
    public open func myGetName(): String
}

@Java["com.java.lib.JDer"]
public open foreign class JDer <: JBase {
    public init()
}

@Java["com.java.lib.JDerDer"]
public open foreign class JDerDer <: JDer {
    public init()

    public static func myGetClassName(): String
    public open func myGetName(): String
}

@Java["com.java.lib.JDerDerDer"]
public open foreign class JDerDerDer <: JDerDer {
    public init()

    public static func myGetClassName(): String
    public open func myGetName(): String
}

@Java["com.java.lib.JAbs"]
public abstract foreign class JAbs {
    @ForeignName["getAbsString"]
    public abstract func getAbs(): String
}

@Java["com.java.lib.JIface"]
public foreign interface JIface {
    @ForeignName["getIfaceString"]
    func getIface(): String
}

@Java["com.java.lib.JClass"]
public open foreign class JClass <: JAbs & JIface {
    public init()

    public override func getAbs(): String
    public open override func getIface(): String
}

@Java["com.java.lib.JOtherClass"]
public open foreign class JOtherClass <: JClass {
    public init()

    public override func getIface(): String
}

@Java
public class Main <: JObject {
    @ForeignName["main"]
    public static func entry(args: JArray<JString>): Unit {
        print("cj: Main()\n", flush: true)

        let jb = JBase()
        println(jb.myIdVar)
        println(JBase.myGetClassName())
        println(jb.myGetName())

        let jd = JDer()
        println(jd.myIdVar)
        println(JDer.myGetClassName())
        println(jd.myGetName())

        let jdd = JDerDer()
        println(jdd.myIdVar)
        println(JDerDer.myGetClassName())
        println(jdd.myGetName())

        let jddd = JDerDerDer()
        jddd.myIdVar = 54
        println(jddd.myIdVar)
        println(JDerDerDer.myGetClassName())
        println(jddd.myGetName())

        let jc = JClass()
        println(jc.getAbs())
        println(jc.getIface())

        let joc = JOtherClass()
        println(joc.getAbs())
        println(joc.getIface())

        println("* var/let")
        println(jb.myIdVar)
        println(jb.myIdLet)
        jb.myIdVar = 99
        println(jb.myIdVar)
        println(jb.myIdLet)

        println("** static")
        println(JBase.myIdStaticVar)
        println(JBase.myIdStaticLet)
        JBase.myIdStaticVar = 73
        println(JBase.myIdStaticVar)
        println(JBase.myIdStaticLet)

        print("cj: Main() end\n", flush: true)
    }
}

/* SCAN-IN
cj: Main()
42
JBase
JBase.getName()
42
JBase
JDer.getName()
37
JDerDer
JDer.getName()
54
JDerDer
JDer.getName()
JClass::getAbsString()
JClass::getIfaceString()
JOtherClass::getAbsString()
JOtherClass::getIfaceString()
* var/let
42
42
99
99
** static
37
37
73
73
cj: Main() end
*/

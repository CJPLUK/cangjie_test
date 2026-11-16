// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java
public class CjExe <: Exe {

    public init(s: String, opt: ?String) {
        strFieldImpl = s
        nullableFieldImpl = opt
    }

    public var strFieldImpl: String = "field"
    public var nullableFieldImpl: ?String = None

    public func GetStrFieldImpl(): String {
        strFieldImpl
    }

    public func SetStrFieldImpl(v: String): Unit {
        strFieldImpl = v
    }

    public func GetNullableFieldImpl(): ?String {
        nullableFieldImpl
    }

    public func SetNullableFieldImpl(v: ?String): Unit {
        nullableFieldImpl = v
    }

    public override func AcceptNullableString(arg: ?String): Unit {
        match (arg) {
            case Some(s) => println("CJ: ${arg}")
            case None => println("CJ: None")
        }
    }

    public override func EchoString(s: String): String {
        s
    }

    public override func EchoNullableString(arg: ?String): ?String {
        arg
    }

    public override func GetStringArray(): JArray<String> {
        super.GetStringArray()
    }

    public override func EchoStringArray(arg: ?JArray<String>): ?JArray<String> {
        arg
    }

    public override func GetNullableStringArray(): ?JArray<?String> {
        super.GetNullableStringArray()
    }

    public override func EchoNullableStringArray(arg: ?JArray<?String>): ?JArray<?String> {
        arg
    }

    public func PassStringsToJava(): Unit {
        let e = Exe()
        e.AcceptNullableString("hello")
        e.AcceptNullableString("")
        e.AcceptNullableString(None)
        e.PrintString("hello")
        e.PrintString("")
        let s = e.EchoString("echo")
        println("CJ: ${s}")
        let s1 = e.EchoNullableString("echo")
        println("CJ: ${s1}")
        let s2 = e.EchoNullableString(None)
        println("CJ: ${s2}")
        println("CJ: ${e.strField}")
        println("CJ: ${e.nullableField}")
        println(e.GetStringArray()[0])
        e.GetStringArray()[0] = ""
        println(e.GetStringArray()[0])
        println(e.GetNullableStringArray()?[0])
        e.GetNullableStringArray()?[0] = ""
        println(e.GetNullableStringArray()?[0])
        let a = JArray<String>(1)
        a[0] = "Hi"
        println(a[0])
    }

    public func ReturnString(): String {
        return "hello"
    }

    public func ReturnNullableSome(): ?String {
        return Some("hello")
    }

    public func ReturnNullableNone(): ?String {
        return None
    }

    public func ProcessString(arg: ?String): ?String {
        if (arg == None) {
            return None
        }
        return "${arg}-processed-${strFieldImpl}"
    }

    public func ProcessNonNullString(s: String): String {
        return "${s}-nn-${strFieldImpl}"
    }

    public func ProcessStringArray(arg: ?JArray<String>): ?JArray<String> {
        arg
    }

    public func ProcessNullableStringArray(arg: ?JArray<?String>): ?JArray<?String> {
        arg
    }
}

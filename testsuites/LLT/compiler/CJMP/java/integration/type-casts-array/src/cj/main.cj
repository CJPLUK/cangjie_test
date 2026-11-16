// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java["com.java.lib.Exe"]
public open foreign class Exe {
    public init()

    public static func getArrayInt8(b: Int8): JObject
    public static func getArrayFloat32(f: Float32): JObject
    public static func getArrayString(s: JString): JObject
    public static func getArrayExe(e: Exe): JObject
}

func expect<T>(a: T, b: T) where T <: Equatable<T> {
    if (a != b) {
        throw Exception("FAILURE")
    }
}
func fail(): Nothing {
    throw Exception("FAILURE")
}

@Java
public class CjExe <: Exe {
    public init(doTest: Bool) {
        if (!doTest) { return }
        unsafe {
            testMatchValue()
            testIs()
            testAs()
        }
    }

    private static func getArrayInt8AsAny(b: Int8): Any { getArrayInt8(b) }
    private static func getArrayFloat32AsAny(f: Float32): Any { getArrayFloat32(f) }
    private static func getArrayStringAsAny(s: JString): Any { getArrayString(s) }
    private static func getArrayExeAsAny(e: Exe): Any { getArrayExe(e) }

    static func testMatchValue(): Unit {
        match (getArrayInt8(42)) {
            case c: Int8 => fail()
            case c: JArray<Int32> => fail()
            case c: JArray<Float32> => fail()
            case c: JArray<JObject> => fail()
            case c: JArray<Int8> => expect(c[0], 42)
            case _ => fail()
        }
        match (getArrayInt8AsAny(44)) {
            case c: Int8 => fail()
            case c: JArray<Int32> => fail()
            case c: JArray<Float32> => fail()
            case c: JArray<JObject> => fail()
            case c: JArray<Int8> => expect(c[0], 44)
            case _ => fail()
        }
        match (getArrayFloat32(3.0)) {
            case c: Int8 => fail()
            case c: JArray<Int32> => fail()
            case c: JArray<JObject> => fail()
            case c: JArray<Int8> => fail()
            case c: JArray<Float32> => expect(c[0], 3.0)
            case _ => fail()
        }
        match (getArrayFloat32AsAny(4.0)) {
            case c: Int8 => fail()
            case c: JArray<Int32> => fail()
            case c: JArray<JObject> => fail()
            case c: JArray<Int8> => fail()
            case c: JArray<Float32> => expect(c[0], 4.0)
            case _ => fail()
        }
        match (getArrayString(JString("Hello"))) {
            case c: Int8 => fail()
            case c: JArray<Int32> => fail()
            case c: JArray<Exe> => fail()
            case c: JArray<Int8> => fail()
            case c: JArray<Float32> => fail()
            case c: JArray<String> => expect(c[0], "Hello")
            case _ => fail()
        }
        match (getArrayStringAsAny(JString("aabbcc"))) {
            case c: Int8 => fail()
            case c: JArray<Int32> => fail()
            case c: JArray<Exe> => fail()
            case c: JArray<Int8> => fail()
            case c: JArray<Float32> => fail()
            case c: JArray<String> => expect(c[0], "aabbcc")
            case _ => fail()
        }
        match (getArrayString(JString("Hello"))) {
            case c: JArray<JString> => expect(c[0].toString(), "Hello")
            case _ => fail()
        }
        match (getArrayStringAsAny(JString("aabbcc"))) {
            case c: JArray<JString> => expect(c[0].toString(), "aabbcc")
            case _ => fail()
        }
        let exe = Exe()
        match (getArrayExe(exe)) {
            case c: Int8 => fail()
            case c: JArray<Int32> => fail()
            case c: JArray<Int8> => fail()
            case c: JArray<Float32> => fail()
            case c: JArray<Exe> => expect(c[0].equals(exe), true)
            case _ => fail()
        }
        match (getArrayExeAsAny(exe)) {
            case c: Int8 => fail()
            case c: JArray<Int32> => fail()
            case c: JArray<Int8> => fail()
            case c: JArray<Float32> => fail()
            case c: JArray<Exe> => expect(c[0].equals(exe), true)
            case _ => fail()
        }
        let cjExe = CjExe(false)
        match (getArrayExe(cjExe)) {
            case c: Int8 => fail()
            case c: JArray<Int32> => fail()
            case c: JArray<Int8> => fail()
            case c: JArray<Float32> => fail()
            case c: JArray<CjExe> => fail() // because the type of array is Exe
            case c: JArray<Exe> => expect(c[0].equals(cjExe), true)
            case _ => fail()
        }
        match (getArrayExeAsAny(cjExe)) {
            case c: Int8 => fail()
            case c: JArray<Int32> => fail()
            case c: JArray<Int8> => fail()
            case c: JArray<Float32> => fail()
            case c: JArray<CjExe> => fail() // because the type of array is Exe
            case c: JArray<Exe> => expect(c[0].equals(cjExe), true)
            case _ => fail()
        }
        // demonstrating java array covariance
        match (getArrayExeAsAny(cjExe)) {
            case c: JArray<JObject> => expect(c[0].equals(cjExe), true)
            case _ => fail()
        }
        // a more tricky covariance example
        match (getArrayExeAsAny(cjExe)) {
            case cj: JArray<Exe> =>
                match (cj) {
                    case co: JArray<JObject> => expect(co[0].equals(cjExe), true)
                    case _ => fail()
                }
            case _ => fail()
        }
    }

    static func testIs(): Unit {
        if (let value <- getArrayInt8(42)) {
            expect(value is Int8, false)
            expect(value is JArray<Int32>, false)
            expect(value is JArray<Float32>, false)
            expect(value is JArray<JObject>, false)
            expect(value is JArray<Int8>, true)
        }
        if (let value <- getArrayInt8AsAny(44)) {
            expect(value is Int8, false)
            expect(value is JArray<Int32>, false)
            expect(value is JArray<Float32>, false)
            expect(value is JArray<JObject>, false)
            expect(value is JObject, true)
            expect(value is JArray<Int8>, true)
        }
        if (let value <- getArrayFloat32(3.0)) {
            expect(value is Int8, false)
            expect(value is JArray<Int32>, false)
            expect(value is JArray<Int8>, false)
            expect(value is JArray<JObject>, false)
            expect(value is JObject, true)
            expect(value is JArray<Float32>, true)
        }
        if (let value <- getArrayFloat32AsAny(4.0)) {
            expect(value is Int8, false)
            expect(value is JArray<Int32>, false)
            expect(value is JArray<Int8>, false)
            expect(value is JArray<JObject>, false)
            expect(value is JObject, true)
            expect(value is JArray<Float32>, true)
        }
        if (let value <- getArrayString(JString("Hello"))) {
            expect(value is Int8, false)
            expect(value is JArray<Int32>, false)
            expect(value is JArray<Int8>, false)
            expect(value is JArray<Float32>, false)
            expect(value is JArray<JObject>, true)
            expect(value is JObject, true)
            expect(value is JArray<JString>, true)
            expect(value is JArray<String>, true)
        }
        if (let value <- getArrayStringAsAny(JString("aabbcc"))) {
            expect(value is Int8, false)
            expect(value is JArray<Int32>, false)
            expect(value is JArray<Int8>, false)
            expect(value is JArray<Float32>, false)
            expect(value is JArray<JObject>, true)
            expect(value is JObject, true)
            expect(value is JArray<JString>, true)
            expect(value is JArray<String>, true)
        }
        let exe = Exe()
        if (let value <- getArrayExe(exe)) {
            expect(value is Int8, false)
            expect(value is JArray<Int32>, false)
            expect(value is JArray<Int8>, false)
            expect(value is JArray<Float32>, false)
            expect(value is JArray<JObject>, true)
            expect(value is JObject, true)
            expect(value is JArray<Exe>, true)
            expect(value is JArray<CjExe>, false)
        }
        if (let value <- getArrayExeAsAny(exe)) {
            expect(value is Int8, false)
            expect(value is JArray<Int32>, false)
            expect(value is JArray<Int8>, false)
            expect(value is JArray<Float32>, false)
            expect(value is JArray<JObject>, true)
            expect(value is JObject, true)
            expect(value is JArray<Exe>, true)
            expect(value is JArray<CjExe>, false)
        }
    }

    static func testAs(): Unit {
        if (let value <- getArrayInt8(42)) {
            expect((value as Int8).isSome(), false)
            expect((value as JArray<Int32>).isSome(), false)
            expect((value as JArray<Float32>).isSome(), false)
            expect((value as JArray<JObject>).isSome(), false)
            expect((value as JArray<Int8>)?[0], 42)
        }
        if (let value <- getArrayInt8AsAny(44)) {
            expect((value as Int8).isSome(), false)
            expect((value as JArray<Int32>).isSome(), false)
            expect((value as JArray<Float32>).isSome(), false)
            expect((value as JArray<JObject>).isSome(), false)
            expect((value as JArray<Int8>)?[0], 44)
        }
        if (let value <- getArrayFloat32(3.0)) {
            expect((value as Int8).isSome(), false)
            expect((value as JArray<Int32>).isSome(), false)
            expect((value as JArray<Int8>).isSome(), false)
            expect((value as JArray<JObject>).isSome(), false)
            expect((value as JObject).isSome(), true)
            expect((value as JArray<Float32>)?[0], 3.0)
        }
        if (let value <- getArrayFloat32AsAny(4.0)) {
            expect((value as Int8).isSome(), false)
            expect((value as JArray<Int32>).isSome(), false)
            expect((value as JArray<Int8>).isSome(), false)
            expect((value as JArray<JObject>).isSome(), false)
            expect((value as JObject).isSome(), true)
            expect((value as JArray<Float32>)?[0], 4.0)
        }
        if (let value <- getArrayString(JString("Hello"))) {
            expect((value as Int8).isSome(), false)
            expect((value as JArray<Int32>).isSome(), false)
            expect((value as JArray<Int8>).isSome(), false)
            expect((value as JArray<Float32>).isSome(), false)
            expect((value as JArray<JObject>).isSome(), true)
            expect((value as JObject).isSome(), true)
            expect((value as JArray<JString>)?[0].toString(), "Hello")
            expect((value as JArray<String>)?[0], "Hello")
        }
        if (let value <- getArrayStringAsAny(JString("aabbcc"))) {
            expect((value as Int8).isSome(), false)
            expect((value as JArray<Int32>).isSome(), false)
            expect((value as JArray<Int8>).isSome(), false)
            expect((value as JArray<Float32>).isSome(), false)
            expect((value as JArray<JObject>).isSome(), true)
            expect((value as JObject).isSome(), true)
            expect((value as JArray<JString>)?[0].toString(), "aabbcc")
            expect((value as JArray<String>)?[0], "aabbcc")
        }
        let exe = Exe()
        if (let value <- getArrayExe(exe)) {
            expect((value as Int8).isSome(), false)
            expect((value as JArray<Int32>).isSome(), false)
            expect((value as JArray<Int8>).isSome(), false)
            expect((value as JArray<Float32>).isSome(), false)
            expect((value as JArray<JObject>)?[0].equals(exe), true)
            expect((value as JObject).isSome(), true)
            expect((value as JArray<Exe>)?[0].equals(exe), true)
            expect((value as JArray<CjExe>).isSome(), false)
        }
        if (let value <- getArrayExeAsAny(exe)) {
            expect((value as Int8).isSome(), false)
            expect((value as JArray<Int32>).isSome(), false)
            expect((value as JArray<Int8>).isSome(), false)
            expect((value as JArray<Float32>).isSome(), false)
            expect((value as JArray<JObject>)?[0].equals(exe), true)
            expect((value as JObject).isSome(), true)
            expect((value as JArray<Exe>)?[0].equals(exe), true)
            expect((value as JArray<CjExe>).isSome(), false)
        }
        // tricky covariant case
        if (let value <- getArrayExeAsAny(exe)) {
            if (let Some(je) <- (value as JArray<Exe>)) {
                // incorrect with Cangjie generics, correct with java array
                if (let Some(jo) <- (je as JArray<JObject>)) {
                    expect(jo[0].equals(exe), true)                    
                } else {
                    fail()
                }
            } else {
                fail()
            }
        } else {
            fail()
        }
    }

}

// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package javasample

import java.lang.*

@Java ["javasample.Item"]
public foreign open class Item {
    public init()
    public init(value: Int32)
    public open func getValue(): Int32
}

@Java ["javasample.SpecialItem"]
public class SpecialItem <: Item {
    private let specialValue: Int32

    public init(value: Int32) {
        this.specialValue = value
    }

    public override func getValue(): Int32 {
        return 1000 + specialValue
    }
}

@Java ["javasample.TestImpl"]
public class TestImpl {
    public init() {}

    private func assertCondition(condition: Bool, message: String): Unit {
        if (!condition) {
            throw Exception("FAIL: " + message)
        }
    }

    // Java creates these arrays with 1 in every slot. Cangjie verifies the
    // initial contents, overwrites them, and verifies its own writes.
    public func testPrimitiveArrays(
        booleans: JArray<Bool>,
        bytes: JArray<Int8>,
        chars: JArray<UInt16>,
        shorts: JArray<Int16>,
        ints: JArray<Int32>,
        longs: JArray<Int64>,
        floats: JArray<Float32>,
        doubles: JArray<Float64>
    ): Unit {
        assertCondition(booleans[0] == true && booleans[1] == true, "initial boolean[] values")
        booleans[0] = false
        booleans[1] = true
        assertCondition(booleans[0] == false && booleans[1] == true, "boolean[] read after write")

        assertCondition(bytes[0] == 1 && bytes[1] == 1, "initial byte[] values")
        bytes[0] = 2
        bytes[1] = 3
        assertCondition(bytes[0] == 2 && bytes[1] == 3, "byte[] read after write")

        assertCondition(chars[0] == 1 && chars[1] == 1, "initial char[] values")
        chars[0] = 2
        chars[1] = 3
        assertCondition(chars[0] == 2 && chars[1] == 3, "char[] read after write")

        assertCondition(shorts[0] == 1 && shorts[1] == 1, "initial short[] values")
        shorts[0] = -2
        shorts[1] = 3
        assertCondition(shorts[0] == -2 && shorts[1] == 3, "short[] read after write")

        assertCondition(ints[0] == 1 && ints[1] == 1, "initial int[] values")
        ints[0] = 2
        ints[1] = 3
        assertCondition(ints[0] == 2 && ints[1] == 3, "int[] read after write")

        assertCondition(longs[0] == 1 && longs[1] == 1, "initial long[] values")
        longs[0] = 2
        longs[1] = 3
        assertCondition(longs[0] == 2 && longs[1] == 3, "long[] read after write")

        assertCondition(floats[0] == 1.0 && floats[1] == 1.0, "initial float[] values")
        floats[0] = 2.5
        floats[1] = -3.5
        assertCondition(floats[0] == 2.5 && floats[1] == -3.5, "float[] read after write")

        assertCondition(doubles[0] == 1.0 && doubles[1] == 1.0, "initial double[] values")
        doubles[0] = 2.25
        doubles[1] = -3.75
        assertCondition(doubles[0] == 2.25 && doubles[1] == -3.75, "double[] read after write")
    }

    public func testStringArray(values: JArray<String>): Unit {
        assertCondition(values[0] == "initial" && values[1] == "initial", "initial String[] values")
        values[0] = "written-by-cangjie"
        values[1] = "你好，JNI"
        assertCondition(values[0] == "written-by-cangjie", "String[] ASCII read after write")
        assertCondition(values[1] == "你好，JNI", "String[] Unicode read after write")
    }

    public func testMirrorObjectArray(values: JArray<Item>): Unit {
        assertCondition(values.length == 2, "Item[] length from Java")
        assertCondition(values[0].getValue() == 1, "initial Item[0] value from Java")
        assertCondition(values[1].getValue() == 1, "initial Item[1] value from Java")

        values[0] = Item(2)
        values[1] = Item(3)

        assertCondition(values[0].getValue() == 2, "Item[0] read after Cangjie write")
        assertCondition(values[1].getValue() == 3, "Item[1] read after Cangjie write")
    }

    // SpecialItem is a JavaImpl subclass of the JavaMirror Item class. This
    // checks virtual dispatch and storing a JavaImpl instance in Item[].
    public func testJavaImplArray(values: JArray<Item>): Unit {
        assertCondition(values.length == 2, "SpecialItem[] test array length")
        assertCondition(values[0].getValue() == 1011, "virtual getValue on JavaImpl received from Java")
        assertCondition(values[1].getValue() == 1, "base Item received from Java")

        values[1] = SpecialItem(22)
        assertCondition(values[1].getValue() == 1022, "virtual getValue on JavaImpl written by Cangjie")
    }

    public func testJObjectArray(values: JArray<JObject>): Unit {
        assertCondition(values.length == 2, "Object[] length from Java")
        let first: JObject = values[0]
        let second: JObject = values[1]

        values[0] = second
        values[1] = first

        assertCondition(values[0].toString() == second.toString(), "Object[0] read after Cangjie swap")
        assertCondition(values[1].toString() == first.toString(), "Object[1] read after Cangjie swap")
    }

    public func primitiveGetOutOfBounds(values: JArray<Int32>): Int32 {
        return values[values.length]
    }

    public func primitiveSetOutOfBounds(values: JArray<Int32>): Unit {
        values[values.length] = 7
    }

    public func objectGetOutOfBounds(values: JArray<Item>): Int32 {
        return values[values.length].getValue()
    }

    public func objectSetOutOfBounds(values: JArray<Item>): Unit {
        values[values.length] = Item(7)
    }

    public func objectSetArrayStoreException(values: JArray<JObject>): Unit {
        // Java passes a String[] as Object[]. Storing an Item must preserve
        // Java's runtime array-store check and propagate the resulting error.
        values[0] = Item(77)
    }
}

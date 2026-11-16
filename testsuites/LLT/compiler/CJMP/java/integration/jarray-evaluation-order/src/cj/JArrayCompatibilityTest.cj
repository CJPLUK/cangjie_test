// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package javasample

import java.lang.*

@Java ["javasample.TestImpl"]
public class TestImpl {
    public init() {}

    // Evaluation states:
    // 0 — INITIAL: no expression evaluated
    // 1 — ARRAY_EVALUATED: array expression evaluated
    // 2 — INDEX_EVALUATED: array and index expressions evaluated
    // 3 — ELEMENT_VALUE_EVALUATED: value for the array element evaluated
    private var state: Int32 = 0

    private var observedArrayCalls: Int32 = 0
    private var observedIndexCalls: Int32 = 0
    private var observedValueCalls: Int32 = 0

    private func assertCondition(condition: Bool, message: String): Unit {
        if (!condition) {
            throw Exception("FAIL: " + message)
        }
    }

    private func getPrimitiveArray(array: JArray<Int32>): JArray<Int32> {
        assertCondition(state == 0, "Array must be evaluated first")
        observedArrayCalls += 1
        state = 1
        return array
    }

    private func getObjectArray(array: JArray<JObject>): JArray<JObject> {
        assertCondition(state == 0, "Array must be evaluated first")
        observedArrayCalls += 1
        state = 1
        return array
    }

    private func getIndex(): Int32 {
        assertCondition(state == 1, "Index must be evaluated after array")
        observedIndexCalls += 1
        state = 2
        return 0
    }

    private func getPrimitiveElementValue(): Int32 {
        assertCondition(state == 2, "Element value must be evaluated after index")
        observedValueCalls += 1
        state = 3
        return 123
    }

    private func getObjectElementValue(): JObject {
        assertCondition(state == 2, "Element value must be evaluated after index")
        observedValueCalls += 1
        state = 3
        return this
    }

    private func testPrimitiveArrayGet(): Unit {
        println("\n--- Primitive array GET ---")

        let array = JArray<Int32>(2)
        array[0] = 42

        state = 0
        observedArrayCalls = 0
        observedIndexCalls = 0

        let actual = getPrimitiveArray(array)[getIndex()]

        println("After GET: actual = ${actual}")
        println("Array calls = ${observedArrayCalls}")
        println("Index calls = ${observedIndexCalls}")

        assertCondition(state == 2, "Primitive array GET: expected array and index evaluation")
        assertCondition(observedArrayCalls == 1,
            "Primitive array GET: array expression must be evaluated exactly once")
        assertCondition(observedIndexCalls == 1,
            "Primitive array GET: index expression must be evaluated exactly once")
        assertCondition(actual == 42,
            "Primitive array GET: expected 42, got ${actual}")
    }

    private func testPrimitiveArraySet(): Unit {
        println("\n--- Primitive array SET ---")

        let array = JArray<Int32>(2)

        state = 0
        observedArrayCalls = 0
        observedIndexCalls = 0
        observedValueCalls = 0

        getPrimitiveArray(array)[getIndex()] = getPrimitiveElementValue()

        let actual = array[0]

        println("After SET: actual = ${actual}")
        println("Array calls = ${observedArrayCalls}")
        println("Index calls = ${observedIndexCalls}")
        println("Value calls = ${observedValueCalls}")

        assertCondition(state == 3, "Primitive array SET: expected array, index and element value evaluation")
        assertCondition(observedArrayCalls == 1,
            "Primitive array SET: array expression must be evaluated exactly once")
        assertCondition(observedIndexCalls == 1,
            "Primitive array SET: index expression must be evaluated exactly once")
        assertCondition(observedValueCalls == 1,
            "Primitive array SET: element value expression must be evaluated exactly once")
        assertCondition(actual == 123,
            "Primitive array SET: expected 123, got ${actual}")
    }

    private func testObjectArrayGet(): Unit {
        println("\n--- Object array GET ---")

        let array = JArray<JObject>(2)
        array[0] = this

        state = 0
        observedArrayCalls = 0
        observedIndexCalls = 0

        let actual = getObjectArray(array)[getIndex()]

        println("After GET: object read completed")
        println("Array calls = ${observedArrayCalls}")
        println("Index calls = ${observedIndexCalls}")

        assertCondition(state == 2, "Object array GET: expected array and index evaluation")
        assertCondition(observedArrayCalls == 1,
            "Object array GET: array expression must be evaluated exactly once")
        assertCondition(observedIndexCalls == 1,
            "Object array GET: index expression must be evaluated exactly once")
    }

    private func testObjectArraySet(): Unit {
        println("\n--- Object array SET ---")

        let array = JArray<JObject>(2)

        state = 0
        observedArrayCalls = 0
        observedIndexCalls = 0
        observedValueCalls = 0

        getObjectArray(array)[getIndex()] = getObjectElementValue()

        let actual = array[0]

        println("After SET: object read completed")
        println("Array calls = ${observedArrayCalls}")
        println("Index calls = ${observedIndexCalls}")
        println("Value calls = ${observedValueCalls}")

        assertCondition(state == 3, "Object array SET: expected array, index and element value evaluation")
        assertCondition(observedArrayCalls == 1,
            "Object array SET: array expression must be evaluated exactly once")
        assertCondition(observedIndexCalls == 1,
            "Object array SET: index expression must be evaluated exactly once")
        assertCondition(observedValueCalls == 1,
            "Object array SET: element value expression must be evaluated exactly once")
    }

    public func testArrayEvaluationOrder(): Unit {
        println("== Run Java -> Cangjie JArray get/set evaluation order tests ==")

        testPrimitiveArrayGet()
        testPrimitiveArraySet()
        testObjectArrayGet()
        testObjectArraySet()

        println("\n== All JArray evaluation order tests passed ==")
    }
}


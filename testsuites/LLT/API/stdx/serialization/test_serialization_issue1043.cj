/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// (CJNATIVE) EXEC:  %compiler %import-cangjie-stdx %cmp_opt %f -o %output %cmp_utest_opt
// (CJNATIVE) EXEC: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args

import stdx.serialization.serialization.*
import std.collection.*

/*
 * Test description: Regression guard for issue 1043 (fixed by stdx PR #965).
 * Float16/Float32.deserialize shall accept DataModelInt within the safe
 * integer range and throw DataModelException beyond it, symmetric with
 * Float64; fallback message covers both accepted types.
 */
@Test
class SerializationIssue1043Test {
    /*
     * Test description: Float16.deserialize accepts DataModelInt within safe range
     * Test API:
     * static func deserialize(dm: DataModel): Float16
     */
    @TestCase
    func testFloat16DeserializeDataModelInt(): Unit {
        @Expect(Float16.deserialize(DataModelInt(3)), Float16(3.0))
        @Expect(Float16.deserialize(DataModelInt(-100)), Float16(-100.0))
        @Expect(Float16.deserialize(DataModelInt(0)), Float16(0.0))
        @Expect(Float16.deserialize(DataModelInt(2047)), Float16(2047.0))
        @Expect(Float16.deserialize(DataModelInt(-2047)), Float16(-2047.0))
    }

    /*
     * Test description: Float16.deserialize throws beyond the safe integer range
     * Test API:
     * static func deserialize(dm: DataModel): Float16
     */
    @TestCase
    func testFloat16DeserializeDataModelIntOutOfRange(): Unit {
        var exception: ?Exception = None
        try {
            Float16.deserialize(DataModelInt(5000))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testFloat16DeserializeDataModelIntOutOfRange", exception, "safe integer range")
        var exceptionNeg: ?Exception = None
        try {
            Float16.deserialize(DataModelInt(-5000))
        } catch (e: DataModelException) {
            exceptionNeg = e
        }
        anomalyAssert("testFloat16DeserializeDataModelIntOutOfRangeNeg", exceptionNeg, "safe integer range")
    }

    /*
     * Test description: Float32.deserialize accepts DataModelInt within safe range
     * Test API:
     * static func deserialize(dm: DataModel): Float32
     */
    @TestCase
    func testFloat32DeserializeDataModelInt(): Unit {
        @Expect(Float32.deserialize(DataModelInt(5)), Float32(5.0))
        @Expect(Float32.deserialize(DataModelInt(-100)), Float32(-100.0))
        @Expect(Float32.deserialize(DataModelInt(16777215)), Float32(16777215.0))
        @Expect(Float32.deserialize(DataModelInt(-16777215)), Float32(-16777215.0))
    }

    /*
     * Test description: Float32.deserialize throws beyond the safe integer range
     * Test API:
     * static func deserialize(dm: DataModel): Float32
     */
    @TestCase
    func testFloat32DeserializeDataModelIntOutOfRange(): Unit {
        var exception: ?Exception = None
        try {
            Float32.deserialize(DataModelInt(16777216))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testFloat32DeserializeDataModelIntOutOfRange", exception, "safe integer range")
    }

    /*
     * Test description: Float64.deserialize keeps accepting DataModelInt (regression)
     * Test API:
     * static func deserialize(dm: DataModel): Float64
     */
    @TestCase
    func testFloat64DeserializeDataModelInt(): Unit {
        @Expect(Float64.deserialize(DataModelInt(7)), Float64(7.0))
        @Expect(Float64.deserialize(DataModelInt(9007199254740991)), Float64(9007199254740991.0))
    }

    /*
     * Test description: Float64.deserialize throws beyond the safe integer range (regression)
     * Test API:
     * static func deserialize(dm: DataModel): Float64
     */
    @TestCase
    func testFloat64DeserializeDataModelIntOutOfRange(): Unit {
        var exception: ?Exception = None
        try {
            Float64.deserialize(DataModelInt(9007199254740992))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testFloat64DeserializeDataModelIntOutOfRange", exception, "safe integer range")
    }

    /*
     * Test description: fallback message covers both accepted types
     * Test API:
     * static func deserialize(dm: DataModel): Float16
     */
    @TestCase
    func testFallbackMessageCoversBothTypes(): Unit {
        var exception: ?Exception = None
        try {
            Float16.deserialize(DataModelBool(true))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testFallbackMessageCoversBothTypes", exception, "Expected DataModelFloat or DataModelInt.")
    }

    /*
     * Test description: HashMap<String, Int64> serialize/deserialize round-trip regression
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): HashMap<K, V>
     */
    @TestCase
    func testHashMapStringKeyRoundTrip(): Unit {
        let m = HashMap<String, Int64>()
        m.add("key1", 100)
        let dm = m.serialize()
        @Expect(dm is DataModelStruct, true)
        let m2 = HashMap<String, Int64>.deserialize(dm)
        @Expect(m2.get("key1"), Some(100))
    }

    /*
     * Test description: HashMap with non-String key type throws clarified message
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): HashMap<K, V>
     */
    @TestCase
    func testHashMapNonStringKeyMessage(): Unit {
        var exceptionSer: ?Exception = None
        try {
            let m = HashMap<Int64, String>()
            m.add(1, "x")
            let _ = m.serialize()
        } catch (e: DataModelException) {
            exceptionSer = e
        }
        anomalyAssert("testHashMapNonStringKeyMessageSer", exceptionSer, "requires the key type to be String")
        var exceptionDeser: ?Exception = None
        try {
            let dms = DataModelStruct().add(field<String>("1", "x"))
            let _ = HashMap<Int64, String>.deserialize(dms)
        } catch (e: DataModelException) {
            exceptionDeser = e
        }
        anomalyAssert("testHashMapNonStringKeyMessageDeser", exceptionDeser, "requires the key type to be String")
    }

    /*
     * description: assert of abnormal test case error
     * params:
     * caseName: case name
     * actualException case actual exception
     * expectMessage expect exception message
     */
    func anomalyAssert(caseName: String, actualException: Option<Exception>, expectMessage: String) {
        if (let Some(e) <- actualException) {
            if (e.message.contains(expectMessage)) {
                @Expect(true)
            } else {
                @Expect("The case ${caseName} error is ${e.message}","The case ${caseName} error is ${expectMessage}")
            }
        } else {
            @Expect("The test case ${caseName} has no errors","The test case ${caseName} has  errors")
        }
    }
}

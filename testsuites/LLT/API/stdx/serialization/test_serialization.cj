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
import stdx.encoding.json.*
import std.collection.*
import std.math.*

/*
 * Test description: Test the funcs for Serializable
 * Test class:
 * public interface Serializable<T>
 */
@Test
class SerializableTest {
    /*
     * description: assert of  abnormal test case error
     * params:
     * caseName: case name
     * actualException  case actual exception
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

    /*
     * Test description: Test extend Int64 <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeInt64(): Unit {
        var in64: Int64 = 100
        @Expect(Int64.deserialize(in64.serialize()),in64)
    }

    /*
     * Test description: Test extend Int64 <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeInt64(): Unit {
        var exception: ?Exception = None
        try {
            Int64.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeInt64", exception, "Expected DataModelInt.")
    }

    /*
     * Test description: Test extend Int32 <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeInt32(): Unit {
        var in32: Int32 = 100
        @Expect(Int32.deserialize(in32.serialize()),in32)
    }

    /*
     * Test description: Test extend Int32 <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeInt32(): Unit {
        var exception: ?Exception = None
        try {
            Int32.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeInt32", exception, "Expected DataModelInt.")
    }

    /*
     * Test description: Test extend Int16 <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeInt16(): Unit {
        var in16: Int16 = 100
        @Expect(Int16.deserialize(in16.serialize()),in16)
    }

    /*
     * Test description: Test extend Int16 <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeInt16(): Unit {
        var exception: ?Exception = None
        try {
            Int16.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeInt16", exception, "Expected DataModelInt.")
    }

    /*
     * Test description: Test extend Int8 <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeInt8(): Unit {
        var in8: Int8 = 127
        @Expect(Int8.deserialize(in8.serialize()),in8)
    }

    /*
     * Test description: Test extend Int8 <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeInt8(): Unit {
        var exception: ?Exception = None
        try {
            Int8.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeInt8", exception, "Expected DataModelInt.")
    }

    /*
     * Test description: Test extend UInt64  <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeUInt64(): Unit {
        var uIn64: UInt64 = 127
        @Expect(UInt64.deserialize(uIn64.serialize()),uIn64)
    }

    /*
     * Test description: Test extend UInt64 <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeUInt64(): Unit {
        var exception: ?Exception = None
        try {
            UInt64.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeUInt64", exception, "Expected DataModelInt.")
    }

    /*
     * Test description: Test extend UInt32  <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeUInt32(): Unit {
        var uIn32: UInt32 = 127
        @Expect(UInt32.deserialize(uIn32.serialize()),uIn32)
    }

    /*
     * Test description: Test extend UInt32 <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeUInt32(): Unit {
        var exception: ?Exception = None
        try {
            UInt32.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeUInt32", exception, "Expected DataModelInt.")
    }

    /*
     * Test description: Test extend UInt16  <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeUInt16(): Unit {
        var uIn16: UInt16 = 127
        @Expect(UInt16.deserialize(uIn16.serialize()),uIn16)
    }

    /*
     * Test description: Test extend UInt16 <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeUInt16(): Unit {
        var exception: ?Exception = None
        try {
            UInt16.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeUInt16", exception, "Expected DataModelInt.")
    }

    /*
     * Test description: Test extend UInt8  <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeUInt8(): Unit {
        var uIn8: UInt8 = 127
        @Expect(UInt8.deserialize(uIn8.serialize()),uIn8)
    }

    /*
     * Test description: Test extend UInt8 <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeUInt8(): Unit {
        var exception: ?Exception = None
        try {
            UInt8.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeUInt8", exception, "Expected DataModelInt.")
    }

    /*
     * Test description: Test extend Float64   <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeFloat64(): Unit {
        var float64: Float64 = 0.0
        @Expect(Float64.deserialize(float64.serialize()),float64)
    }

    /*
     * Test description: Test extend Float64 <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeFloat64(): Unit {
        var exception: ?Exception = None
        try {
            Float64.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeUInt8", exception, "Expected DataModelFloat or DataModelInt.")
    }

    /*
     * Test description: Test extend Float32   <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeFloat32(): Unit {
        var float32: Float32 = 0.0
        @Expect(Float32.deserialize(float32.serialize()),float32)
    }

    /*
     * Test description: Test extend Float32 <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeFloat32(): Unit {
        var exception: ?Exception = None
        try {
            Float32.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeFloat32", exception, "Expected DataModelFloat or DataModelInt.")
    }

    /*
     * Test description: Test extend Float16   <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeFloat16(): Unit {
        var float16: Float16 = 0.0
        @Expect(Float16.deserialize(float16.serialize()),float16)
    }

    /*
     * Test description: Test extend Float32 <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeFloat16(): Unit {
        var exception: ?Exception = None
        try {
            Float16.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeFloat16", exception, "Expected DataModelFloat or DataModelInt.")
    }

    /*
     * Test description: Test extend Bool    <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeBool(): Unit {
        @Expect(Bool.deserialize(true.serialize()),true)
    }

    /*
     * Test description: Test extend Bool  <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeBool(): Unit {
        var exception: ?Exception = None
        try {
            Bool.deserialize(DataModelString("false"))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeBool", exception, "Expected DataModelBool.")
    }

    /*
     * Test description: Test extend String <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeString(): Unit {
        @Expect(String.deserialize("test".serialize()),"test")
    }

    /*
     * Test description: Test extend String<: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeString(): Unit {
        var exception: ?Exception = None
        try {
            String.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeString", exception, "Expected DataModelString.")
    }

    /*
     * Test description: Test extend Rune<: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeRune(): Unit {
        @Expect(Rune.deserialize(r'C'.serialize()),r'C')
    }

    /*
     * Test description: Test extend Rune<: Serializable ::serialization with non-ASCII character
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeRuneNonASCII(): Unit {
        @Expect(Rune.deserialize(r'中'.serialize()),r'中')
        @Expect(Rune.deserialize(r'あ'.serialize()),r'あ')
        @Expect(Rune.deserialize(r'😊'.serialize()),r'😊')
    }

    /*
     * Test description: Test extend Rune<: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeRune(): Unit {
        var exception01: ?Exception = None
        try {
            Rune.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception01 = e
        }
        anomalyAssert("testInvalidDeserializeRune_01", exception01, "Expected DataModelString.")
        var exception02: ?Exception = None
        try {
            Rune.deserialize(DataModelString("fgh"))
        } catch (e: Exception) {
            exception02 = e
        }
        anomalyAssert("testInvalidDeserializeRune_02", exception02, "Expected Rune.")
    }

    /*
     * Test description: Test extend Array <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeArray(): Unit {
        var l: Array<String> = ["a", "b", "c"]
        var seris: DataModel = l.serialize()
        @Expect(l,Array<String>.deserialize(seris))

        var ref: Array<Values> = [Values(3), Values(5), Values(2), Values(7), Values(45), Values(322)]
        var refdemo: DataModel = ref.serialize()
        @Expect(Array<Values>.deserialize(refdemo),ref)
        var empty: Array<String> = []
        var refdemo2: DataModel = empty.serialize()
        @Expect(Array<String>.deserialize(refdemo2),empty)
    }

    /*
     * Test description: Test extend Array <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeArray(): Unit {
        var exception: ?Exception = None
        try {
            Array<String>.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeArray", exception, "Expected DataModelSeq.")
    }

    /*
     * Test description: Test extend ArrayList <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeArrayList(): Unit {
        var l: ArrayList<String> = ArrayList<String>(["a", "b", "c"])
        var seris: DataModel = l.serialize()
        @Expect(l,ArrayList<String>.deserialize(seris))
    }

    /*
     * Test description: Test extend ArrayList <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeArrayList(): Unit {
        var exception: ?Exception = None
        try {
            ArrayList<String>.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeArrayList", exception, "Expected DataModelSeq.")
    }

    /*
     * Test description: Test extend HashMap <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeHashMap(): Unit {
        var map01: HashMap<String, String> = HashMap<String, String>([("1", "3"), ("2", "6"), ("3", "9")])
        var seris01: DataModel = map01.serialize()
        @Expect(map01, HashMap<String, String>.deserialize(seris01))

        var hm: HashMap<String, String> = HashMap<String, String>.deserialize(
            DataModel.fromJson(JsonValue.fromStr(##"{"age": "456"}"##)))
        @Expect(hm.get("age").getOrThrow(),"456")

        var map02: HashMap<String, Values> = HashMap<String, Values>([("1", Values(3)), ("2", Values(6)),
            ("3", Values(9))])
        var seris02: DataModel = map02.serialize()
        var dm: HashMap<String, Values> = HashMap<String, Values>.deserialize(seris02)
        @Expect(dm==map02)
    }

    /*
     * Test description: Test extend HashMap <: Serializable ::serialization
     * Test API:
     * public func serialize(): DataModel
     */
    @TestCase
    func testInvalidSerializeHashMap(): Unit {
        var exception: ?Exception = None
        try {
            var m: HashMap<Int64, String> = HashMap<Int64, String>([(1, "3"), (2, "6"), (3, "9")])
            m.serialize()
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidSerializeHashMap", exception, "requires the key type to be String")
    }
    /*
     * Test description: Test extend HashMap <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeHashMap(): Unit {
        var exception01: ?Exception = None
        try {
            HashMap<String, String>.deserialize(DataModelBool(true))
        } catch (e: DataModelException) {
            exception01 = e
        }
        anomalyAssert("testInvalidDeserializeHashMap_01", exception01, "Expected DataModelStruct.")
        var exception02: ?Exception = None
        try {
            HashMap<String, String>.deserialize(HashMap<Int64, String>([(1, "3"), (2, "6"), (3, "9")]).serialize())
        } catch (e: DataModelException) {
            exception02 = e
        }

        anomalyAssert("testInvalidDeserializeHashMap_02", exception02, "requires the key type to be String")
    }

    /*
     * Test description: Test extend HashSet<: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeHashSet(): Unit {
        var set01: HashSet<String> = HashSet<String>(["a", "b", "c"])
        var serim: DataModel = set01.serialize()
        @Expect(set01,HashSet<String>.deserialize(serim))

        var set02: HashSet<Values> = HashSet<Values>([Values(3), Values(5), Values(7)])
        var ds: HashSet<Values> = HashSet<Values>.deserialize(set02.serialize())
        @Expect(set02==ds)
    }

    /*
     * Test description: Test extend HashSet <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeHashSet(): Unit {
        var exception: ?Exception = None
        try {
            HashSet<String>.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeHashSet", exception, "Expected DataModelSeq.")
    }

    /*
     * Test description: Test extend Option <: Serializable ::serialization
     * Test API:
     * func serialize(): DataModel
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testSerializableAndDeserializeOption(): Unit {
        var op01: Option<String> = Some("Hello")
        var sop01: DataModel = op01.serialize()
        @Expect(op01,Option<String>.deserialize(sop01))

        var op02: Option<String> = None
        var sop02: DataModel = op02.serialize()
        @Expect(op02,Option<String>.deserialize(sop02))
    }

    /*
     * Test description: Test extend Option <: Serializable ::serialization
     * Test API:
     * static func deserialize(dm: DataModel): T
     */
    @TestCase
    func testInvalidDeserializeOption(): Unit {
        var exception: ?Exception = None
        try {
            Option<String>.deserialize(DataModelBool(false))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testInvalidDeserializeOption", exception, "Expected DataModelString.")
    }

    /*
     * Test description: Test interface Serializable<T>
     *
     */
    @TestCase
    func testDeserializeFromJson(): Unit {
        let abcStr = ##"{"age": 123, "name": "zhangsan", "score": 100}"##
        let objModel = DataModel.fromJson(JsonValue.fromStr(abcStr))
        let abc = Abc.deserialize(objModel)
        @Expect(abc.toString(),##"age: 123, name: zhangsan, score: 100.000000"##)
    }

    /*
     * Test description: Test interface Serializable<T>
     *
     */
    @TestCase
    func testDeserializeFromCustomObject(): Unit {
        var aa = Location()
        var bb: DataModel = aa.serialize()
        var cc: Location = Location.deserialize(bb)
        cc.time = 123
        cc.heheh = r'M'
        @Expect(cc.time,123)
        var dd = abc()
        var ee: DataModel = dd.serialize()
        var ff: abc = abc.deserialize(ee)
        @Expect(ff.loc is Option<Location>)
        var aaa = ##"{"age": 123,"loc": { "heheh":"H","time":45 },"name": "chuangchao"}"##
        var ccc: abc = abc.deserialize(DataModel.fromJson(JsonValue.fromStr(aaa)))
        @Expect(ccc.name == "chuangchao" && ccc.age == 123 && ccc.loc.getOrThrow().time == 45 && ccc.loc.getOrThrow().heheh == r'H')
        var bbb = ##"{"age": 456,"name": "gaoshiyuan"}"##
        var ddd: abc = abc.deserialize(DataModel.fromJson(JsonValue.fromStr(bbb)))
        @Expect(ddd.name == "gaoshiyuan" && ddd.age == 456)
    }

    /*
     * Test description: Test Float64 Deserialize
     *
     */
    @TestCase
    func testFloat64DeserializeOverMaxSafeInt(): Unit {
        var exception: ?Exception = None
        try {
            Float64.deserialize(DataModelInt(9007199254740992))
        } catch (e: DataModelException) {
            exception = e
        }
        anomalyAssert("testFloat64DeserializeOverMaxSafeInt", exception, "Integer value '9007199254740992' exceeds Float64 safe integer range")
    }
}

class Abc <: Serializable<Abc> & ToString {
    var name: String = "Abcde"
    var age: Int64 = 555
    var score: Float64 = 90.5

    public init() {}

    public init(name: String, age: Int64, score: Float64) {
        this.name = name
        this.age = age
        this.score = score
    }

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("name", name))
            .add(field<Int64>("age", age))
            .add(field<Float64>("score", this.score))
    }

    public static func deserialize(dm: DataModel): Abc {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = Abc()
        result.name = String.deserialize(dms.get("name"))
        result.age = Int64.deserialize(dms.get("age"))
        result.score = Float64.deserialize(dms.get("score"))
        return result
    }

    public func toString(): String {
        return "age: ${age}, name: ${name}, score: ${score}"
    }
}

class Values <: Hashable & Equatable<Values> & Serializable<Values> {
    public var m_data: Int64

    public init(m_data: Int64) {
        this.m_data = m_data
    }

    public func hashCode(): Int64 {
        return this.m_data
    }

    public operator func ==(right: Values): Bool {
        var a = (this.m_data == right.m_data)
        if (a) {
            return true
        } else {
            return false
        }
    }

    public operator func !=(right: Values): Bool {
        var a = (this.m_data != right.m_data)
        if (a) {
            return true
        } else {
            return false
        }
    }
    public func serialize(): DataModel {
        return DataModelStruct().add(field<Int64>("m_data", m_data))
    }

    public static func deserialize(dm: DataModel): Values {
        var dms: DataModelStruct = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = Values(0)
        result.m_data = Int64.deserialize(dms.get("m_data"))
        return result
    }
}

class abc <: Serializable<abc> {
    public var name: String = "abcde"
    public var age: Int64 = 555
    public var loc: Option<Location> = Option<Location>.None

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("name", name))
            .add(field<Int64>("age", age))
            .add(field<Option<Location>>("loc", loc))
    }

    public static func deserialize(dm: DataModel): abc {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = abc()
        result.name = String.deserialize(dms.get("name"))
        result.age = Int64.deserialize(dms.get("age"))
        result.loc = Option<Location>.deserialize(dms.get("loc"))
        return result
    }
}

class Location <: Serializable<Location> {
    public var time: Int64 = 666
    public var heheh: Rune = r'T'
    public func serialize(): DataModel {
        return DataModelStruct().add(field<Int64>("time", time)).add(field<Rune>("heheh", heheh))
    }

    public static func deserialize(dm: DataModel): Location {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = Location()
        result.time = Int64.deserialize(dms.get("time"))
        result.heheh = Rune.deserialize(dms.get("heheh"))
        return result
    }
}

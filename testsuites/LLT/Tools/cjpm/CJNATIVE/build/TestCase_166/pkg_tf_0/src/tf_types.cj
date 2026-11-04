// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package pkg_tf_0

import std.collection.*
import pkg_macro_1.mfunc_920836

var __trace: StringBuilder = StringBuilder()

interface I0<T0, T1> {
    func update_i0_0(input: T0, data: T1, value: T0): Float32

    func compute_i0_1(): T1

    public static func handleEvent_i0_2(): UInt64 {
        __trace.append("[I0.handleEvent_i0_2]")
        1u64
    }

    public static func compute_i0_3(): Int8 {
        __trace.append("[I0.compute_i0_3]")
        1i8
    }

    public static func resolve_i0_4(): Float64 {
        __trace.append("[I0.resolve_i0_4]")
        114.514000f64
    }

    operator func *(right: Int64): Int64
}

interface I1<T0> {
    public static func compare_i1_0(): Float64 {
        __trace.append("[I1.compare_i1_0]")
        114.514000f64
    }

    func calculate_i1_1(input: Rune, data: Unit): UInt16

    public static func resolve_i1_2(): Float32 {
        __trace.append("[I1.resolve_i1_2]")
        114.514000f32
    }

    func calculate_i1_3(input: UInt64, data: T0, value: T0): T0

    func handleEvent_i1_4(input: UInt32): T0

    func validate_i1_5(): Bool

    public static func calculate_i1_6(): Int64 {
        __trace.append("[I1.calculate_i1_6]")
        1i64
    }

    func resolve_i1_7(input: Bool): UInt64

    func fetch_i1_8(input: Int64, data: Bool): Bool

    func serialize_i1_9(input: Array<Int64>): T0

    func calculate_i1_10(input: Float64): Rune
}

sealed interface I2<T0> {
    func filter_i2_0(input: Rune, data: Int32, value: UInt64): T0

    func analyze_i2_1(input: String): T0

    func update_i2_2(input: Int64): Int64 {
        __trace.append("[I2.update_i2_2]")
        1i64
    }

    func serialize_i2_3(): T0

    func buildResult_i2_4(): T0

    func calculate_i2_5(input: Array<Int64>, data: Rune, value: T0): Rune

    public static func compare_i2_6(): UInt64 {
        __trace.append("[I2.compare_i2_6]")
        1u64
    }

    public static func evaluate_i2_7(): Int16 {
        __trace.append("[I2.evaluate_i2_7]")
        1i16
    }

    func update_i2_8(input: String, data: Int64): Bool

    public static func update_i2_9(): Unit {
        __trace.append("[I2.update_i2_9]")
        return
    }
}

sealed interface I3<T0, T1> {
    public static func query_i3_0(): Float32 {
        __trace.append("[I3.query_i3_0]")
        114.514000f32
    }

    func checkState_i3_1(): UInt8

    public static func transform_i3_2(): Float32 {
        __trace.append("[I3.transform_i3_2]")
        114.514000f32
    }

    func process_i3_3(): T0

    func filter_i3_4(input: Int32, data: T0): Bool {
        __trace.append("[I3.filter_i3_4]")
        true
    }

    func finalize_i3_5(input: T1): Int16

    func buildResult_i3_6(input: Bool, data: UInt64): UInt8

    func handleEvent_i3_7(input: Float32, data: T1, value: Array<Int64>): Bool

    operator func ==(right: Int64): Bool
}

interface I4<T0> <: I5<UInt16, Rune> {
    func compare_i4_0(input: T0, data: UInt64, value: Float64): UInt64 {
        __trace.append("[I4.compare_i4_0]")
        1u64
    }

    func evaluate_i4_1(input: Int32, data: Float64): T0

    func checkState_i4_2(input: Float64): Int32

    public static func initialize_i4_3(): UInt64 {
        __trace.append("[I4.initialize_i4_3]")
        1u64
    }
}

interface I5<T0, T1> {
    func checkState_i5_0(input: T0): T0

    func fetch_i5_1(): T0

    func validate_i5_2(input: T1): String

    func update_i5_3(input: T1): Int64

    func compute_i5_4(input: T1, data: UInt32, value: T0): Int64

    func setValue_i5_5(): UInt64

    func checkState_i5_6(input: UInt8, data: UInt8): T1
}

interface I6<T0, T1> {
    public static func transform_i6_0(): Rune {
        __trace.append("[I6.transform_i6_0]")
        r'a'
    }

    func evaluate_i6_1(input: T0, data: Int32): T1

    func execute_i6_2(input: T1, data: T0): Int32

    func analyze_i6_3(input: UInt16, data: T0): T0

    public static func process_i6_4(): UInt32 {
        __trace.append("[I6.process_i6_4]")
        1u32
    }

    func update_i6_5(input: T1, data: UInt8, value: T1): T1

    func initialize_i6_6(): T0

    func resolve_i6_7(input: Float32): T0

    func fetch_i6_8(): Rune
}

interface I7<T0, T1> {
    func convert_i7_0(): Float32

    func validate_i7_1(input: UInt32, data: T1, value: Unit): Float32

    func compare_i7_2(input: Int16, data: Unit, value: T1): T0

    func fetch_i7_3(input: Float64, data: UInt8): UInt16

    func handleEvent_i7_4(input: T0): Unit

    func serialize_i7_5(input: UInt32, data: Array<Int64>, value: T0): UInt64

    func evaluate_i7_6(input: T0, data: T0): T0
}

interface I8<T0, T1> {
    func transform_i8_0(input: Rune, data: UInt16): T0

    public static func execute_i8_1(): Unit {
        __trace.append("[I8.execute_i8_1]")
        return
    }

    func update_i8_2(input: Bool, data: T0, value: T0): Unit {
        __trace.append("[I8.update_i8_2]")
        return
    }

    func query_i8_3(input: UInt32, data: UInt16): T0

    func synthesize_i8_4(input: Int64): T1
}

interface I9<T0> {
    func validate_i9_0(): T0

    public static func evaluate_i9_1(): Int16 {
        __trace.append("[I9.evaluate_i9_1]")
        1i16
    }

    func query_i9_2(input: Int32, data: T0, value: T0): Int16 {
        __trace.append("[I9.query_i9_2]")
        1i16
    }

    func analyze_i9_3(input: Int8, data: T0, value: Rune): UInt16 {
        __trace.append("[I9.analyze_i9_3]")
        1u16
    }

    func fetch_i9_4(): T0

    func compare_i9_5(input: String): Int64

    func checkState_i9_6(input: T0, data: String, value: Int64): T0

    func calculate_i9_7(input: T0, data: Int8, value: Int16): T0
}

interface I10<T0, T1> {
    func getValue_i10_0(): T0

    func merge_i10_1(input: T0, data: Rune): T1

    func filter_i10_2(input: T0, data: T1, value: T1): T1

    func evaluate_i10_3(input: Float32, data: T1, value: Int16): T1

    func execute_i10_4(input: Float32): T1

    func initialize_i10_5(): Bool

    func compute_i10_6(): T0

    public static func compare_i10_7(): Int8 {
        __trace.append("[I10.compare_i10_7]")
        1i8
    }

    func filter_i10_8(input: Float32, data: Int32): T0

    func analyze_i10_9(): T1
}

sealed interface I11<T0> <: I5<UInt16, Rune> {
    func checkState_i11_0(input: UInt64): UInt8 {
        __trace.append("[I11.checkState_i11_0]")
        1u8
    }

    public static func setValue_i11_1(): Int32 {
        __trace.append("[I11.setValue_i11_1]")
        1i32
    }

    func setValue_i11_2(): T0

    func validate_i11_3(input: Unit): T0

    func fetch_i11_4(): Array<Int64>

    func calculate_i11_5(input: UInt64, data: T0): T0

    func process_i11_6(): T0

    func calculate_i11_7(): T0

    func process_i11_8(input: T0, data: UInt32): Int32

    func handleEvent_i11_9(input: Unit): Rune
}

interface I12<T0> {
    func execute_i12_0(): String

    func serialize_i12_1(input: Array<Int64>, data: Array<Int64>): T0

    public static func evaluate_i12_2(): Int8 {
        __trace.append("[I12.evaluate_i12_2]")
        1i8
    }

    func transform_i12_3(): Float32 {
        __trace.append("[I12.transform_i12_3]")
        114.514000f32
    }

    func analyze_i12_4(input: T0): Unit

    public static func handleEvent_i12_5(): Rune {
        __trace.append("[I12.handleEvent_i12_5]")
        r'a'
    }

    public static func resolve_i12_6(): Int32 {
        __trace.append("[I12.resolve_i12_6]")
        1i32
    }
}

interface I13<T0> {
    func execute_i13_0(): UInt8 {
        __trace.append("[I13.execute_i13_0]")
        1u8
    }

    func initialize_i13_1(input: T0): T0

    func compare_i13_2(input: T0, data: T0): UInt64

    func convert_i13_3(input: Int32, data: UInt32, value: Unit): UInt8

    func process_i13_4(input: UInt8, data: T0): UInt32 {
        __trace.append("[I13.process_i13_4]")
        1u32
    }

    func getValue_i13_5(input: UInt32, data: T0): UInt8

    public static func query_i13_6(): Int16 {
        __trace.append("[I13.query_i13_6]")
        1i16
    }

    func getValue_i13_7(): T0
}

sealed interface I14<T0, T1> {
    func process_i14_0(): Int64

    func synthesize_i14_1(input: Rune): Unit

    func convert_i14_2(): Int16

    func query_i14_3(): Bool

    func query_i14_4(input: Int8): T0
}

abstract class A0 <: O1<Float64, Int64> {
    let f_A0_62387_500773: Bool = true

    let f_A0_62388_35680: Int8 = 1i8
}

abstract class A1 <: O1<Float64, Int64> {}

abstract class A2<T0, T1> <: I5<UInt16, Rune> & I14<Rune, UInt64> {
    var f_A2_62389_432258: Rune = r'a'

    var f_A2_62390_225825: Rune = r'a'

    var f_A2_62391_174433: Float32 = 114.514000f32

    public open func checkState_i5_0(input: UInt16): UInt16

    public open func fetch_i5_1(): UInt16

    public open func validate_i5_2(input: Rune): String

    public open func update_i5_3(input: Rune): Int64

    public open func compute_i5_4(input: Rune, data: UInt32, value: UInt16): Int64

    public open func setValue_i5_5(): UInt64

    public open func checkState_i5_6(input: UInt8, data: UInt8): Rune

    public open func process_i14_0(): Int64

    public open func synthesize_i14_1(input: Rune): Unit

    public open func convert_i14_2(): Int16

    public open func query_i14_3(): Bool

    public open func query_i14_4(input: Int8): Rune
}

open class O0<T0> <: I9<Array<Int64>> & I1<UInt64> & I8<UInt32, Int32> {
    var f_O0_62392_166464: Bool = true

    public prop p_10000_6536: Int16 {
        get() {
            1i16
        }
    }

    public open func validate_i9_0(): Array<Int64> {
        __trace.append("[O0.validate_i9_0]")
        Array<Int64>()
    }

    public open override func query_i9_2(input: Int32, data: Array<Int64>, value: Array<Int64>): Int16 {
        __trace.append("[O0.query_i9_2]")
        1i16
    }

    public open override func analyze_i9_3(input: Int8, data: Array<Int64>, value: Rune): UInt16 {
        __trace.append("[O0.analyze_i9_3]")
        1u16
    }

    public open func fetch_i9_4(): Array<Int64> {
        __trace.append("[O0.fetch_i9_4]")
        Array<Int64>()
    }

    public open func compare_i9_5(input: String): Int64 {
        __trace.append("[O0.compare_i9_5]")
        1i64
    }

    public open func checkState_i9_6(input: Array<Int64>, data: String, value: Int64): Array<Int64> {
        __trace.append("[O0.checkState_i9_6]")
        Array<Int64>()
    }

    public open func calculate_i9_7(input: Array<Int64>, data: Int8, value: Int16): Array<Int64> {
        __trace.append("[O0.calculate_i9_7]")
        Array<Int64>()
    }

    public open func calculate_i1_1(input: Rune, data: Unit): UInt16 {
        __trace.append("[O0.calculate_i1_1]")
        1u16
    }

    public open func calculate_i1_3(input: UInt64, data: UInt64, value: UInt64): UInt64 {
        __trace.append("[O0.calculate_i1_3]")
        1u64
    }

    public open func handleEvent_i1_4(input: UInt32): UInt64 {
        __trace.append("[O0.handleEvent_i1_4]")
        1u64
    }

    public open func validate_i1_5(): Bool {
        __trace.append("[O0.validate_i1_5]")
        true
    }

    public open func resolve_i1_7(input: Bool): UInt64 {
        __trace.append("[O0.resolve_i1_7]")
        1u64
    }

    public open func fetch_i1_8(input: Int64, data: Bool): Bool {
        __trace.append("[O0.fetch_i1_8]")
        true
    }

    public open func serialize_i1_9(input: Array<Int64>): UInt64 {
        __trace.append("[O0.serialize_i1_9]")
        1u64
    }

    public open func calculate_i1_10(input: Float64): Rune {
        __trace.append("[O0.calculate_i1_10]")
        r'a'
    }

    public open func transform_i8_0(input: Rune, data: UInt16): UInt32 {
        __trace.append("[O0.transform_i8_0]")
        1u32
    }

    public open override func update_i8_2(input: Bool, data: UInt32, value: UInt32): Unit {
        __trace.append("[O0.update_i8_2]")
        return
    }

    public open func query_i8_3(input: UInt32, data: UInt16): UInt32 {
        __trace.append("[O0.query_i8_3]")
        1u32
    }

    public open func synthesize_i8_4(input: Int64): Int32 {
        __trace.append("[O0.synthesize_i8_4]")
        1i32
    }
}

open class O1<T0, T1> <: I13<UInt16> & I8<UInt32, Int32> & I7<Bool, UInt32> & I1<UInt64> {
    public open override func execute_i13_0(): UInt8 {
        __trace.append("[O1.execute_i13_0]")
        1u8
    }

    public open func initialize_i13_1(input: UInt16): UInt16 {
        __trace.append("[O1.initialize_i13_1]")
        1u16
    }

    public open func compare_i13_2(input: UInt16, data: UInt16): UInt64 {
        __trace.append("[O1.compare_i13_2]")
        1u64
    }

    public open func convert_i13_3(input: Int32, data: UInt32, value: Unit): UInt8 {
        __trace.append("[O1.convert_i13_3]")
        1u8
    }

    public open override func process_i13_4(input: UInt8, data: UInt16): UInt32 {
        __trace.append("[O1.process_i13_4]")
        1u32
    }

    public open func getValue_i13_5(input: UInt32, data: UInt16): UInt8 {
        __trace.append("[O1.getValue_i13_5]")
        1u8
    }

    public open func getValue_i13_7(): UInt16 {
        __trace.append("[O1.getValue_i13_7]")
        1u16
    }

    public open func transform_i8_0(input: Rune, data: UInt16): UInt32 {
        __trace.append("[O1.transform_i8_0]")
        1u32
    }

    public open override func update_i8_2(input: Bool, data: UInt32, value: UInt32): Unit {
        __trace.append("[O1.update_i8_2]")
        return
    }

    public open func query_i8_3(input: UInt32, data: UInt16): UInt32 {
        __trace.append("[O1.query_i8_3]")
        1u32
    }

    public open func synthesize_i8_4(input: Int64): Int32 {
        __trace.append("[O1.synthesize_i8_4]")
        1i32
    }

    public open func convert_i7_0(): Float32 {
        __trace.append("[O1.convert_i7_0]")
        114.514000f32
    }

    public open func validate_i7_1(input: UInt32, data: UInt32, value: Unit): Float32 {
        __trace.append("[O1.validate_i7_1]")
        114.514000f32
    }

    public open func compare_i7_2(input: Int16, data: Unit, value: UInt32): Bool {
        __trace.append("[O1.compare_i7_2]")
        true
    }

    public open func fetch_i7_3(input: Float64, data: UInt8): UInt16 {
        __trace.append("[O1.fetch_i7_3]")
        1u16
    }

    public open func handleEvent_i7_4(input: Bool): Unit {
        __trace.append("[O1.handleEvent_i7_4]")
        return
    }

    public open func serialize_i7_5(input: UInt32, data: Array<Int64>, value: Bool): UInt64 {
        __trace.append("[O1.serialize_i7_5]")
        1u64
    }

    public open func evaluate_i7_6(input: Bool, data: Bool): Bool {
        __trace.append("[O1.evaluate_i7_6]")
        true
    }

    public open func calculate_i1_1(input: Rune, data: Unit): UInt16 {
        __trace.append("[O1.calculate_i1_1]")
        1u16
    }

    public open func calculate_i1_3(input: UInt64, data: UInt64, value: UInt64): UInt64 {
        __trace.append("[O1.calculate_i1_3]")
        1u64
    }

    public open func handleEvent_i1_4(input: UInt32): UInt64 {
        __trace.append("[O1.handleEvent_i1_4]")
        1u64
    }

    public open func validate_i1_5(): Bool {
        __trace.append("[O1.validate_i1_5]")
        true
    }

    public open func resolve_i1_7(input: Bool): UInt64 {
        __trace.append("[O1.resolve_i1_7]")
        1u64
    }

    public open func fetch_i1_8(input: Int64, data: Bool): Bool {
        __trace.append("[O1.fetch_i1_8]")
        true
    }

    public open func serialize_i1_9(input: Array<Int64>): UInt64 {
        __trace.append("[O1.serialize_i1_9]")
        1u64
    }

    public open func calculate_i1_10(input: Float64): Rune {
        __trace.append("[O1.calculate_i1_10]")
        r'a'
    }

    public init() {
    }
}

open class O2 <: I3<Int32, String> & I14<Rune, UInt64> {
    var f_O2_62393_405834: String = "hello"

    var f_O2_62394_299587: Float32 = 114.514000f32

    public open func checkState_i3_1(): UInt8 {
        __trace.append("[O2.checkState_i3_1]")
        1u8
    }

    public open func process_i3_3(): Int32 {
        __trace.append("[O2.process_i3_3]")
        1i32
    }

    public open override func filter_i3_4(input: Int32, data: Int32): Bool {
        __trace.append("[O2.filter_i3_4]")
        true
    }

    public open func finalize_i3_5(input: String): Int16 {
        __trace.append("[O2.finalize_i3_5]")
        1i16
    }

    public open func buildResult_i3_6(input: Bool, data: UInt64): UInt8 {
        __trace.append("[O2.buildResult_i3_6]")
        1u8
    }

    public open func handleEvent_i3_7(input: Float32, data: String, value: Array<Int64>): Bool {
        __trace.append("[O2.handleEvent_i3_7]")
        true
    }

    public open operator func ==(right: Int64): Bool {
        __trace.append("[O2.==]")
        true
    }

    public open func process_i14_0(): Int64 {
        __trace.append("[O2.process_i14_0]")
        1i64
    }

    public open func synthesize_i14_1(input: Rune): Unit {
        __trace.append("[O2.synthesize_i14_1]")
        return
    }

    public open func convert_i14_2(): Int16 {
        __trace.append("[O2.convert_i14_2]")
        1i16
    }

    public open func query_i14_3(): Bool {
        __trace.append("[O2.query_i14_3]")
        true
    }

    public open func query_i14_4(input: Int8): Rune {
        __trace.append("[O2.query_i14_4]")
        r'a'
    }

    public static func create_O2(): O2 {
        __trace.append("[O2.create_O2]")
        O2()
    }

    static var COUNT_O2: Int64 = 0i64

    public init() {
    }
}

open class O3<T0> <: O0<T0> {
    var f_O3_62395_110757: Float64 = 114.514000f64

    let f_O3_62396_806965: UInt16 = 1u16

    var f_O3_62397_247453: Int32 = 1i32

    public open override func validate_i9_0(): Array<Int64> {
        __trace.append("[O3.validate_i9_0]")
        Array<Int64>()
    }

    public open override func query_i9_2(input: Int32, data: Array<Int64>, value: Array<Int64>): Int16 {
        __trace.append("[O3.query_i9_2]")
        1i16
    }

    public open override func analyze_i9_3(input: Int8, data: Array<Int64>, value: Rune): UInt16 {
        __trace.append("[O3.analyze_i9_3]")
        1u16
    }

    public open override func compare_i9_5(input: String): Int64 {
        __trace.append("[O3.compare_i9_5]")
        1i64
    }

    public open override func calculate_i9_7(input: Array<Int64>, data: Int8, value: Int16): Array<Int64> {
        __trace.append("[O3.calculate_i9_7]")
        Array<Int64>()
    }

    public open override func calculate_i1_1(input: Rune, data: Unit): UInt16 {
        __trace.append("[O3.calculate_i1_1]")
        1u16
    }

    public open override func calculate_i1_3(input: UInt64, data: UInt64, value: UInt64): UInt64 {
        __trace.append("[O3.calculate_i1_3]")
        return super.calculate_i1_3(1u64, 1u64, 1u64)
    }

    public open override func resolve_i1_7(input: Bool): UInt64 {
        __trace.append("[O3.resolve_i1_7]")
        return super.resolve_i1_7(true)
    }

    public open override func serialize_i1_9(input: Array<Int64>): UInt64 {
        __trace.append("[O3.serialize_i1_9]")
        1u64
    }

    public open override func transform_i8_0(input: Rune, data: UInt16): UInt32 {
        __trace.append("[O3.transform_i8_0]")
        1u32
    }

    public open override func update_i8_2(input: Bool, data: UInt32, value: UInt32): Unit {
        __trace.append("[O3.update_i8_2]")
        super.update_i8_2(true, 1u32, 1u32)
    }

    public open override func synthesize_i8_4(input: Int64): Int32 {
        __trace.append("[O3.synthesize_i8_4]")
        return super.synthesize_i8_4(1i64)
    }
}

open class O4 <: O0<Int8> {
    let f_O4_62398_553374: UInt32 = 1u32

    let f_O4_62399_761997: UInt32 = 1u32

    public mut prop p_10001_5949: Float32 {
        get() {
            114.514000f32
        }
        set(v) {
            0
        }
    }

    public open override func validate_i9_0(): Array<Int64> {
        __trace.append("[O4.validate_i9_0]")
        Array<Int64>()
    }

    public open override func analyze_i9_3(input: Int8, data: Array<Int64>, value: Rune): UInt16 {
        __trace.append("[O4.analyze_i9_3]")
        1u16
    }

    public open override func calculate_i9_7(input: Array<Int64>, data: Int8, value: Int16): Array<Int64> {
        __trace.append("[O4.calculate_i9_7]")
        return super.calculate_i9_7(Array<Int64>(), 1i8, 1i16)
    }

    public open override func calculate_i1_3(input: UInt64, data: UInt64, value: UInt64): UInt64 {
        __trace.append("[O4.calculate_i1_3]")
        1u64
    }

    public open override func resolve_i1_7(input: Bool): UInt64 {
        __trace.append("[O4.resolve_i1_7]")
        1u64
    }

    public open override func serialize_i1_9(input: Array<Int64>): UInt64 {
        __trace.append("[O4.serialize_i1_9]")
        1u64
    }

    public open override func calculate_i1_10(input: Float64): Rune {
        __trace.append("[O4.calculate_i1_10]")
        return super.calculate_i1_10(114.514000f64)
    }

    public open override func query_i8_3(input: UInt32, data: UInt16): UInt32 {
        __trace.append("[O4.query_i8_3]")
        1u32
    }

    public static func create_O4(): O4 {
        __trace.append("[O4.create_O4]")
        O4()
    }

    static var COUNT_O4: Int64 = 0i64
}

open class O5 <: I14<Rune, UInt64> & I10<Bool, UInt32> & I12<UInt8> & I4<Int16> {
    public prop p_10002_3874: Int8 {
        get() {
            1i8
        }
    }

    public open func process_i14_0(): Int64 {
        __trace.append("[O5.process_i14_0]")
        1i64
    }

    public open func synthesize_i14_1(input: Rune): Unit {
        __trace.append("[O5.synthesize_i14_1]")
        return
    }

    public open func convert_i14_2(): Int16 {
        __trace.append("[O5.convert_i14_2]")
        1i16
    }

    public open func query_i14_3(): Bool {
        __trace.append("[O5.query_i14_3]")
        true
    }

    public open func query_i14_4(input: Int8): Rune {
        __trace.append("[O5.query_i14_4]")
        r'a'
    }

    public open func getValue_i10_0(): Bool {
        __trace.append("[O5.getValue_i10_0]")
        true
    }

    public open func merge_i10_1(input: Bool, data: Rune): UInt32 {
        __trace.append("[O5.merge_i10_1]")
        1u32
    }

    public open func filter_i10_2(input: Bool, data: UInt32, value: UInt32): UInt32 {
        __trace.append("[O5.filter_i10_2]")
        1u32
    }

    public open func evaluate_i10_3(input: Float32, data: UInt32, value: Int16): UInt32 {
        __trace.append("[O5.evaluate_i10_3]")
        1u32
    }

    public open func execute_i10_4(input: Float32): UInt32 {
        __trace.append("[O5.execute_i10_4]")
        1u32
    }

    public open func initialize_i10_5(): Bool {
        __trace.append("[O5.initialize_i10_5]")
        true
    }

    public open func compute_i10_6(): Bool {
        __trace.append("[O5.compute_i10_6]")
        true
    }

    public open func filter_i10_8(input: Float32, data: Int32): Bool {
        __trace.append("[O5.filter_i10_8]")
        true
    }

    public open func analyze_i10_9(): UInt32 {
        __trace.append("[O5.analyze_i10_9]")
        1u32
    }

    public open func execute_i12_0(): String {
        __trace.append("[O5.execute_i12_0]")
        "hello"
    }

    public open func serialize_i12_1(input: Array<Int64>, data: Array<Int64>): UInt8 {
        __trace.append("[O5.serialize_i12_1]")
        1u8
    }

    public open override func transform_i12_3(): Float32 {
        __trace.append("[O5.transform_i12_3]")
        114.514000f32
    }

    public open func analyze_i12_4(input: UInt8): Unit {
        __trace.append("[O5.analyze_i12_4]")
        return
    }

    public open override func compare_i4_0(input: Int16, data: UInt64, value: Float64): UInt64 {
        __trace.append("[O5.compare_i4_0]")
        1u64
    }

    public open func evaluate_i4_1(input: Int32, data: Float64): Int16 {
        __trace.append("[O5.evaluate_i4_1]")
        1i16
    }

    public open func checkState_i4_2(input: Float64): Int32 {
        __trace.append("[O5.checkState_i4_2]")
        1i32
    }

    public open func checkState_i5_0(input: UInt16): UInt16 {
        __trace.append("[O5.checkState_i5_0]")
        1u16
    }

    public open func fetch_i5_1(): UInt16 {
        __trace.append("[O5.fetch_i5_1]")
        1u16
    }

    public open func validate_i5_2(input: Rune): String {
        __trace.append("[O5.validate_i5_2]")
        "hello"
    }

    public open func update_i5_3(input: Rune): Int64 {
        __trace.append("[O5.update_i5_3]")
        1i64
    }

    public open func compute_i5_4(input: Rune, data: UInt32, value: UInt16): Int64 {
        __trace.append("[O5.compute_i5_4]")
        1i64
    }

    public open func setValue_i5_5(): UInt64 {
        __trace.append("[O5.setValue_i5_5]")
        1u64
    }

    public open func checkState_i5_6(input: UInt8, data: UInt8): Rune {
        __trace.append("[O5.checkState_i5_6]")
        r'a'
    }
}

open class O6 <: I2<UInt8> {
    var f_O6_62400_84935: Float32 = 114.514000f32

    public open func filter_i2_0(input: Rune, data: Int32, value: UInt64): UInt8 {
        __trace.append("[O6.filter_i2_0]")
        1u8
    }

    public open func analyze_i2_1(input: String): UInt8 {
        __trace.append("[O6.analyze_i2_1]")
        1u8
    }

    public open override func update_i2_2(input: Int64): Int64 {
        __trace.append("[O6.update_i2_2]")
        1i64
    }

    public open func serialize_i2_3(): UInt8 {
        __trace.append("[O6.serialize_i2_3]")
        1u8
    }

    public open func buildResult_i2_4(): UInt8 {
        __trace.append("[O6.buildResult_i2_4]")
        1u8
    }

    public open func calculate_i2_5(input: Array<Int64>, data: Rune, value: UInt8): Rune {
        __trace.append("[O6.calculate_i2_5]")
        r'a'
    }

    public open func update_i2_8(input: String, data: Int64): Bool {
        __trace.append("[O6.update_i2_8]")
        true
    }
}

open class O7<T0, T1> <: I2<UInt8> {
    public open func filter_i2_0(input: Rune, data: Int32, value: UInt64): UInt8 {
        __trace.append("[O7.filter_i2_0]")
        1u8
    }

    public open func analyze_i2_1(input: String): UInt8 {
        __trace.append("[O7.analyze_i2_1]")
        1u8
    }

    public open override func update_i2_2(input: Int64): Int64 {
        __trace.append("[O7.update_i2_2]")
        1i64
    }

    public open func serialize_i2_3(): UInt8 {
        __trace.append("[O7.serialize_i2_3]")
        1u8
    }

    public open func buildResult_i2_4(): UInt8 {
        __trace.append("[O7.buildResult_i2_4]")
        1u8
    }

    public open func calculate_i2_5(input: Array<Int64>, data: Rune, value: UInt8): Rune {
        __trace.append("[O7.calculate_i2_5]")
        r'a'
    }

    public open func update_i2_8(input: String, data: Int64): Bool {
        __trace.append("[O7.update_i2_8]")
        true
    }

    public init() {
    }
}

open class O8 <: I11<Float32> {
    var f_O8_62401_606228: Int32 = 1i32

    let f_O8_62402_402495: Float32 = 114.514000f32

    public open override func checkState_i11_0(input: UInt64): UInt8 {
        __trace.append("[O8.checkState_i11_0]")
        1u8
    }

    public open func setValue_i11_2(): Float32 {
        __trace.append("[O8.setValue_i11_2]")
        114.514000f32
    }

    public open func validate_i11_3(input: Unit): Float32 {
        __trace.append("[O8.validate_i11_3]")
        114.514000f32
    }

    public open func fetch_i11_4(): Array<Int64> {
        __trace.append("[O8.fetch_i11_4]")
        Array<Int64>()
    }

    public open func calculate_i11_5(input: UInt64, data: Float32): Float32 {
        __trace.append("[O8.calculate_i11_5]")
        114.514000f32
    }

    public open func process_i11_6(): Float32 {
        __trace.append("[O8.process_i11_6]")
        114.514000f32
    }

    public open func calculate_i11_7(): Float32 {
        __trace.append("[O8.calculate_i11_7]")
        114.514000f32
    }

    public open func process_i11_8(input: Float32, data: UInt32): Int32 {
        __trace.append("[O8.process_i11_8]")
        1i32
    }

    public open func handleEvent_i11_9(input: Unit): Rune {
        __trace.append("[O8.handleEvent_i11_9]")
        r'a'
    }

    public open func checkState_i5_0(input: UInt16): UInt16 {
        __trace.append("[O8.checkState_i5_0]")
        1u16
    }

    public open func fetch_i5_1(): UInt16 {
        __trace.append("[O8.fetch_i5_1]")
        1u16
    }

    public open func validate_i5_2(input: Rune): String {
        __trace.append("[O8.validate_i5_2]")
        "hello"
    }

    public open func update_i5_3(input: Rune): Int64 {
        __trace.append("[O8.update_i5_3]")
        1i64
    }

    public open func compute_i5_4(input: Rune, data: UInt32, value: UInt16): Int64 {
        __trace.append("[O8.compute_i5_4]")
        1i64
    }

    public open func setValue_i5_5(): UInt64 {
        __trace.append("[O8.setValue_i5_5]")
        1u64
    }

    public open func checkState_i5_6(input: UInt8, data: UInt8): Rune {
        __trace.append("[O8.checkState_i5_6]")
        r'a'
    }

    public init() {
    }
}

open class O9<T0, T1> <: O0<T0> {
    let f_O9_62403_50213: UInt16 = 1u16

    var f_O9_62404_186896: Int16 = 1i16

    let f_O9_62405_694072: Float32 = 114.514000f32

    public open override func query_i9_2(input: Int32, data: Array<Int64>, value: Array<Int64>): Int16 {
        __trace.append("[O9.query_i9_2]")
        return super.query_i9_2(1i32, Array<Int64>(), Array<Int64>())
    }

    public open override func fetch_i9_4(): Array<Int64> {
        __trace.append("[O9.fetch_i9_4]")
        Array<Int64>()
    }

    public open override func checkState_i9_6(input: Array<Int64>, data: String, value: Int64): Array<Int64> {
        __trace.append("[O9.checkState_i9_6]")
        Array<Int64>()
    }

    public open override func calculate_i9_7(input: Array<Int64>, data: Int8, value: Int16): Array<Int64> {
        __trace.append("[O9.calculate_i9_7]")
        Array<Int64>()
    }

    public open override func calculate_i1_1(input: Rune, data: Unit): UInt16 {
        __trace.append("[O9.calculate_i1_1]")
        1u16
    }

    public open override func validate_i1_5(): Bool {
        __trace.append("[O9.validate_i1_5]")
        true
    }

    public open override func resolve_i1_7(input: Bool): UInt64 {
        __trace.append("[O9.resolve_i1_7]")
        1u64
    }

    public open override func fetch_i1_8(input: Int64, data: Bool): Bool {
        __trace.append("[O9.fetch_i1_8]")
        true
    }

    public open override func update_i8_2(input: Bool, data: UInt32, value: UInt32): Unit {
        __trace.append("[O9.update_i8_2]")
        super.update_i8_2(true, 1u32, 1u32)
    }

    public open override func query_i8_3(input: UInt32, data: UInt16): UInt32 {
        __trace.append("[O9.query_i8_3]")
        1u32
    }

    public open override func synthesize_i8_4(input: Int64): Int32 {
        __trace.append("[O9.synthesize_i8_4]")
        1i32
    }

    public init() {
    }
}

class C0 <: O2 {
    var f_C0_62406_610628: Int32 = 1i32

    let f_C0_62407_20836: Rune = r'a'

    let f_C0_62408_565751: UInt8 = 1u8

    public override func checkState_i3_1(): UInt8 {
        __trace.append("[C0.checkState_i3_1]")
        1u8
    }

    public override func filter_i3_4(input: Int32, data: Int32): Bool {
        __trace.append("[C0.filter_i3_4]")
        true
    }

    public override func buildResult_i3_6(input: Bool, data: UInt64): UInt8 {
        __trace.append("[C0.buildResult_i3_6]")
        return super.buildResult_i3_6(true, 1u64)
    }

    public override func handleEvent_i3_7(input: Float32, data: String, value: Array<Int64>): Bool {
        __trace.append("[C0.handleEvent_i3_7]")
        return super.handleEvent_i3_7(114.514000f32, "hello", Array<Int64>())
    }

    public override func synthesize_i14_1(input: Rune): Unit {
        __trace.append("[C0.synthesize_i14_1]")
        super.synthesize_i14_1(r'a')
    }

    public override func convert_i14_2(): Int16 {
        __trace.append("[C0.convert_i14_2]")
        1i16
    }

    public override func query_i14_3(): Bool {
        __trace.append("[C0.query_i14_3]")
        true
    }

    public override func query_i14_4(input: Int8): Rune {
        __trace.append("[C0.query_i14_4]")
        r'a'
    }

    public static func create_C0(): C0 {
        __trace.append("[C0.create_C0]")
        C0()
    }

    public init() {
    }
}

class C1<T0, T1> <: O0<T0> {
    var f_C1_62409_587773: Int16 = 1i16

    public prop p_10003_9265: String {
        get() {
            "hello"
        }
    }

    public override func query_i9_2(input: Int32, data: Array<Int64>, value: Array<Int64>): Int16 {
        __trace.append("[C1.query_i9_2]")
        1i16
    }

    public override func fetch_i9_4(): Array<Int64> {
        __trace.append("[C1.fetch_i9_4]")
        Array<Int64>()
    }

    public override func compare_i9_5(input: String): Int64 {
        __trace.append("[C1.compare_i9_5]")
        1i64
    }

    public override func calculate_i1_1(input: Rune, data: Unit): UInt16 {
        __trace.append("[C1.calculate_i1_1]")
        return super.calculate_i1_1(r'a', ())
    }

    public override func calculate_i1_3(input: UInt64, data: UInt64, value: UInt64): UInt64 {
        __trace.append("[C1.calculate_i1_3]")
        return super.calculate_i1_3(1u64, 1u64, 1u64)
    }

    public override func resolve_i1_7(input: Bool): UInt64 {
        __trace.append("[C1.resolve_i1_7]")
        1u64
    }

    public override func fetch_i1_8(input: Int64, data: Bool): Bool {
        __trace.append("[C1.fetch_i1_8]")
        true
    }

    public override func calculate_i1_10(input: Float64): Rune {
        __trace.append("[C1.calculate_i1_10]")
        r'a'
    }

    public override func transform_i8_0(input: Rune, data: UInt16): UInt32 {
        __trace.append("[C1.transform_i8_0]")
        return super.transform_i8_0(r'a', 1u16)
    }

    public override func update_i8_2(input: Bool, data: UInt32, value: UInt32): Unit {
        __trace.append("[C1.update_i8_2]")
        return
    }

    public override func query_i8_3(input: UInt32, data: UInt16): UInt32 {
        __trace.append("[C1.query_i8_3]")
        1u32
    }

    public init() {
    }
}

class C2<T0> <: O5 {
    public override func process_i14_0(): Int64 {
        __trace.append("[C2.process_i14_0]")
        1i64
    }

    public override func synthesize_i14_1(input: Rune): Unit {
        __trace.append("[C2.synthesize_i14_1]")
        return
    }

    public override func convert_i14_2(): Int16 {
        __trace.append("[C2.convert_i14_2]")
        1i16
    }

    public override func query_i14_3(): Bool {
        __trace.append("[C2.query_i14_3]")
        true
    }

    public override func getValue_i10_0(): Bool {
        __trace.append("[C2.getValue_i10_0]")
        true
    }

    public override func merge_i10_1(input: Bool, data: Rune): UInt32 {
        __trace.append("[C2.merge_i10_1]")
        1u32
    }

    public override func execute_i10_4(input: Float32): UInt32 {
        __trace.append("[C2.execute_i10_4]")
        return super.execute_i10_4(114.514000f32)
    }

    public override func initialize_i10_5(): Bool {
        __trace.append("[C2.initialize_i10_5]")
        return super.initialize_i10_5()
    }

    public override func compute_i10_6(): Bool {
        __trace.append("[C2.compute_i10_6]")
        return super.compute_i10_6()
    }

    public override func filter_i10_8(input: Float32, data: Int32): Bool {
        __trace.append("[C2.filter_i10_8]")
        true
    }

    public override func execute_i12_0(): String {
        __trace.append("[C2.execute_i12_0]")
        return super.execute_i12_0()
    }

    public override func transform_i12_3(): Float32 {
        __trace.append("[C2.transform_i12_3]")
        114.514000f32
    }

    public override func analyze_i12_4(input: UInt8): Unit {
        __trace.append("[C2.analyze_i12_4]")
        return
    }

    public override func evaluate_i4_1(input: Int32, data: Float64): Int16 {
        __trace.append("[C2.evaluate_i4_1]")
        1i16
    }

    public override func fetch_i5_1(): UInt16 {
        __trace.append("[C2.fetch_i5_1]")
        1u16
    }

    public override func update_i5_3(input: Rune): Int64 {
        __trace.append("[C2.update_i5_3]")
        1i64
    }

    public override func setValue_i5_5(): UInt64 {
        __trace.append("[C2.setValue_i5_5]")
        1u64
    }
}

class C3 <: A0 {
    var f_C3_62410_466870: Bool = true

    let f_C3_62411_286350: Float32 = 114.514000f32

    var f_C3_62412_105038: Int64 = 1i64
}

class C4<T0, T1> <: A2<T0, T1> {
    public func checkState_i5_0(input: UInt16): UInt16 {
        __trace.append("[C4.checkState_i5_0]")
        1u16
    }

    public func fetch_i5_1(): UInt16 {
        __trace.append("[C4.fetch_i5_1]")
        1u16
    }

    public func validate_i5_2(input: Rune): String {
        __trace.append("[C4.validate_i5_2]")
        "hello"
    }

    public func update_i5_3(input: Rune): Int64 {
        __trace.append("[C4.update_i5_3]")
        1i64
    }

    public func compute_i5_4(input: Rune, data: UInt32, value: UInt16): Int64 {
        __trace.append("[C4.compute_i5_4]")
        1i64
    }

    public func setValue_i5_5(): UInt64 {
        __trace.append("[C4.setValue_i5_5]")
        1u64
    }

    public func checkState_i5_6(input: UInt8, data: UInt8): Rune {
        __trace.append("[C4.checkState_i5_6]")
        r'a'
    }

    public func process_i14_0(): Int64 {
        __trace.append("[C4.process_i14_0]")
        1i64
    }

    public func synthesize_i14_1(input: Rune): Unit {
        __trace.append("[C4.synthesize_i14_1]")
        return
    }

    public func convert_i14_2(): Int16 {
        __trace.append("[C4.convert_i14_2]")
        1i16
    }

    public func query_i14_3(): Bool {
        __trace.append("[C4.query_i14_3]")
        true
    }

    public func query_i14_4(input: Int8): Rune {
        __trace.append("[C4.query_i14_4]")
        r'a'
    }

    public init() {
    }
}

class C5 <: O7<Rune, Int16> {
    let f_C5_62413_522646: Int32 = 1i32

    var f_C5_62414_407393: Int16 = 1i16

    var f_C5_62415_7825: UInt32 = 1u32

    public prop p_10004_8307: String {
        get() {
            "hello"
        }
    }

    public override func analyze_i2_1(input: String): UInt8 {
        __trace.append("[C5.analyze_i2_1]")
        1u8
    }

    public override func update_i2_2(input: Int64): Int64 {
        __trace.append("[C5.update_i2_2]")
        return super.update_i2_2(1i64)
    }

    public override func buildResult_i2_4(): UInt8 {
        __trace.append("[C5.buildResult_i2_4]")
        1u8
    }

    public override func calculate_i2_5(input: Array<Int64>, data: Rune, value: UInt8): Rune {
        __trace.append("[C5.calculate_i2_5]")
        r'a'
    }

    public override func update_i2_8(input: String, data: Int64): Bool {
        __trace.append("[C5.update_i2_8]")
        return super.update_i2_8("hello", 1i64)
    }

    public static func create_C5(): C5 {
        __trace.append("[C5.create_C5]")
        C5()
    }

    public init() {
    }
}

class C6<T0> <: O8 {
    var f_C6_62416_263700: Int8 = 1i8

    let f_C6_62417_669346: Bool = true

    var f_C6_62418_803166: String = "hello"

    public prop p_10005_9892: Float32 {
        get() {
            114.514000f32
        }
    }

    public override func checkState_i11_0(input: UInt64): UInt8 {
        __trace.append("[C6.checkState_i11_0]")
        return super.checkState_i11_0(1u64)
    }

    public override func validate_i11_3(input: Unit): Float32 {
        __trace.append("[C6.validate_i11_3]")
        return super.validate_i11_3(())
    }

    public override func calculate_i11_5(input: UInt64, data: Float32): Float32 {
        __trace.append("[C6.calculate_i11_5]")
        return super.calculate_i11_5(1u64, 114.514000f32)
    }

    public override func process_i11_6(): Float32 {
        __trace.append("[C6.process_i11_6]")
        return super.process_i11_6()
    }

    public override func handleEvent_i11_9(input: Unit): Rune {
        __trace.append("[C6.handleEvent_i11_9]")
        r'a'
    }

    public override func checkState_i5_0(input: UInt16): UInt16 {
        __trace.append("[C6.checkState_i5_0]")
        return super.checkState_i5_0(1u16)
    }

    public override func fetch_i5_1(): UInt16 {
        __trace.append("[C6.fetch_i5_1]")
        1u16
    }

    public override func validate_i5_2(input: Rune): String {
        __trace.append("[C6.validate_i5_2]")
        return super.validate_i5_2(r'a')
    }

    public override func update_i5_3(input: Rune): Int64 {
        __trace.append("[C6.update_i5_3]")
        return super.update_i5_3(r'a')
    }
}

class C7 <: O8 {
    let f_C7_62419_586146: UInt64 = 1u64

    var f_C7_62420_423284: Float32 = 114.514000f32

    public override func validate_i11_3(input: Unit): Float32 {
        __trace.append("[C7.validate_i11_3]")
        114.514000f32
    }

    public override func calculate_i11_5(input: UInt64, data: Float32): Float32 {
        __trace.append("[C7.calculate_i11_5]")
        return super.calculate_i11_5(1u64, 114.514000f32)
    }

    public override func process_i11_6(): Float32 {
        __trace.append("[C7.process_i11_6]")
        114.514000f32
    }

    public override func calculate_i11_7(): Float32 {
        __trace.append("[C7.calculate_i11_7]")
        114.514000f32
    }

    public override func process_i11_8(input: Float32, data: UInt32): Int32 {
        __trace.append("[C7.process_i11_8]")
        1i32
    }

    public override func handleEvent_i11_9(input: Unit): Rune {
        __trace.append("[C7.handleEvent_i11_9]")
        r'a'
    }

    public override func fetch_i5_1(): UInt16 {
        __trace.append("[C7.fetch_i5_1]")
        return super.fetch_i5_1()
    }

    public override func validate_i5_2(input: Rune): String {
        __trace.append("[C7.validate_i5_2]")
        "hello"
    }

    public override func update_i5_3(input: Rune): Int64 {
        __trace.append("[C7.update_i5_3]")
        1i64
    }

    public override func compute_i5_4(input: Rune, data: UInt32, value: UInt16): Int64 {
        __trace.append("[C7.compute_i5_4]")
        return super.compute_i5_4(r'a', 1u32, 1u16)
    }

    public override func setValue_i5_5(): UInt64 {
        __trace.append("[C7.setValue_i5_5]")
        1u64
    }

    public override func checkState_i5_6(input: UInt8, data: UInt8): Rune {
        __trace.append("[C7.checkState_i5_6]")
        r'a'
    }

    public init() {
    }
}

class C8 <: I6<Rune, Int8> & I8<UInt32, Int32> {
    let f_C8_62421_971047: UInt8 = 1u8

    var f_C8_62422_243379: Int64 = 1i64

    public func evaluate_i6_1(input: Rune, data: Int32): Int8 {
        __trace.append("[C8.evaluate_i6_1]")
        1i8
    }

    public func execute_i6_2(input: Int8, data: Rune): Int32 {
        __trace.append("[C8.execute_i6_2]")
        1i32
    }

    public func analyze_i6_3(input: UInt16, data: Rune): Rune {
        __trace.append("[C8.analyze_i6_3]")
        r'a'
    }

    public func update_i6_5(input: Int8, data: UInt8, value: Int8): Int8 {
        __trace.append("[C8.update_i6_5]")
        1i8
    }

    public func initialize_i6_6(): Rune {
        __trace.append("[C8.initialize_i6_6]")
        r'a'
    }

    public func resolve_i6_7(input: Float32): Rune {
        __trace.append("[C8.resolve_i6_7]")
        r'a'
    }

    public func fetch_i6_8(): Rune {
        __trace.append("[C8.fetch_i6_8]")
        r'a'
    }

    public func transform_i8_0(input: Rune, data: UInt16): UInt32 {
        __trace.append("[C8.transform_i8_0]")
        1u32
    }

    public override func update_i8_2(input: Bool, data: UInt32, value: UInt32): Unit {
        __trace.append("[C8.update_i8_2]")
        return
    }

    public func query_i8_3(input: UInt32, data: UInt16): UInt32 {
        __trace.append("[C8.query_i8_3]")
        1u32
    }

    public func synthesize_i8_4(input: Int64): Int32 {
        __trace.append("[C8.synthesize_i8_4]")
        1i32
    }

    public init() {
    }
}

class C9<T0, T1> <: O7<T0, T1> {
    public prop p_10006_3744: UInt64 {
        get() {
            1u64
        }
    }

    public override func analyze_i2_1(input: String): UInt8 {
        __trace.append("[C9.analyze_i2_1]")
        1u8
    }

    public override func update_i2_2(input: Int64): Int64 {
        __trace.append("[C9.update_i2_2]")
        1i64
    }

    public override func serialize_i2_3(): UInt8 {
        __trace.append("[C9.serialize_i2_3]")
        1u8
    }

    public override func buildResult_i2_4(): UInt8 {
        __trace.append("[C9.buildResult_i2_4]")
        1u8
    }

    public override func calculate_i2_5(input: Array<Int64>, data: Rune, value: UInt8): Rune {
        __trace.append("[C9.calculate_i2_5]")
        return super.calculate_i2_5(Array<Int64>(), r'a', 1u8)
    }

    public override func update_i2_8(input: String, data: Int64): Bool {
        __trace.append("[C9.update_i2_8]")
        return super.update_i2_8("hello", 1i64)
    }

    public init() {
    }
}

class C10<T0> <: A1 {
    var f_C10_62423_463995: UInt16 = 1u16

    var f_C10_62424_6677: UInt64 = 1u64
}

class C11 <: O2 {
    var f_C11_62425_238865: UInt16 = 1u16

    var f_C11_62426_167688: UInt64 = 1u64

    var f_C11_62427_798711: UInt16 = 1u16

    public prop p_10007_647: Bool {
        get() {
            true
        }
    }

    public override func checkState_i3_1(): UInt8 {
        __trace.append("[C11.checkState_i3_1]")
        1u8
    }

    public override func process_i3_3(): Int32 {
        __trace.append("[C11.process_i3_3]")
        1i32
    }

    public override func buildResult_i3_6(input: Bool, data: UInt64): UInt8 {
        __trace.append("[C11.buildResult_i3_6]")
        1u8
    }

    public override func handleEvent_i3_7(input: Float32, data: String, value: Array<Int64>): Bool {
        __trace.append("[C11.handleEvent_i3_7]")
        return super.handleEvent_i3_7(114.514000f32, "hello", Array<Int64>())
    }

    public override operator func ==(right: Int64): Bool {
        __trace.append("[C11.==]")
        true
    }

    public override func synthesize_i14_1(input: Rune): Unit {
        __trace.append("[C11.synthesize_i14_1]")
        return
    }

    public override func query_i14_3(): Bool {
        __trace.append("[C11.query_i14_3]")
        true
    }

    public override func query_i14_4(input: Int8): Rune {
        __trace.append("[C11.query_i14_4]")
        r'a'
    }

    public init() {
    }
}

class C12 <: A1 {
    let f_C12_62428_161384: UInt32 = 1u32

    var f_C12_62429_509131: Float32 = 114.514000f32

    public prop p_10008_2792: Float32 {
        get() {
            114.514000f32
        }
    }

    public static func create_C12(): C12 {
        __trace.append("[C12.create_C12]")
        C12()
    }
}

class C13<T0> <: I4<Int16> & I0<Int32, Int64> & I7<Bool, UInt32> {
    var f_C13_62430_197271: Int8 = 1i8

    var f_C13_62431_941919: Int16 = 1i16

    public prop p_10009_9028: Int8 {
        get() {
            1i8
        }
    }

    public override func compare_i4_0(input: Int16, data: UInt64, value: Float64): UInt64 {
        __trace.append("[C13.compare_i4_0]")
        1u64
    }

    public func evaluate_i4_1(input: Int32, data: Float64): Int16 {
        __trace.append("[C13.evaluate_i4_1]")
        1i16
    }

    public func checkState_i4_2(input: Float64): Int32 {
        __trace.append("[C13.checkState_i4_2]")
        1i32
    }

    public func checkState_i5_0(input: UInt16): UInt16 {
        __trace.append("[C13.checkState_i5_0]")
        1u16
    }

    public func fetch_i5_1(): UInt16 {
        __trace.append("[C13.fetch_i5_1]")
        1u16
    }

    public func validate_i5_2(input: Rune): String {
        __trace.append("[C13.validate_i5_2]")
        "hello"
    }

    public func update_i5_3(input: Rune): Int64 {
        __trace.append("[C13.update_i5_3]")
        1i64
    }

    public func compute_i5_4(input: Rune, data: UInt32, value: UInt16): Int64 {
        __trace.append("[C13.compute_i5_4]")
        1i64
    }

    public func setValue_i5_5(): UInt64 {
        __trace.append("[C13.setValue_i5_5]")
        1u64
    }

    public func checkState_i5_6(input: UInt8, data: UInt8): Rune {
        __trace.append("[C13.checkState_i5_6]")
        r'a'
    }

    public func update_i0_0(input: Int32, data: Int64, value: Int32): Float32 {
        __trace.append("[C13.update_i0_0]")
        114.514000f32
    }

    public func compute_i0_1(): Int64 {
        __trace.append("[C13.compute_i0_1]")
        1i64
    }

    public operator func *(right: Int64): Int64 {
        __trace.append("[C13.*]")
        1i64
    }

    public func convert_i7_0(): Float32 {
        __trace.append("[C13.convert_i7_0]")
        114.514000f32
    }

    public func validate_i7_1(input: UInt32, data: UInt32, value: Unit): Float32 {
        __trace.append("[C13.validate_i7_1]")
        114.514000f32
    }

    public func compare_i7_2(input: Int16, data: Unit, value: UInt32): Bool {
        __trace.append("[C13.compare_i7_2]")
        true
    }

    public func fetch_i7_3(input: Float64, data: UInt8): UInt16 {
        __trace.append("[C13.fetch_i7_3]")
        1u16
    }

    public func handleEvent_i7_4(input: Bool): Unit {
        __trace.append("[C13.handleEvent_i7_4]")
        return
    }

    public func serialize_i7_5(input: UInt32, data: Array<Int64>, value: Bool): UInt64 {
        __trace.append("[C13.serialize_i7_5]")
        1u64
    }

    public func evaluate_i7_6(input: Bool, data: Bool): Bool {
        __trace.append("[C13.evaluate_i7_6]")
        true
    }

    public init() {
    }
}

class C14 <: I0<Int32, Int64> {
    var f_C14_62432_68149: UInt64 = 1u64

    var f_C14_62433_829941: UInt32 = 1u32

    let f_C14_62434_872065: Int8 = 1i8

    public func update_i0_0(input: Int32, data: Int64, value: Int32): Float32 {
        __trace.append("[C14.update_i0_0]")
        114.514000f32
    }

    public func compute_i0_1(): Int64 {
        __trace.append("[C14.compute_i0_1]")
        1i64
    }

    public operator func *(right: Int64): Int64 {
        __trace.append("[C14.*]")
        1i64
    }

    public static func create_C14(): C14 {
        __trace.append("[C14.create_C14]")
        C14()
    }

    public init() {
    }
}

class C15<T0> <: I8<UInt32, Int32> & I2<UInt8> & I12<UInt8> {
    public func transform_i8_0(input: Rune, data: UInt16): UInt32 {
        __trace.append("[C15.transform_i8_0]")
        1u32
    }

    public override func update_i8_2(input: Bool, data: UInt32, value: UInt32): Unit {
        __trace.append("[C15.update_i8_2]")
        return
    }

    public func query_i8_3(input: UInt32, data: UInt16): UInt32 {
        __trace.append("[C15.query_i8_3]")
        1u32
    }

    public func synthesize_i8_4(input: Int64): Int32 {
        __trace.append("[C15.synthesize_i8_4]")
        1i32
    }

    public func filter_i2_0(input: Rune, data: Int32, value: UInt64): UInt8 {
        __trace.append("[C15.filter_i2_0]")
        1u8
    }

    public func analyze_i2_1(input: String): UInt8 {
        __trace.append("[C15.analyze_i2_1]")
        1u8
    }

    public override func update_i2_2(input: Int64): Int64 {
        __trace.append("[C15.update_i2_2]")
        1i64
    }

    public func serialize_i2_3(): UInt8 {
        __trace.append("[C15.serialize_i2_3]")
        1u8
    }

    public func buildResult_i2_4(): UInt8 {
        __trace.append("[C15.buildResult_i2_4]")
        1u8
    }

    public func calculate_i2_5(input: Array<Int64>, data: Rune, value: UInt8): Rune {
        __trace.append("[C15.calculate_i2_5]")
        r'a'
    }

    public func update_i2_8(input: String, data: Int64): Bool {
        __trace.append("[C15.update_i2_8]")
        true
    }

    public func execute_i12_0(): String {
        __trace.append("[C15.execute_i12_0]")
        "hello"
    }

    public func serialize_i12_1(input: Array<Int64>, data: Array<Int64>): UInt8 {
        __trace.append("[C15.serialize_i12_1]")
        1u8
    }

    public override func transform_i12_3(): Float32 {
        __trace.append("[C15.transform_i12_3]")
        114.514000f32
    }

    public func analyze_i12_4(input: UInt8): Unit {
        __trace.append("[C15.analyze_i12_4]")
        return
    }

    public init() {
    }
}

class C16 <: A0 {
    var f_C16_62435_326312: Float64 = 114.514000f64

    public prop p_10010_5458: UInt64 {
        get() {
            1u64
        }
    }
}

class C17 <: O9<Int8, Array<Int64>> {
    public override func fetch_i9_4(): Array<Int64> {
        __trace.append("[C17.fetch_i9_4]")
        Array<Int64>()
    }

    public override func checkState_i9_6(input: Array<Int64>, data: String, value: Int64): Array<Int64> {
        __trace.append("[C17.checkState_i9_6]")
        return super.checkState_i9_6(Array<Int64>(), "hello", 1i64)
    }

    public override func calculate_i9_7(input: Array<Int64>, data: Int8, value: Int16): Array<Int64> {
        __trace.append("[C17.calculate_i9_7]")
        Array<Int64>()
    }

    public override func resolve_i1_7(input: Bool): UInt64 {
        __trace.append("[C17.resolve_i1_7]")
        1u64
    }

    public override func fetch_i1_8(input: Int64, data: Bool): Bool {
        __trace.append("[C17.fetch_i1_8]")
        true
    }

    public override func query_i8_3(input: UInt32, data: UInt16): UInt32 {
        __trace.append("[C17.query_i8_3]")
        1u32
    }

    public override func synthesize_i8_4(input: Int64): Int32 {
        __trace.append("[C17.synthesize_i8_4]")
        1i32
    }

    public static func create_C17(): C17 {
        __trace.append("[C17.create_C17]")
        C17()
    }

    public init() {
    }
}

class C18 <: I2<UInt8> & I5<UInt16, Rune> & I1<UInt64> {
    public func filter_i2_0(input: Rune, data: Int32, value: UInt64): UInt8 {
        __trace.append("[C18.filter_i2_0]")
        1u8
    }

    public func analyze_i2_1(input: String): UInt8 {
        __trace.append("[C18.analyze_i2_1]")
        1u8
    }

    public override func update_i2_2(input: Int64): Int64 {
        __trace.append("[C18.update_i2_2]")
        1i64
    }

    public func serialize_i2_3(): UInt8 {
        __trace.append("[C18.serialize_i2_3]")
        1u8
    }

    public func buildResult_i2_4(): UInt8 {
        __trace.append("[C18.buildResult_i2_4]")
        1u8
    }

    public func calculate_i2_5(input: Array<Int64>, data: Rune, value: UInt8): Rune {
        __trace.append("[C18.calculate_i2_5]")
        r'a'
    }

    public func update_i2_8(input: String, data: Int64): Bool {
        __trace.append("[C18.update_i2_8]")
        true
    }

    public func checkState_i5_0(input: UInt16): UInt16 {
        __trace.append("[C18.checkState_i5_0]")
        1u16
    }

    public func fetch_i5_1(): UInt16 {
        __trace.append("[C18.fetch_i5_1]")
        1u16
    }

    public func validate_i5_2(input: Rune): String {
        __trace.append("[C18.validate_i5_2]")
        "hello"
    }

    public func update_i5_3(input: Rune): Int64 {
        __trace.append("[C18.update_i5_3]")
        1i64
    }

    public func compute_i5_4(input: Rune, data: UInt32, value: UInt16): Int64 {
        __trace.append("[C18.compute_i5_4]")
        1i64
    }

    public func setValue_i5_5(): UInt64 {
        __trace.append("[C18.setValue_i5_5]")
        1u64
    }

    public func checkState_i5_6(input: UInt8, data: UInt8): Rune {
        __trace.append("[C18.checkState_i5_6]")
        r'a'
    }

    public func calculate_i1_1(input: Rune, data: Unit): UInt16 {
        __trace.append("[C18.calculate_i1_1]")
        1u16
    }

    public func calculate_i1_3(input: UInt64, data: UInt64, value: UInt64): UInt64 {
        __trace.append("[C18.calculate_i1_3]")
        1u64
    }

    public func handleEvent_i1_4(input: UInt32): UInt64 {
        __trace.append("[C18.handleEvent_i1_4]")
        1u64
    }

    public func validate_i1_5(): Bool {
        __trace.append("[C18.validate_i1_5]")
        true
    }

    public func resolve_i1_7(input: Bool): UInt64 {
        __trace.append("[C18.resolve_i1_7]")
        1u64
    }

    public func fetch_i1_8(input: Int64, data: Bool): Bool {
        __trace.append("[C18.fetch_i1_8]")
        true
    }

    public func serialize_i1_9(input: Array<Int64>): UInt64 {
        __trace.append("[C18.serialize_i1_9]")
        1u64
    }

    public func calculate_i1_10(input: Float64): Rune {
        __trace.append("[C18.calculate_i1_10]")
        r'a'
    }

    public init() {
    }
}

class C19<T0, T1> <: O7<T0, T1> {
    var f_C19_62436_321205: Int8 = 1i8

    let f_C19_62437_726757: UInt16 = 1u16

    let f_C19_62438_208794: UInt8 = 1u8

    public override func filter_i2_0(input: Rune, data: Int32, value: UInt64): UInt8 {
        __trace.append("[C19.filter_i2_0]")
        return super.filter_i2_0(r'a', 1i32, 1u64)
    }

    public override func analyze_i2_1(input: String): UInt8 {
        __trace.append("[C19.analyze_i2_1]")
        1u8
    }

    public override func serialize_i2_3(): UInt8 {
        __trace.append("[C19.serialize_i2_3]")
        1u8
    }

    public override func update_i2_8(input: String, data: Int64): Bool {
        __trace.append("[C19.update_i2_8]")
        true
    }

    public init() {
    }
}

class C20 <: O7<Rune, Int16> {
    public mut prop p_10011_1557: Float64 {
        get() {
            114.514000f64
        }
        set(v) {
            0
        }
    }

    public override func filter_i2_0(input: Rune, data: Int32, value: UInt64): UInt8 {
        __trace.append("[C20.filter_i2_0]")
        return super.filter_i2_0(r'a', 1i32, 1u64)
    }

    public override func update_i2_2(input: Int64): Int64 {
        __trace.append("[C20.update_i2_2]")
        1i64
    }

    public override func serialize_i2_3(): UInt8 {
        __trace.append("[C20.serialize_i2_3]")
        1u8
    }

    public static func create_C20(): C20 {
        __trace.append("[C20.create_C20]")
        C20()
    }
}

class C21 <: O3<Int8> {
    public override func analyze_i9_3(input: Int8, data: Array<Int64>, value: Rune): UInt16 {
        __trace.append("[C21.analyze_i9_3]")
        return super.analyze_i9_3(1i8, Array<Int64>(), r'a')
    }

    public override func compare_i9_5(input: String): Int64 {
        __trace.append("[C21.compare_i9_5]")
        1i64
    }

    public override func calculate_i9_7(input: Array<Int64>, data: Int8, value: Int16): Array<Int64> {
        __trace.append("[C21.calculate_i9_7]")
        Array<Int64>()
    }

    public override func calculate_i1_1(input: Rune, data: Unit): UInt16 {
        __trace.append("[C21.calculate_i1_1]")
        1u16
    }

    public override func calculate_i1_3(input: UInt64, data: UInt64, value: UInt64): UInt64 {
        __trace.append("[C21.calculate_i1_3]")
        return super.calculate_i1_3(1u64, 1u64, 1u64)
    }

    public override func resolve_i1_7(input: Bool): UInt64 {
        __trace.append("[C21.resolve_i1_7]")
        1u64
    }

    public override func update_i8_2(input: Bool, data: UInt32, value: UInt32): Unit {
        __trace.append("[C21.update_i8_2]")
        super.update_i8_2(true, 1u32, 1u32)
    }
}

class C22 <: A1 {
    var f_C22_62439_65429: Float64 = 114.514000f64

    public init() {
    }
}

public enum E0 {
    | A(UInt32)
    | B
    | C(Rune, UInt32)
}

public enum E1 {
    | A(Int8)
    | B(UInt32, Int32)
}

public enum E2 {
    | A(String)
}

public enum E3 {
    | A
    | B(Bool)
    | C(Bool)

    public func describe(self: Float64): Float64 {
        __trace.append("[E3.describe]")
        114.514000f64
    }
}

public enum E4 {
    | A(Bool)
    | B
    | C
}

public enum E5 {
    | A(UInt16, String)
    | B
}

struct S0 {
    var f_62440_406724: Float32 = 114.514000f32

    var f_62441_737995: UInt64 = 1u64
}

struct S1 {
    var f_62442_824714: Rune = r'a'

    var f_62443_734406: UInt32 = 1u32
}

struct S2 {
    var f_62444_837668: Float64 = 114.514000f64

    var f_62445_32254: UInt32 = 1u32
}

struct S3 {
    var f_62446_752719: Float64 = 114.514000f64

    var f_62447_251729: UInt32 = 1u32
}

public class BBB {
    public func goo(): Int64 {
        __trace.append("[BBB.goo]")
        1i64
    }
}

extend C20 <: I10<Bool, UInt32> {
    public func getValue_i10_0(): Bool {
        __trace.append("[extend_C20_I10.getValue_i10_0]")
        true
    }
    public func merge_i10_1(input: Bool, data: Rune): UInt32 {
        __trace.append("[extend_C20_I10.merge_i10_1]")
        1u32
    }
    public func filter_i10_2(input: Bool, data: UInt32, value: UInt32): UInt32 {
        __trace.append("[extend_C20_I10.filter_i10_2]")
        1u32
    }
    public func evaluate_i10_3(input: Float32, data: UInt32, value: Int16): UInt32 {
        __trace.append("[extend_C20_I10.evaluate_i10_3]")
        1u32
    }
    public func execute_i10_4(input: Float32): UInt32 {
        __trace.append("[extend_C20_I10.execute_i10_4]")
        1u32
    }
    public func initialize_i10_5(): Bool {
        __trace.append("[extend_C20_I10.initialize_i10_5]")
        true
    }
    public func compute_i10_6(): Bool {
        __trace.append("[extend_C20_I10.compute_i10_6]")
        true
    }
    public func filter_i10_8(input: Float32, data: Int32): Bool {
        __trace.append("[extend_C20_I10.filter_i10_8]")
        true
    }
    public func analyze_i10_9(): UInt32 {
        __trace.append("[extend_C20_I10.analyze_i10_9]")
        1u32
    }
}

func call_0<T0>(a: T0): Unit where T0 <: I8<UInt32, Int32> {
    a.transform_i8_0(r'a', 1u16)
    a.query_i8_3(1u32, 1u16)
    a.synthesize_i8_4(1i64)
}

func call_1<T0>(a: T0): Unit where T0 <: I1<UInt64> {
    a.calculate_i1_1(r'a', ())
    a.handleEvent_i1_4(1u32)
    a.validate_i1_5()
    a.resolve_i1_7(true)
    a.fetch_i1_8(1i64, true)
    a.serialize_i1_9(Array<Int64>())
    a.calculate_i1_10(114.514000f64)
}

func call_2<T0>(a: T0): Unit where T0 <: I3<Int32, String> & I14<Rune, UInt64> {
    a.checkState_i3_1()
    a.process_i3_3()
    a.buildResult_i3_6(true, 1u64)
}

func call_3<T0>(a: T0): Unit where T0 <: I14<Rune, UInt64> & I10<Bool, UInt32> {
    a.process_i14_0()
    a.synthesize_i14_1(r'a')
    a.convert_i14_2()
    a.query_i14_3()
    a.query_i14_4(1i8)
}

func call_4<T0>(a: T0): Unit where T0 <: I12<UInt8> {
    a.execute_i12_0()
    a.serialize_i12_1(Array<Int64>(), Array<Int64>())
    a.transform_i12_3()
}

func call_5<T0>(a: T0): Unit where T0 <: I2<UInt8> {
    a.filter_i2_0(r'a', 1i32, 1u64)
    a.analyze_i2_1("hello")
    a.update_i2_2(1i64)
    a.serialize_i2_3()
    a.buildResult_i2_4()
    a.update_i2_8("hello", 1i64)
}

func call_6<T0>(a: T0): Unit where T0 <: I11<Float32> {
    a.checkState_i11_0(1u64)
    a.setValue_i11_2()
    a.validate_i11_3(())
    a.fetch_i11_4()
    a.process_i11_6()
    a.calculate_i11_7()
    a.handleEvent_i11_9(())
}

func call_7<T0>(a: T0): Unit where T0 <: I8<UInt32, Int32> {
    a.transform_i8_0(r'a', 1u16)
    a.query_i8_3(1u32, 1u16)
    a.synthesize_i8_4(1i64)
}

func call_8<T0>(a: T0): Unit where T0 <: I4<Int16> {
    a.evaluate_i4_1(1i32, 114.514000f64)
    a.checkState_i4_2(114.514000f64)
}

func call_9<T0>(a: T0): Unit where T0 <: I8<UInt32, Int32> {
    a.transform_i8_0(r'a', 1u16)
    a.query_i8_3(1u32, 1u16)
    a.synthesize_i8_4(1i64)
}

public func tf_oracle_main(): Unit {
    let obj0: O0<Int8> = O0<Int8>()
    obj0.validate_i9_0()
    obj0.query_i9_2(1i32, Array<Int64>(), Array<Int64>())
    obj0.analyze_i9_3(1i8, Array<Int64>(), r'a')
    obj0.fetch_i9_4()
    obj0.compare_i9_5("hello")
    obj0.checkState_i9_6(Array<Int64>(), "hello", 1i64)
    obj0.calculate_i9_7(Array<Int64>(), 1i8, 1i16)
    obj0.calculate_i1_1(r'a', ())
    obj0.calculate_i1_3(1u64, 1u64, 1u64)
    obj0.handleEvent_i1_4(1u32)
    obj0.validate_i1_5()
    obj0.resolve_i1_7(true)
    obj0.fetch_i1_8(1i64, true)
    obj0.serialize_i1_9(Array<Int64>())
    obj0.calculate_i1_10(114.514000f64)
    obj0.transform_i8_0(r'a', 1u16)
    obj0.update_i8_2(true, 1u32, 1u32)
    obj0.query_i8_3(1u32, 1u16)
    obj0.synthesize_i8_4(1i64)
    let iface1: I9<Array<Int64>> = O0<Int8>()
    iface1.validate_i9_0()
    iface1.query_i9_2(1i32, Array<Int64>(), Array<Int64>())
    iface1.analyze_i9_3(1i8, Array<Int64>(), r'a')
    iface1.fetch_i9_4()
    iface1.compare_i9_5("hello")
    iface1.checkState_i9_6(Array<Int64>(), "hello", 1i64)
    iface1.calculate_i9_7(Array<Int64>(), 1i8, 1i16)
    let iface2: I1<UInt64> = O0<Int8>()
    iface2.calculate_i1_1(r'a', ())
    iface2.calculate_i1_3(1u64, 1u64, 1u64)
    iface2.handleEvent_i1_4(1u32)
    iface2.validate_i1_5()
    iface2.resolve_i1_7(true)
    iface2.fetch_i1_8(1i64, true)
    iface2.serialize_i1_9(Array<Int64>())
    iface2.calculate_i1_10(114.514000f64)
    let iface3: I8<UInt32, Int32> = O0<Int8>()
    iface3.transform_i8_0(r'a', 1u16)
    iface3.update_i8_2(true, 1u32, 1u32)
    iface3.query_i8_3(1u32, 1u16)
    iface3.synthesize_i8_4(1i64)
    let obj4: O1<Float64, Int64> = O1<Float64, Int64>()
    obj4.execute_i13_0()
    obj4.initialize_i13_1(1u16)
    obj4.compare_i13_2(1u16, 1u16)
    obj4.convert_i13_3(1i32, 1u32, ())
    obj4.process_i13_4(1u8, 1u16)
    obj4.getValue_i13_5(1u32, 1u16)
    obj4.getValue_i13_7()
    obj4.transform_i8_0(r'a', 1u16)
    obj4.update_i8_2(true, 1u32, 1u32)
    obj4.query_i8_3(1u32, 1u16)
    obj4.synthesize_i8_4(1i64)
    obj4.convert_i7_0()
    obj4.validate_i7_1(1u32, 1u32, ())
    obj4.compare_i7_2(1i16, (), 1u32)
    obj4.fetch_i7_3(114.514000f64, 1u8)
    obj4.handleEvent_i7_4(true)
    obj4.serialize_i7_5(1u32, Array<Int64>(), true)
    obj4.evaluate_i7_6(true, true)
    obj4.calculate_i1_1(r'a', ())
    obj4.calculate_i1_3(1u64, 1u64, 1u64)
    obj4.handleEvent_i1_4(1u32)
    obj4.validate_i1_5()
    obj4.resolve_i1_7(true)
    obj4.fetch_i1_8(1i64, true)
    obj4.serialize_i1_9(Array<Int64>())
    obj4.calculate_i1_10(114.514000f64)
    let obj5: O2 = O2()
    obj5.checkState_i3_1()
    obj5.process_i3_3()
    obj5.filter_i3_4(1i32, 1i32)
    obj5.finalize_i3_5("hello")
    obj5.buildResult_i3_6(true, 1u64)
    obj5.handleEvent_i3_7(114.514000f32, "hello", Array<Int64>())
    obj5 == 1i64
    obj5.process_i14_0()
    obj5.synthesize_i14_1(r'a')
    obj5.convert_i14_2()
    obj5.query_i14_3()
    obj5.query_i14_4(1i8)
    O2.create_O2()
    let obj6: O3<Int8> = O3<Int8>()
    obj6.validate_i9_0()
    obj6.query_i9_2(1i32, Array<Int64>(), Array<Int64>())
    obj6.analyze_i9_3(1i8, Array<Int64>(), r'a')
    obj6.compare_i9_5("hello")
    obj6.calculate_i9_7(Array<Int64>(), 1i8, 1i16)
    obj6.calculate_i1_1(r'a', ())
    obj6.calculate_i1_3(1u64, 1u64, 1u64)
    obj6.resolve_i1_7(true)
    obj6.serialize_i1_9(Array<Int64>())
    obj6.transform_i8_0(r'a', 1u16)
    obj6.update_i8_2(true, 1u32, 1u32)
    obj6.synthesize_i8_4(1i64)
    let poly7: O0<Int8> = O3<Int8>()
    poly7.validate_i9_0()
    poly7.query_i9_2(1i32, Array<Int64>(), Array<Int64>())
    poly7.analyze_i9_3(1i8, Array<Int64>(), r'a')
    poly7.fetch_i9_4()
    poly7.compare_i9_5("hello")
    poly7.checkState_i9_6(Array<Int64>(), "hello", 1i64)
    poly7.calculate_i9_7(Array<Int64>(), 1i8, 1i16)
    poly7.calculate_i1_1(r'a', ())
    poly7.calculate_i1_3(1u64, 1u64, 1u64)
    poly7.handleEvent_i1_4(1u32)
    poly7.validate_i1_5()
    poly7.resolve_i1_7(true)
    poly7.fetch_i1_8(1i64, true)
    poly7.serialize_i1_9(Array<Int64>())
    poly7.calculate_i1_10(114.514000f64)
    poly7.transform_i8_0(r'a', 1u16)
    poly7.update_i8_2(true, 1u32, 1u32)
    poly7.query_i8_3(1u32, 1u16)
    poly7.synthesize_i8_4(1i64)
    let obj8: O4 = O4()
    obj8.validate_i9_0()
    obj8.analyze_i9_3(1i8, Array<Int64>(), r'a')
    obj8.calculate_i9_7(Array<Int64>(), 1i8, 1i16)
    obj8.calculate_i1_3(1u64, 1u64, 1u64)
    obj8.resolve_i1_7(true)
    obj8.serialize_i1_9(Array<Int64>())
    obj8.calculate_i1_10(114.514000f64)
    obj8.query_i8_3(1u32, 1u16)
    O4.create_O4()
    let obj9: O5 = O5()
    obj9.process_i14_0()
    obj9.synthesize_i14_1(r'a')
    obj9.convert_i14_2()
    obj9.query_i14_3()
    obj9.query_i14_4(1i8)
    obj9.getValue_i10_0()
    obj9.merge_i10_1(true, r'a')
    obj9.filter_i10_2(true, 1u32, 1u32)
    obj9.evaluate_i10_3(114.514000f32, 1u32, 1i16)
    obj9.execute_i10_4(114.514000f32)
    obj9.initialize_i10_5()
    obj9.compute_i10_6()
    obj9.filter_i10_8(114.514000f32, 1i32)
    obj9.analyze_i10_9()
    obj9.execute_i12_0()
    obj9.serialize_i12_1(Array<Int64>(), Array<Int64>())
    obj9.transform_i12_3()
    obj9.analyze_i12_4(1u8)
    obj9.compare_i4_0(1i16, 1u64, 114.514000f64)
    obj9.evaluate_i4_1(1i32, 114.514000f64)
    obj9.checkState_i4_2(114.514000f64)
    obj9.checkState_i5_0(1u16)
    obj9.fetch_i5_1()
    obj9.validate_i5_2(r'a')
    obj9.update_i5_3(r'a')
    obj9.compute_i5_4(r'a', 1u32, 1u16)
    obj9.setValue_i5_5()
    obj9.checkState_i5_6(1u8, 1u8)
    let obj10: O6 = O6()
    obj10.filter_i2_0(r'a', 1i32, 1u64)
    obj10.analyze_i2_1("hello")
    obj10.update_i2_2(1i64)
    obj10.serialize_i2_3()
    obj10.buildResult_i2_4()
    obj10.calculate_i2_5(Array<Int64>(), r'a', 1u8)
    obj10.update_i2_8("hello", 1i64)
    let obj11: O7<Rune, Int16> = O7<Rune, Int16>()
    obj11.filter_i2_0(r'a', 1i32, 1u64)
    obj11.analyze_i2_1("hello")
    obj11.update_i2_2(1i64)
    obj11.serialize_i2_3()
    obj11.buildResult_i2_4()
    obj11.calculate_i2_5(Array<Int64>(), r'a', 1u8)
    obj11.update_i2_8("hello", 1i64)
    let obj12: O8 = O8()
    obj12.checkState_i11_0(1u64)
    obj12.setValue_i11_2()
    obj12.validate_i11_3(())
    obj12.fetch_i11_4()
    obj12.calculate_i11_5(1u64, 114.514000f32)
    obj12.process_i11_6()
    obj12.calculate_i11_7()
    obj12.process_i11_8(114.514000f32, 1u32)
    obj12.handleEvent_i11_9(())
    obj12.checkState_i5_0(1u16)
    obj12.fetch_i5_1()
    obj12.validate_i5_2(r'a')
    obj12.update_i5_3(r'a')
    obj12.compute_i5_4(r'a', 1u32, 1u16)
    obj12.setValue_i5_5()
    obj12.checkState_i5_6(1u8, 1u8)
    let obj13: O9<Int8, Array<Int64>> = O9<Int8, Array<Int64>>()
    obj13.query_i9_2(1i32, Array<Int64>(), Array<Int64>())
    obj13.fetch_i9_4()
    obj13.checkState_i9_6(Array<Int64>(), "hello", 1i64)
    obj13.calculate_i9_7(Array<Int64>(), 1i8, 1i16)
    obj13.calculate_i1_1(r'a', ())
    obj13.validate_i1_5()
    obj13.resolve_i1_7(true)
    obj13.fetch_i1_8(1i64, true)
    obj13.update_i8_2(true, 1u32, 1u32)
    obj13.query_i8_3(1u32, 1u16)
    obj13.synthesize_i8_4(1i64)
    let obj14: C0 = C0()
    obj14.checkState_i3_1()
    obj14.filter_i3_4(1i32, 1i32)
    obj14.buildResult_i3_6(true, 1u64)
    obj14.handleEvent_i3_7(114.514000f32, "hello", Array<Int64>())
    obj14.synthesize_i14_1(r'a')
    obj14.convert_i14_2()
    obj14.query_i14_3()
    obj14.query_i14_4(1i8)
    C0.create_C0()
    let obj15: C1<Int8, Int64> = C1<Int8, Int64>()
    obj15.query_i9_2(1i32, Array<Int64>(), Array<Int64>())
    obj15.fetch_i9_4()
    obj15.compare_i9_5("hello")
    obj15.calculate_i1_1(r'a', ())
    obj15.calculate_i1_3(1u64, 1u64, 1u64)
    obj15.resolve_i1_7(true)
    obj15.fetch_i1_8(1i64, true)
    obj15.calculate_i1_10(114.514000f64)
    obj15.transform_i8_0(r'a', 1u16)
    obj15.update_i8_2(true, 1u32, 1u32)
    obj15.query_i8_3(1u32, 1u16)
    let poly16: O0<Int8> = C1<Int8, Int64>()
    poly16.validate_i9_0()
    poly16.query_i9_2(1i32, Array<Int64>(), Array<Int64>())
    poly16.analyze_i9_3(1i8, Array<Int64>(), r'a')
    poly16.fetch_i9_4()
    poly16.compare_i9_5("hello")
    poly16.checkState_i9_6(Array<Int64>(), "hello", 1i64)
    poly16.calculate_i9_7(Array<Int64>(), 1i8, 1i16)
    poly16.calculate_i1_1(r'a', ())
    poly16.calculate_i1_3(1u64, 1u64, 1u64)
    poly16.handleEvent_i1_4(1u32)
    poly16.validate_i1_5()
    poly16.resolve_i1_7(true)
    poly16.fetch_i1_8(1i64, true)
    poly16.serialize_i1_9(Array<Int64>())
    poly16.calculate_i1_10(114.514000f64)
    poly16.transform_i8_0(r'a', 1u16)
    poly16.update_i8_2(true, 1u32, 1u32)
    poly16.query_i8_3(1u32, 1u16)
    poly16.synthesize_i8_4(1i64)
    let obj17: C2<Array<Int64>> = C2<Array<Int64>>()
    obj17.process_i14_0()
    obj17.synthesize_i14_1(r'a')
    obj17.convert_i14_2()
    obj17.query_i14_3()
    obj17.getValue_i10_0()
    obj17.merge_i10_1(true, r'a')
    obj17.execute_i10_4(114.514000f32)
    obj17.initialize_i10_5()
    obj17.compute_i10_6()
    obj17.filter_i10_8(114.514000f32, 1i32)
    obj17.execute_i12_0()
    obj17.transform_i12_3()
    obj17.analyze_i12_4(1u8)
    obj17.evaluate_i4_1(1i32, 114.514000f64)
    obj17.fetch_i5_1()
    obj17.update_i5_3(r'a')
    obj17.setValue_i5_5()
    let poly18: O5 = C2<Array<Int64>>()
    poly18.process_i14_0()
    poly18.synthesize_i14_1(r'a')
    poly18.convert_i14_2()
    poly18.query_i14_3()
    poly18.query_i14_4(1i8)
    poly18.getValue_i10_0()
    poly18.merge_i10_1(true, r'a')
    poly18.filter_i10_2(true, 1u32, 1u32)
    poly18.evaluate_i10_3(114.514000f32, 1u32, 1i16)
    poly18.execute_i10_4(114.514000f32)
    poly18.initialize_i10_5()
    poly18.compute_i10_6()
    poly18.filter_i10_8(114.514000f32, 1i32)
    poly18.analyze_i10_9()
    poly18.execute_i12_0()
    poly18.serialize_i12_1(Array<Int64>(), Array<Int64>())
    poly18.transform_i12_3()
    poly18.analyze_i12_4(1u8)
    poly18.compare_i4_0(1i16, 1u64, 114.514000f64)
    poly18.evaluate_i4_1(1i32, 114.514000f64)
    poly18.checkState_i4_2(114.514000f64)
    poly18.checkState_i5_0(1u16)
    poly18.fetch_i5_1()
    poly18.validate_i5_2(r'a')
    poly18.update_i5_3(r'a')
    poly18.compute_i5_4(r'a', 1u32, 1u16)
    poly18.setValue_i5_5()
    poly18.checkState_i5_6(1u8, 1u8)
    let obj19: C3 = C3()
    let poly20: A0 = C3()
    let obj21: C4<UInt32, Unit> = C4<UInt32, Unit>()
    obj21.checkState_i5_0(1u16)
    obj21.fetch_i5_1()
    obj21.validate_i5_2(r'a')
    obj21.update_i5_3(r'a')
    obj21.compute_i5_4(r'a', 1u32, 1u16)
    obj21.setValue_i5_5()
    obj21.checkState_i5_6(1u8, 1u8)
    obj21.process_i14_0()
    obj21.synthesize_i14_1(r'a')
    obj21.convert_i14_2()
    obj21.query_i14_3()
    obj21.query_i14_4(1i8)
    let poly22: A2<UInt32, Unit> = C4<UInt32, Unit>()
    let obj23: C5 = C5()
    obj23.analyze_i2_1("hello")
    obj23.update_i2_2(1i64)
    obj23.buildResult_i2_4()
    obj23.calculate_i2_5(Array<Int64>(), r'a', 1u8)
    obj23.update_i2_8("hello", 1i64)
    C5.create_C5()
    let obj24: C6<UInt8> = C6<UInt8>()
    obj24.checkState_i11_0(1u64)
    obj24.validate_i11_3(())
    obj24.calculate_i11_5(1u64, 114.514000f32)
    obj24.process_i11_6()
    obj24.handleEvent_i11_9(())
    obj24.checkState_i5_0(1u16)
    obj24.fetch_i5_1()
    obj24.validate_i5_2(r'a')
    obj24.update_i5_3(r'a')
    let poly25: O8 = C6<UInt8>()
    poly25.checkState_i11_0(1u64)
    poly25.setValue_i11_2()
    poly25.validate_i11_3(())
    poly25.fetch_i11_4()
    poly25.calculate_i11_5(1u64, 114.514000f32)
    poly25.process_i11_6()
    poly25.calculate_i11_7()
    poly25.process_i11_8(114.514000f32, 1u32)
    poly25.handleEvent_i11_9(())
    poly25.checkState_i5_0(1u16)
    poly25.fetch_i5_1()
    poly25.validate_i5_2(r'a')
    poly25.update_i5_3(r'a')
    poly25.compute_i5_4(r'a', 1u32, 1u16)
    poly25.setValue_i5_5()
    poly25.checkState_i5_6(1u8, 1u8)
    let obj26: C7 = C7()
    obj26.validate_i11_3(())
    obj26.calculate_i11_5(1u64, 114.514000f32)
    obj26.process_i11_6()
    obj26.calculate_i11_7()
    obj26.process_i11_8(114.514000f32, 1u32)
    obj26.handleEvent_i11_9(())
    obj26.fetch_i5_1()
    obj26.validate_i5_2(r'a')
    obj26.update_i5_3(r'a')
    obj26.compute_i5_4(r'a', 1u32, 1u16)
    obj26.setValue_i5_5()
    obj26.checkState_i5_6(1u8, 1u8)
    let poly27: O8 = C7()
    poly27.checkState_i11_0(1u64)
    poly27.setValue_i11_2()
    poly27.validate_i11_3(())
    poly27.fetch_i11_4()
    poly27.calculate_i11_5(1u64, 114.514000f32)
    poly27.process_i11_6()
    poly27.calculate_i11_7()
    poly27.process_i11_8(114.514000f32, 1u32)
    poly27.handleEvent_i11_9(())
    poly27.checkState_i5_0(1u16)
    poly27.fetch_i5_1()
    poly27.validate_i5_2(r'a')
    poly27.update_i5_3(r'a')
    poly27.compute_i5_4(r'a', 1u32, 1u16)
    poly27.setValue_i5_5()
    poly27.checkState_i5_6(1u8, 1u8)
    let obj28: C8 = C8()
    obj28.evaluate_i6_1(r'a', 1i32)
    obj28.execute_i6_2(1i8, r'a')
    obj28.analyze_i6_3(1u16, r'a')
    obj28.update_i6_5(1i8, 1u8, 1i8)
    obj28.initialize_i6_6()
    obj28.resolve_i6_7(114.514000f32)
    obj28.fetch_i6_8()
    obj28.transform_i8_0(r'a', 1u16)
    obj28.update_i8_2(true, 1u32, 1u32)
    obj28.query_i8_3(1u32, 1u16)
    obj28.synthesize_i8_4(1i64)
    let iface29: I6<Rune, Int8> = C8()
    iface29.evaluate_i6_1(r'a', 1i32)
    iface29.execute_i6_2(1i8, r'a')
    iface29.analyze_i6_3(1u16, r'a')
    iface29.update_i6_5(1i8, 1u8, 1i8)
    iface29.initialize_i6_6()
    iface29.resolve_i6_7(114.514000f32)
    iface29.fetch_i6_8()
    let iface30: I8<UInt32, Int32> = C8()
    iface30.transform_i8_0(r'a', 1u16)
    iface30.update_i8_2(true, 1u32, 1u32)
    iface30.query_i8_3(1u32, 1u16)
    iface30.synthesize_i8_4(1i64)
    let obj31: C9<Rune, Int16> = C9<Rune, Int16>()
    obj31.analyze_i2_1("hello")
    obj31.update_i2_2(1i64)
    obj31.serialize_i2_3()
    obj31.buildResult_i2_4()
    obj31.calculate_i2_5(Array<Int64>(), r'a', 1u8)
    obj31.update_i2_8("hello", 1i64)
    let obj32: C10<Float32> = C10<Float32>()
    let poly33: A1 = C10<Float32>()
    let obj34: C11 = C11()
    obj34.checkState_i3_1()
    obj34.process_i3_3()
    obj34.buildResult_i3_6(true, 1u64)
    obj34.handleEvent_i3_7(114.514000f32, "hello", Array<Int64>())
    obj34 == 1i64
    obj34.synthesize_i14_1(r'a')
    obj34.query_i14_3()
    obj34.query_i14_4(1i8)
    let poly35: O2 = C11()
    poly35.checkState_i3_1()
    poly35.process_i3_3()
    poly35.filter_i3_4(1i32, 1i32)
    poly35.finalize_i3_5("hello")
    poly35.buildResult_i3_6(true, 1u64)
    poly35.handleEvent_i3_7(114.514000f32, "hello", Array<Int64>())
    poly35 == 1i64
    poly35.process_i14_0()
    poly35.synthesize_i14_1(r'a')
    poly35.convert_i14_2()
    poly35.query_i14_3()
    poly35.query_i14_4(1i8)
    let obj36: C12 = C12()
    C12.create_C12()
    let obj37: C13<UInt64> = C13<UInt64>()
    obj37.compare_i4_0(1i16, 1u64, 114.514000f64)
    obj37.evaluate_i4_1(1i32, 114.514000f64)
    obj37.checkState_i4_2(114.514000f64)
    obj37.checkState_i5_0(1u16)
    obj37.fetch_i5_1()
    obj37.validate_i5_2(r'a')
    obj37.update_i5_3(r'a')
    obj37.compute_i5_4(r'a', 1u32, 1u16)
    obj37.setValue_i5_5()
    obj37.checkState_i5_6(1u8, 1u8)
    obj37.update_i0_0(1i32, 1i64, 1i32)
    obj37.compute_i0_1()
    obj37 * 1i64
    obj37.convert_i7_0()
    obj37.validate_i7_1(1u32, 1u32, ())
    obj37.compare_i7_2(1i16, (), 1u32)
    obj37.fetch_i7_3(114.514000f64, 1u8)
    obj37.handleEvent_i7_4(true)
    obj37.serialize_i7_5(1u32, Array<Int64>(), true)
    obj37.evaluate_i7_6(true, true)
    let iface38: I4<Int16> = C13<UInt64>()
    iface38.compare_i4_0(1i16, 1u64, 114.514000f64)
    iface38.evaluate_i4_1(1i32, 114.514000f64)
    iface38.checkState_i4_2(114.514000f64)
    let iface39: I0<Int32, Int64> = C13<UInt64>()
    iface39.update_i0_0(1i32, 1i64, 1i32)
    iface39.compute_i0_1()
    iface39 * 1i64
    let iface40: I7<Bool, UInt32> = C13<UInt64>()
    iface40.convert_i7_0()
    iface40.validate_i7_1(1u32, 1u32, ())
    iface40.compare_i7_2(1i16, (), 1u32)
    iface40.fetch_i7_3(114.514000f64, 1u8)
    iface40.handleEvent_i7_4(true)
    iface40.serialize_i7_5(1u32, Array<Int64>(), true)
    iface40.evaluate_i7_6(true, true)
    let obj41: C14 = C14()
    obj41.update_i0_0(1i32, 1i64, 1i32)
    obj41.compute_i0_1()
    obj41 * 1i64
    C14.create_C14()
    let obj42: C15<Int32> = C15<Int32>()
    obj42.transform_i8_0(r'a', 1u16)
    obj42.update_i8_2(true, 1u32, 1u32)
    obj42.query_i8_3(1u32, 1u16)
    obj42.synthesize_i8_4(1i64)
    obj42.filter_i2_0(r'a', 1i32, 1u64)
    obj42.analyze_i2_1("hello")
    obj42.update_i2_2(1i64)
    obj42.serialize_i2_3()
    obj42.buildResult_i2_4()
    obj42.calculate_i2_5(Array<Int64>(), r'a', 1u8)
    obj42.update_i2_8("hello", 1i64)
    obj42.execute_i12_0()
    obj42.serialize_i12_1(Array<Int64>(), Array<Int64>())
    obj42.transform_i12_3()
    obj42.analyze_i12_4(1u8)
    let obj43: C16 = C16()
    let poly44: A0 = C16()
    let obj45: C17 = C17()
    obj45.fetch_i9_4()
    obj45.checkState_i9_6(Array<Int64>(), "hello", 1i64)
    obj45.calculate_i9_7(Array<Int64>(), 1i8, 1i16)
    obj45.resolve_i1_7(true)
    obj45.fetch_i1_8(1i64, true)
    obj45.query_i8_3(1u32, 1u16)
    obj45.synthesize_i8_4(1i64)
    C17.create_C17()
    let obj46: C18 = C18()
    obj46.filter_i2_0(r'a', 1i32, 1u64)
    obj46.analyze_i2_1("hello")
    obj46.update_i2_2(1i64)
    obj46.serialize_i2_3()
    obj46.buildResult_i2_4()
    obj46.calculate_i2_5(Array<Int64>(), r'a', 1u8)
    obj46.update_i2_8("hello", 1i64)
    obj46.checkState_i5_0(1u16)
    obj46.fetch_i5_1()
    obj46.validate_i5_2(r'a')
    obj46.update_i5_3(r'a')
    obj46.compute_i5_4(r'a', 1u32, 1u16)
    obj46.setValue_i5_5()
    obj46.checkState_i5_6(1u8, 1u8)
    obj46.calculate_i1_1(r'a', ())
    obj46.calculate_i1_3(1u64, 1u64, 1u64)
    obj46.handleEvent_i1_4(1u32)
    obj46.validate_i1_5()
    obj46.resolve_i1_7(true)
    obj46.fetch_i1_8(1i64, true)
    obj46.serialize_i1_9(Array<Int64>())
    obj46.calculate_i1_10(114.514000f64)
    let iface47: I2<UInt8> = C18()
    iface47.filter_i2_0(r'a', 1i32, 1u64)
    iface47.analyze_i2_1("hello")
    iface47.update_i2_2(1i64)
    iface47.serialize_i2_3()
    iface47.buildResult_i2_4()
    iface47.calculate_i2_5(Array<Int64>(), r'a', 1u8)
    iface47.update_i2_8("hello", 1i64)
    let iface48: I5<UInt16, Rune> = C18()
    iface48.checkState_i5_0(1u16)
    iface48.fetch_i5_1()
    iface48.validate_i5_2(r'a')
    iface48.update_i5_3(r'a')
    iface48.compute_i5_4(r'a', 1u32, 1u16)
    iface48.setValue_i5_5()
    iface48.checkState_i5_6(1u8, 1u8)
    let iface49: I1<UInt64> = C18()
    iface49.calculate_i1_1(r'a', ())
    iface49.calculate_i1_3(1u64, 1u64, 1u64)
    iface49.handleEvent_i1_4(1u32)
    iface49.validate_i1_5()
    iface49.resolve_i1_7(true)
    iface49.fetch_i1_8(1i64, true)
    iface49.serialize_i1_9(Array<Int64>())
    iface49.calculate_i1_10(114.514000f64)
    let obj50: C19<Rune, Int16> = C19<Rune, Int16>()
    obj50.filter_i2_0(r'a', 1i32, 1u64)
    obj50.analyze_i2_1("hello")
    obj50.serialize_i2_3()
    obj50.update_i2_8("hello", 1i64)
    let poly51: O7<Rune, Int16> = C19<Rune, Int16>()
    poly51.filter_i2_0(r'a', 1i32, 1u64)
    poly51.analyze_i2_1("hello")
    poly51.update_i2_2(1i64)
    poly51.serialize_i2_3()
    poly51.buildResult_i2_4()
    poly51.calculate_i2_5(Array<Int64>(), r'a', 1u8)
    poly51.update_i2_8("hello", 1i64)
    let obj52: C20 = C20()
    obj52.filter_i2_0(r'a', 1i32, 1u64)
    obj52.update_i2_2(1i64)
    obj52.serialize_i2_3()
    C20.create_C20()
    let poly53: O7<Rune, Int16> = C20()
    poly53.filter_i2_0(r'a', 1i32, 1u64)
    poly53.analyze_i2_1("hello")
    poly53.update_i2_2(1i64)
    poly53.serialize_i2_3()
    poly53.buildResult_i2_4()
    poly53.calculate_i2_5(Array<Int64>(), r'a', 1u8)
    poly53.update_i2_8("hello", 1i64)
    let obj54: C21 = C21()
    obj54.analyze_i9_3(1i8, Array<Int64>(), r'a')
    obj54.compare_i9_5("hello")
    obj54.calculate_i9_7(Array<Int64>(), 1i8, 1i16)
    obj54.calculate_i1_1(r'a', ())
    obj54.calculate_i1_3(1u64, 1u64, 1u64)
    obj54.resolve_i1_7(true)
    obj54.update_i8_2(true, 1u32, 1u32)
    let obj55: C22 = C22()
    let poly56: A1 = C22()
    let obj57: E0 = E0.A(1u32)
    let obj58: E1 = E1.A(1i8)
    let obj59: E2 = E2.A("hello")
    let obj60: E3 = E3.A
    obj60.describe(114.514000f64)
    let obj61: E4 = E4.A(true)
    let obj62: E5 = E5.A(1u16, "hello")
    let obj63: S0 = S0()
    let obj64: S1 = S1()
    let obj65: S2 = S2()
    let obj66: S3 = S3()
    call_0<O0<Int8>>(O0<Int8>())
    call_1<O1<Float64, Int64>>(O1<Float64, Int64>())
    call_2<O2>(O2())
    call_3<O5>(O5())
    call_4<O5>(O5())
    call_5<O7<Rune, Int16>>(O7<Rune, Int16>())
    call_6<O8>(O8())
    call_7<C8>(C8())
    call_8<C13<UInt64>>(C13<UInt64>())
    call_9<C15<Int32>>(C15<Int32>())
    let ext0: I10<Bool, UInt32> = C20()
    ext0.getValue_i10_0()
    ext0.merge_i10_1(true, r'a')
    ext0.filter_i10_2(true, 1u32, 1u32)
    ext0.evaluate_i10_3(114.514000f32, 1u32, 1i16)
    ext0.execute_i10_4(114.514000f32)
    ext0.initialize_i10_5()
    ext0.compute_i10_6()
    ext0.filter_i10_8(114.514000f32, 1i32)
    ext0.analyze_i10_9()
    if (__trace.toString() ==
        "[O0.validate_i9_0][O0.query_i9_2][O0.analyze_i9_3][O0.fetch_i9_4][O0.compare_i9_5][O0.checkState_i9_6][O0.calculate_i9_7][O0.calculate_i1_1][O0.calculate_i1_3][O0.handleEvent_i1_4][O0.validate_i1_5][O0.resolve_i1_7][O0.fetch_i1_8][O0.serialize_i1_9][O0.calculate_i1_10][O0.transform_i8_0][O0.update_i8_2][O0.query_i8_3][O0.synthesize_i8_4][O0.validate_i9_0][O0.query_i9_2][O0.analyze_i9_3][O0.fetch_i9_4][O0.compare_i9_5][O0.checkState_i9_6][O0.calculate_i9_7][O0.calculate_i1_1][O0.calculate_i1_3][O0.handleEvent_i1_4][O0.validate_i1_5][O0.resolve_i1_7][O0.fetch_i1_8][O0.serialize_i1_9][O0.calculate_i1_10][O0.transform_i8_0][O0.update_i8_2][O0.query_i8_3][O0.synthesize_i8_4][O1.execute_i13_0][O1.initialize_i13_1][O1.compare_i13_2][O1.convert_i13_3][O1.process_i13_4][O1.getValue_i13_5][O1.getValue_i13_7][O1.transform_i8_0][O1.update_i8_2][O1.query_i8_3][O1.synthesize_i8_4][O1.convert_i7_0][O1.validate_i7_1][O1.compare_i7_2][O1.fetch_i7_3][O1.handleEvent_i7_4][O1.serialize_i7_5][O1.evaluate_i7_6][O1.calculate_i1_1][O1.calculate_i1_3][O1.handleEvent_i1_4][O1.validate_i1_5][O1.resolve_i1_7][O1.fetch_i1_8][O1.serialize_i1_9][O1.calculate_i1_10][O2.checkState_i3_1][O2.process_i3_3][O2.filter_i3_4][O2.finalize_i3_5][O2.buildResult_i3_6][O2.handleEvent_i3_7][O2.==][O2.process_i14_0][O2.synthesize_i14_1][O2.convert_i14_2][O2.query_i14_3][O2.query_i14_4][O2.create_O2][O3.validate_i9_0][O3.query_i9_2][O3.analyze_i9_3][O3.compare_i9_5][O3.calculate_i9_7][O3.calculate_i1_1][O3.calculate_i1_3][O0.calculate_i1_3][O3.resolve_i1_7][O0.resolve_i1_7][O3.serialize_i1_9][O3.transform_i8_0][O3.update_i8_2][O0.update_i8_2][O3.synthesize_i8_4][O0.synthesize_i8_4][O3.validate_i9_0][O3.query_i9_2][O3.analyze_i9_3][O0.fetch_i9_4][O3.compare_i9_5][O0.checkState_i9_6][O3.calculate_i9_7][O3.calculate_i1_1][O3.calculate_i1_3][O0.calculate_i1_3][O0.handleEvent_i1_4][O0.validate_i1_5][O3.resolve_i1_7][O0.resolve_i1_7][O0.fetch_i1_8][O3.serialize_i1_9][O0.calculate_i1_10][O3.transform_i8_0][O3.update_i8_2][O0.update_i8_2][O0.query_i8_3][O3.synthesize_i8_4][O0.synthesize_i8_4][O4.validate_i9_0][O4.analyze_i9_3][O4.calculate_i9_7][O0.calculate_i9_7][O4.calculate_i1_3][O4.resolve_i1_7][O4.serialize_i1_9][O4.calculate_i1_10][O0.calculate_i1_10][O4.query_i8_3][O4.create_O4][O5.process_i14_0][O5.synthesize_i14_1][O5.convert_i14_2][O5.query_i14_3][O5.query_i14_4][O5.getValue_i10_0][O5.merge_i10_1][O5.filter_i10_2][O5.evaluate_i10_3][O5.execute_i10_4][O5.initialize_i10_5][O5.compute_i10_6][O5.filter_i10_8][O5.analyze_i10_9][O5.execute_i12_0][O5.serialize_i12_1][O5.transform_i12_3][O5.analyze_i12_4][O5.compare_i4_0][O5.evaluate_i4_1][O5.checkState_i4_2][O5.checkState_i5_0][O5.fetch_i5_1][O5.validate_i5_2][O5.update_i5_3][O5.compute_i5_4][O5.setValue_i5_5][O5.checkState_i5_6][O6.filter_i2_0][O6.analyze_i2_1][O6.update_i2_2][O6.serialize_i2_3][O6.buildResult_i2_4][O6.calculate_i2_5][O6.update_i2_8][O7.filter_i2_0][O7.analyze_i2_1][O7.update_i2_2][O7.serialize_i2_3][O7.buildResult_i2_4][O7.calculate_i2_5][O7.update_i2_8][O8.checkState_i11_0][O8.setValue_i11_2][O8.validate_i11_3][O8.fetch_i11_4][O8.calculate_i11_5][O8.process_i11_6][O8.calculate_i11_7][O8.process_i11_8][O8.handleEvent_i11_9][O8.checkState_i5_0][O8.fetch_i5_1][O8.validate_i5_2][O8.update_i5_3][O8.compute_i5_4][O8.setValue_i5_5][O8.checkState_i5_6][O9.query_i9_2][O0.query_i9_2][O9.fetch_i9_4][O9.checkState_i9_6][O9.calculate_i9_7][O9.calculate_i1_1][O9.validate_i1_5][O9.resolve_i1_7][O9.fetch_i1_8][O9.update_i8_2][O0.update_i8_2][O9.query_i8_3][O9.synthesize_i8_4][C0.checkState_i3_1][C0.filter_i3_4][C0.buildResult_i3_6][O2.buildResult_i3_6][C0.handleEvent_i3_7][O2.handleEvent_i3_7][C0.synthesize_i14_1][O2.synthesize_i14_1][C0.convert_i14_2][C0.query_i14_3][C0.query_i14_4][C0.create_C0][C1.query_i9_2][C1.fetch_i9_4][C1.compare_i9_5][C1.calculate_i1_1][O0.calculate_i1_1][C1.calculate_i1_3][O0.calculate_i1_3][C1.resolve_i1_7][C1.fetch_i1_8][C1.calculate_i1_10][C1.transform_i8_0][O0.transform_i8_0][C1.update_i8_2][C1.query_i8_3][O0.validate_i9_0][C1.query_i9_2][O0.analyze_i9_3][C1.fetch_i9_4][C1.compare_i9_5][O0.checkState_i9_6][O0.calculate_i9_7][C1.calculate_i1_1][O0.calculate_i1_1][C1.calculate_i1_3][O0.calculate_i1_3][O0.handleEvent_i1_4][O0.validate_i1_5][C1.resolve_i1_7][C1.fetch_i1_8][O0.serialize_i1_9][C1.calculate_i1_10][C1.transform_i8_0][O0.transform_i8_0][C1.update_i8_2][C1.query_i8_3][O0.synthesize_i8_4][C2.process_i14_0][C2.synthesize_i14_1][C2.convert_i14_2][C2.query_i14_3][C2.getValue_i10_0][C2.merge_i10_1][C2.execute_i10_4][O5.execute_i10_4][C2.initialize_i10_5][O5.initialize_i10_5][C2.compute_i10_6][O5.compute_i10_6][C2.filter_i10_8][C2.execute_i12_0][O5.execute_i12_0][C2.transform_i12_3][C2.analyze_i12_4][C2.evaluate_i4_1][C2.fetch_i5_1][C2.update_i5_3][C2.setValue_i5_5][C2.process_i14_0][C2.synthesize_i14_1][C2.convert_i14_2][C2.query_i14_3][O5.query_i14_4][C2.getValue_i10_0][C2.merge_i10_1][O5.filter_i10_2][O5.evaluate_i10_3][C2.execute_i10_4][O5.execute_i10_4][C2.initialize_i10_5][O5.initialize_i10_5][C2.compute_i10_6][O5.compute_i10_6][C2.filter_i10_8][O5.analyze_i10_9][C2.execute_i12_0][O5.execute_i12_0][O5.serialize_i12_1][C2.transform_i12_3][C2.analyze_i12_4][O5.compare_i4_0][C2.evaluate_i4_1][O5.checkState_i4_2][O5.checkState_i5_0][C2.fetch_i5_1][O5.validate_i5_2][C2.update_i5_3][O5.compute_i5_4][C2.setValue_i5_5][O5.checkState_i5_6][C4.checkState_i5_0][C4.fetch_i5_1][C4.validate_i5_2][C4.update_i5_3][C4.compute_i5_4][C4.setValue_i5_5][C4.checkState_i5_6][C4.process_i14_0][C4.synthesize_i14_1][C4.convert_i14_2][C4.query_i14_3][C4.query_i14_4][C5.analyze_i2_1][C5.update_i2_2][O7.update_i2_2][C5.buildResult_i2_4][C5.calculate_i2_5][C5.update_i2_8][O7.update_i2_8][C5.create_C5][C6.checkState_i11_0][O8.checkState_i11_0][C6.validate_i11_3][O8.validate_i11_3][C6.calculate_i11_5][O8.calculate_i11_5][C6.process_i11_6][O8.process_i11_6][C6.handleEvent_i11_9][C6.checkState_i5_0][O8.checkState_i5_0][C6.fetch_i5_1][C6.validate_i5_2][O8.validate_i5_2][C6.update_i5_3][O8.update_i5_3][C6.checkState_i11_0][O8.checkState_i11_0][O8.setValue_i11_2][C6.validate_i11_3][O8.validate_i11_3][O8.fetch_i11_4][C6.calculate_i11_5][O8.calculate_i11_5][C6.process_i11_6][O8.process_i11_6][O8.calculate_i11_7][O8.process_i11_8][C6.handleEvent_i11_9][C6.checkState_i5_0][O8.checkState_i5_0][C6.fetch_i5_1][C6.validate_i5_2][O8.validate_i5_2][C6.update_i5_3][O8.update_i5_3][O8.compute_i5_4][O8.setValue_i5_5][O8.checkState_i5_6][C7.validate_i11_3][C7.calculate_i11_5][O8.calculate_i11_5][C7.process_i11_6][C7.calculate_i11_7][C7.process_i11_8][C7.handleEvent_i11_9][C7.fetch_i5_1][O8.fetch_i5_1][C7.validate_i5_2][C7.update_i5_3][C7.compute_i5_4][O8.compute_i5_4][C7.setValue_i5_5][C7.checkState_i5_6][O8.checkState_i11_0][O8.setValue_i11_2][C7.validate_i11_3][O8.fetch_i11_4][C7.calculate_i11_5][O8.calculate_i11_5][C7.process_i11_6][C7.calculate_i11_7][C7.process_i11_8][C7.handleEvent_i11_9][O8.checkState_i5_0][C7.fetch_i5_1][O8.fetch_i5_1][C7.validate_i5_2][C7.update_i5_3][C7.compute_i5_4][O8.compute_i5_4][C7.setValue_i5_5][C7.checkState_i5_6][C8.evaluate_i6_1][C8.execute_i6_2][C8.analyze_i6_3][C8.update_i6_5][C8.initialize_i6_6][C8.resolve_i6_7][C8.fetch_i6_8][C8.transform_i8_0][C8.update_i8_2][C8.query_i8_3][C8.synthesize_i8_4][C8.evaluate_i6_1][C8.execute_i6_2][C8.analyze_i6_3][C8.update_i6_5][C8.initialize_i6_6][C8.resolve_i6_7][C8.fetch_i6_8][C8.transform_i8_0][C8.update_i8_2][C8.query_i8_3][C8.synthesize_i8_4][C9.analyze_i2_1][C9.update_i2_2][C9.serialize_i2_3][C9.buildResult_i2_4][C9.calculate_i2_5][O7.calculate_i2_5][C9.update_i2_8][O7.update_i2_8][C11.checkState_i3_1][C11.process_i3_3][C11.buildResult_i3_6][C11.handleEvent_i3_7][O2.handleEvent_i3_7][C11.==][C11.synthesize_i14_1][C11.query_i14_3][C11.query_i14_4][C11.checkState_i3_1][C11.process_i3_3][O2.filter_i3_4][O2.finalize_i3_5][C11.buildResult_i3_6][C11.handleEvent_i3_7][O2.handleEvent_i3_7][C11.==][O2.process_i14_0][C11.synthesize_i14_1][O2.convert_i14_2][C11.query_i14_3][C11.query_i14_4][C12.create_C12][C13.compare_i4_0][C13.evaluate_i4_1][C13.checkState_i4_2][C13.checkState_i5_0][C13.fetch_i5_1][C13.validate_i5_2][C13.update_i5_3][C13.compute_i5_4][C13.setValue_i5_5][C13.checkState_i5_6][C13.update_i0_0][C13.compute_i0_1][C13.*][C13.convert_i7_0][C13.validate_i7_1][C13.compare_i7_2][C13.fetch_i7_3][C13.handleEvent_i7_4][C13.serialize_i7_5][C13.evaluate_i7_6][C13.compare_i4_0][C13.evaluate_i4_1][C13.checkState_i4_2][C13.update_i0_0][C13.compute_i0_1][C13.*][C13.convert_i7_0][C13.validate_i7_1][C13.compare_i7_2][C13.fetch_i7_3][C13.handleEvent_i7_4][C13.serialize_i7_5][C13.evaluate_i7_6][C14.update_i0_0][C14.compute_i0_1][C14.*][C14.create_C14][C15.transform_i8_0][C15.update_i8_2][C15.query_i8_3][C15.synthesize_i8_4][C15.filter_i2_0][C15.analyze_i2_1][C15.update_i2_2][C15.serialize_i2_3][C15.buildResult_i2_4][C15.calculate_i2_5][C15.update_i2_8][C15.execute_i12_0][C15.serialize_i12_1][C15.transform_i12_3][C15.analyze_i12_4][C17.fetch_i9_4][C17.checkState_i9_6][O9.checkState_i9_6][C17.calculate_i9_7][C17.resolve_i1_7][C17.fetch_i1_8][C17.query_i8_3][C17.synthesize_i8_4][C17.create_C17][C18.filter_i2_0][C18.analyze_i2_1][C18.update_i2_2][C18.serialize_i2_3][C18.buildResult_i2_4][C18.calculate_i2_5][C18.update_i2_8][C18.checkState_i5_0][C18.fetch_i5_1][C18.validate_i5_2][C18.update_i5_3][C18.compute_i5_4][C18.setValue_i5_5][C18.checkState_i5_6][C18.calculate_i1_1][C18.calculate_i1_3][C18.handleEvent_i1_4][C18.validate_i1_5][C18.resolve_i1_7][C18.fetch_i1_8][C18.serialize_i1_9][C18.calculate_i1_10][C18.filter_i2_0][C18.analyze_i2_1][C18.update_i2_2][C18.serialize_i2_3][C18.buildResult_i2_4][C18.calculate_i2_5][C18.update_i2_8][C18.checkState_i5_0][C18.fetch_i5_1][C18.validate_i5_2][C18.update_i5_3][C18.compute_i5_4][C18.setValue_i5_5][C18.checkState_i5_6][C18.calculate_i1_1][C18.calculate_i1_3][C18.handleEvent_i1_4][C18.validate_i1_5][C18.resolve_i1_7][C18.fetch_i1_8][C18.serialize_i1_9][C18.calculate_i1_10][C19.filter_i2_0][O7.filter_i2_0][C19.analyze_i2_1][C19.serialize_i2_3][C19.update_i2_8][C19.filter_i2_0][O7.filter_i2_0][C19.analyze_i2_1][O7.update_i2_2][C19.serialize_i2_3][O7.buildResult_i2_4][O7.calculate_i2_5][C19.update_i2_8][C20.filter_i2_0][O7.filter_i2_0][C20.update_i2_2][C20.serialize_i2_3][C20.create_C20][C20.filter_i2_0][O7.filter_i2_0][O7.analyze_i2_1][C20.update_i2_2][C20.serialize_i2_3][O7.buildResult_i2_4][O7.calculate_i2_5][O7.update_i2_8][C21.analyze_i9_3][O3.analyze_i9_3][C21.compare_i9_5][C21.calculate_i9_7][C21.calculate_i1_1][C21.calculate_i1_3][O3.calculate_i1_3][O0.calculate_i1_3][C21.resolve_i1_7][C21.update_i8_2][O3.update_i8_2][O0.update_i8_2][E3.describe][O0.transform_i8_0][O0.query_i8_3][O0.synthesize_i8_4][O1.calculate_i1_1][O1.handleEvent_i1_4][O1.validate_i1_5][O1.resolve_i1_7][O1.fetch_i1_8][O1.serialize_i1_9][O1.calculate_i1_10][O2.checkState_i3_1][O2.process_i3_3][O2.buildResult_i3_6][O5.process_i14_0][O5.synthesize_i14_1][O5.convert_i14_2][O5.query_i14_3][O5.query_i14_4][O5.execute_i12_0][O5.serialize_i12_1][O5.transform_i12_3][O7.filter_i2_0][O7.analyze_i2_1][O7.update_i2_2][O7.serialize_i2_3][O7.buildResult_i2_4][O7.update_i2_8][O8.checkState_i11_0][O8.setValue_i11_2][O8.validate_i11_3][O8.fetch_i11_4][O8.process_i11_6][O8.calculate_i11_7][O8.handleEvent_i11_9][C8.transform_i8_0][C8.query_i8_3][C8.synthesize_i8_4][C13.evaluate_i4_1][C13.checkState_i4_2][C15.transform_i8_0][C15.query_i8_3][C15.synthesize_i8_4][extend_C20_I10.getValue_i10_0][extend_C20_I10.merge_i10_1][extend_C20_I10.filter_i10_2][extend_C20_I10.evaluate_i10_3][extend_C20_I10.execute_i10_4][extend_C20_I10.initialize_i10_5][extend_C20_I10.compute_i10_6][extend_C20_I10.filter_i10_8][extend_C20_I10.analyze_i10_9]") {
        println("TF_ORACLE_OK")
    } else {
        println("MISMATCH " + __trace.toString())
    }
}

public func gfunc_524403(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v747551: Float64 = 114.514000f64
    let v10486108: Bool = true
}

@mfunc_920836
public func gfunc_524404(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
    let v997356: Int64 = 114514i64
}

internal func gfunc_524405(depth: Int64): Unit {
    if (depth <= 0i64) {
        return
    }
}

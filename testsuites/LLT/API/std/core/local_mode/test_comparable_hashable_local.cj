/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// 覆盖设计项（LM-DOC-20260910）：T426-T431,T434。

import std.core.*

// T426: a non-Copyable key with separate original and local equality paths.
class T426EqualityKey <: Equatable<T426EqualityKey> {
    let value: String

    init(v: String) {
        value = v
    }

    public operator func ==(other: T426EqualityKey): Bool {
        value == other.value
    }

    public operator func !=(other: T426EqualityKey): Bool {
        value != other.value
    }

    public operator func ==(this @local?, other: T426EqualityKey @local?): Bool {
        value == other.value
    }

    public operator func !=(this @local?, other: T426EqualityKey @local?): Bool {
        value != other.value
    }
}

func t426HeapEqual<T>(a: T, b: T): Bool where T <: Equatable<T> {
    a == b
}

func t426HeapNotEqual<T>(a: T, b: T): Bool where T <: Equatable<T> {
    a != b
}

func t426HalfEqual<T>(a: T @local?, b: T @local?): Bool where T <: Equatable<T> {
    a == b
}

func t426HalfNotEqual<T>(a: T @local?, b: T @local?): Bool where T <: Equatable<T> {
    a != b
}

// T427 fixtures are intentionally separate: each omits one local overload.
class T427EqOnly <: Equal<T427EqOnly> {
    let value: Int64

    init(v: Int64) {
        value = v
    }

    public operator func ==(other: T427EqOnly): Bool {
        value == other.value
    }
}

class T427NotEqOnly <: NotEqual<T427NotEqOnly> {
    let value: Int64

    init(v: Int64) {
        value = v
    }

    public operator func !=(other: T427NotEqOnly): Bool {
        value != other.value
    }
}

class T427Equatable <: Equatable<T427Equatable> {
    let value: Int64

    init(v: Int64) {
        value = v
    }

    public operator func ==(other: T427Equatable): Bool {
        value == other.value
    }

    public operator func !=(other: T427Equatable): Bool {
        value != other.value
    }

    public operator func ==(this @local?, other: T427Equatable @local?): Bool {
        value == other.value
    }
}

func t427EqOnlyDefault(receiver: T427EqOnly @local?, other: T427EqOnly @local?): Bool {
    var caught = false
    try {
        let result = receiver == other
        let _ = result
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

func t427NotEqOnlyDefault(receiver: T427NotEqOnly @local?, other: T427NotEqOnly @local?): Bool {
    var caught = false
    try {
        let result = receiver != other
        let _ = result
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

// 2026-09-28 契约翻转（URL 文档 §8）：Equatable.!= @local? 默认体改为
// !(this == other)，不再抛异常；结果经 T427Equatable 的 == @local? 覆写推导。
func t427EquatableNotEqDefault(receiver: T427Equatable @local?, other: T427Equatable @local?): Bool {
    receiver != other
}

// T428/T429: only compare is implemented; Comparable supplies the ordering
// operators. The local != default is intentionally not part of the five-op
// table; T427 proves Equatable's local != delegates to == (doc §8), while a
// direct NotEqual conformer's local != still throws (NotEqual has no default).
class T429CompareOnlyKey <: Comparable<T429CompareOnlyKey> {
    let value: String

    init(v: String) {
        value = v
    }

    public func compare(other: T429CompareOnlyKey): Ordering {
        if (value < other.value) {
            Ordering.LT
        } else if (value > other.value) {
            Ordering.GT
        } else {
            Ordering.EQ
        }
    }

    public func compare(this @local?, other: T429CompareOnlyKey @local?): Ordering {
        if (value < other.value) {
            Ordering.LT
        } else if (value > other.value) {
            Ordering.GT
        } else {
            Ordering.EQ
        }
    }
}

// T430: no local compare override, so compare and each local default operator
// must independently throw the precise exception.
class T430NoLocalCompareKey <: Comparable<T430NoLocalCompareKey> {
    let value: String

    init(v: String) {
        value = v
    }

    public func compare(other: T430NoLocalCompareKey): Ordering {
        if (value < other.value) {
            Ordering.LT
        } else if (value > other.value) {
            Ordering.GT
        } else {
            Ordering.EQ
        }
    }
}

func t430Compare(receiver: T430NoLocalCompareKey @local?, other: T430NoLocalCompareKey @local?): Bool {
    var caught = false
    try {
        let result: Ordering @local? = receiver.compare(other)
        let _ = result
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

func t430Equal(receiver: T430NoLocalCompareKey @local?, other: T430NoLocalCompareKey @local?): Bool {
    var caught = false
    try {
        let result = receiver == other
        let _ = result
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

func t430Less(receiver: T430NoLocalCompareKey @local?, other: T430NoLocalCompareKey @local?): Bool {
    var caught = false
    try {
        let result = receiver < other
        let _ = result
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

func t430Greater(receiver: T430NoLocalCompareKey @local?, other: T430NoLocalCompareKey @local?): Bool {
    var caught = false
    try {
        let result = receiver > other
        let _ = result
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

func t430LessOrEqual(receiver: T430NoLocalCompareKey @local?, other: T430NoLocalCompareKey @local?): Bool {
    var caught = false
    try {
        let result = receiver <= other
        let _ = result
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

func t430GreaterOrEqual(receiver: T430NoLocalCompareKey @local?, other: T430NoLocalCompareKey @local?): Bool {
    var caught = false
    try {
        let result = receiver >= other
        let _ = result
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

class T431HashKey <: Hashable {
    let value: String

    init(v: String) {
        value = v
    }

    public func hashCode(): Int64 {
        value.size
    }

    public func hashCode(this @local?): Int64 {
        value.size
    }
}

class T431MissingHash <: Hashable {
    public func hashCode(): Int64 {
        17
    }
}

func t431GenericHash<T>(value: T @local?): Int64 where T <: Hashable {
    value.hashCode()
}

func t431MissingHashDefault(value: T431MissingHash @local?): Bool {
    let receiver: Hashable @local? = value
    var caught = false
    try {
        let result: Int64 @local? = receiver.hashCode()
        let _ = result
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

func t431StringInterfaceHash(first: String @local!, second: String @local!): Bool {
    exclave {
        let firstHashable: Hashable @local? = first
        let secondHashable: Hashable @local? = second
        let firstHash: Int64 @local? = firstHashable.hashCode()
        let secondHash: Int64 @local? = secondHashable.hashCode()
        let directHash: Int64 @local? = first.hashCode()
        firstHash == secondHash && firstHash == directHash
    }
}

class T432MissingToString <: ToString {
    public func toString(): String {
        "heap-only"
    }
}

func t432MissingToStringDefault(value: T432MissingToString @local?): Bool {
    var caught = false
    try {
        let result: String @local! = value.toString()
        let _ = result
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

// T429: 0=LT, 1=EQ, 2=GT。
func t429CompareHalf(left: String @local!, right: String @local!): Int64 {
    exclave {
        let comparable: Comparable<String> @local? = left
        let other: String @local? = right
        match (comparable.compare(other)) {
            case Ordering.LT => 0
            case Ordering.EQ => 1
            case Ordering.GT => 2
        }
    }
}

main(): Int64 {
    var failed = 0

    // T426: heap and generic-half equality/not-equality dispatch for a
    // non-Copyable key, with both equal and unequal inputs.
    let heapEqA = T426EqualityKey("a")
    let heapEqB = T426EqualityKey("a")
    let heapNe = T426EqualityKey("b")
    failed += assertB(t426HeapEqual(heapEqA, heapEqB), "T426_heap_equal_true")
    failed += assertB(!t426HeapEqual(heapEqA, heapNe), "T426_heap_equal_false")
    failed += assertB(t426HeapNotEqual(heapEqA, heapNe), "T426_heap_notequal_true")
    failed += assertB(!t426HeapNotEqual(heapEqA, heapEqB), "T426_heap_notequal_false")

    let halfEqA: T426EqualityKey @local? = heapEqA
    let halfEqB: T426EqualityKey @local? = heapEqB
    let halfNe: T426EqualityKey @local? = heapNe
    failed += assertB(t426HalfEqual(halfEqA, halfEqB), "T426_half_equal_true")
    failed += assertB(!t426HalfEqual(halfEqA, halfNe), "T426_half_equal_false")
    failed += assertB(t426HalfNotEqual(halfEqA, halfNe), "T426_half_notequal_true")
    failed += assertB(!t426HalfNotEqual(halfEqA, halfEqB), "T426_half_notequal_false")
    // Doc-correct full-mode expectation (C10): the same four checks use
    // T426EqualityKey @local! once a custom full fixture can be constructed.

    // T427: EqOnly local == default, NotEqOnly local != default, and an
    // Equatable local == override without a local != override.
    let eqOnlyA: T427EqOnly @local? = T427EqOnly(1)
    let eqOnlyB: T427EqOnly @local? = T427EqOnly(1)
    failed += assertB(t427EqOnlyDefault(eqOnlyA, eqOnlyB), "T427_eq_only_default_throws")

    let notEqOnlyA: T427NotEqOnly @local? = T427NotEqOnly(1)
    let notEqOnlyB: T427NotEqOnly @local? = T427NotEqOnly(2)
    failed += assertB(t427NotEqOnlyDefault(notEqOnlyA, notEqOnlyB), "T427_noteq_only_default_throws")

    let equatableA: T427Equatable @local? = T427Equatable(1)
    let equatableB: T427Equatable @local? = T427Equatable(1)
    failed += assertB(equatableA == equatableB, "T427_equatable_local_equal_override")
    failed += assertB(!t427EquatableNotEqDefault(equatableA, equatableB), "T427_equatable_local_notequal_default_delegates_eq")
    let equatableC: T427Equatable @local? = T427Equatable(2)
    failed += assertB(t427EquatableNotEqDefault(equatableA, equatableC), "T427_equatable_local_notequal_default_delegates_ne")
    // Doc-correct full-mode expectation (C10): EqOnly/NotEqOnly/Equatable
    // full receivers use the same exact typed catches.

    // T428: heap Comparable default paths, full LT/EQ/GT truth table including !=.
    let heapLtA = T429CompareOnlyKey("a")
    let heapLtB = T429CompareOnlyKey("b")
    let heapEq = T429CompareOnlyKey("a")
    failed += assertB(heapLtA < heapLtB, "T428_heap_lt_true")
    failed += assertB(!(heapLtA == heapLtB), "T428_heap_eq_false_lt")
    failed += assertB(heapLtA != heapLtB, "T428_heap_noteq_true_lt")
    failed += assertB(heapLtA <= heapLtB, "T428_heap_le_true_lt")
    failed += assertB(!(heapLtA > heapLtB), "T428_heap_gt_false_lt")
    failed += assertB(!(heapLtA >= heapLtB), "T428_heap_ge_false_lt")
    failed += assertB(heapLtA == heapEq, "T428_heap_eq_true_eq")
    failed += assertB(!(heapLtA != heapEq), "T428_heap_noteq_false_eq")
    failed += assertB(!(heapLtA < heapEq), "T428_heap_lt_false_eq")
    failed += assertB(!(heapLtA > heapEq), "T428_heap_gt_false_eq")
    failed += assertB(heapLtA <= heapEq, "T428_heap_le_true_eq")
    failed += assertB(heapLtA >= heapEq, "T428_heap_ge_true_eq")
    failed += assertB(heapLtB > heapLtA, "T428_heap_gt_true_gt")
    failed += assertB(!(heapLtB == heapLtA), "T428_heap_eq_false_gt")
    failed += assertB(heapLtB != heapLtA, "T428_heap_noteq_true_gt")
    failed += assertB(!(heapLtB < heapLtA), "T428_heap_lt_false_gt")
    failed += assertB(!(heapLtB <= heapLtA), "T428_heap_le_false_gt")
    failed += assertB(heapLtB >= heapLtA, "T428_heap_ge_true_gt")

    // T429: local compare override feeds Comparable's five local operators.
    let localLtA: T429CompareOnlyKey @local? = T429CompareOnlyKey("a")
    let localLtB: T429CompareOnlyKey @local? = T429CompareOnlyKey("b")
    let localEq: T429CompareOnlyKey @local? = T429CompareOnlyKey("a")
    failed += assertB(localLtA.compare(localLtB) == Ordering.LT, "T429_compare_lt")
    failed += assertB(!(localLtA == localLtB), "T429_lt_eq_false")
    failed += assertB(localLtA < localLtB, "T429_lt_less_true")
    failed += assertB(!(localLtA > localLtB), "T429_lt_greater_false")
    failed += assertB(localLtA <= localLtB, "T429_lt_le_true")
    failed += assertB(!(localLtA >= localLtB), "T429_lt_ge_false")
    failed += assertB(localLtA.compare(localEq) == Ordering.EQ, "T429_compare_eq")
    failed += assertB(localLtA == localEq, "T429_eq_equal_true")
    failed += assertB(!(localLtA < localEq), "T429_eq_less_false")
    failed += assertB(!(localLtA > localEq), "T429_eq_greater_false")
    failed += assertB(localLtA <= localEq, "T429_eq_le_true")
    failed += assertB(localLtA >= localEq, "T429_eq_ge_true")
    failed += assertB(localLtB.compare(localLtA) == Ordering.GT, "T429_compare_gt")
    failed += assertB(!(localLtB == localLtA), "T429_gt_equal_false")
    failed += assertB(!(localLtB < localLtA), "T429_gt_less_false")
    failed += assertB(localLtB > localLtA, "T429_gt_greater_true")
    failed += assertB(!(localLtB <= localLtA), "T429_gt_le_false")
    failed += assertB(localLtB >= localLtA, "T429_gt_ge_true")

    // T430: each default local path is tested in its own try/catch.
    let missingA: T430NoLocalCompareKey @local? = T430NoLocalCompareKey("a")
    let missingB: T430NoLocalCompareKey @local? = T430NoLocalCompareKey("b")
    failed += assertB(t430Compare(missingA, missingB), "T430_compare_default_throws")
    failed += assertB(t430Equal(missingA, missingB), "T430_equal_default_throws")
    failed += assertB(t430Less(missingA, missingB), "T430_less_default_throws")
    failed += assertB(t430Greater(missingA, missingB), "T430_greater_default_throws")
    failed += assertB(t430LessOrEqual(missingA, missingB), "T430_le_default_throws")
    failed += assertB(t430GreaterOrEqual(missingA, missingB), "T430_ge_default_throws")

    // T431: heap hash, missing-local default, generic local hash, and String
    // Hashable interface dispatch. No algorithmic hash constant is pinned.
    let hashHeapA = T431HashKey("ab")
    let hashHeapB = T431HashKey("ab")
    failed += assertEq(hashHeapA.hashCode(), hashHeapB.hashCode(), "T431_heap_equal_hash")
    failed += assertEq(hashHeapA.hashCode(), 2, "T431_heap_hash_value")
    let hashHalf: T431HashKey @local? = hashHeapA
    failed += assertB(t431GenericHash(hashHalf) == 2, "T431_generic_local_hash")
    let missingHash: T431MissingHash @local? = T431MissingHash()
    failed += assertB(t431MissingHashDefault(missingHash), "T431_missing_local_hash_throws")
    let firstString: String @local! = "ab"
    let secondString: String @local! = "ab"
    failed += assertB(t431StringInterfaceHash(firstString, secondString), "T431_string_interface_hash")

    // T432's missing-local default is also kept beside the Comparable/Hashable
    // default paths as an interface contract probe.
    let missingText: T432MissingToString @local? = T432MissingToString()
    failed += assertB(t432MissingToStringDefault(missingText), "T432_missing_local_tostring_throws")

    // T434: heap static receiver keeps the original compare overload. The
    // String Comparable<String> @local? matrix is isolated in the blocked probe
    // because this SDK dispatches it to the default UnImplemented body.
    let heapComparable: Comparable<String> = "a"
    failed += assertEq(heapComparable.compare("b"), Ordering.LT, "T434_heap_receiver_lt")
    // T429: String 经 `Comparable<String> @local?` 静态接收者的 compare 分派到
    // String 的 local 覆写，结果与 heap 路径一致。
    failed += assertEq(t429CompareHalf("a", "b"), 0, "T429_half_receiver_lt")
    failed += assertEq(t429CompareHalf("b", "a"), 2, "T429_half_receiver_gt")
    failed += assertEq(t429CompareHalf("a", "a"), 1, "T429_half_receiver_eq")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}

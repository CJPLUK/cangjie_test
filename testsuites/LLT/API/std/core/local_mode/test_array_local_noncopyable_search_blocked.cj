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
// 2026-09-28 已解锁（T134 恢复 EXEC）：七个 `Array<T> @local?` 搜索重载改为
// **就地循环**实现（arrayGetUnchecked3 + == @local?），约束从
// `T <: Copyable & Equatable<T>` 收窄为仅 `T <: Equatable<T>`——本用例的
// non-Copyable、Equatable-by-id Box（target 的 tag 与 receiver 中不同）现已通过。
// 设计期望（裸 Option<Int64>）：indexOf(target,2)=Some(2)，indexOf([2,3])=Some(2)，
// indexOf([2,3],3)=Some(4)，lastIndexOf(target)=Some(4)，
// lastIndexOf(target,2)=Some(4)，lastIndexOf([2,3])=Some(4)，
// lastIndexOf([2,3],1)=Some(4)。
// 设计编号命名空间：LM-DOC-20260910。

main(): Int64 {
    var failed = 0

    // Box is deliberately a class (therefore non-Copyable) and equality ignores tag.
    let source134: Array<Box> @local? = [
        Box(1, "one"),
        Box(2, "first"),
        Box(2, "second"),
        Box(3, "three"),
        Box(2, "last"),
        Box(3, "last-three")
    ]
    let target134: Box @local? = Box(2, "different-tag")
    let needle134: Array<Box> @local? = [Box(2, "needle-two"), Box(3, "needle-three")]

    // T134: exactly the seven closed-loop search overloads.
    let indexScalar134: Option<Int64> = source134.indexOf(target134, 2)
    failed += assertEq(indexScalar134, Some<Int64>(2), "T134_indexOf_scalar_from2")
    let indexNeedle134: Option<Int64> = source134.indexOf(needle134)
    failed += assertEq(indexNeedle134, Some<Int64>(2), "T134_indexOf_subarray")
    let indexNeedleFrom134: Option<Int64> = source134.indexOf(needle134, 3)
    failed += assertEq(indexNeedleFrom134, Some<Int64>(4), "T134_indexOf_subarray_from3")
    let lastScalar134: Option<Int64> = source134.lastIndexOf(target134)
    failed += assertEq(lastScalar134, Some<Int64>(4), "T134_lastIndexOf_scalar")
    let lastScalarFrom134: Option<Int64> = source134.lastIndexOf(target134, 2)
    failed += assertEq(lastScalarFrom134, Some<Int64>(4), "T134_lastIndexOf_scalar_from2")
    let lastNeedle134: Option<Int64> = source134.lastIndexOf(needle134)
    failed += assertEq(lastNeedle134, Some<Int64>(4), "T134_lastIndexOf_subarray")
    let lastNeedleFrom134: Option<Int64> = source134.lastIndexOf(needle134, 1)
    failed += assertEq(lastNeedleFrom134, Some<Int64>(4), "T134_lastIndexOf_subarray_from1")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}

class Box <: Equatable<Box> {
    let id: Int64
    let tag: String

    init(id: Int64, tag: String) {
        this.id = id
        this.tag = tag
    }

    public operator func ==(other: Box): Bool {
        this.id == other.id
    }

    // 2026-09-28：indexOf/lastIndexOf @local? 就地比较需 == @local? 适配（见用例头部说明）。
    public operator func ==(this @local?, other: Box @local?): Bool {
        this.id == other.id
    }
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// UPDATE 2026-09-11: SDK local_mode-localmods-20260911-final 已修复本文件原阻塞器，恢复 EXEC（原阻塞记录见下）。
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// BLOCKED-SOURCE（设计项 LM-DOC-20260910：T132/T133）：闭环要求
// `Array<T> @local?` 上恰好 7 个搜索重载并返回裸 Option<Int64>。当前目标
// 0907 SDK 没有这些 local? 成员的链接/声明对齐；编译诊断表现为
// `mismatched types`（receiver expected non-local Array）/`no matching function`
// 而不是运行时失败。保留每个 typed needle、精确 Some/None payload、from 边界、
// empty/too-long 以及 KeyC equal-id 期望；SDK 对齐后恢复 EXEC。不要把原先
// 未列入闭环的单参数 `indexOf(x)` sugar 当作这 7 个目标重载。
// 设计编号命名空间：LM-DOC-20260910。

main(): Int64 {
    var failed = 0

    // T132: the seven and only seven target search overloads, with typed needles.
    let source132: Array<Int64> @local? = [1, 2, 2, 3, 2, 3]
    let scalarTwo132: Int64 @local? = 2
    let needleTwoThree132: Array<Int64> @local? = [2, 3]
    let result132_1: Option<Int64> = source132.indexOf(scalarTwo132, 2)
    failed += assertEq(result132_1, Some<Int64>(2), "T132_indexOf_scalar_from2")
    let result132_2: Option<Int64> = source132.indexOf(needleTwoThree132)
    failed += assertEq(result132_2, Some<Int64>(2), "T132_indexOf_subarray")
    let result132_3: Option<Int64> = source132.indexOf(needleTwoThree132, 3)
    failed += assertEq(result132_3, Some<Int64>(4), "T132_indexOf_subarray_from3")
    let result132_4: Option<Int64> = source132.lastIndexOf(scalarTwo132)
    failed += assertEq(result132_4, Some<Int64>(4), "T132_lastIndexOf_scalar")
    let result132_5: Option<Int64> = source132.lastIndexOf(scalarTwo132, 3)
    failed += assertEq(result132_5, Some<Int64>(4), "T132_lastIndexOf_scalar_from3")
    let result132_6: Option<Int64> = source132.lastIndexOf(needleTwoThree132)
    failed += assertEq(result132_6, Some<Int64>(4), "T132_lastIndexOf_subarray")
    let result132_7: Option<Int64> = source132.lastIndexOf(needleTwoThree132, 3)
    failed += assertEq(result132_7, Some<Int64>(4), "T132_lastIndexOf_subarray_from3")

    // T133: empty receiver, empty/too-long typed needles, absent values, from=-1
    // clamping, from=size early return, and a typed custom equality key.
    let empty133: Array<Int64> @local? = []
    let emptyNeedle133: Array<Int64> @local? = []
    let tooLong133: Array<Int64> @local? = [1, 2, 3, 4, 5, 6, 7]
    let scalarOne133: Int64 @local? = 1
    let scalarTwo133: Int64 @local? = 2
    failed += assertEq(empty133.indexOf(needleTwoThree132), None<Int64>,
        "T133_empty_indexOf_nonempty_needle")
    failed += assertEq(empty133.lastIndexOf(needleTwoThree132), None<Int64>,
        "T133_empty_lastIndexOf_nonempty_needle")
    failed += assertEq(source132.indexOf(emptyNeedle133), Some<Int64>(0),
        "T133_indexOf_empty_needle")
    failed += assertEq(source132.lastIndexOf(emptyNeedle133), Some<Int64>(6),
        "T133_lastIndexOf_empty_needle_size")
    failed += assertEq(source132.indexOf(tooLong133), None<Int64>,
        "T133_indexOf_too_long_needle")
    failed += assertEq(source132.lastIndexOf(tooLong133), None<Int64>,
        "T133_lastIndexOf_too_long_needle")
    failed += assertEq(source132.indexOf(scalarOne133, -1), Some<Int64>(0),
        "T133_indexOf_negative_from_clamp0")
    failed += assertEq(source132.lastIndexOf(scalarOne133, -1), Some<Int64>(0),
        "T133_lastIndexOf_negative_from_clamp0")
    failed += assertEq(source132.indexOf(scalarTwo133, source132.size), None<Int64>,
        "T133_indexOf_from_size_none")
    failed += assertEq(source132.lastIndexOf(scalarTwo133, source132.size), None<Int64>,
        "T133_lastIndexOf_from_size_none")
    failed += assertEq(empty133.indexOf(scalarTwo133, -1), None<Int64>,
        "T133_empty_scalar_from_negative_none")
    failed += assertEq(empty133.lastIndexOf(scalarTwo133, -1), None<Int64>,
        "T133_empty_last_scalar_from_negative_none")

    // KeyC's tag differs while id is equal; search must use KeyC's own equality.
    let keys133: Array<KeyC> @local? = [KeyC(1, 10), KeyC(2, 20),
        KeyC(2, 30), KeyC(3, 40), KeyC(2, 50)]
    let keyTarget133: KeyC @local? = KeyC(2, 99)
    let keyResult133: Option<Int64> = keys133.indexOf(keyTarget133, -1)
    failed += assertEq(keyResult133, Some<Int64>(1), "T133_key_equal_id_index")
    let keyLast133: Option<Int64> = keys133.lastIndexOf(keyTarget133)
    failed += assertEq(keyLast133, Some<Int64>(4), "T133_key_equal_id_last")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}

struct KeyC <: Copyable & Equatable<KeyC> {
    let id: Int64
    let tag: Int64

    init(id: Int64, tag: Int64) {
        this.id = id
        this.tag = tag
    }

    public operator func ==(other: KeyC): Bool {
        this.id == other.id
    }

    // 2026-09-28：indexOf/lastIndexOf @local? 改为就地比较后走 == @local? 分派，
    // 元素类型必须自行适配（否则落 Equal 默认体抛 UnimplementedException）。
    public operator func ==(this @local?, other: KeyC @local?): Bool {
        this.id == other.id
    }
}

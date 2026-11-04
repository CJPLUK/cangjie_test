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
// 覆盖设计项（LM-DOC-20260910）：T129 读侧模式/类型矩阵。
// 本文件只使用无副作用的 local? 读取与 size/isEmpty，避免把当前 local-object
// 写屏障误计为模式判断失败。Int64 读取验证 Copyable local? 的精确槽；String
// Array 的 size/isEmpty 验证 non-Copyable 元素不会被 Copyable 隐式转换掩盖。
// T129 的两个静态负例在独立文件中：
// test_array_local_neg_noncopyable_q_write.cj 与
// test_array_local_neg_local_bang_assign.cj。
// 设计编号命名空间：LM-DOC-20260910。

main(): Int64 {
    var failed = 0

    // T129: Copyable Array<Int64> local? receiver and local? element read.
    let copyable129: Array<Int64> @local? = [10, 20]
    let copyableValue129: Int64 @local? = copyable129[1]
    failed += assertEq(copyableValue129, 20, "T129_copyable_localQuestion_read")
    failed += assertEq(copyable129.size, 2, "T129_copyable_localQuestion_size")
    failed += assertB(!copyable129.isEmpty(), "T129_copyable_localQuestion_nonempty")

    // T129: non-Copyable String elements distinguish the mode contract from the
    // Copyable Int64 case. These read-only properties preserve exact receiver modes.
    let stringBang129: Array<String> @local! = ["left", "right"]
    let stringQuestion129: Array<String> @local? = stringBang129
    failed += assertEq(stringBang129.size, 2, "T129_nonCopyable_localBang_size")
    failed += assertEq(stringQuestion129.size, 2, "T129_nonCopyable_localQuestion_size")
    failed += assertB(!stringBang129.isEmpty(), "T129_nonCopyable_localBang_nonempty")
    failed += assertB(!stringQuestion129.isEmpty(), "T129_nonCopyable_localQuestion_nonempty")
    let stringClone129: Array<String> @local! = stringBang129.clone()
    failed += assertEq(stringClone129.size, 2, "T129_nonCopyable_clone_localBang_size")
    let emptyString129: Array<String> @local? = []
    failed += assertB(emptyString129.isEmpty(), "T129_nonCopyable_empty_localQuestion")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}

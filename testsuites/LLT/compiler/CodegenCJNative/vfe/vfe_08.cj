/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// 端端看护：编译器信息配对槽（ET_FLAG != 0，FuncTable 为 [2 x i8*]：槽位函数 +
// _GetOuterTiFn 伴生函数）形状。伴生函数体经 CJ_MCC_GetOrCreateTypeInfo 拉活目标
// 类型，其依赖边锚在 FT 自身：链活 ⇒ FT 活 ⇒ 伴生活（可被派发时必须可达）。
// 泛型类实现接口的 std.core Iterator 适配器形状下，两条链都活且都实际派发，
// 运行期必须全部正确；若伴生/配对标记丢失，dispatch 到空槽即 SIGSEGV。
// "死链的 FT/伴生随链删除"由 lit 用例 cangjie-vfe-pair-anchor.ll 锁定。

// EXEC: %compiler %cmp_opt %enableO2 %disableReflection %disableDevirtualization --lto=full %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan-begin C<T>::next
// ASSERT: scan-next D<T>::next
// ASSERT: scan-next D<T>::next

interface I {
    func next(): Unit
}

class C<T> <: I {
    public func next(): Unit { println("C<T>::next") }
}

class D<T> <: I {
    public func next(): Unit { println("D<T>::next") }
}

func drive(x: I) { x.next() }

main(): Unit {
    let c = C<Int64>()
    let d = D<Int64>()
    drive(c) // C 链：经调用点标记，配对随 FT 活
    drive(d) // D 链：同上
    d.next() // D 链直接分发
}

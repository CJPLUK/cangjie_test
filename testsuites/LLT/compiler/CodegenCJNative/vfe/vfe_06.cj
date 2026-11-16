/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// 端端看护：同一接口根下多个实现 × 三种通配形态调用点（具体 / 前位通配 / 后位通配）
// 共存。VFE 的位置对齐匹配必须把每条被调链都标记到位；若出现"通配占位被跳过导致
// 后续参数整体前移"的旧解码器缺陷，被调实现将拿到全零 mtable，运行期 SIGSEGV。
// 未被调用的 S 实现链应被整体删除（其存活不影响本用例的正确性判定）。

// EXEC: %compiler %cmp_opt %enableO2 %disableReflection %disableDevirtualization --lto=full %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan-begin P::foo
// ASSERT: scan-next P::bar
// ASSERT: scan-next Q::foo
// ASSERT: scan-next Q::bar
// ASSERT: scan-next R::foo
// ASSERT: scan-next R::bar

interface I2<M, N> {
    func foo(): Unit
    func bar(): Unit
}

class S <: I2<Int64, String> { // 从未被调用的实现，其类型链应被 VFE 删除
    public func foo(): Unit { println("S::foo") }
    public func bar(): Unit { println("S::bar") }
}

class P <: I2<Int64, String> { // 双侧具体
    public func foo(): Unit { println("P::foo") }
    public func bar(): Unit { println("P::bar") }
}

class Q<T> <: I2<T, String> { // 前位通配 def：I2<$g, String>
    public func foo(): Unit { println("Q::foo") }
    public func bar(): Unit { println("Q::bar") }
}

class R<T> <: I2<Int64, T> { // 后位通配 def：I2<Int64, $g>
    public func foo(): Unit { println("R::foo") }
    public func bar(): Unit { println("R::bar") }
}

func site1(x: I2<Int64, String>) { x.foo(); x.bar() } // 全具体调用点
func site2<T>(x: I2<T, String>) { x.foo(); x.bar() }  // 通配在位 0 的调用点
func site3<T>(x: I2<Int64, T>) { x.foo(); x.bar() }   // 通配在位 1 的调用点

main(): Unit {
    site1(P())
    site2(Q<Int64>())
    site3(R<String>())
}

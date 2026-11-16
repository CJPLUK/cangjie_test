/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// 端端看护：未被任何实现覆写的默认接口方法，经通配调用点（泛型函数）分发。
// 该 mtable 表项在 def/调用点之外没有任何直接引用，存活完全依赖 VFE 按模式
// 匹配补出的依赖边；旧解码器"跳过通配导致移位漏标"时，此表项被清零、
// dispatch 落到空指针，运行期 SIGSEGV。

// EXEC: %compiler %cmp_opt %enableO2 %disableReflection %disableDevirtualization --lto=full %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan-begin IDefault::present
// ASSERT: scan-next OnlyDefault::tag
// ASSERT: scan-next Overridden::present
// ASSERT: scan-next Overridden::tag

interface IDefault<M, N> {
    func present(): Unit { println("IDefault::present") } // 仅默认实现，无人覆写
    func tag(): Unit
}

class OnlyDefault<T> <: IDefault<T, Int64> { // 不覆写 present
    public func tag(): Unit { println("OnlyDefault::tag") }
}

class Overridden<T> <: IDefault<T, Int64> { // 覆写 present
    public func present(): Unit { println("Overridden::present") }
    public func tag(): Unit { println("Overridden::tag") }
}

func driveDefault<T>(x: IDefault<T, Int64>) { x.present() } // 通配在位 0
func driveTag<T>(x: IDefault<T, Int64>) { x.tag() }

main(): Unit {
    let a = OnlyDefault<Int64>()
    let b = Overridden<Int64>()
    driveDefault(a) // 走 IDefault::present 默认实现的 mtable 表项
    driveTag(a)
    driveDefault(b)
    driveTag(b)
}

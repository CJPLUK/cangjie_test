// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output | compare %f
// ASSERT: scan-2 member value: 7

public open class Base {
    public var value: Int64 = 7
    public init() {}
    public exclave init(this @local!) {}
}

public class Derived <: Base {
    public init() { super() }
    public exclave init(this @local!) { super() }
}

public class Container<T> where T <: Base {
    public var element: T
    public init(element: T) { this.element = element }
}

@Frozen
public func read<T>(value: Container<T>): Int64 where T <: Base {
    value.element.value
}

@Frozen
public func readLocal<T>(value: T@local!): Int64 where T <: Derived {
    value.value
}

main() {
    println("member value: ${read(Container(Derived()))}")
    let local: Derived@local! = Derived()
    println("member value: ${readLocal(local)}")
}

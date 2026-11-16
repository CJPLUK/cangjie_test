// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

struct Hat<T> {
    let t: T
    init(t: T) { this.t = t }
}
extend<T> Hat<T> <: Copyable where T <: Copyable {}

struct Range<T> {
    let start: T
    init(start: T) { this.start = start }
}

struct Map<T, V> {
    let m: T
    let v: V 
    init(m: T, v: V) {
        this.m = m
        this.v = v
    }
}

extend<A,B> Map<A,B> <: Copyable where A <: Copyable , B <: Copyable {}

extend<A,B> Range<Map<A,B>> <: Copyable where A <: Copyable , B <: Copyable {}
main() {
    let m: Map<Int64, String> @local! = Map<Int64, String>(1, "1")
    let r: Range<Map<Int64, String>> = Range<Map<Int64, String>>(m)
}

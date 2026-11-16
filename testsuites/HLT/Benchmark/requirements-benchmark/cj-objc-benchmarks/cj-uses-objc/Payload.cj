// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package objc.sample

func blackhole (iters: Int64) : Int64 {
    let m = iters
    let p = 1000 * 1000 * 1000 + 7
    var x = p
    if (iters == 0) {
        return x + 1
    }
    var s = p % m
    while (s != 0) {
        s = (s + p) % m
        x ^= x << 13
        x ^= x >> 7
        x ^= x << 17
        x ^= x << 19
        x ^= x >> 11
        x ^= x << 17
        x ^= x << 3
        x ^= x >> 11
        x ^= x << 7
        x ^= x << 5
        x ^= x >> 23
        x ^= x << 9
    }
    x + 1
}

public open class Payload {

    public static func staticBlackhole(iters: Int64) : Int64 {
        blackhole(iters)
    }

    public func instanceBlackhole(iters: Int64) : Int64 {
        blackhole(iters)
    }

    public open func virtualBlackhole(iters: Int64) : Int64 {
        blackhole(iters)
    }

    private static let instance = Payload()

    public static func get(): Payload {
        instance
    }
}

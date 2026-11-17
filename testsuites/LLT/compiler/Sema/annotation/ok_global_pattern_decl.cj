// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

import std.reflect.*

const K: Int64 = 42

@Annotation
public class Anno {
    public let x: Int64
    public const init(x: Int64) {
        this.x = x
    }
}

@Anno[K]
public let (a, b) = (1, 2)

main(): Int64 {
    let pkg = PackageInfo.get("default")
    let annoA = pkg.getVariable("a").findAnnotation<Anno>()
    let annoB = pkg.getVariable("b").findAnnotation<Anno>()
    if (a != 1 || b != 2) {
        return 1
    }
    if (annoA.isNone() || annoB.isNone()) {
        return 2
    }
    if (annoA.getOrThrow().x != K || annoB.getOrThrow().x != K) {
        return 3
    }
    return 0
}

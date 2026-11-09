// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A bare literal keeps its own default type (Int64 here) instead of adopting the expected type: the
// pending state is not carried by a function type, so the expectation only bounds the literal's
// default. The instantiations are counted per expected type, so one of the two sites below that
// keeps the Int64 default can no longer regress unnoticed.

// EXEC: %compiler %local %noColor %cmp_opt %compile_lib_opt %f -Woff all --dump-chir --dump-to-screen | compare %f

func id<T>(x: T): T { x }

// The expectation comes from the enclosing function's return type.
func viaInterface(): ToString {
    id(1)
}

main() {
    // The expectation comes from the variable's annotation.
    let annotated: ToString = id(1)
    // A numeric expectation is still adopted, so this site instantiates Int8 and is counted apart.
    let sized: Int8 = id(1)
    println(viaInterface())
    println(annotated)
    println(sized)
    return 0
}

// ASSERT: scan-2 Int64 = Apply(
// ASSERT: scan-1 Int8 = Apply(

// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Nested @local? functions create multiple region scopes in one enclosing frame.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan nested same frame: 60

class LocalValue {
    var value: Int64

    exclave init(this @local?, value: Int64) {
        this.value = value
    }
}

func nestedScopes(): Int64 {
    var sum: Int64 = 0
    let outer: LocalValue @local? = LocalValue(10) @local?

    @local? func middleScope() {
        let middle: LocalValue @local? = LocalValue(20) @local?

        @local? func innerScope() {
            let inner: LocalValue @local? = LocalValue(30) @local?
            sum += inner.value
        }

        innerScope()
        sum += middle.value
    }

    middleScope()
    sum + outer.value
}

main(): Unit {
    println("nested same frame: ${nestedScopes()}")
}

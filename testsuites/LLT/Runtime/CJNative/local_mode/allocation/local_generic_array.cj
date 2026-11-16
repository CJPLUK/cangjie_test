// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Allocate Array<T> in local mode while T is still a generic type parameter,
// forcing the llvm.cj.malloc.local.array.generic allocation path.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan local generic array size: 3

class GenericPayload {
    let value: Int64

    init(value: Int64) {
        this.value = value
    }

}

func makeGenericArray<T>(value: T): Array<T> @local? {
    exclave { [value, value, value] }
}

main(): Unit {
    let values = makeGenericArray<GenericPayload>(GenericPayload(8))
    println("local generic array size: ${values.size}")
}

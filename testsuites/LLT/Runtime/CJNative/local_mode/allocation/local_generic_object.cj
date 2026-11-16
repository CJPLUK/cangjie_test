// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Exercise local allocation of a generic class from a generic function.
// The compiler emits llvm.cj.alloca.local.generic for this source construct;
// current LLVM lowering routes it to CJ_MCC_NewLocalObject.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan local generic object: 37

class GenericPayload {
    let value: Int64

    init(value: Int64) {
        this.value = value
    }
}

class GenericBox<T> {
    var value: T

    exclave init(this @local?, value: T) {
        this.value = value
    }
}

func makeGenericBox<T>(value: T): GenericBox<T> @local? {
    exclave { GenericBox<T>(value) }
}

main(): Unit {
    let box = makeGenericBox<GenericPayload>(GenericPayload(37))
    println("local generic object: ${box.value.value}")
}

// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
interface I<T> {
    prop value: T @local?
}
class C<T> <: I<T> {
    public prop value: T @local? {
        get() {
            throw Exception()
        }
    }
}

class E <: I<String> {
    public prop value: String @local? {
        get() {
            exclave {"haha"}
        }
    }
}

struct D<S> {}
extend<P> D<P> <: I<P> {
    public prop value: P @local? {
        get() {
            throw Exception()
        }
    }
}

main() {}

// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %enableEH %cmp_opt %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output

// In a handler of a command with result type Extern<T>, `resume with v` is desugared into
// ImmediateHandlerReturn<Extern<T>>.Result(v). The type argument Extern<T> is given explicitly, so that
// a value v of another type is converted with T.toExtern(v) instead of being used to infer
// ImmediateHandlerReturn<typeof(v)>.

import stdx.effect.Command

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(_: Extern<DummyRT>, _: String): Extern<DummyRT> {
        throw Exception("memberAccess not implemented")
    }
    public static func indexedAccess(_: Extern<DummyRT>, _: Any): Extern<DummyRT> {
        throw Exception("indexedAccess not implemented")
    }
    public static func memberUpdate(_: Extern<DummyRT>, _: String, _: Any): Unit {
        throw Exception("memberUpdate not implemented")
    }
    public static func indexedUpdate(_: Extern<DummyRT>, _: Any, _: Any): Unit {
        throw Exception("indexedUpdate not implemented")
    }
    public static func functionCall(_: Extern<DummyRT>, _: Array<Any>): Extern<DummyRT> {
        throw Exception("functionCall not implemented")
    }
    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        (Extern.getPayload(e) as R).getOrThrow()
    }
    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>(v)
    }
}

class GetExtern <: Command<Extern<DummyRT>> {
    GetExtern(let converted: Bool) {}
}

func payload(e: Extern<DummyRT>): Int64 {
    DummyRT.fromExtern<Int64>(e)
}

func run(converted: Bool): Int64 {
    try {
        payload(perform GetExtern(converted))
    } handle(cmd: GetExtern) {
        if (cmd.converted) {
            resume with 7
        } else {
            resume with Extern<DummyRT>(8)
        }
    }
}

main(): Int64 {
    if (run(true) != 7 || run(false) != 8) {
        return 1
    }
    return 0
}

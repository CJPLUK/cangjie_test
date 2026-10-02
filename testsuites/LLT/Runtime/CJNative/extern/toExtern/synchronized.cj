// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.collection.*
import std.sync.*

let mtx = Mutex()

public class DummyRT <: ForeignRuntime<DummyRT> {
    // Whether the mutex was free during each conversion, as seen from another thread.
    public static var mutexFree: ArrayList<Bool> = ArrayList<Bool>()

    public static func eval(t: Extern<DummyRT>): Extern<DummyRT> {
        t
    }

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        match (e) {
            case ExternPayload(value) => (value as R).getOrThrow()
            case _ => throw ExternConversionException("not a payload")
        }
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        let free = spawn {
            let locked = mtx.tryLock()
            if (locked) {
                mtx.unlock()
            }
            locked
        }.get()
        mutexFree.add(free)
        Extern<DummyRT>.ExternPayload(v)
    }
}

func check(cond: Bool, msg: String): Unit {
    if (!cond) {
        throw Exception(msg)
    }
}

func syncBody(): Extern<DummyRT> {
    synchronized (mtx) { 2 }
}

main() {
    // The whole synchronized expression is converted, after the lock is released.
    let v: Extern<DummyRT> = synchronized (mtx) { 1 }
    check(DummyRT.mutexFree.toArray() == [true], "initializer: ${DummyRT.mutexFree}")
    check(DummyRT.fromExtern<Int64>(v) == 1, "initializer value")

    DummyRT.mutexFree.clear()
    let r = syncBody()
    check(DummyRT.mutexFree.toArray() == [true], "function body: ${DummyRT.mutexFree}")
    check(DummyRT.fromExtern<Int64>(r) == 2, "function body value")

    // A conversion written inside the body still runs while the lock is held.
    DummyRT.mutexFree.clear()
    let inside = synchronized (mtx) { DummyRT.toExtern<Int64>(3) }
    check(DummyRT.mutexFree.toArray() == [false], "explicit conversion: ${DummyRT.mutexFree}")
    check(DummyRT.fromExtern<Int64>(inside) == 3, "explicit conversion value")
    0
}

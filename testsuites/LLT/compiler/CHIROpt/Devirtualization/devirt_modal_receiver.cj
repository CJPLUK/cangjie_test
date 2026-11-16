// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Generic receivers keep the member callee generic during devirtualization. Both class casts and
// struct unboxing must retain the receiver modal required by the target method.
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %local %cmp_opt %enableDevirtualization %dumpCHIRDebug --output-type=staticlib %f -o %output -O2
// EXEC: %python pick_defination.py devirt_modal_receiver_CHIR/[0-9]*_Devirtualization.chirtxt "Func @_CN7default10localClassIG_Hv" | compare %f
// ASSERT: scan Apply(Class-_CN7default9LocalViewIG_E<
// ASSERT: scan-not Invoke(

interface View<T> {
    func get(this @local!): Int64
    func get(this @local?): Int64
}

class LocalView<T> <: View<T> {
    public exclave init(this @local!) {}

    public func get(this @local!): Int64 { 1 }
    public func get(this @local?): Int64 { 2 }
}

struct LocalValue<T> <: View<T> {
    public exclave init(this @local!) {}

    public func get(this @local!): Int64 { 3 }
    public func get(this @local?): Int64 { 4 }
}

@Frozen
public func localClass<T>(): Int64 {
    let view: View<T> @local! = LocalView<T>()
    view.get()
}

@Frozen
public func maybeLocalClass<T>(): Int64 {
    let view: View<T> @local? = LocalView<T>()
    view.get()
}

@Frozen
public func localStruct<T>(): Int64 {
    let view: View<T> @local! = LocalValue<T>()
    view.get()
}

@Frozen
public func maybeLocalStruct<T>(): Int64 {
    let view: View<T> @local? = LocalValue<T>()
    view.get()
}

@Frozen
public func localClassInTry<T>(): Int64 {
    let view: View<T> @local! = LocalView<T>()
    try {
        view.get()
    } catch (_: Exception) {
        0
    }
}

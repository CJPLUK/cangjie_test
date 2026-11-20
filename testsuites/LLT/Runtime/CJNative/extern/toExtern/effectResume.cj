// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %enableEH %cmp_opt %f -o %output
// EXEC: %run %set_stdx_path %run_opt %output %run_args

// `resume with v` is checked against the result type of the command, so a value is converted when that type is or
// contains Extern<T>. The other command types are resumed as before.

import stdx.effect.Command

var conversions = 0

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func memberAccess(e: Extern<DummyRT>, field: String): Extern<DummyRT> {
        throw ExternMemberAccessException(field)
    }

    public static func indexedAccess(e: Extern<DummyRT>, arg: Any): Extern<DummyRT> {
        throw ExternIndexedAccessException()
    }

    public static func memberUpdate(e: Extern<DummyRT>, field: String, value: Any): Unit {
        throw ExternMemberAccessException(field)
    }

    public static func indexedUpdate(e: Extern<DummyRT>, field: Any, value: Any): Unit {
        throw ExternIndexedAccessException()
    }

    public static func functionCall(e: Extern<DummyRT>, args: Array<Any>): Extern<DummyRT> {
        throw ExternFunctionCallException()
    }

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        (Extern.getPayload(e) as R).getOrThrow()
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        conversions++
        Extern<DummyRT>(v)
    }
}

class AskExtern <: Command<Extern<DummyRT>> {}

class AskPair <: Command<(Extern<DummyRT>, Int64)> {}

class AskList <: Command<Array<Extern<DummyRT>>> {}

class AskInt <: Command<Int64> {}

open class Animal {
    public open func name(): String {
        "animal"
    }
}

class Dog <: Animal {
    public override func name(): String {
        "dog"
    }
}

class AskAnimal <: Command<Animal> {}

class Counter {
    var count = 0
}

func expect(n: Int64, what: String): Unit {
    if (conversions != n) {
        throw Exception(what + ": expected ${n} conversions but got ${conversions}")
    }
    conversions = 0
}

func check(cond: Bool, what: String): Unit {
    if (!cond) {
        throw Exception(what)
    }
}

func askTwice(): Int64 {
    let first = perform AskExtern()
    let second = perform AskExtern()
    DummyRT.fromExtern<Int64>(first) + DummyRT.fromExtern<Int64>(second)
}

main() {
    let value = try {
        DummyRT.fromExtern<Int64>(perform AskExtern())
    } handle (_: AskExtern) {
        resume with 1
    }
    expect(1, "resume with a value converted to Extern")
    check(value == 1, "resumed value")

    let text = try {
        DummyRT.fromExtern<String>(perform AskExtern())
    } handle (_: AskExtern) {
        let n = 2
        if (n > 1) {
            resume with "big"
        }
        resume with n
    }
    expect(1, "resume in a branch")
    check(text == "big", "resumed branch value")

    let counter = Counter()
    let sum = try {
        askTwice()
    } handle (_: AskExtern) {
        counter.count++
        resume with counter.count * 10
    }
    expect(2, "resume for each perform")
    check(sum == 30, "resumed values of each perform")

    let pair = try {
        let (e, n) = perform AskPair()
        DummyRT.fromExtern<Int64>(e) + n
    } handle (_: AskPair) {
        resume with (3, 4)
    }
    expect(1, "resume with a tuple")
    check(pair == 7, "resumed tuple")

    let size = try {
        (perform AskList()).size
    } handle (_: AskList) {
        resume with [1, "two", 3]
    }
    expect(3, "resume with an array literal")
    check(size == 3, "resumed array")

    let unchanged = try {
        DummyRT.fromExtern<Int64>(perform AskExtern())
    } handle (_: AskExtern) {
        resume with Extern<DummyRT>(5)
    }
    expect(0, "resume with an Extern value")
    check(unchanged == 5, "resumed Extern value")

    let plain = try {
        (perform AskInt()) + 1
    } handle (_: AskInt) {
        resume with 6
    }
    expect(0, "resume with Int64")
    check(plain == 7, "resumed Int64")

    let animal = try {
        (perform AskAnimal()).name()
    } handle (_: AskAnimal) {
        resume with Dog()
    }
    expect(0, "resume with a subclass")
    check(animal == "dog", "resumed subclass")
    0
}

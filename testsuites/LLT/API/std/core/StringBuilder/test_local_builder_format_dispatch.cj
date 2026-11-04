/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

var plainCalls: Int64 = 0
var localCalls: Int64 = 0
var missingPlainCalls: Int64 = 0
var throwingPlainCalls: Int64 = 0
var throwingLocalCalls: Int64 = 0

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

class ModeText <: ToString {
    public func toString(): String {
        plainCalls++
        "plain"
    }

    public func toString(this @local?): String @local! {
        exclave {
            localCalls++
            let text: String @local! = "local"
            text
        }
    }
}

class MissingLocalText <: ToString {
    public func toString(): String {
        missingPlainCalls++
        "missing-plain"
    }
}

class ThrowingLocalText <: ToString {
    public func toString(): String {
        throwingPlainCalls++
        "throwing-plain"
    }

    public func toString(this @local?): String @local! {
        exclave {
            throwingLocalCalls++
            throw ArithmeticException("format-sentinel")
        }
    }
}

main(): Int64 {
    let value = ModeText()
    let heapBuilder = StringBuilder()
    heapBuilder.append<ModeText>(value)
    check(heapBuilder.toString() == "plain" && plainCalls == 1 && localCalls == 0,
        "heap generic append must use plain formatting once")

    let builder: StringBuilder @local! = StringBuilder()
    builder.append("head:")
    let view: ModeText @local? = value
    builder.append<ModeText>(view)
    let first: String @local! = builder.toString()
    check(first == "head:local" && plainCalls == 1 && localCalls == 1,
        "local generic append must use local formatting once")

    let missing: MissingLocalText @local? = MissingLocalText()
    var caught = false
    try { builder.append<MissingLocalText>(missing) }
    catch (_: UnimplementedException) { caught = true }
    let afterMissing: String @local! = builder.toString()
    check(caught && missingPlainCalls == 0 && afterMissing == "head:local",
        "missing local formatting must throw without appending")

    let throwing: ThrowingLocalText @local? = ThrowingLocalText()
    caught = false
    try { builder.append<ThrowingLocalText>(throwing) }
    catch (e: ArithmeticException) { caught = e.message == "format-sentinel" }
    let afterThrow: String @local! = builder.toString()
    check(caught && throwingPlainCalls == 0 && throwingLocalCalls == 1 && afterThrow == "head:local",
        "local formatting exception must propagate once without appending")

    builder.append(":")
    builder.append<ModeText>(view)
    let finalText: String @local! = builder.toString()
    check(finalText == "head:local:local" && plainCalls == 1 && localCalls == 2,
        "local builder must remain usable after formatting exceptions")
    check(first == "head:local", "earlier formatting snapshot must remain unchanged")
    println("ALL PASSED")
    0
}

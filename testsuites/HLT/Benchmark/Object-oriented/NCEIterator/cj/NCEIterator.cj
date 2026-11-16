/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt -O2 %overflow_wrapping %f -o %output
// RUN-EXEC: %run %run_opt %output 3 %run_args

import std.collection.ArrayList
import std.convert.Parsable
import std.random.Random
import std.time.*

enum ElementKind {
   BEAN | PROPERTY | METHOD
}

let rand = Random(1)

var checkable_count = 0
var call_count = 0
var not_cascading = 0
var non_checkable_marked_count = 0

interface A {}

interface M_A <: A {
   func getKind(): ElementKind
   func getKindVerified(): ElementKind
   func isCascading(): Bool
   func isCascadingVerified(): Bool
   func isConstrained(): Bool
   func isConstrainedVerified(): Bool
}

abstract class M_A_A <: M_A {
    private let cascading: Bool
    private let constrained: Bool

    init() {
        cascading = rand.nextBool()
        constrained = rand.nextBool()
        if (cascading && constrained) {
            checkable_count++
        } else if (!cascading) {
            not_cascading++
        }
    }

    public func isCascading() {
        return cascading
    }

    public func isCascadingVerified() {
        call_count++
        return cascading
    }

    public open func isConstrained() {
        return constrained
    }

    public open func isConstrainedVerified() {
        call_count++
        return constrained
    }
}

open class M_A_A_A <: M_A_A {
    public open func getKind() {
        return BEAN
    }

    public open func getKindVerified() {
        call_count++
        return BEAN
    }
}

open class M_A_A_C <: M_A_A {
    public open func getKind() {
        return PROPERTY
    }

    public open func getKindVerified() {
        call_count++
        return PROPERTY
    }
}

open class M_A_A_B <: M_A_A {
    private let isKind: ElementKind

    init() {
        isKind = METHOD
    }

    public open func getKind() {
        return isKind
    }

    public open func getKindVerified() {
        call_count++
        return isKind
    }
}

abstract class N {
    protected let marker: Bool

    init() {
        marker = rand.nextBool()
    }

    public open func isMarked() {
        return marker
    }

    public open func isMarkedVerified() {
        call_count++
        return marker
    }
}

abstract class N_A_A <: N & M_A {
    private let cascading: Bool
    private let constrained: Bool

    init() {
        cascading = rand.nextBool()
        constrained = rand.nextBool()
        if (cascading && constrained) {
            checkable_count++
        } else {
            if (!cascading) {
                not_cascading++
            }
            if (marker) {
                non_checkable_marked_count++
            }
        }
    }

    public func isCascading() {
        return cascading
    }

    public func isCascadingVerified() {
        call_count++
        return cascading
    }

    public open func isConstrained() {
        return constrained
    }

    public open func isConstrainedVerified() {
        call_count++
        return constrained
    }
}

open class N_A_A_A <: N_A_A {
    public open func getKind() {
        return BEAN
    }

    public open func getKindVerified() {
        call_count++
        return BEAN
    }
}

var result = false
var items = 500
var iterations = 1000000

func verify(iterations: Int64, mAs: ArrayList<M_A>): UInt64 {
    func compute_marked_increment(maElement: M_A): UInt64 {
        match (maElement) {
            case n: N where n.isMarkedVerified() => 1
            case _ => 0
        }
    }

    var expected: UInt64 = 0
    var cascading_marked_count: UInt64 = 0
    var non_cascading_marked_count: UInt64 = 0
    var non_checkable_N_count: Int64 = 0

    if (items != mAs.size) {
        throw Exception("Wrong item count")
    }

    for (_ in 0..iterations) {
        var checked_count = 0

        for (j in 0..items) {
            let maElement = mAs[j]
            if (maElement.isCascadingVerified() && maElement.isConstrainedVerified()) {
                result = match (maElement.getKindVerified()) {
                    case PROPERTY => j % 2 == 0
                    case METHOD => j % 2 != 0 && j % 3 == 0
                    case BEAN => j % 20 == 0 || j % 2 != 0 && j % 3 != 0
                }

                if (!result) {
                    throw Exception("Wrong kind")
                }

                checked_count++

                result = match (maElement.getKindVerified()) {
                    case BEAN where j % 20 == 0 || j % 2 != 0 && j % 3 != 0 => false
                    case METHOD where j % 2 != 0 && j % 3 == 0 => false
                    case PROPERTY where j % 2 == 0 => false
                    case _ => true
                }

                if (result) {
                    throw Exception("Wrong kind")
                }

                checked_count++

                if (j % 20 != 0 && j % 2 == 0) {
                    expected = (expected << 1 | 1) % 9223372036854775783
                } else {
                    expected = (expected << 1) % 9223372036854775783
                }
            } else {
                match (maElement) {
                    case n: N => non_checkable_N_count++
                    case _ => ()
                }

                let increment = compute_marked_increment(maElement)
                if ((increment != 0) && (increment != 1)) {
                    throw Exception("Wrong increment")
                }

                // Assert that (increment == 1) => (j % 20 == 0)
                if ((increment != 0) && (j % 20 != 0)) {
                    throw Exception("Wrong element")
                }

                if (maElement.isCascadingVerified()) {
                    cascading_marked_count += increment
                } else {
                    non_cascading_marked_count += increment
                }
            }
        }

        if (checked_count != checkable_count * 2) {
            throw Exception("Wrong checked count")
        }
    }

    if (checkable_count > items) {
        throw Exception("Wrong checkable count")
    }

    if (not_cascading > items) {
        throw Exception("Wrong non-cascading count")
    }

    if (call_count != non_checkable_N_count + iterations * (not_cascading + (items - not_cascading) * 2 + checkable_count * 2 + (items - checkable_count))) {
        throw Exception("Wrong call count")
    }

    if (cascading_marked_count + non_cascading_marked_count > UInt64(non_checkable_N_count)) {
        throw Exception("Wrong non-checkable marked count")
    }

    if (cascading_marked_count + non_cascading_marked_count != UInt64(iterations * non_checkable_marked_count)) {
        throw Exception("Wrong non-checkable marked count")
    }

    if (cascading_marked_count > UInt64(iterations * (items - not_cascading))) {
        throw Exception("Wrong cascading marked count")
    }

    if (non_cascading_marked_count > UInt64(iterations * not_cascading)) {
        throw Exception("Wrong non-cascading marked count")
    }

    return expected ^ cascading_marked_count
}

func measure(expected: UInt64, mAs: ArrayList<M_A>) {
    var status = false
    var actual: UInt64 = 0
    var actual_marked_count: UInt64 = 0

    print("Benchmark started...", flush: true)
    let start = DateTime.now()

    for (_ in 0..iterations) {
        for (maElement in mAs) {
            status = maElement.isCascading()
            if (status) {
                status = status && maElement.isConstrained()
                if (status) {
                    // we have these two matches to get an additional virtual call (the target of this benchmark)
                    result = match (maElement.getKind()) {
                        case METHOD => true
                        case _ => false
                    }

                    result = match (maElement.getKind()) {
                        case PROPERTY => true
                        case _ => false
                    }

                    if (result) {
                        actual = (actual << 1 | 1) % 9223372036854775783
                    } else {
                        actual = (actual << 1) % 9223372036854775783
                    }
                } else {
                    match (maElement) {
                        case n: N where n.isMarked() => actual_marked_count++
                        case _ => ()
                    }
                }
            }
        }
    }

    let timeMs = (DateTime.now() - start).toMilliseconds()
    let result = actual ^ actual_marked_count
    if (result == expected) {
        println(" done. Total time: ${timeMs} ms")
    } else {
        println(" failed in ${timeMs} ms: expected ${expected}, actual ${result}.")
    }
}

main(args: Array<String>) {
    if (args.size > 3) {
      println("Usage: program <repeats> [items] [iterations]")
      println("   where default value of items is ${items}")
      println("     and default value of iterations is ${iterations}")
      return
    }

    let R = Int64.tryParse(args[0]).getOrThrow()

    if (args.size >= 2) {
      items = Int64.tryParse(args[1]).getOrThrow()
    }

    if (args.size >= 3) {
      iterations = Int64.tryParse(args[2]).getOrThrow()
    }

    let mAs = ArrayList<M_A>(items)

    for (i in 0..items) {
        if (i % 20 == 0) {
            mAs.add(N_A_A_A())
        } else if (i % 2 == 0) {
            mAs.add(M_A_A_C())
        } else if (i % 3 == 0) {
            mAs.add(M_A_A_B())
        } else {
            mAs.add(M_A_A_A())
        }
    }

    let expected = verify(iterations, mAs)

    for (_ in 0..R) {
      measure(expected, mAs)
    }
}

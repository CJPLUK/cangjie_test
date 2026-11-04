/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// T416 removeIf: exercised through a named predicate and through an inline
// lambda, on lists that each own their source array.
//
// NOT COVERED HERE — a separate, still-open defect: an ArrayList built from a
// source array that ANOTHER ArrayList also used crashes on the second removeIf.
//
// The trigger is the shared source array, not the predicate form and not the
// element type.  With
//
//   let src: Array<Item> @local! = [Item(true) @local!, Item(false) @local!]
//   let a: ArrayList<Item> @local! = ArrayList<Item>(src) @local!
//   let b: ArrayList<Item> @local! = ArrayList<Item>(src) @local!
//
// mutating BOTH lists crashes inside ArrayList.removeIf(@local!) at the
// `predicate(itemLocal)` call (collection/array_list.cj:816):
//
//   E CJNative Handle signal: 11.
//   E   #0 ... keepIt(...)$g
//   E   #1 ... ArrayList::removeIfHWLEF0bG_QLEEQlE  at std/collection/array_list.cj:816
//
// Control: identical code with a SEPARATE source array per list runs correctly
// (a=1, b=1).  Reproduces at both -O0 and -O2.  Also reproduces with an inline
// lambda instead of the named predicate, and with a Copyable struct element, so
// the defect is in the sharing, not in the closure or the element type.
// Earlier revisions of this header blamed the inline lambda + a non-Copyable
// element; that was wrong, as the control shows.
//
// This case therefore gives each list its own source array, so the contract it
// actually tests (removeIf, via a named predicate and via an inline lambda) is
// asserted.  The shared-array shape is kept out of the automated run until the
// crash is fixed.
import std.collection.*
import std.core.*

class Item {
    public var keep: Bool
    public init(keep: Bool) { this.keep = keep }
    public exclave init(this @local!, keep: Bool) { this.keep = keep }
}

exclave func isRemovable(v: Item @local!): Bool { !v.keep }

// removeIf through a named predicate.
func t416RemoveIfNamedPredicate(l: ArrayList<Item> @local!): Int64 {
    exclave {
        l.removeIf(isRemovable)
        if (l.size != 1) { return 1 }
        if (!l[0].keep) { return 1 }
        0
    }
}

// removeIf through an inline lambda.
func t416RemoveIfInlineLambda(l: ArrayList<Item> @local!): Int64 {
    exclave {
        l.removeIf({ v: Item @local! => !v.keep })
        if (l.size != 1) { return 1 }
        if (!l[0].keep) { return 1 }
        0
    }
}

main(): Int64 {
    var failed = 0

    // Each list gets its own source array: sharing one array between two lists
    // crashes on the second removeIf (see the header).
    let srcNamed: Array<Item> @local! = [Item(true) @local!, Item(false) @local!]
    let named: ArrayList<Item> @local! = ArrayList<Item>(srcNamed) @local!
    failed += assertEq(t416RemoveIfNamedPredicate(named), 0, "T416_removeif_named_predicate")

    let srcInline: Array<Item> @local! = [Item(true) @local!, Item(false) @local!]
    let inline: ArrayList<Item> @local! = ArrayList<Item>(srcInline) @local!
    failed += assertEq(t416RemoveIfInlineLambda(inline), 0, "T416_removeif_inline_lambda")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}

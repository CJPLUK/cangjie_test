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
// T413/T414/T416: ReadOnlyList and List modal contracts through the interface
// static receiver (@local! and @local? forms).
//
// UPDATE 2026-09-29: the declarations exist and the case runs.
//   - ReadOnlyList carries get([])/[] in @local!/@local? form.
//   - List carries all nine @local! members (add x4, remove x2, removeIf, clear, []=).
//   - Option.getOrThrow has no @local overload (core/option.cj declares only the two
//     heap forms and the local-mode change list does not mention it), so Option
//     payloads are narrowed through an explicit match instead.
//   - Comparing an Option (@local!) directly, e.g. `rl.last == b`, throws
//     UnimplementedException: no '==' for its @local! instance, so Option payloads
//     are narrowed to the element before comparison too.
//   - removeIf takes ((T @local!) -> Bool) @local?, which cannot be formed inside a
//     non-exclave function, so it is invoked from an exclave helper.
//
// Still blocked and not asserted here: removeIf with a non-Copyable element and an
// inline @local! lambda compiles but SEGFAULTs inside ArrayList.removeIf at the
// predicate call; the same mutation through a named exclave predicate works. See
// test_arraylist_local_removeif_noncopyable_blocked.cj.
// T417 (heap String passed to a List<String> @local! add) is a separate negative case.
import std.collection.*
import std.core.*

// Narrow a local Option: Option.getOrThrow has no @local overload, and the payload
// is only usable as @local! inside the match arm, so comparisons happen there.
func eqOpt(opt: ?String @local!, want: String @local!): Bool {
    exclave {
        match (opt) {
            case Some(v) => v == want
            case None => false
        }
    }
}

func someOrQ(opt: ?String @local?, fallback: String): String {
    match (opt) {
        case Some(v) => String(v)
        case None => fallback
    }
}

// Assert a @local? Option payload without comparing the Option directly.
func eqOptQ(opt: ?String @local?, want: String): Bool {
    match (opt) {
        case Some(v) => String(v) == want
        case None => false
    }
}

// removeIf needs ((T @local!) -> Bool) @local?, formable only in an exclave context.
func removeLocal(l: List<Int64> @local!, target: Int64): Int64 {
    exclave {
        l.removeIf({ v: Int64 @local! => v == target })
        0
    }
}

func readContracts(seed: String @local!): Int64 {
    exclave {
        var failed = 0
        let al: ArrayList<String> @local! = ArrayList<String>() @local!
        al.add(seed)

        // T413: ReadOnlyList<String> @local! static receiver.
        let rlL: ReadOnlyList<String> @local! = al
        failed += assertB(eqOpt(rlL.get(0), seed), "T413_get0_local_bang")
        failed += assertB(rlL[0] == seed, "T413_index0_local_bang")
        failed += assertB(eqOpt(rlL.last, seed), "T413_last_local_bang")

        // T414: same receiver widened to @local?.
        let rlQ: ReadOnlyList<String> @local? = al
        failed += assertB(eqOptQ(rlQ.get(0), "a"), "T414_get0_local_q")
        failed += assertB(rlQ[0] == "a", "T414_index0_local_q")
        failed
    }
}

func mutateContracts(tag: String @local!): Int64 {
    exclave {
        var failed = 0
        // T416: List<Int64> @local! static receiver, the nine members.
        let base: Int64 @local! = 2
        let l1: List<Int64> @local! = ArrayList<Int64>([base, 4]) @local!
        l1.add(6)                        // [2, 4, 6]
        l1.add(all: [8, 10])             // [2, 4, 6, 8, 10]
        l1.add(1, at: 0)                 // [1, 2, 4, 6, 8, 10]
        l1.add(all: [3, 5], at: 2)       // [1, 2, 3, 5, 4, 6, 8, 10]
        let removed: Int64 @local! = l1.remove(at: 0)
        failed += assertB(removed == 1, "T416_remove_at_returns")
        l1.remove(0..1)                  // [3, 5, 4, 6, 8, 10]
        failed += assertB(l1[0] == 3, "T416_remove_range_head")
        removeLocal(l1, 5)               // [3, 4, 6, 8, 10]
        failed += assertB(l1[0] == 3, "T416_removeif_head")
        failed += assertB(l1[1] == 4, "T416_removeif_next")
        l1[1] = 99                       // [3, 99, 6, 8, 10]
        failed += assertB(l1[1] == 99, "T416_set_index")
        failed += assertB(match (l1.last) { case Some(v) => v == 10; case None => false }, "T416_tail_after_set")
        l1.clear()
        failed += assertB(l1.isEmpty(), "T416_clear_empty")
        failed
    }
}

main(): Int64 {
    let seed: String @local! = "a"
    var failed = 0
    failed += readContracts(seed)
    failed += mutateContracts(seed)
    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}

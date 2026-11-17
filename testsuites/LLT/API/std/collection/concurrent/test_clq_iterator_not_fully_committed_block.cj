/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// EXEC: %run %run_opt %output %run_utest_opt

import std.collection.*
import std.collection.concurrent.*
import std.sync.*
import std.time.*

/*
 * Regression test for the ConcurrentLinkedQueue iterator silent truncation
 * at a not-fully-committed block (issue 942).
 *
 * Defect: ConcurrentLinkedQueueIterator.next() terminates the iterator
 * permanently (hasNext = false) as soon as its read index reaches the current
 * block's committed count, including when committed < allocated, i.e. a
 * concurrent producer sits between allocated.fetchAdd(1) (Block.push) and
 * committed.fetchAdd(1). The iterator then never advances to later blocks that
 * already hold fully committed elements, and the caller receives a silently
 * truncated snapshot indistinguishable from end-of-queue. Unlike pop()/front(),
 * which spin-retry while committed != allocated ("Retry: existing unfinished
 * senders in this block."), the iterator gives up forever. toArray() iterates
 * via `for (e in this)` and is truncated identically.
 *
 * Observable effect: elements committed BEFORE the iterator was created are
 * omitted from the iteration (and from toArray()), while remove() at the same
 * moment still returns all of them. Even a weakly consistent iterator must
 * return elements that were already present at its creation; a truncated
 * snapshot violates that and is indistinguishable from element loss.
 *
 * Scenario (coordinated probe, public API only, BUF_SIZE = 128):
 *   - main pre-fills block B_0 slots 0..126 (127 committed elements).
 *   - P1 pushes 127, the ONE block-filling push of B_0: its in-flight window
 *     (allocated.fetchAdd -> buffer write -> committed.fetchAdd) is essentially
 *     all of P1's CPU time in the round, maximizing the chance that a
 *     scheduling event lands inside it.
 *   - P2 spins until q.size >= 128 (B_0 full <=> P1's fetchAdd landed), then
 *     pushes 200, 201, 202 which overflow into the next block B_1 and commit
 *     there.
 *   - main joins P2 (happens-before: 200..202 are committed and present),
 *     THEN creates a fresh iterator and iterates it to exhaustion, and calls
 *     toArray().
 *
 * Violation predicate (airtight under weak consistency): elements 200, 201,
 * 202 were committed before the iterator was created and are still present, so
 * the iteration and toArray() must contain all 131 elements. If the iteration
 * ends without yielding 200..202, the iterator silently truncated at B_0's
 * not-fully-committed slot 127.
 *
 * The trigger is a scheduler preemption of P1 inside its few-ns window;
 * naturally it recurs at roughly 1 per 10^4 rounds. The stress loops below run
 * up to 150000 rounds (~10 s) and exit on the first violation; when the defect
 * is fixed the loops simply run to completion and pass.
 */

const ROUNDS: Int64 = 150000
const SEQUENTIAL_SANITY_EXPECTED: Int64 = 131

func runProbeRound(r: Int64): Int64 {
    /* 0 = healthy, 1 = truncation violation, 2 = anomaly */
    let q = ConcurrentLinkedQueue<Int64>()
    var v: Int64 = 0
    while (v < 127) {
        q.add(v) // pre-fill B_0 slots 0..126
        v++
    }
    let f1 = spawn {
        q.add(127) // THE block-filling push (in-flight window)
    }
    let f2 = spawn {
        var spin: Int64 = 0
        while (q.size < 128) { // B_0 full <=> P1's fetchAdd landed
            spin++
            if (spin > 8_000_000_000) {
                break
            }
        }
        q.add(200) // overflow -> newBlock B_1; commits in B_1
        q.add(201)
        q.add(202)
    }
    f2.get() // join P2: 200,201,202 committed before this returns

    let seenIds = ArrayList<Int64>()
    let it = q.iterator()
    while (let Some(e) <- it.next()) {
        seenIds.add(e)
    }
    f1.get() // join P1 (its in-flight window, if any, is over)

    let arr = q.toArray()

    let drainedIds = ArrayList<Int64>()
    while (let Some(e) <- q.remove()) {
        drainedIds.add(e)
    }

    let sawTail = seenIds.contains(200) && seenIds.contains(201) && seenIds.contains(202)
    if (sawTail && seenIds.size == SEQUENTIAL_SANITY_EXPECTED && arr.size == SEQUENTIAL_SANITY_EXPECTED) {
        return 0
    }
    if (!sawTail || seenIds.size != SEQUENTIAL_SANITY_EXPECTED) {
        println("round ${r}: VIOLATION - iteration ended after ${seenIds.size} elements, " +
            "omitting 200,201,202 which were committed (P2 joined) BEFORE the iterator was created; " +
            "toArray().size = ${arr.size}, remove() drains ${drainedIds.size}")
        return 1
    }
    if (arr.size != SEQUENTIAL_SANITY_EXPECTED) {
        println("round ${r}: ANOMALY - iteration complete but toArray().size = ${arr.size} (expected 131)")
        return 2
    }
    if (drainedIds.size != SEQUENTIAL_SANITY_EXPECTED) {
        println("round ${r}: ANOMALY - drained ${drainedIds.size} elements (expected 131)")
        return 2
    }
    return 0
}

@Test
class ClqIteratorTruncateTest {
    /*
     * Sequential sanity: with no concurrency, iteration, toArray and remove
     * must all see every element. Guards the block layout assumptions of the
     * concurrent probes (BUF_SIZE = 128, block-chaining iterator).
     */
    @TestCase
    func testSequentialSanity(): Unit {
        let qs = ConcurrentLinkedQueue<Int64>()
        for (i in 0..128) {
            qs.add(i)
        }
        qs.add(200)
        qs.add(201)
        qs.add(202)
        var cnt: Int64 = 0
        for (e in qs) {
            if (e >= 0) {
                cnt++
            }
        }
        let arr = qs.toArray()
        var drained: Int64 = 0
        while (let Some(_) <- qs.remove()) {
            drained++
        }
        @Expect(cnt, SEQUENTIAL_SANITY_EXPECTED)
        @Expect(arr.size, SEQUENTIAL_SANITY_EXPECTED)
        @Expect(drained, SEQUENTIAL_SANITY_EXPECTED)
    }

    /*
     * Coordinated black-box stress against the truncation. Every round must
     * yield the complete snapshot: 131 elements in the iteration and in
     * toArray(), and 131 via remove(). Exits on the first violation.
     */
    @TestCase
    func testIteratorYieldsCommittedElementsUnderConcurrentProducer(): Unit {
        var healthy: Int64 = 0
        var violations: Int64 = 0
        var anomalies: Int64 = 0
        var r: Int64 = 0
        while (r < ROUNDS) {
            let res = runProbeRound(r)
            if (res == 0) {
                healthy++
            } else if (res == 1) {
                violations++
                break
            } else {
                anomalies++
                break
            }
            r++
        }
        @Expect(violations, 0)
        @Expect(anomalies, 0)
    }
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// EXEC: %run %run_opt %output %run_utest_opt

import std.collection.concurrent.*
import std.sync.*
import std.time.*

/*
 * LLT for ConcurrentHashMap stripe-lock exception safety.
 *
 * Defect (MC-19): ConcurrentHashMap.entryView(key, fn) and the
 * predicate/callback-taking remove(key, predicate) / replace(key, predicate, eval)
 * run the USER callback while holding the stripe mutex
 * (stdlib/libs/std/collection/concurrent/concurrent_hash_map.cj,
 * entryViewInternal: lock -> copyEntryView(fn) -> unlock;
 * removeInternal / replaceInternel: same shape). The unlock only runs on the
 * normal path: the file contains no try/finally, so when the user callback
 * throws, the exception unwinds past the unlock and the stripe mutex is
 * leaked FOREVER. Any later writer whose key hashes to the same stripe then
 * blocks permanently in tryGetBucket -> MutexLockGroup.lock.
 *
 * Trigger used here is plain public-API behavior: a user callback that throws
 * (validation/parse failure inside the callback) — no timing assistance, no
 * state injection. Timing (Future.get with timeout) is used only to DETECT
 * whether a writer to the leaked stripe completes.
 *
 * Expected behavior after the fix: the stripe mutex is always released when
 * the callback throws (unlock in a finally block), the exception still
 * propagates to the entryView/remove/replace caller, and every writer
 * completes — no TimeoutException anywhere.
 *
 * Layout: the default ConcurrentHashMap has 16 buckets and 16 stripe mutexes,
 * so key & 15 selects both the bucket and the stripe:
 *   map  : stripe 1 leaked via entryView(1, throwing fn)
 *   mapB : stripe 5 leaked via remove(5, throwing predicate)
 *   mapC : stripe 6 leaked via replace(6, throwing predicate, throwing eval)
 *   control writer uses healthy stripe 2 and MUST complete; leaked-stripe
 *   writers on stripes 1/5/6 must also complete once the lock is released.
 */
let PROBE_WAIT: Duration = Duration.second * 5
const LEAKED_STRIPE_KEY: Int64 = 1     // 1 & 15 == 1
const WRITER_KEY_SAME_STRIPE: Int64 = 17 // 17 & 15 == 1

@Test
class ConcurrentHashMapLockExceptionSafetyTest {
    @TestCase
    func testEntryViewThrowingCallbackReleasesLock(): Unit {
        let map = ConcurrentHashMap<Int64, Int64>()
        map.add(3, 30)
        @Expect(map.get(3), Some(30))

        // Variant A: entryView callback throws under the stripe lock.
        var caught = false
        try {
            map.entryView(LEAKED_STRIPE_KEY, { _ =>
                throw IllegalArgumentException("user callback rejects the entry")
            })
        } catch (e: IllegalArgumentException) {
            caught = true
            @Expect(e.message.contains("user callback rejects the entry"), true)
        }
        @Expect(caught, true)

        // Writer to the SAME stripe: must complete (previously parked forever).
        let writer = spawn {
            map.add(WRITER_KEY_SAME_STRIPE, 43)
        }
        writer.get(PROBE_WAIT)
        @Expect(map.get(WRITER_KEY_SAME_STRIPE), Some(43))

        // Control: an untouched stripe keeps working.
        map.add(2, 20)
        @Expect(map.get(2), Some(20))
    }

    @TestCase
    func testRemoveThrowingPredicateReleasesLock(): Unit {
        let mapB = ConcurrentHashMap<Int64, Int64>()
        mapB.add(5, 50) // 5 & 15 == 5

        // Variant B: remove(key, predicate) predicate throws under the stripe lock.
        var caught = false
        try {
            mapB.remove(5, { _ =>
                throw IllegalArgumentException("user predicate fails")
            })
        } catch (e: IllegalArgumentException) {
            caught = true
            @Expect(e.message.contains("user predicate fails"), true)
        }
        @Expect(caught, true)

        // Writer to the SAME stripe of mapB: must complete.
        let writer = spawn {
            mapB.remove(21) // 21 & 15 == 5: same stripe, no-op remove
        }
        writer.get(PROBE_WAIT)
        @Expect(mapB.get(5), Some(50))
    }

    @TestCase
    func testReplaceThrowingPredicateAndEvalReleaseLock(): Unit {
        let mapC = ConcurrentHashMap<Int64, Int64>()
        mapC.add(6, 60) // 6 & 15 == 6

        // Variant C1: replace(key, predicate, eval) predicate throws under the lock.
        var caught = false
        try {
            mapC.replace(6, { _ =>
                throw IllegalArgumentException("replace predicate fails")
            }, { v => v })
        } catch (e: IllegalArgumentException) {
            caught = true
            @Expect(e.message.contains("replace predicate fails"), true)
        }
        @Expect(caught, true)

        // Variant C2: eval throws under the lock.
        caught = false
        try {
            mapC.replace(6, { _ => true }, { _ =>
                throw IllegalArgumentException("replace eval fails")
            })
        } catch (e: IllegalArgumentException) {
            caught = true
            @Expect(e.message.contains("replace eval fails"), true)
        }
        @Expect(caught, true)
        @Expect(mapC.get(6), Some(60))

        // Writer to the SAME stripe of mapC: must complete.
        let writer = spawn {
            mapC.add(22, 220) // 22 & 15 == 6
        }
        writer.get(PROBE_WAIT)
        @Expect(mapC.get(22), Some(220))
    }

    @TestCase
    func testAddPathStillWorksAfterCallbackThrows(): Unit {
        // Sanity: repeated throw cycles leave the map usable on every stripe.
        let map = ConcurrentHashMap<Int64, Int64>()
        for (k in 0..16) {
            var caught = false
            try {
                map.entryView(k, { _ => throw IllegalArgumentException("boom") })
            } catch (e: IllegalArgumentException) {
                caught = true
            }
            @Expect(caught, true)
            // The stripe must be released: a write on the same stripe succeeds.
            map.add(k, k * 10)
            @Expect(map.get(k), Some(k * 10))
        }
        @Expect(map.size, 16)
    }
}

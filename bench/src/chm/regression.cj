/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package bench.chm

import std.sync.AtomicInt64

/*
 * Fixed-semantics regression tests for the optimized ConcurrentHashMap
 * implementation in this package. Each test drives one of the new code paths
 * and asserts observable invariants:
 *   - testDropLastBucket: removing the last element of a bucket while the
 *     table has no previous table publishes the bucket as None (allowDrop);
 *     reads and iteration must stay correct afterwards.
 *   - testFrozenRetryContract: a frozen bucket must make tryGetBucket /
 *     tryGetBucketWithEntries report "not ready", which is the signal that
 *     makes the public operations reload head and retry.
 *   - testResizeRemoveInterleave: resize/migration interleaved with remove,
 *     single-threaded (deterministic) and multi-threaded (invariant-checked).
 *   - testPredicateInvokedOnce: remove/replace invoke the predicate exactly
 *     once on the matched key (zero times on a miss), even when the bucket
 *     holds hash-colliding keys.
 *
 * The tests live in package bench.chm on purpose: they inspect internal
 * table state (buckets, freezeFlags, pre) to pin down branch behavior.
 */

public func testDropLastBucket(): Bool {
    // capacity 1024 -> per-cell resize threshold is 64, so no resize happens here
    let m = ConcurrentHashMap<Int64, Int64>(1024)
    // Int64 hash is the identity: 0, 1024, 2048 all land in bucket 0
    if (m.add(0, 10).isSome()) { return false }
    if (m.add(1024, 20).isSome()) { return false }
    if (m.add(2048, 30).isSome()) { return false }
    if (let Some(es) <- m.head.load().buckets[0].refList()) {
        if (es.size != 3) { return false }
    } else { return false }
    // head has no previous table -> allowDrop is enabled
    if (m.head.load().pre.load().isSome()) { return false }

    if (let Some(v) <- m.remove(0)) {
        if (v != 10) { return false }
    } else { return false }
    if (let Some(v) <- m.remove(1024)) {
        if (v != 20) { return false }
    } else { return false }
    // dropping the last element must publish the bucket as None
    if (let Some(v) <- m.remove(2048)) {
        if (v != 30) { return false }
    } else { return false }
    if (m.size != 0) { return false }
    if (m.head.load().buckets[0].refList().isSome()) { return false }

    // reads after the drop
    if (m.get(2048).isSome()) { return false }
    if (m.contains(2048)) { return false }
    // iteration over a map that contains a dropped bucket
    var cnt: Int64 = 0
    let it = m.iterator()
    while (let Some(kv) <- it.next()) {
        cnt++
    }
    if (cnt != 0) { return false }
    // re-add into the dropped bucket (entries == None reuse path)
    if (m.add(0, 100).isSome()) { return false }
    if (let Some(v) <- m.get(0)) {
        if (v != 100) { return false }
    } else { return false }
    if (let Some(es) <- m.head.load().buckets[0].refList()) {
        if (es.size != 1) { return false }
    } else { return false }

    // multi-bucket: drop the middle of three occupied buckets, iterate the rest
    let m2 = ConcurrentHashMap<Int64, Int64>(1024)
    if (m2.add(0, 1).isSome()) { return false }
    if (m2.add(1, 2).isSome()) { return false }
    if (m2.add(2, 3).isSome()) { return false }
    if (m2.remove(1).isNone()) { return false }
    if (m2.size != 2) { return false }
    var n: Int64 = 0
    var seen0: Int64 = -1
    var seen2: Int64 = -1
    let it2 = m2.iterator()
    while (let Some(kv) <- it2.next()) {
        n++
        if (kv[0] == 0) { seen0 = kv[1] }
        if (kv[0] == 2) { seen2 = kv[1] }
    }
    if (n != 2 || seen0 != 1 || seen2 != 3) { return false }
    return true
}

public func testFrozenRetryContract(): Bool {
    // capacity 16 -> the second insert into one hash cell triggers a resize
    let m = ConcurrentHashMap<Int64, Int64>(16)
    if (m.add(0, 100).isSome()) { return false }
    if (m.add(16, 200).isSome()) { return false }
    // after the resize: head = T1(32, pre = T0(16)); both keys sit in T0 bucket 0
    let t1 = m.head.load()
    if (t1.buckets.size != 32) { return false }
    if (let Some(t0) <- t1.pre.load()) {
        // migrate T1 bucket 0 from T0: this freezes T0 bucket 0
        if (!t1.tryGetBucket(0)) { return false }
        t1.lockG.unlock(0) // tryGetBucket keeps the lock on the ready path
        if (t1.freezeFlags[0]) { return false }
        if (!t0.freezeFlags[0]) { return false } // T0 bucket 0 must be frozen now
        if (let Some(es) <- t1.buckets[0].refList()) {
            if (es.size != 1) { return false } // only key 0 belongs to T1 bucket 0
        } else { return false }

        // the frozen-bucket contract: both accessors report "not ready"
        if (t0.tryGetBucket(0)) { return false }
        let (fe, fready) = t0.tryGetBucketWithEntries(0)
        if (fready) { return false }
        if (fe.isSome()) { return false }

        // a non-frozen bucket is still ready; an empty one reports None entries
        let (ne, nready) = t0.tryGetBucketWithEntries(1)
        if (!nready) { return false }
        t0.lockG.unlock(1) // ready path keeps the lock
        if (ne.isSome()) { return false }

        // public reads through head must stay consistent
        if (let Some(v) <- m.get(0)) {
            if (v != 100) { return false }
        } else { return false }
        // key 16 is not migrated into T1 yet: the read falls back to the pre-table
        if (let Some(v) <- m.get(16)) {
            if (v != 200) { return false }
        } else { return false }
    } else { return false }
    return true
}

public func testResizeRemoveInterleave(): Bool {
    // deterministic single-threaded sequence across multiple resizes
    let m = ConcurrentHashMap<Int64, Int64>(16)
    for (i in 0..500) {
        if (m.add(i, i).isSome()) { return false }
    }
    if (m.size != 500) { return false }
    for (i in 0..500) {
        if (let Some(v) <- m.get(i)) {
            if (v != i) { return false }
        } else { return false }
    }
    // remove the even keys
    for (i in 0..500 : 2) {
        if (let Some(v) <- m.remove(i)) {
            if (v != i) { return false }
        } else { return false }
    }
    if (m.size != 250) { return false }
    for (i in 0..500 : 2) {
        if (m.get(i).isSome()) { return false }
    }
    for (i in 1..500 : 2) {
        if (let Some(v) <- m.get(i)) {
            if (v != i) { return false }
        } else { return false }
    }
    // iterate the survivors
    var seen: Int64 = 0
    let it = m.iterator()
    while (let Some(kv) <- it.next()) {
        seen++
        if (kv[1] != kv[0]) { return false }
        if (kv[0] % 2 == 0) { return false }
    }
    if (seen != 250) { return false }
    // grow again (more resizes), then remove the new range
    for (i in 500..1000) {
        if (m.add(i, i).isSome()) { return false }
    }
    if (m.size != 750) { return false }
    for (i in 500..1000) {
        if (let Some(v) <- m.remove(i)) {
            if (v != i) { return false }
        } else { return false }
    }
    if (m.size != 250) { return false }
    // drain the rest
    for (i in 1..500 : 2) {
        if (let Some(v) <- m.remove(i)) {
            if (v != i) { return false }
        } else { return false }
    }
    if (m.size != 0 || !m.isEmpty()) { return false }
    for (i in 0..1000 : 7) {
        if (m.get(i).isSome()) { return false }
    }
    var cnt2: Int64 = 0
    let it2 = m.iterator()
    while (let Some(kv) <- it2.next()) {
        cnt2++
    }
    if (cnt2 != 0) { return false }

    // multi-threaded interleave: two writers (forcing resizes) + one remover;
    // this is where the frozen-bucket reload-and-retry path is exercised
    let m2 = ConcurrentHashMap<Int64, Int64>(16)
    let futA = spawn { =>
        for (i in 0..10000) {
            m2.add(i, i)
        }
    }
    let futB = spawn { =>
        for (i in 0..10000) {
            m2.add(10000 + i, 10000 + i)
        }
    }
    let futC = spawn { =>
        for (i in 0..10000) {
            m2.remove(i)
            m2.remove(10000 + i)
        }
    }
    futA.get()
    futB.get()
    futC.get()
    // invariants: value consistency + size equals the number of live keys
    var live: Int64 = 0
    for (k in 0..20000) {
        if (let Some(v) <- m2.get(k)) {
            if (v != k) { return false }
            live++
        }
    }
    if (m2.size != live) { return false }
    var icnt: Int64 = 0
    let it3 = m2.iterator()
    while (let Some(kv) <- it3.next()) {
        icnt++
        if (kv[1] != kv[0]) { return false }
    }
    if (icnt != live) { return false }
    return true
}

/* A counting predicate helper: Cangjie lambdas take a single expression, so
 * the call counter lives in a class and the lambdas read {v => c.accept()}. */
class PredCounter {
    let cnt = AtomicInt64(0)

    public func accept(): Bool {
        cnt.fetchAdd(1)
        return true
    }

    public func reject(): Bool {
        cnt.fetchAdd(1)
        return false
    }

    public func count(): Int64 {
        return cnt.load()
    }
}

public func testPredicateInvokedOnce(): Bool {
    // capacity 1024, bucket 5: keys 5, 1029, 2053 collide (Int64 hash is identity)
    let m = ConcurrentHashMap<Int64, Int64>(1024)
    if (m.add(5, 1).isSome()) { return false }
    if (m.add(1029, 2).isSome()) { return false }
    if (m.add(2053, 3).isSome()) { return false }
    if (let Some(es) <- m.head.load().buckets[5].refList()) {
        if (es.size != 3) { return false }
    } else { return false }

    let c = PredCounter()
    // hit: the predicate is invoked exactly once and the element is removed
    if (let Some(v) <- m.remove(1029, {v: Int64 => c.accept()})) {
        if (v != 2) { return false }
    } else { return false }
    if (c.count() != 1) { return false }
    if (m.get(1029).isSome()) { return false }
    if (let Some(v) <- m.get(5)) {
        if (v != 1) { return false }
    } else { return false }
    if (let Some(v) <- m.get(2053)) {
        if (v != 3) { return false }
    } else { return false }
    // miss: bucket non-empty, key absent -> the predicate is not invoked
    if (m.remove(3077, {v: Int64 => c.accept()}).isSome()) { return false }
    if (c.count() != 1) { return false }
    // rejected: the predicate is invoked once and the element is kept
    if (m.remove(5, {v: Int64 => c.reject()}).isSome()) { return false }
    if (c.count() != 2) { return false }
    if (let Some(v) <- m.get(5)) {
        if (v != 1) { return false }
    } else { return false }

    // replace follows the same hit-once contract
    let rc = PredCounter()
    if (let Some(v) <- m.replace(5, {v: Int64 => rc.accept()}, {v: Int64 => v + 10})) {
        if (v != 1) { return false }
    } else { return false }
    if (rc.count() != 1) { return false }
    if (let Some(v) <- m.get(5)) {
        if (v != 11) { return false }
    } else { return false }
    if (m.replace(4097, {v: Int64 => rc.accept()}, {v: Int64 => v + 10}).isSome()) { return false }
    if (rc.count() != 1) { return false }
    return true
}

public func replBranchRegressionTests(): Bool {
    return testDropLastBucket()
        && testFrozenRetryContract()
        && testResizeRemoveInterleave()
        && testPredicateInvokedOnce()
}

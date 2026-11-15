/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// NOTE: this file MUST be compiled with --cj-pct — it verifies that the
// import remap resolves the whole mirrored surface INCLUDING the
// vocabulary types stdx.unittest.sync re-exports (reexport.cj): every
// named `import std.sync.X` below goes through the remap, so the file
// compiles only if Lock, UniqueLock, Condition, IReentrantMutex,
// ConditionID and IllegalSynchronizationStateException are importable
// from the mirror package. Each type is then exercised meaningfully:
// interface dispatch through Lock/UniqueLock/Condition, a ConditionID
// produced by the mirror's own MultiConditionMonitor.newCondition, an
// IReentrantMutex implementation backed by the mirror's Mutex, the
// misuse exception thrown by an unlock without a hold, and the
// interfaces used inside a scenario actor under an active coordinator.
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 5

import std.sync.Condition
import std.sync.ConditionID
import std.sync.IReentrantMutex
import std.sync.IllegalSynchronizationStateException
import std.sync.Lock
import std.sync.Monitor
import std.sync.Mutex
import std.sync.MultiConditionMonitor
import std.sync.UniqueLock
import stdx.unittest.concurrent.*

/// An IReentrantMutex implementation backed by the mirror's Mutex: the
/// deprecated interface resolves through the re-export and dispatches
/// its contract through the wrapper.
class SyncReexportReentrant <: IReentrantMutex {
    private let inner = Mutex()

    public func lock(): Unit {
        inner.lock()
    }

    public func tryLock(): Bool {
        inner.tryLock()
    }

    public func unlock(): Unit {
        inner.unlock()
    }
}

@Test
class SyncReexportTests {
    /// Lock, UniqueLock and Condition resolve through the remap and
    /// dispatch against the mirror's Mutex: an uncontended acquire is
    /// reentrant (the same thread's tryLock succeeds), a condition is
    /// obtained through the UniqueLock interface while the lock is
    /// held, a waiter-less notification is a no-op, and a fully
    /// released lock is acquirable again through the Lock interface.
    @TestCase
    func test_sync_reexport_lock_interfaces(): Unit {
        println("Testing sync re-exported lock interfaces...")

        let mx = Mutex()
        let l: Lock = mx
        let ul: UniqueLock = mx
        l.lock()
        @Assert(ul.tryLock()) // reentrant: the holder's own tryLock succeeds
        let c: Condition = ul.condition()
        c.notifyAll() // no waiters: a no-op notification
        mx.unlock()
        mx.unlock()
        @Assert(l.tryLock()) // fully released: a fresh acquire succeeds
        l.unlock()
    }

    /// ConditionID resolves through the remap: the mirror's
    /// MultiConditionMonitor produces one through its own
    /// newCondition (the signature that made the re-export mandatory),
    /// and waiter-less notifies on it are no-ops.
    @TestCase
    func test_sync_reexport_condition_id(): Unit {
        println("Testing sync re-exported ConditionID...")

        let mcm = MultiConditionMonitor()
        let l: Lock = mcm
        l.lock()
        let cid: ConditionID = mcm.newCondition()
        mcm.notify(cid) // no waiters
        mcm.notifyAll(cid) // no waiters
        @Assert(mcm.tryLock()) // reentrant: the holder's own tryLock succeeds
        mcm.unlock()
        mcm.unlock()
    }

    /// IllegalSynchronizationStateException resolves through the remap
    /// and is thrown by the documented misuse shapes: unlocking a
    /// monitor nobody holds, and notifying a condition after releasing
    /// its owner lock.
    @TestCase
    func test_sync_reexport_misuse_exception(): Unit {
        println("Testing sync re-exported misuse exception...")

        let m = Monitor()
        var caught = false
        try {
            m.unlock() // never locked by this thread
        } catch (e: IllegalSynchronizationStateException) {
            caught = true
        }
        @Assert(caught)

        let mx = Mutex()
        mx.lock()
        let c: Condition = mx.condition()
        mx.unlock()
        var caughtAfterRelease = false
        try {
            c.notify() // the owner lock is not held
        } catch (e: IllegalSynchronizationStateException) {
            caughtAfterRelease = true
        }
        @Assert(caughtAfterRelease)
    }

    /// IReentrantMutex resolves through the remap: a user class
    /// implements the deprecated interface over the mirror's Mutex and
    /// the reentrant contract holds through interface-typed calls,
    /// including the over-unlock exception.
    @TestCase
    func test_sync_reexport_ireentrant(): Unit {
        println("Testing sync re-exported IReentrantMutex...")

        let ir: IReentrantMutex = SyncReexportReentrant()
        ir.lock()
        @Assert(ir.tryLock()) // reentrant through the interface
        ir.unlock()
        ir.unlock()
        var caught = false
        try {
            ir.unlock() // fully released
        } catch (e: IllegalSynchronizationStateException) {
            caught = true
        }
        @Assert(caught)
    }

    /// The re-exported interfaces work inside a scenario actor too:
    /// under an active coordinator the mirror's mediated paths stay
    /// silent for waiter-less traffic (single actor, uncontended lock,
    /// a no-op notification) and the schedule completes cleanly.
    @TestCase
    func test_sync_reexport_actor_scenario(): Unit {
        println("Testing sync re-exported interfaces in a scenario...")

        let result = scenario("sync_reexport_actor")
            .mode(PCT)
            .iterations(1)
            .actor {
                let mx = Mutex()
                let l: Lock = mx
                l.lock()
                let c: Condition = mx.condition()
                c.notifyAll() // no waiters
                l.unlock()
                0
            }
            .build()
            .run()

        @Assert(result.passed)
    }
}

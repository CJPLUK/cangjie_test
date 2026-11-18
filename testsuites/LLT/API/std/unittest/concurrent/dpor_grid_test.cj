/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// NOTE: this file MUST be compiled with --cj-pct — it verifies that the
// fine-grained PCT grid keeps working under DPOR mode: under the flag,
// `std.sync` imports resolve to the stdx.unittest.sync wrappers, whose
// atomic operations carry a pctGridDispatchRw call after every step
// (plan §5E). In DPOR mode those grid points are both switch sites and
// dependency keys, so the explorer must cover the dependent orderings of
// the grid-level segments (dpor plan §3).
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 5

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*
import std.runtime.gc

// ---------------------------------------------------------------------------
// Verbatim copy of the CURRENT (known-buggy) ConcurrentLinkedQueue
// implementation from
// std/collection/concurrent/non_blocking_queue.cj (Block, newBlock,
// nextBlock, add/remove/peek; everything the scenario touches).
//
// The copy lives here so that --cj-pct compiles it into this binary: std
// library code (including its generic instantiations) is precompiled
// without the flag and therefore carries no grid points. When the bug is
// fixed upstream, this copy stays as the regression fixture (see the todo
// in queue_bug_test.cj).
// ---------------------------------------------------------------------------

enum ENTRY<E> {
    | BlockDone
    | NoEntry
    | ELEM(E)
}

enum PushRes {
    | BlockDone
    | CONFLICT
    | SUCCEED
}

const BUF_SIZE_BITS = 7
const BUF_SIZE: Int64 = 1 << BUF_SIZE_BITS

class Block<E> {
    let version: UInt64

    let isExtended = AtomicBool(false)
    let next = AtomicOptionReference<Block<E>>(None)
    private let allocated = AtomicInt64(0)
    let committed = AtomicInt64(0)
    let reserved = AtomicInt64(0)
    let buffer = unsafe { Array<E>(BUF_SIZE, repeat: zeroValue<E>()) }

    init(version: UInt64) {
        this.version = version
    }

    func push(element: E): Bool {
        // buffer full
        if (allocated.load() >= BUF_SIZE) {
            return false
        }

        let index = allocated.fetchAdd(1)

        // buffer full
        if (index >= BUF_SIZE) {
            return false
        }

        buffer[index] = element
        committed.fetchAdd(1)

        return true
    }

    func pop(): ENTRY<E> {
        while (true) {
            let index = reserved.load()

            // all of the entries in the buffer have been consumed.
            if (index >= BUF_SIZE) {
                return BlockDone
            }

            let currentCommitted = committed.load()
            if (currentCommitted != BUF_SIZE) {
                // Retry: existing unfinished senders in this block.
                if (currentCommitted != allocated.load()) {
                    continue
                }
            }

            // there is no element in the buffer
            if (index == currentCommitted) {
                return NoEntry
            }

            // get and remove the element of buffer[index]
            if (reserved.compareAndSwap(index, index + 1)) {
                let elem = ELEM(buffer[index])
                buffer[index] = unsafe { zeroValue<E>() }
                return elem
            }
        }

        return BlockDone
    }

    func front(): ENTRY<E> {
        while (true) {
            let index = reserved.load()

            // all of the entries in the buffer have been consumed.
            if (index >= BUF_SIZE) {
                return BlockDone
            }

            let currentCommitted = committed.load()
            if (currentCommitted != BUF_SIZE) {
                // Retry: existing unfinished senders in this block.
                if (currentCommitted != allocated.load()) {
                    continue
                }
            }

            // there is no element in the buffer.
            if (index == currentCommitted) {
                return NoEntry
            }

            // get the element of buffer[index].
            return ELEM(buffer[index])
        }

        return BlockDone
    }
}

func newBlock<E>(tailBlock: Block<E>, tail: AtomicReference<Block<E>>): Unit {
    if (!tailBlock.isExtended.compareAndSwap(false, true)) {
        while (true) {
            if (let Some(_) <- tailBlock.next.load()) {
                return
            }
        }
    }

    let newBlock = Block<E>(tailBlock.version + 1)
    tailBlock.next.store(newBlock)
    tail.store(newBlock)
}

func nextBlock<E>(headBlock: Block<E>, head: AtomicReference<Block<E>>, tail: AtomicReference<Block<E>>): Bool {
    if (!refEq(head.load(), headBlock)) {
        return true
    }

    if (let Some(next) <- headBlock.next.load()) {
        // Waits for ongoing allocation. Under DPOR this spin is exactly the
        // non-obstruction-freedom the framework's fair-mode fallback
        // handles: the allocating actor may be parked at a grid point, and
        // the coordinator detects the unbroken grid-poll run and yields.
        while (refEq(headBlock, tail.load())) {}
        head.compareAndSwap(headBlock, next)
        return true
    }

    return false
}

public class BuggyLinkedQueue<E> {
    private let front: AtomicReference<Block<E>>
    private let rear: AtomicReference<Block<E>>

    public init() {
        let block = Block<E>(0)
        front = AtomicReference<Block<E>>(block)
        rear = AtomicReference<Block<E>>(block)
    }

    public func add(element: E): Bool {
        while (true) {
            let tailBlock = rear.load()
            if (tailBlock.push(element)) {
                return true
            }
            newBlock(tailBlock, rear)
        }
        return false
    }

    public func remove(): Option<E> {
        while (true) {
            let headBlock = front.load()
            match (headBlock.pop()) {
                case BlockDone =>
                    if (!nextBlock(headBlock, front, rear)) {
                        return None
                    }
                case NoEntry => break
                case ELEM(e) => return Some(e)
            }
        }
        return None
    }

    public func peek(): Option<E> {
        while (true) {
            let headBlock = front.load()
            let entry = headBlock.front()
            match (entry) {
                case ELEM(e) => return Some(e)
                case NoEntry => break
                case BlockDone =>
                    if (!nextBlock(headBlock, front, rear)) {
                        break
                    }
            }
        }
        return None<E>
    }
}

// The determinism check's two runs, as top-level helpers (a thin test
// method).
private func dporGridDetRunOnce(tag: String): ScenarioResult {
    let counter = AtomicInt64(0)
    return scenario(tag)
        .mode(DPOR)
        .iterations(50)
        .actor { => counter.fetchAdd(1) }
        .actor { => counter.fetchAdd(-1) }
        .verify { => counter.load() == 0 }
        .build()
        .run()
}

private func dporGridDetCheckIdentical(first: ScenarioResult, second: ScenarioResult): Unit {
    @Assert(first.passed)
    @Assert(second.passed)
    let d1 = first.dporReport
    let d2 = second.dporReport
    @Assert(d1.isSome())
    @Assert(d2.isSome())
    if (let Some(a) <- d1) {
        if (let Some(b) <- d2) {
            @Assert(a.schedulesExplored == b.schedulesExplored)
            @Assert(a.exhausted == b.exhausted)
        }
    }
    let s1 = first.pctSchedule
    let s2 = second.pctSchedule
    @Assert(s1.isSome())
    @Assert(s2.isSome())
    if (let Some(a) <- s1) {
        if (let Some(b) <- s2) {
            let ea = pctEvents(a)
            let eb = pctEvents(b)
            @Assert(ea.size == eb.size)
            for (i in 0..ea.size) {
                @Assert(ea[i].kind == eb[i].kind)
                @Assert(ea[i].from == eb[i].from)
                @Assert(ea[i].to == eb[i].to)
                @Assert(ea[i].step == eb[i].step)
            }
        }
    }
}

@Test
class DporGridTests {
    /// The fine-grained grid is active under DPOR: atomic operations in
    /// this --cj-pct-compiled binary fire grid points during the
    /// exploration, and the shared atomic makes the two actors dependent
    /// (both orders of their grid-level segments explored).
    @TestCase
    func test_dpor_grid_active(): Unit {
        println("Testing DPOR grid activation...")

        let counter = AtomicInt64(0)

        let result = scenario("dpor_grid_active")
            .mode(DPOR)
            .iterations(50)
            .actor { => counter.fetchAdd(1) }
            .actor { => counter.fetchAdd(-1) }
            .verify { => counter.load() == 0 }
            .build()
            .run()

        @Assert(result.passed)
        let dpor = result.dporReport
        @Assert(dpor.isSome())
        if (let Some(d) <- dpor) {
            @Assert(d.schedulesExplored >= 2)
            @Assert(d.exhausted)
            @Assert(!d.deadlocked)
        }
        if (let Some(schedule) <- result.pctSchedule) {
            @Assert(pctScheduleGridPoints(schedule) > 0)
            @Assert(!pctIsDiverged(schedule))
            @Assert(!pctIsDeadlocked(schedule))
            println("Grid schedule: ${schedule.report()}")
        } else {
            @Assert(false)
        }
    }

    /// The grid dependency oracle on the known buggy linked queue: an
    /// element slot zeroed by one actor's remove can be read by another
    /// actor's peek between its reserved snapshot and its buffer read.
    /// The reserved-atomic segments of the two actors are dependent
    /// (same key), so the driver systematically explores the
    /// interleaving. (Op-boundary-only PCT cannot see this bug at all —
    /// the whole operations serialize; grid PCT needs K=4 and hundreds
    /// of samples to hit it by chance. The minimal two-vs-one op shape
    /// is used: the exploration is systematic, so the smallest shape
    /// exposing the bug is also the fastest.)
    ///
    /// The violation itself is a PLAIN-MEMORY race outcome (the buffer
    /// slot), ordered only through atomics: per the dependency-oracle
    /// contract it belongs outside the interleaving check — and the
    /// engine visits each sync class once, so whether the visited
    /// variant exhibits the zeroed-slot peek is a function of the
    /// schedule shapes (the study's q1 out-of-contract finding: the
    /// pre-POP engine caught such variants only by incidentally
    /// re-visiting classes). With the pinned starvation threshold
    /// below, the second window — the first reversal, the remove
    /// against the in-flight add — exhibits it deterministically, and
    /// first-failure stops the exploration there.
    ///
    /// The pinned starvation threshold: this scenario's CAS-retry
    /// spins against a parked peer make each reversal window run
    /// ~the threshold's worth of grid polls (the fair-mode recovery
    /// bound), so the default 10_000 makes those windows ~10k segments
    /// each; 1_000 keeps the storm windows small with the op-level
    /// classes unaffected (the threshold bounds scheduling recovery,
    /// not the explored orderings).
    @TestCase
    func test_dpor_grid_catches_queue_bug(): Unit {
        println("Testing DPOR grid on the concurrent queue bug...")

        let result = scenario("queue_serializable_bug_dpor")
            .mode(DPOR)
            .consistencyModel(Serializability)
            .withState { => BuggyLinkedQueue<Int64>() }
            .actorWithOps([
                operation("add1", { queue => queue.add(1) }),
                operation("peek", { queue => queue.peek() ?? -1 }),
            ])
            .actorWithOps([
                operation("remove", { queue => queue.remove() ?? -1 }),
                operation("peek", { queue => queue.peek() ?? -1 }),
            ])
            .iterations(500)
            .starvationThreshold(1000u64)
            // This test documents the DPOR fair-mode fallback at the
            // starvation point (the comment in nextBlock above): pin it to
            // the historical YieldFairly recovery so the fair-rescued
            // interleaving that materializes the zeroed-slot peek still
            // happens — under the ThrowObstruction default the spinning
            // remove would end as a per-op bounded wait instead
            // (ObstructionDetectedException; see ObstructionPolicy).
            .obstructionPolicy(YieldFairly)
            .build()
            .run()

        println("Queue DPOR: passed=${result.passed}")
        let dpor = result.dporReport
        @Assert(dpor.isSome())
        if (let Some(d) <- dpor) {
            println("Exploration: schedules=${d.schedulesExplored} exhausted=${d.exhausted}")
            @Assert(d.schedulesExplored >= 1)
            @Assert(!d.deadlocked)
            // The data-race report is permanently inert (the mtrace
            // runtime no longer exists): nothing is reported — and
            // nothing may be hallucinated.
            @Assert(!d.stoppedOnRace)
            @Assert(dporRacePairCount(d) == 0)
            // The buffer race is invisible to the dependency oracle (by
            // the division-of-labor contract), and the engine visits each
            // sync class once: whether the visited variant exhibits the
            // zeroed-slot peek is a function of the schedule shapes —
            // with the pinned starvation threshold the second window
            // (the first reversal: the remove against the in-flight add)
            // exhibits it deterministically, and first-failure stops the
            // exploration there (schedules=2).
            @Assert(!result.passed)
            @Assert(d.schedulesExplored < 500)
        }
        if (let Some(schedule) <- result.pctSchedule) {
            println("Last schedule: ${schedule.report()}")
            @Assert(pctScheduleGridPoints(schedule) > 0)
        }
    }

    /// The exploration is deterministic: running the same grid scenario
    /// twice produces the identical schedule count and the identical
    /// final schedule event stream (DPOR replaces record-and-replay —
    /// the reproduction artifact is the scenario itself).
    @TestCase
    func test_dpor_grid_deterministic(): Unit {
        println("Testing DPOR grid determinism...")

        let first = dporGridDetRunOnce("dpor_grid_det_1")
        let second = dporGridDetRunOnce("dpor_grid_det_2")
        dporGridDetCheckIdentical(first, second)
    }

    /// GC-phase stress under the DPOR exploration: allocation-heavy
    /// operations and forced GCs inside actor operations while the grid is
    /// armed. Every explored schedule re-runs the actors, parks at grid
    /// points below statepointed call sites, and the fresh-state reset
    /// re-allocates — so relocation must keep the caller's live
    /// references correct across every park of every schedule.
    @TestCase
    func test_dpor_grid_gc_stress(): Unit {
        println("Testing DPOR grid under GC pressure...")

        let counter = AtomicInt64(0)

        let result = scenario("dpor_grid_gc_stress")
            .mode(DPOR)
            .iterations(50)
            .actorWithOps([
                operation("alloc_add", { =>
                    let arr = Array<Int64>(256, { j => j })
                    counter.fetchAdd(arr[128])
                    1
                }),
                operation("alloc_add_gc", { =>
                    let arr = Array<Int64>(256, { j => j })
                    counter.fetchAdd(arr[129])
                    gc(heavy: true)
                    1
                }),
            ])
            .actorWithOps([
                operation("alloc_sub", { =>
                    let arr = Array<Int64>(256, { j => j })
                    counter.fetchAdd(-arr[128])
                    -1
                }),
                operation("alloc_sub_gc", { =>
                    let arr = Array<Int64>(256, { j => j })
                    counter.fetchAdd(-arr[129])
                    gc(heavy: true)
                    -1
                }),
            ])
            .verify { => counter.load() == 0 }
            .build()
            .run()

        println("GC stress: passed=${result.passed}")
        let dpor = result.dporReport
        @Assert(dpor.isSome())
        if (let Some(d) <- dpor) {
            println("Exploration: schedules=${d.schedulesExplored} exhausted=${d.exhausted}")
            @Assert(d.exhausted)
            @Assert(!d.deadlocked)
        }
        if (let Some(schedule) <- result.pctSchedule) {
            println("Last schedule: ${schedule.report()}")
            @Assert(pctScheduleGridPoints(schedule) > 0)
            @Assert(!pctIsDeadlocked(schedule))
            @Assert(!pctIsDiverged(schedule))
        }
        @Assert(result.passed)
    }

    /// The builder's switch bound caps the guided switches per schedule
    /// (the depth analogue of the schedule budget). Bound 0: no guided
    /// switch is plannable, so the exploration stops after the initial
    /// unguided schedule with the race scan's backlog pruned — reported
    /// as depthPruned (incomplete), not exhausted. A generous bound
    /// leaves the exploration complete, identical to the unbounded
    /// default.
    @TestCase
    func test_dpor_grid_switch_bound(): Unit {
        println("Testing DPOR switch bound...")

        let counter = AtomicInt64(0)
        let zero = scenario("dpor_grid_switch_zero")
            .mode(DPOR)
            .iterations(50)
            .switchBound(0)
            .actor { => let _ = counter.fetchAdd(1) }
            .actor { => let _ = counter.fetchAdd(-1) }
            .verify { => counter.load() == 0 }
            .build()
            .run()

        @Assert(zero.passed)
        let zeroReport = zero.dporReport
        @Assert(zeroReport.isSome())
        if (let Some(d) <- zeroReport) {
            println("Bound 0: schedules=${d.schedulesExplored} exhausted=${d.exhausted} " +
                "depthPruned=${d.depthPruned} (${d.stats})")
            @Assert(d.schedulesExplored == 1)
            @Assert(!d.exhausted)
            @Assert(d.depthPruned)
            @Assert(!d.deadlocked)
        }

        counter.store(0)
        let wide = scenario("dpor_grid_switch_wide")
            .mode(DPOR)
            .iterations(50)
            .switchBound(64)
            .actor { => let _ = counter.fetchAdd(1) }
            .actor { => let _ = counter.fetchAdd(-1) }
            .verify { => counter.load() == 0 }
            .build()
            .run()

        @Assert(wide.passed)
        let wideReport = wide.dporReport
        @Assert(wideReport.isSome())
        if (let Some(d) <- wideReport) {
            println("Bound 64: schedules=${d.schedulesExplored} exhausted=${d.exhausted} " +
                "depthPruned=${d.depthPruned} (${d.stats})")
            @Assert(d.schedulesExplored >= 2)
            @Assert(d.exhausted)
            @Assert(!d.depthPruned)
            @Assert(!d.deadlocked)
        }
    }
}

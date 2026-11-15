/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// NOTE: this file MUST be compiled with --cj-pct — it verifies the
// fine-grained PCT grid: under the flag, `std.sync` imports resolve to the
// stdx.unittest.sync wrappers, whose atomic operations carry a
// pctGridDispatchRw call after every step (plan §5E).
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 4

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
        // Waits for ongoing allocation. Under PCT this spin is exactly the
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

@Test
class PctGridTests {
    /// The fine-grained grid is active: atomic operations in this
    /// --cj-pct-compiled binary fire grid points during a PCT run.
    @TestCase
    func test_pct_grid_active(): Unit {
        println("Testing PCT grid activation...")

        let counter = AtomicInt64(0)

        let result = scenario("pct_grid_active")
            .mode(PCT)
            .priorityChangePoints(2)
            .iterations(5)
            .actor { => counter.fetchAdd(1) }
            .actor { => counter.fetchAdd(-1) }
            .verify { => counter.load() == 0 }
            .build()
            .run()

        @Assert(result.passed)
        if (let Some(schedule) <- result.pctSchedule) {
            @Assert(pctScheduleGridPoints(schedule) > 0)
            @Assert(!pctIsDiverged(schedule))
            @Assert(!pctIsDeadlocked(schedule))
            println("Grid schedule: ${schedule.report()}")
        } else {
            @Assert(false)
        }
    }

    /// The grid catches the known non-serializable interleaving inside the
    /// buggy linked queue: an element slot zeroed by one actor's remove is
    /// read by another actor's peek between its reserved snapshot and its
    /// buffer read. Op-boundary-only PCT cannot see this bug (whole
    /// operations execute atomically); the stress runner needs tens of
    /// thousands of rounds to hit it by chance.
    @TestCase
    func test_pct_grid_catches_queue_bug(): Unit {
        println("Testing PCT grid on the concurrent queue bug...")

        let result = scenario("queue_serializable_bug_pct")
            .mode(PCT)
            .priorityChangePoints(4)
            .consistencyModel(Serializability)
            .withState { => BuggyLinkedQueue<Int64>() }
            .actorWithOps([
                operation("add1", { queue => queue.add(1) }),
                operation("peek", { queue => queue.peek() ?? -1 }),
                operation("add3", { queue => queue.add(3) }),
            ])
            .actorWithOps([
                operation("remove", { queue => queue.remove() ?? -1 }),
                operation("peek", { queue => queue.peek() ?? -1 }),
                operation("remove", { queue => queue.remove() ?? -1 }),
            ])
            .iterations(200)
            .build()
            .run()

        println("Queue PCT: passed=${result.passed}")
        if (let Some(schedule) <- result.pctSchedule) {
            println("Last schedule: ${schedule.report()}")
            @Assert(pctScheduleGridPoints(schedule) > 0)
        }
        @Assert(!result.passed)
    }

    /// Record a grid schedule and replay it: a faithful replay reproduces
    /// the exact decision sequence (grid points and op boundaries share the
    /// same replay key space).
    @TestCase
    func test_pct_grid_record_and_replay(): Unit {
        println("Testing PCT grid record + replay...")

        let counter = AtomicInt64(0)

        let recorded = scenario("pct_grid_replay_source")
            .mode(PCT)
            .priorityChangePoints(2)
            .iterations(1)
            .actor { => counter.fetchAdd(1) }
            .actor { => counter.fetchAdd(-1) }
            .verify { => counter.load() == 0 }
            .build()
            .run()

        @Assert(recorded.passed)
        @Assert(recorded.pctSchedule.isSome())
        let schedule = recorded.pctSchedule.getOrThrow()
        @Assert(pctEvents(schedule).size > 0)
        @Assert(pctScheduleGridPoints(schedule) > 0)
        println("Recorded: ${schedule.report()}")

        let replayCounter = AtomicInt64(0)
        let replayed = scenario("pct_grid_replay")
            .mode(PCT)
            .priorityChangePoints(pctSchedulePcpBudget(schedule))
            .replaySchedule(schedule)
            .actor { => replayCounter.fetchAdd(1) }
            .actor { => replayCounter.fetchAdd(-1) }
            .verify { => replayCounter.load() == 0 }
            .build()
            .run()

        @Assert(replayed.passed)
        @Assert(replayed.pctSchedule.isSome())
        let replaySchedule = replayed.pctSchedule.getOrThrow()
        @Assert(!pctIsDiverged(replaySchedule))
        @Assert(!pctIsDeadlocked(replaySchedule))
        println("Replayed: ${replaySchedule.report()}")

        let recordedEvents = pctEvents(schedule)
        let replayedEvents = pctEvents(replaySchedule)
        @Assert(replayedEvents.size == recordedEvents.size)
        for (i in 0..recordedEvents.size) {
            let expected = recordedEvents[i]
            let actual = replayedEvents[i]
            @Assert(expected.kind == actual.kind)
            @Assert(expected.from == actual.from)
            @Assert(expected.to == actual.to)
            @Assert(expected.step == actual.step)
        }
    }

    /// GC-phase stress: allocation-heavy operations and forced GCs inside
    /// actor operations while the grid is armed. Actors park at grid points
    /// below statepointed call sites, so relocation must keep the caller's
    /// live references correct across every park.
    @TestCase
    func test_pct_grid_gc_stress(): Unit {
        println("Testing PCT grid under GC pressure...")

        let counter = AtomicInt64(0)

        let result = scenario("pct_grid_gc_stress")
            .mode(PCT)
            .priorityChangePoints(2)
            .iterations(8)
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
        if (let Some(schedule) <- result.pctSchedule) {
            println("Last schedule: ${schedule.report()}")
            @Assert(pctScheduleGridPoints(schedule) > 0)
            @Assert(!pctIsDeadlocked(schedule))
            @Assert(!pctIsDiverged(schedule))
        }
        @Assert(result.passed)
    }
}

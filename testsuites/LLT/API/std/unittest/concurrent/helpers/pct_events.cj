/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// Test bridge for the (protected) PCT schedule vocabulary of
// stdx.unittest.concurrent.
//
// The schedule event vocabulary (PctEventKind, PctEvent, PctWaitStat) and
// every field of PCTSchedule are protected: end users treat PCTSchedule as
// an opaque reproduction handle (obtain from ScenarioResult.pctSchedule,
// feed back via ScenarioBuilder.replaySchedule / pctSeed) and diagnose
// through report() / waitStatsReport(). The framework's own unit tests
// still need to assert on the recorded event streams; they do it through
// this package, which lives in the same module (`stdx`) as
// stdx.unittest.concurrent, so it can reach the protected members and
// re-exposes them through public functions whose signatures only use
// public types (a public mirror enum + structs, mirroring the protected
// originals field-for-field).

package stdx.concurrent_test_util

import stdx.unittest.concurrent.*
import std.collection.ArrayList

// --- Public mirror of PctEventKind (kind names kept identical, so test
// --- `match (ev.kind)` cases carry over unchanged) ---

public enum TestPctEventKind <: Equatable<TestPctEventKind> & ToString {
    | Switch
    | Block
    | Wait
    | Done
    | Complete
    | Unlock
    | Release
    | Notify
    | NotifyAll
    | Spawn
    | Pcp
    | Deadlock
    | Resume
    | FairYield
    | Timer

    public operator func ==(other: TestPctEventKind): Bool {
        match ((this, other)) {
            case (Switch, Switch) => true
            case (Block, Block) => true
            case (Wait, Wait) => true
            case (Done, Done) => true
            case (Complete, Complete) => true
            case (Unlock, Unlock) => true
            case (Release, Release) => true
            case (Notify, Notify) => true
            case (NotifyAll, NotifyAll) => true
            case (Spawn, Spawn) => true
            case (Pcp, Pcp) => true
            case (FairYield, FairYield) => true
            case (Deadlock, Deadlock) => true
            case (Resume, Resume) => true
            case (Timer, Timer) => true
            case _ => false
        }
    }

    public func toString(): String {
        match (this) {
            case Switch => "Switch"
            case Block => "Block"
            case Wait => "Wait"
            case Done => "Done"
            case Complete => "Complete"
            case Unlock => "Unlock"
            case Release => "Release"
            case Notify => "Notify"
            case NotifyAll => "NotifyAll"
            case Spawn => "Spawn"
            case Pcp => "Pcp"
            case FairYield => "FairYield"
            case Deadlock => "Deadlock"
            case Resume => "Resume"
            case Timer => "Timer"
        }
    }
}

// --- Public mirrors of PctEvent / PctWaitStat (fields kept identical) ---

/** Mirror of one recorded PCT scheduling decision (see PctEvent). */
public struct TestPctEvent <: Equatable<TestPctEvent> {
    public let kind: TestPctEventKind
    public let from: Int64
    public let to: Int64
    public let step: UInt64

    public init(kind!: TestPctEventKind, from!: Int64, to!: Int64, step!: UInt64) {
        this.kind = kind
        this.from = from
        this.to = to
        this.step = step
    }

    public operator func ==(other: TestPctEvent): Bool {
        kind == other.kind && from == other.from && to == other.to && step == other.step
    }
}

/** Mirror of one actor's starvation accounting (see PctWaitStat). */
public struct TestPctWaitStat <: Equatable<TestPctWaitStat> {
    public let actorId: Int64
    public let waits: Int64
    public let blocks: Int64
    public let totalWaitSpan: Int64
    public let maxWaitSpan: Int64
    public let openWaits: Int64

    public init(actorId!: Int64, waits!: Int64, blocks!: Int64,
        totalWaitSpan!: Int64, maxWaitSpan!: Int64, openWaits!: Int64) {
        this.actorId = actorId
        this.waits = waits
        this.blocks = blocks
        this.totalWaitSpan = totalWaitSpan
        this.maxWaitSpan = maxWaitSpan
        this.openWaits = openWaits
    }

    public operator func ==(other: TestPctWaitStat): Bool {
        actorId == other.actorId && waits == other.waits && blocks == other.blocks &&
        totalWaitSpan == other.totalWaitSpan && maxWaitSpan == other.maxWaitSpan &&
        openWaits == other.openWaits
    }
}

// --- Bridge functions (public signatures over protected members) ---

func mapPctEventKind(k: PctEventKind): TestPctEventKind {
    match (k) {
        case PctEventKind.Switch => TestPctEventKind.Switch
        case PctEventKind.Block => TestPctEventKind.Block
        case PctEventKind.Wait => TestPctEventKind.Wait
        case PctEventKind.Done => TestPctEventKind.Done
        case PctEventKind.Complete => TestPctEventKind.Complete
        case PctEventKind.Unlock => TestPctEventKind.Unlock
        case PctEventKind.Release => TestPctEventKind.Release
        case PctEventKind.Notify => TestPctEventKind.Notify
        case PctEventKind.NotifyAll => TestPctEventKind.NotifyAll
        case PctEventKind.Spawn => TestPctEventKind.Spawn
        case PctEventKind.Pcp => TestPctEventKind.Pcp
        case PctEventKind.Deadlock => TestPctEventKind.Deadlock
        case PctEventKind.Resume => TestPctEventKind.Resume
        case PctEventKind.FairYield => TestPctEventKind.FairYield
        case PctEventKind.Timer => TestPctEventKind.Timer
    }
}

/** The recorded event stream of `s` (mirror of `PCTSchedule.events`). */
public func pctEvents(s: PCTSchedule): Array<TestPctEvent> {
    let out = ArrayList<TestPctEvent>()
    for (ev in s.events) {
        out.add(TestPctEvent(
            kind: mapPctEventKind(ev.kind),
            from: Int64(ev.from),
            to: Int64(ev.to),
            step: ev.step
        ))
    }
    out.toArray()
}

/** Starvation accounting, one entry per referenced actor slot (mirror of
 *  `PCTSchedule.waitStats()`). */
public func pctWaitStats(s: PCTSchedule): Array<TestPctWaitStat> {
    let out = ArrayList<TestPctWaitStat>()
    for (st in s.waitStats()) {
        out.add(TestPctWaitStat(
            actorId: st.actorId,
            waits: st.waits,
            blocks: st.blocks,
            totalWaitSpan: st.totalWaitSpan,
            maxWaitSpan: st.maxWaitSpan,
            openWaits: st.openWaits
        ))
    }
    out.toArray()
}

/** The actor path of the wait-for cycle that aborted the iteration
 *  (mirror of `PCTSchedule.deadlockCycle`); `None` when no cycle. */
public func pctDeadlockCycle(s: PCTSchedule): ?Array<Int64> {
    s.deadlockCycle
}

/** Whether the schedule recorded a proven-deadlock abort (mirror of
 *  `PCTSchedule.deadlocked`). */
public func pctIsDeadlocked(s: PCTSchedule): Bool {
    s.deadlocked
}

/** Whether the schedule recorded a replay divergence (mirror of
 *  `PCTSchedule.diverged`). */
public func pctIsDiverged(s: PCTSchedule): Bool {
    s.diverged
}

/** The schedule's RNG seed (mirror of `PCTSchedule.seed`). */
public func pctScheduleSeed(s: PCTSchedule): UInt64 {
    s.seed
}

/** The PCT priority-change-point budget the schedule ran with (mirror of
 *  `PCTSchedule.pcpBudget`). */
public func pctSchedulePcpBudget(s: PCTSchedule): Int64 {
    s.pcpBudget
}

/** How many grid checks the schedule performed (mirror of
 *  `PCTSchedule.gridPoints`). */
public func pctScheduleGridPoints(s: PCTSchedule): UInt64 {
    s.gridPoints
}

/** How many scheduling decisions (polls) the schedule performed (mirror of
 *  `PCTSchedule.pollCount`). */
public func pctSchedulePollCount(s: PCTSchedule): UInt64 {
    s.pollCount
}

/** The number of data-race pairs reported by a DPOR exploration (mirror
 *  of `DporReport.racePairs`; always 0 without an mtrace runtime). */
public func dporRacePairCount(r: DporReport): Int64 {
    Int64(r.racePairs.size)
}

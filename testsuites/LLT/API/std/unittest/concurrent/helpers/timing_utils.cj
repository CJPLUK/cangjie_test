/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// Test-support package for stdx.unittest.concurrent internals.
//
// Like utils.cj, this package lives in the same module (`stdx`) as
// `stdx.unittest.concurrent`, so it can reach protected members and
// re-expose them to concurrent framework unit tests through public
// functions whose signatures only use public types.

package stdx.concurrent_test_util

import stdx.unittest.concurrent.*

// --- Actor-result inspection (timing and names) ---

// Per-actor execution durations (endTime - startTime) in nanoseconds of
// one iteration's ActorResults, in actor order: the protected timing
// fields re-exposed so tests can assert that recorded actor timings are
// really measured. `iteration` defaults to the first (calibration)
// iteration.
public func actorDurationsNanos(result: ScenarioResult, iteration!: Int64 = 0): Array<Int64> {
    result.iterationResults[iteration].actorResults.map { r => r.duration.toNanoseconds() }
}

// The actor-result names of one iteration, in actor order (the actors'
// configured names as recorded by the runner).
public func actorNames(result: ScenarioResult, iteration!: Int64 = 0): Array<String> {
    result.iterationResults[iteration].actorResults.map { r => r.actorName }
}

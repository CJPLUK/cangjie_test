/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// Test-support package for stdx.unittest.concurrent internals.
//
// The concurrent testing framework exposes only its user-facing API publicly.
// Internal building blocks (history, validators, partial order) are protected
// types, so regular users cannot name, instantiate, or inspect them. This
// package lives in the same module (`stdx`) as `stdx.unittest.concurrent`, so
// it can reach those protected members, and re-exposes the operations needed
// by concurrent framework unit tests through public functions whose
// signatures only use public types.

package stdx.concurrent_test_util

import stdx.unittest.concurrent.*
import std.collection.ArrayList

// --- Factory for OperationInvocation (type stays public, constructor is protected) ---

public func newOperationInvocation(
    actorId!: Int64,
    operationIndex!: Int64,
    operationName!: String,
    result!: EquatableObj,
    invocationVC!: ?Array<Int64> = None,
    responseVC!: ?Array<Int64> = None
): OperationInvocation {
    OperationInvocation(
        actorId: actorId,
        operationIndex: operationIndex,
        operationName: operationName,
        result: result,
        invocationVC: invocationVC,
        responseVC: responseVC
    )
}

// --- Encapsulated history + validation ---
//
// Builds a ConcurrentHistory from per-actor invocation lists, validates it
// against the given sequential specification, and returns the validation
// result. ConcurrentHistory and ConsistencyValidator (both protected) never
// escape to the caller.

public func validateManualHistory(
    model: ConsistencyModel,
    actorInvocations: Array<ArrayList<OperationInvocation>>,
    createFreshInstance: () -> Any,
    reExecuteOperation: (Any, OperationInvocation) -> EquatableObj
): ConsistencyValidationResult {
    let history = ConcurrentHistory()
    for (actorId in 0..actorInvocations.size) {
        history.recordActorInvocations(actorId, actorInvocations[actorId])
    }
    let validator = ConsistencyValidator(
        consistencyModel: model,
        createFreshInstance: createFreshInstance,
        reExecuteOperation: reExecuteOperation
    )
    validator.validate(history)
}

// --- Partial-order inspection (encapsulates PartialOrder, protected) ---

// Count predecessor edges in the partial order of the first iteration's
// consistency validation result.
public func countPredecessorEdges(result: ScenarioResult): Int64 {
    var total: Int64 = 0
    match (result.iterationResults[0].consistencyValidation) {
        case Some(cr) =>
            let po = cr.partialOrder
            for (opId in po.operations) {
                total += po.predecessorCount(opId)
            }
        case None => ()
    }
    total
}

// Operation count of the partial order of the first iteration's consistency
// validation result.
public func getPartialOrderSize(result: ScenarioResult): Int64 {
    match (result.iterationResults[0].consistencyValidation) {
        case Some(cr) => cr.partialOrder.size
        case None => 0
    }
}

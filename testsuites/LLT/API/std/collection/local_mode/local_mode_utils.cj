/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
//
// XFAIL(runtime-local-write) registry.
//   16 local_mode cases below keep // LEVEL: 0 but have their // EXEC lines disabled as
//   // DISABLED-EXEC:, because maple_test has no expected-fail directive and a case with
//   no active EXEC is not collected. Each aborts at runtime with
//     F Barrier::WriteGeneric does not support local object: obj ..., src ...
//   The blocking gap is the placeholder guard in runtime/src/Heap/Barrier/Barrier.cpp
//   WriteGeneric (and the identical ones in WCollector/EnumBarrier.cpp,
//   WCollector/TraceBarrier.cpp): a write barrier whose destination field lives in a local
//   object is rejected outright, so storing an enum/Option payload or a reference into a
//   local collection member cannot work yet. Re-enable a case by restoring the // EXEC:
//   prefix once local-object write barriers are implemented.
//   core/local_mode: test_array_copyable_extension, test_array_copyable_mode_contract, test_array_local_construct, test_array_local_get, test_array_local_set, test_array_local_transform, test_collection_local, test_iterable_iterator_local, test_local_mode_result_contract
//   collection/local_mode: test_arraylist_copyable_extension, test_arraylist_copyable_mode_contract, test_arraylist_iterator_local, test_arraylist_local_construct, test_arraylist_local_get, test_arraylist_local_set, test_arraylist_local_transform
//   UPDATE 2026-09-10: 上列文件已按设计（LM-DOC-20260910）重写并部分恢复 EXEC 或
//   拆分出 *_blocked 伴文件（payload/barrier 行独立禁用）；本清单仅为历史线索，
//   现状以各文件头部的 DISABLED-EXEC/EXEC 标注为准。


// Shared assertion helpers for the std local-mode LLT suites:
//   testsuites/LLT/API/std/core/local_mode
//   testsuites/LLT/API/std/collection/local_mode
// This file carries no `// EXEC` directive, so maple_test does not treat it as a
// case. Case files reference it with a `DEPENDENCE:` directive and compile it
// together with the case source, the same convention
// testsuites/LLT/API/std/sync/timer uses for its ./utils.cj helper.

func assertEq<T>(actual: T, expected: T, name: String): Int64 where T <: ToString & Equatable<T> {
    if (actual != expected) {
        println("FAIL: ${name} — expected ${expected}, got ${actual}")
        return 1
    }
    return 0
}

func assertB(actual: Bool, name: String): Int64 {
    if (!actual) {
        println("FAIL: ${name} — expected true, got false")
        return 1
    }
    return 0
}

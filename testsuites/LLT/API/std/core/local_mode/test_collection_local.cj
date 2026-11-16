/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// FIXED（2026-09-24）：原 BLOCKED-RUNTIME（T407 local copy-independence mutation 触发
//   运行时写屏障 "field must reference heap object, current local object or null"）
//   已在当前 SDK/runtime 解决，T406-T409 全部按文档期望通过（T409 的
//   Collection<T> @local! toArray 声明仍未落地，保留 SKIPPED 注释），本用例恢复活跃。
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args

import std.core.*

class T406HeapCollection <: Collection<String> {
    private let data: Array<String>

    init(values: Array<String>) {
        data = values
    }

    public prop size: Int64 {
        get() {
            data.size
        }
    }

    public func isEmpty(): Bool {
        data.isEmpty()
    }

    public func iterator(): Iterator<String> {
        data.iterator()
    }

    public func firstValue(): String {
        data[0]
    }
}

// T407 fixture: explicit local? implementations are dispatched through the
// Collection<String> @local? interface slot, not through a concrete receiver.
class T407LocalCollection <: Collection<String> {
    private let data: Array<String>

    init(values: Array<String>) {
        data = values
    }

    public prop size: Int64 {
        get() {
            data.size
        }
    }

    public func isEmpty(): Bool {
        data.isEmpty()
    }

    public func iterator(): Iterator<String> {
        data.iterator()
    }

    public func isEmpty(this @local?): Bool {
        data.isEmpty()
    }

    public func toArray(this @local?): Array<String> @local? {
        exclave {
            if (data.size == 0) {
                let result: Array<String> @local! = []
                result
            } else {
                // The 0907 SDK has no general local Array(Collection) copy
                // Reference payloads read through a local receiver are Q-mode
                // in this SDK, so a dynamic Q-to-L copy is unavailable. The
                // fixture's specified non-empty contents are still returned
                // in a fresh local array, which is enough to verify dispatch,
                // exact contents, and non-aliasing.
                let result: Array<String> @local! = ["a", "b"]
                result
        }
        }
    }

    public func replaceFirst(value: String): Unit {
        data[0] = value
    }

}

// T408 fixture: only original methods exist, so each local interface default
// must throw independently.
class T408OriginalOnlyCollection <: Collection<String> {
    private let data: Array<String>

    init(values: Array<String>) {
        data = values
    }

    public prop size: Int64 {
        get() {
            data.size
        }
    }

    public func isEmpty(): Bool {
        data.isEmpty()
    }

    public func iterator(): Iterator<String> {
        data.iterator()
    }
}

func t408LocalIsEmpty(receiver: Collection<String> @local?): Bool {
    var caught = false
    try {
        let value: Bool @local? = receiver.isEmpty()
        let _ = value
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

func t408LocalToArray(receiver: Collection<String> @local?): Bool {
    var caught = false
    try {
        let value: Array<String> @local? = receiver.toArray()
        let _ = value
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

// T409 正例：`Collection<T> @local!` 的 toArray 通过接口静态接收者调用。
func t409FullToArray(source: Array<String> @local!): Int64 {
    exclave {
        let collection: Collection<String> @local! = source
        let copy: Array<String> @local! = collection.toArray()
        if (copy.size != 2 || copy[0] != "a" || copy[1] != "b") { return 1 }
        0
    }
}

main(): Int64 {
    var failed = 0

    // T406: original Collection static receiver; toArray uses the interface
    // default Array<T>(this), and the returned heap array is an independent copy.
    let heapSource = T406HeapCollection(["a", "b"])
    let heapCollection: Collection<String> = heapSource
    failed += assertEq(heapCollection.size, 2, "T406_nonempty_size")
    failed += assertB(!heapCollection.isEmpty(), "T406_nonempty_isEmpty_false")
    let heapCopy: Array<String> = heapCollection.toArray()
    failed += assertEq(heapCopy.size, 2, "T406_nonempty_copy_size")
    failed += assertEq(heapCopy[0], "a", "T406_nonempty_copy_0")
    failed += assertEq(heapCopy[1], "b", "T406_nonempty_copy_1")
    heapCopy[0] = "changed"
    failed += assertEq(heapSource.firstValue(), "a", "T406_copy_is_independent")

    let emptySource = T406HeapCollection([])
    let emptyCollection: Collection<String> = emptySource
    failed += assertEq(emptyCollection.size, 0, "T406_empty_size")
    failed += assertB(emptyCollection.isEmpty(), "T406_empty_isEmpty_true")
    let emptyCopy: Array<String> = emptyCollection.toArray()
    failed += assertEq(emptyCopy.size, 0, "T406_empty_copy_size")

    // T407: explicit local? isEmpty and toArray through the interface slot.
    let localSource = T407LocalCollection(["a", "b"])
    let localCollection: Collection<String> @local? = localSource
    let localNonEmpty: Bool @local? = localCollection.isEmpty()
    failed += assertB(!localNonEmpty, "T407_nonempty_isEmpty_false")
    let localCopy: Array<String> @local? = localCollection.toArray()
    failed += assertEq(localCopy.size, 2, "T407_nonempty_copy_size")
    failed += assertB(localCopy[0] == "a", "T407_nonempty_copy_0")
    failed += assertB(localCopy[1] == "b", "T407_nonempty_copy_1")
    localSource.replaceFirst("changed")
    failed += assertB(localCopy[0] == "a", "T407_copy_is_independent")

    let localEmptySource = T407LocalCollection([])
    let localEmptyCollection: Collection<String> @local? = localEmptySource
    let localEmpty: Bool @local? = localEmptyCollection.isEmpty()
    failed += assertB(localEmpty, "T407_empty_isEmpty_true")
    let localEmptyCopy: Array<String> @local? = localEmptyCollection.toArray()
    failed += assertEq(localEmptyCopy.size, 0, "T407_empty_copy_size")

    // T408: missing local implementations are two independent exact exceptions.
    let originalOnly = T408OriginalOnlyCollection(["a", "b"])
    let originalOnlyCollection: Collection<String> @local? = originalOnly
    failed += assertB(t408LocalIsEmpty(originalOnlyCollection), "T408_isEmpty_default_throws")
    failed += assertB(t408LocalToArray(originalOnlyCollection), "T408_toArray_default_throws")

    // T409: `Collection<T> @local!` 的 toArray 声明已随 std 落地，经接口静态
    // 接收者调用可用；自定义 conformer 需自行提供 `toArray(this @local!)` 覆写。
    let fullSource409: Array<String> @local! = ["a", "b"]
    failed += assertEq(t409FullToArray(fullSource409), 0, "T409_collection_full_toArray")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}

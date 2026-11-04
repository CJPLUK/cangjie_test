/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

func check(condition: Bool, message: String): Unit {
    if (!condition) {
        throw Exception(message)
    }
}

class IdentityChild <: Object {
    init() {
        super()
    }

    init(this @local!) {
        exclave {
            super()
        }
    }

    init(this @local?) {
        exclave {
            super()
        }
    }
}

main(): Unit {
    let owned: Object @local! = Object() @local!
    let otherOwned: Object @local! = Object() @local!
    let ownedView: Object @local? = owned
    let ownedAlias: Object @local? = ownedView
    check(refEq(owned, owned), "owned object equals itself")
    check(refEq(owned, ownedView), "owned object shares its view")
    check(refEq(ownedView, ownedAlias), "shared aliases preserve identity")
    check(!refEq(owned, otherOwned), "distinct owned objects differ")
    check(!refEq(otherOwned, ownedView), "distinct owned and shared objects differ")

    let shared: Object @local? = Object() @local?
    let otherShared: Object @local? = Object() @local?
    let sharedAlias: Object @local? = shared
    check(refEq(shared, shared), "shared constructor preserves self identity")
    check(refEq(shared, sharedAlias), "shared constructor preserves alias identity")
    check(!refEq(shared, otherShared), "distinct shared objects differ")
    check(!refEq(ownedView, shared), "different local constructor results differ")
    check(!refEq(shared, ownedView), "local identity is symmetric")

    let heap: Object = Object()
    let otherHeap: Object = Object()
    let heapView: Object @local? = heap
    let heapAlias: Object @local? = heapView
    check(refEq(heapView, heap), "heap view equals its original")
    check(refEq(heap, heapView), "heap original equals its view")
    check(refEq(heapView, heapAlias), "heap shared aliases preserve identity")
    check(!refEq(heapView, otherHeap), "heap view differs from another heap object")
    check(!refEq(owned, heap), "owned object differs from heap object")
    check(!refEq(heap, owned), "heap object differs from owned object")
    check(!refEq(shared, heap), "shared local object differs from heap object")
    check(!refEq(heap, shared), "heap object differs from shared local object")

    // Upcasting must preserve identity in every supported constructor mode.
    let childOwned: IdentityChild @local! = IdentityChild() @local!
    let childOwnedBase: Object @local? = childOwned
    let childOwnedAlias: Object @local? = childOwnedBase
    let childShared: IdentityChild @local? = IdentityChild() @local?
    let childSharedBase: Object @local? = childShared
    let childHeap: IdentityChild = IdentityChild()
    let childHeapBase: Object @local? = childHeap
    check(refEq(childOwned, childOwnedBase), "owned child equals its base view")
    check(refEq(childOwnedBase, childOwnedAlias), "owned child base aliases preserve identity")
    check(refEq(childShared, childSharedBase), "shared child equals its base view")
    check(!refEq(childOwnedBase, childSharedBase), "distinct local children differ after upcast")
    check(!refEq(childSharedBase, childOwnedBase), "upcast local identity is symmetric")
    check(refEq(childHeapBase, childHeap), "heap child equals its base view")
    check(!refEq(childOwnedBase, childHeapBase), "local child differs from heap child after upcast")
    check(!refEq(childHeapBase, childOwnedBase), "heap child differs from local child after upcast")
}

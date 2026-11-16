// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-trace-memcmp -Woff all %f -o sancov.out
// EXEC: %python pick_defination.py sancov_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt WHOLE | compare %f

internal import std.collection.ArrayList

func f3(a: Array<Int32>, b: Array<Int32>): Bool {
    if (a == b) {
        return true
    }
    return false
}

func f4(a: ArrayList<Int32>, b: ArrayList<Int32>): Bool {
    if (a == b) {
        return true
    }
    return false
}

main() {
    var arr1: Array<Int32> = [1, 2, 3]
    var arr2: Array<Int32> = [2, 3, 4]
    f3(arr1, arr2)
    let arrList1 = ArrayList<Int32>([3, 2, 1])
    let arrList2 = ArrayList<Int32>([4, 3, 2])
    f4(arrList1, arrList2)
    0
}

// ASSERT: regex-2 = Apply\(@__cj_sanitizer_weak_hook_memcmp[,)]
// ASSERT: regex-begin Func @_CN7default2f3
// ASSERT: regex-after %(?P<arraya>\d+)\[a\]:
// ASSERT: regex-after %(?P<arrayb>\d+)\[b\]:
// ASSERT: regex-after %(?P<arrayaarray>\d+): RawArray<Int32>& = Field\(%(?P=arraya), 0\)
// ASSERT: regex-after %(?P<arrayaoffset>\d+): Int64 = Field\(%(?P=arraya), 1\)
// ASSERT: regex-after %(?P<arrayaraw>\d+): CPointer<Int32> = Intrinsic\(acquireRawData<Int32>, %(?P=arrayaarray)\)
// ASSERT: regex-after %(?P<arrayaptr>\d+): CPointer<Int32> = Intrinsic\(addPointer<Int32>, %(?P=arrayaraw), %(?P=arrayaoffset)\)
// ASSERT: regex-after %(?P<arraybarray>\d+): RawArray<Int32>& = Field\(%(?P=arrayb), 0\)
// ASSERT: regex-after %(?P<arrayboffset>\d+): Int64 = Field\(%(?P=arrayb), 1\)
// ASSERT: regex-after %(?P<arraybraw>\d+): CPointer<Int32> = Intrinsic\(acquireRawData<Int32>, %(?P=arraybarray)\)
// ASSERT: regex-after %(?P<arraybptr>\d+): CPointer<Int32> = Intrinsic\(addPointer<Int32>, %(?P=arraybraw), %(?P=arrayboffset)\)
// ASSERT: regex-after %(?P<arrayleft>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=arrayaptr)\)
// ASSERT: regex-after %(?P<arrayright>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=arraybptr)\)
// ASSERT: regex-after %(?P<arraylen>\d+): Int64 = Field\(%(?P=arraya), 2\)
// ASSERT: regex-after %(?P<arraywidth>\d+): Int64 = Intrinsic\(sizeOfType<Int32>\)
// ASSERT: regex-after %(?P<arraybytes>\d+): Int64 = Mul\(%(?P=arraylen), %(?P=arraywidth)\)
// ASSERT: regex-after %(?P<arraysize>\d+): UInt32 = NumericCast\(%(?P=arraybytes)\)
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_memcmp, %(?P=arrayleft), %(?P=arrayright), %(?P=arraysize)\)
// ASSERT: regex-after Bool = Apply\(.*eq\w*, %(?P=arraya), %(?P=arrayb)\)
// ASSERT: regex-begin Func @_CN7default2f4
// ASSERT: regex-after %(?P<lista>\d+)\[a\]:
// ASSERT: regex-after %(?P<listb>\d+)\[b\]:
// ASSERT: regex-after %(?P<listaref>\d+): Struct-\S+<Int32>& = GetElementRef\(%(?P=lista), 0\)
// ASSERT: regex-after %(?P<listbref>\d+): Struct-\S+<Int32>& = GetElementRef\(%(?P=listb), 0\)
// ASSERT: regex-after %(?P<listavalue>\d+): Struct-\S+<Int32> = Load\(%(?P=listaref)\)
// ASSERT: regex-after %(?P<listbvalue>\d+): Struct-\S+<Int32> = Load\(%(?P=listbref)\)
// ASSERT: regex-after %(?P<listaarray>\d+): RawArray<Int32>& = Field\(%(?P=listavalue), 0\)
// ASSERT: regex-after %(?P<listaoffset>\d+): Int64 = Field\(%(?P=listavalue), 1\)
// ASSERT: regex-after %(?P<listaraw>\d+): CPointer<Int32> = Intrinsic\(acquireRawData<Int32>, %(?P=listaarray)\)
// ASSERT: regex-after %(?P<listaptr>\d+): CPointer<Int32> = Intrinsic\(addPointer<Int32>, %(?P=listaraw), %(?P=listaoffset)\)
// ASSERT: regex-after %(?P<listbarray>\d+): RawArray<Int32>& = Field\(%(?P=listbvalue), 0\)
// ASSERT: regex-after %(?P<listboffset>\d+): Int64 = Field\(%(?P=listbvalue), 1\)
// ASSERT: regex-after %(?P<listbraw>\d+): CPointer<Int32> = Intrinsic\(acquireRawData<Int32>, %(?P=listbarray)\)
// ASSERT: regex-after %(?P<listbptr>\d+): CPointer<Int32> = Intrinsic\(addPointer<Int32>, %(?P=listbraw), %(?P=listboffset)\)
// ASSERT: regex-after %(?P<listleft>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=listaptr)\)
// ASSERT: regex-after %(?P<listright>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=listbptr)\)
// ASSERT: regex-after %(?P<listlen>\d+): Int64 = Field\(%(?P=listavalue), 2\)
// ASSERT: regex-after %(?P<listwidth>\d+): Int64 = Intrinsic\(sizeOfType<Int32>\)
// ASSERT: regex-after %(?P<listbytes>\d+): Int64 = Mul\(%(?P=listlen), %(?P=listwidth)\)
// ASSERT: regex-after %(?P<listsize>\d+): UInt32 = NumericCast\(%(?P=listbytes)\)
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_memcmp, %(?P=listleft), %(?P=listright), %(?P=listsize)\)
// ASSERT: regex-after Bool = Apply\(.*eq\w*, %(?P=lista), %(?P=listb)\)

// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %dumpCHIRDebug --sanitizer-coverage-trace-memcmp -Woff all %f -o sancov.out
// EXEC: %python pick_defination.py sancov_CHIR/[0-9]*_Sanitizer_Coverage.chirtxt "Func @_CN7default6<main>Hv" | compare %f

class X {
    let a: Int64 = 1
    let b: Int32 = 2
}

extend X <: Comparable<X> {
    public func compare(x: X) {
        return Ordering.LT
    }
}

main(): Int64 {
    let arrViaString: Array<String> = ["cangjie", "cang", "jie"]
    let arrViaArrF: Array<Array<String>> = Array<Array<String>>(2, repeat: arrViaString)
    let arrViaArrS = arrViaArrF.clone()
    let res1 = arrViaArrS == arrViaArrF

    let arrClass: Array<X> = [X(), X()]
    let arrClass2 = arrClass.clone()
    let res2 = arrClass == arrClass2
    0
}

// ASSERT: regex-2 = Apply\(@__cj_sanitizer_weak_hook_memcmp,
// ASSERT: regex-begin Func @_CN7default6<main>Hv
// ASSERT: regex-after %(?P<nestedleftarray>\d+): RawArray<Struct-_CNat5ArrayIG_E<Struct-_CNat6StringE>>& = Field\(%(?P<nestedleft>\d+), 0\)
// ASSERT: regex-after %(?P<nestedleftoffset>\d+): Int64 = Field\(%(?P=nestedleft), 1\)
// ASSERT: regex-after %(?P<nestedleftraw>\d+): CPointer<Struct-_CNat5ArrayIG_E<Struct-_CNat6StringE>> = Intrinsic\(acquireRawData<Struct-_CNat5ArrayIG_E<Struct-_CNat6StringE>>, %(?P=nestedleftarray)\)
// ASSERT: regex-after %(?P<nestedleftpoint>\d+): CPointer<Struct-_CNat5ArrayIG_E<Struct-_CNat6StringE>> = Intrinsic\(addPointer<Struct-_CNat5ArrayIG_E<Struct-_CNat6StringE>>, %(?P=nestedleftraw), %(?P=nestedleftoffset)\)
// ASSERT: regex-after %(?P<nestedrightarray>\d+): RawArray<Struct-_CNat5ArrayIG_E<Struct-_CNat6StringE>>& = Field\(%(?P<nestedright>\d+), 0\)
// ASSERT: regex-after %(?P<nestedrightoffset>\d+): Int64 = Field\(%(?P=nestedright), 1\)
// ASSERT: regex-after %(?P<nestedrightraw>\d+): CPointer<Struct-_CNat5ArrayIG_E<Struct-_CNat6StringE>> = Intrinsic\(acquireRawData<Struct-_CNat5ArrayIG_E<Struct-_CNat6StringE>>, %(?P=nestedrightarray)\)
// ASSERT: regex-after %(?P<nestedrightpoint>\d+): CPointer<Struct-_CNat5ArrayIG_E<Struct-_CNat6StringE>> = Intrinsic\(addPointer<Struct-_CNat5ArrayIG_E<Struct-_CNat6StringE>>, %(?P=nestedrightraw), %(?P=nestedrightoffset)\)
// ASSERT: regex-after %(?P<nestedleftvoid>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=nestedleftpoint)\)
// ASSERT: regex-after %(?P<nestedrightvoid>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=nestedrightpoint)\)
// ASSERT: regex-after %(?P<nestedlength>\d+): Int64 = Field\(%(?P=nestedleft), 2\)
// ASSERT: regex-after %(?P<nestedwidth>\d+): Int64 = Intrinsic\(sizeOfType<Struct-_CNat5ArrayIG_E<Struct-_CNat6StringE>>\)
// ASSERT: regex-after %(?P<nestedbytes>\d+): Int64 = Mul\(%(?P=nestedlength), %(?P=nestedwidth)\)
// ASSERT: regex-after %(?P<nestedsize>\d+): UInt32 = NumericCast\(%(?P=nestedbytes)\)
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_memcmp, %(?P=nestedleftvoid), %(?P=nestedrightvoid), %(?P=nestedsize)\)
// ASSERT: regex-after Bool = Apply\(.*eq\w*, %(?P=nestedleft), %(?P=nestedright)\)
// ASSERT: regex-after %(?P<objectleftarray>\d+): RawArray<Class-_CN7default1XE&>& = Field\(%(?P<objectleft>\d+), 0\)
// ASSERT: regex-after %(?P<objectleftoffset>\d+): Int64 = Field\(%(?P=objectleft), 1\)
// ASSERT: regex-after %(?P<objectleftraw>\d+): CPointer<Class-_CN7default1XE&> = Intrinsic\(acquireRawData<Class-_CN7default1XE&>, %(?P=objectleftarray)\)
// ASSERT: regex-after %(?P<objectleftpoint>\d+): CPointer<Class-_CN7default1XE&> = Intrinsic\(addPointer<Class-_CN7default1XE&>, %(?P=objectleftraw), %(?P=objectleftoffset)\)
// ASSERT: regex-after %(?P<objectrightarray>\d+): RawArray<Class-_CN7default1XE&>& = Field\(%(?P<objectright>\d+), 0\)
// ASSERT: regex-after %(?P<objectrightoffset>\d+): Int64 = Field\(%(?P=objectright), 1\)
// ASSERT: regex-after %(?P<objectrightraw>\d+): CPointer<Class-_CN7default1XE&> = Intrinsic\(acquireRawData<Class-_CN7default1XE&>, %(?P=objectrightarray)\)
// ASSERT: regex-after %(?P<objectrightpoint>\d+): CPointer<Class-_CN7default1XE&> = Intrinsic\(addPointer<Class-_CN7default1XE&>, %(?P=objectrightraw), %(?P=objectrightoffset)\)
// ASSERT: regex-after %(?P<objectleftvoid>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=objectleftpoint)\)
// ASSERT: regex-after %(?P<objectrightvoid>\d+): CPointer<Void> = Intrinsic\(pointerInit1, %(?P=objectrightpoint)\)
// ASSERT: regex-after %(?P<objectlength>\d+): Int64 = Field\(%(?P=objectleft), 2\)
// ASSERT: regex-after %(?P<objectwidth>\d+): Int64 = Intrinsic\(sizeOfType<Class-_CN7default1XE&>\)
// ASSERT: regex-after %(?P<objectbytes>\d+): Int64 = Mul\(%(?P=objectlength), %(?P=objectwidth)\)
// ASSERT: regex-after %(?P<objectsize>\d+): UInt32 = NumericCast\(%(?P=objectbytes)\)
// ASSERT: regex-after Unit = Apply\(@__cj_sanitizer_weak_hook_memcmp, %(?P=objectleftvoid), %(?P=objectrightvoid), %(?P=objectsize)\)
// ASSERT: regex-after Bool = Apply\(.*eq\w*, %(?P=objectleft), %(?P=objectright)\)

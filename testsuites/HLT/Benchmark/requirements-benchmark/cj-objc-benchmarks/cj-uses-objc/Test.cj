// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package objc.sample

import std.convert.*
import std.time.*
import objc.sample.macros.*

@C
public func ObjC_objcsample_Test_testImpl(): Unit {
    test()
}

public func testStatic(): Unit {
    @Test[0, "CJ static"](Payload.staticBlackhole($N))
}

func testInstance(): Unit {
    let cjInstance = Payload()
    @Test[0, "CJ instance"](cjInstance.instanceBlackhole($N))
}

func testVirtual(): Unit {
    let cjInstance = Payload()
    @Test[0, "CJ->CJ   virtual   "](cjInstance.virtualBlackhole($N))
}

public func testGet(): Unit {
    @Test[0, "CJ->CJ   get       "](Payload.get().virtualBlackhole($N))
}

public func testObjcStatic(): Unit {
    @Test[0, "CJ->ObjC static    "](M.staticBlackhole($N))
}

func testObjcInstance(): Unit {
    let objcInstance = M()
    @Test[0, "CJ->ObjC instance  "](objcInstance.instanceBlackhole($N))
}

func testObjcGet(): Unit {
    @Test[0, "CJ->ObjC get       "](M.get().instanceBlackhole($N))
}

public func testObjcStatic1(): Unit {
    @Test[0, "CJ->ObjC static   1"](M1.staticBlackhole($N))
}

func testObjcInstance1(): Unit {
    let objcInstance = M1()
    @Test[0, "CJ->ObjC instance 1"](objcInstance.instanceBlackhole($N))
}

func testObjcGet1(): Unit {
    @Test[0, "CJ->ObjC get      1"](M1.get().instanceBlackhole($N))
}

public func testObjcStatic2(): Unit {
    @Test[0, "CJ->ObjC static   2"](M2.staticBlackhole($N))
}

func testObjcInstance2(): Unit {
    let objcInstance = M2()
    @Test[0, "CJ->ObjC instance 2"](objcInstance.instanceBlackhole($N))
}

func testObjcGet2(): Unit {
    @Test[0, "CJ->ObjC get      2"](M2.get().instanceBlackhole($N))
}

func testObjcInstance3(): Unit {
    unsafe {
        let objcInstance = M3.make()
        @Test[0, "CJ->ObjC instance 3"](M3.instanceBlackhole(objcInstance, $N))
        M3.destroy(objcInstance)
    }

}

func testObjcGet3(): Unit {
    @Test[0, "CJ->ObjC get      3"](
        unsafe {
            let objcInstance = M3.get()
            let result = M3.instanceBlackhole(objcInstance, $N)
            M3.destroy(objcInstance)
            result
        }
    )
}

public func testObjcStatic4(): Unit {
    @Test[0, "CJ->ObjC static   4"](M4.staticBlackhole($N))
}

func testObjcInstance4(): Unit {
    unsafe {
        let objcInstance = M4.make()
        @Test[0, "CJ->ObjC instance 4"](M4.instanceBlackhole(objcInstance, $N))
        M4.destroy(objcInstance)
    }
}

func testObjcGet4(): Unit {
    @Test[0, "CJ->ObjC get      4"](
        unsafe {
            let objcInstance = M4.get()
            let result = M4.instanceBlackhole(objcInstance, $N)
            M4.destroy(objcInstance)
            result
        }
    )
}

func testObjcGet5(): Unit {
    @Test[0, "CJ->ObjC get      5"](
        unsafe {
            let objcInstance = M5.get().getOrThrow()
            let result = M5.instanceBlackhole(objcInstance, $N)
            M5.destroy(objcInstance)
            result
        }
    )
}

func test() {
    testStatic()
    testInstance()

    testObjcStatic()
    testObjcStatic1()
    testObjcStatic2()
    testObjcStatic4()

    testVirtual()
    testObjcInstance()
    testObjcInstance1()
    testObjcInstance2()
    testObjcInstance3()
    testObjcInstance4()

    testGet()
    testObjcGet()
    testObjcGet1()
    testObjcGet2()
    testObjcGet3()
    testObjcGet4()
    testObjcGet5()
}

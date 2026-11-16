// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package objc.sample

import objc.lang.*
import objc.internal.*

foreign func objc_msgSend(): Unit

public class M2 {
    public let obj: NativeObjCId

    public init(obj: NativeObjCId) {
        this.obj = obj
    }

    static var initialised = false
    static var msgSend: ?CPointer<Unit> = None
    static var M_class: ?NativeObjCId = None
    static var sel_alloc: ?NativeObjCSel = None
    static var sel_init: ?NativeObjCSel = None
    static var sel_M_instanceBlackhole: ?NativeObjCSel = None
    static var sel_M_staticBlackhole: ?NativeObjCSel = None
    static var sel_M_get: ?NativeObjCSel = None

    static unsafe func initialise() {
        if (!initialised) {
            msgSend = CPointer<Unit>(objc_msgSend)
            M_class = getClass("M")
            sel_alloc = registerName("alloc")
            sel_init = registerName("init")
            sel_M_instanceBlackhole = registerName("instanceBlackhole:")
            sel_M_staticBlackhole = registerName("staticBlackhole:")
            sel_M_get = registerName("get")
            initialised = true
        }
    }

    init() {
        unsafe {
            initialise()
            let send = msgSend.getOrThrow()
            let allocated = CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(send)(M_class.getOrThrow(), sel_alloc.getOrThrow())
            this.obj = CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(send)(allocated, sel_init.getOrThrow())
        }
    }

    ~init() {
        unsafe { objCRelease(obj) }
    }

    public unsafe func instanceBlackhole(x: Int64): Int64 {
        initialise()
        CFunc<(NativeObjCId, NativeObjCSel, Int64) -> Int64>(msgSend.getOrThrow())(obj, sel_M_instanceBlackhole.getOrThrow(), x)
    }

    public unsafe static func staticBlackhole(x: Int64): Int64 {
        initialise()
        CFunc<(NativeObjCId, NativeObjCSel, Int64) -> Int64>(msgSend.getOrThrow())(M_class.getOrThrow(), sel_M_staticBlackhole.getOrThrow(), x)
    }

    public unsafe static func get(): M2 {
        initialise()
        let objcM = objCRetainAutoreleasedReturnValue(
            CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(msgSend.getOrThrow())(M_class.getOrThrow(), sel_M_get.getOrThrow())
        )
        M2(objcM)
    }

}

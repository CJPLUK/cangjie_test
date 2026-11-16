// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package objc.sample

import objc.lang.*
import objc.internal.*

// M3 with cached values instead of Option
public class M4 {

    static var initialised = false
    static var msgSend: CPointer<Unit> = CPointer<Unit>()
    static var M_class: NativeObjCId = CPointer<Unit>()
    static var sel_alloc: NativeObjCSel = CPointer<Unit>()
    static var sel_init: NativeObjCSel = CPointer<Unit>()
    static var sel_M_instanceBlackhole: NativeObjCSel = CPointer<Unit>()
    static var sel_M_staticBlackhole: NativeObjCSel = CPointer<Unit>()
    static var sel_M_get: NativeObjCSel = CPointer<Unit>()

    static unsafe func initialise() {
        if (!initialised) {
            msgSend = CPointer<Unit>(objCMsgSend())
            M_class = getClass("M")
            sel_alloc = registerName("alloc")
            sel_init = registerName("init")
            sel_M_instanceBlackhole = registerName("instanceBlackhole:")
            sel_M_staticBlackhole = registerName("staticBlackhole:")
            sel_M_get = registerName("get")
            initialised = true
        }
    }

    public static unsafe func make(): NativeObjCId {
        initialise()
        let allocated = CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(msgSend)(M_class, sel_alloc)
        CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(msgSend)(allocated, sel_init)
    }

    public static unsafe func destroy(obj: NativeObjCId): Unit {
        unsafe { objCRelease(obj) }
    }

    public static unsafe func instanceBlackhole(obj: NativeObjCId, x: Int64): Int64 {
        initialise()
        CFunc<(NativeObjCId, NativeObjCSel, Int64) -> Int64>(msgSend)(obj, sel_M_instanceBlackhole, x)
    }

    public static unsafe func staticBlackhole(x: Int64): Int64 {
        initialise()
        CFunc<(NativeObjCId, NativeObjCSel, Int64) -> Int64>(msgSend)(M_class, sel_M_staticBlackhole, x)
    }

    public static unsafe func get(): NativeObjCId {
        initialise()
        objCRetainAutoreleasedReturnValue(
            CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(msgSend)(M_class, sel_M_get)
        )
    }

}

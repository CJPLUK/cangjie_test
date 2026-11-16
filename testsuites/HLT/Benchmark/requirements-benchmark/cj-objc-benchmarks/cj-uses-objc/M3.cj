// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package objc.sample

import objc.lang.*
import objc.internal.*

public class M3 {

    static var initialised = false
    static var msgSend: ?CPointer<Unit> = None
    static var M_class: ?NativeObjCId = None
    static var sel_alloc: ?NativeObjCSel = None
    static var sel_init: ?NativeObjCSel = None
    static var sel_M_instanceBlackhole: ?NativeObjCSel = None
    // static var sel_M_staticBlackhole: ?NativeObjCSel = None
    static var sel_M_get: ?NativeObjCSel = None

    static unsafe func initialise() {
        if (!initialised) {
            msgSend = objCMsgSend()
            M_class = getClass("M")
            sel_alloc = registerName("alloc")
            sel_init = registerName("init")
            sel_M_instanceBlackhole = registerName("instanceBlackhole:")
            // sel_M_staticBlackhole = registerName("staticBlackhole:")
            sel_M_get = registerName("get")
            initialised = true
        }
    }

    public static unsafe func make(): NativeObjCId {
        initialise()
        let send = msgSend.getOrThrow()
        let allocated = CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(send)(M_class.getOrThrow(), sel_alloc.getOrThrow())
        CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(send)(allocated, sel_init.getOrThrow())
    }

    public static unsafe func destroy(obj: NativeObjCId): Unit {
        unsafe { objCRelease(obj) }
    }

    public static unsafe func instanceBlackhole(obj: NativeObjCId, x: Int64): Int64 {
        initialise()
        CFunc<(NativeObjCId, NativeObjCSel, Int64) -> Int64>(msgSend.getOrThrow())(obj, sel_M_instanceBlackhole.getOrThrow(), x)
    }

    public static unsafe func get(): NativeObjCId {
        initialise()
        objCRetainAutoreleasedReturnValue(
            CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(msgSend.getOrThrow())(M_class.getOrThrow(), sel_M_get.getOrThrow())
        )
    }

}

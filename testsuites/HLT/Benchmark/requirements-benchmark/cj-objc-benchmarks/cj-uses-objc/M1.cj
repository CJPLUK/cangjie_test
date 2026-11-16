// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package objc.sample

import objc.lang.*
import objc.internal.*

public class M1 {
    public let obj: NativeObjCId

    public init(obj: NativeObjCId) {
        this.obj = obj
    }

    init() {
        this(unsafe{ 
            CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(objCMsgSend())(alloc(("M")), registerName("init"))
        })
    }

    ~init() {
        unsafe { objCRelease(obj) }
    }

    public func instanceBlackhole(x: Int64): Int64 {
        unsafe {
            CFunc<(NativeObjCId, NativeObjCSel, Int64) -> Int64>(objCMsgSend())(obj, registerName("instanceBlackhole:"), x)
        }
    }

    public static func staticBlackhole(x: Int64): Int64 {
        unsafe {
            CFunc<(NativeObjCId, NativeObjCSel, Int64) -> Int64>(objCMsgSend())(getClass("M"), registerName("staticBlackhole:"), x)
        }
    }

    public static unsafe func get(): M1 {
        let objcM = objCRetainAutoreleasedReturnValue(
            CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(objCMsgSend())(getClass("M"), registerName("get"))
        )
        M1(objcM)
    }

}

// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
open foreign class M <: ProtoM & ProtoM1 {
    public var idField: ObjCId
    public var protoField: ProtoM1

    public static mut prop sIdProp: ObjCId
    public static mut prop sProtoProp: ProtoM1

    public init()

    @ForeignName["booRetObjCIdWithArg0:andArg1:"]
    public static func booRetObjCIdWithArg0AndArg1(arg0: ObjCId, arg1: ProtoM1): ObjCId
    @ForeignName["booRetProtoM1WithArg0:andArg1:"]
    public static func booRetProtoM1WithArg0AndArg1(arg0: ProtoM1, arg1: ObjCId): ProtoM1

    @ForeignName["fooRetObjCIdWithArg0:andArg1:"]
    public open func fooRetObjCIdWithArg0AndArg1(arg0: ObjCId, arg1: ProtoM1): ObjCId
    @ForeignName["fooRetProtoM1WithArg0:andArg1:"]
    public open func fooRetProtoM1WithArg0AndArg1(arg0: ProtoM1, arg1: ObjCId): ProtoM1
}

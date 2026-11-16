// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
foreign interface ProtoM {
  mut prop idProp: ObjCId
  mut prop protoProp: ProtoM1

  static mut prop sIdProp: ObjCId
  static mut prop sProtoProp: ProtoM1

  static func booRetObjCIdWithArg0(arg0: ObjCId): ObjCId
  static func booRetProtoM1WithArg0(arg0: ProtoM1): ProtoM1

  func fooRetObjCIdWithArg0(arg0: ObjCId): ObjCId
  func fooRetProtoM1WithArg0(arg0: ProtoM1): ProtoM1
}

// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (Linux) EXEC-PIPE-0: %compiler %dumpCHIRDebug %enableO2 -Woff all %f %compile_lib_opt -o %n.%middle %import_objc_interop
// (Linux) EXEC: %cat %n\_CHIR/[0-9]*_Devirtualization.chirtxt | compare %f
// (Linux) ASSERT: regex-not Apply\(.*9instancef
// (Linux) ASSERT: regex-not Invoke\(.*9instancef
// (Linux) ASSERT: regex-not Apply\(.*7staticf
// (Linux) ASSERT: regex-not InvokeStatic\(.*7staticf
// (Linux) ASSERT: regex Intrinsic\(.*, @objc_msgSend

import objc.lang.*

@ObjC
foreign class F {
    init()
    func instancef(): Int64
    static func staticf(): Int64
}

public func exposedFunction() {
    let f = F()
    f.instancef()
    F.staticf()
}

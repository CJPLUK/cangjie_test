// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java["com.java.lib.MyObject"]
public open foreign class MyObject {
    public init(arg0: Int8, arg1: ?JArray<Float32>, arg2: ?JArray<Int32>, arg3: ?JArray<Float64>)

    public init(arg0: Int32, arg1: Float32, arg2: ?JArray<Int8>, arg3: Int16)

    public init(arg0: Int8, arg1: ?JArray<Float32>, arg2: Int32, arg3: ?JArray<Float32>, arg4: ?JArray<UInt16>, arg5: ?JArray<Int8>, arg6: ?JArray<UInt16>, arg7: ?JArray<Int32>, arg8: ?JArray<Float32>, arg9: Float32)

    public open func getValue(): ?JString
}

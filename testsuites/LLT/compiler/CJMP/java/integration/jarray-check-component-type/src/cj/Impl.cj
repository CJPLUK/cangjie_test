// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package g

import java.lang.*

@Java
public class Impl {
    // Array component type: java.lang.String
    public func getJStringArr(): JArray<JString> {
        return JArray<JString>(1);
    }

    // Array component type: g.Impl
    public func getImplArr(): JArray<Impl> {
        return JArray<Impl>(1);
    }

    // Array component type: int
    public func getInt32Arr(): JArray<Int32> {
        return JArray<Int32>(1);
    }

    // Array component type: [Lg.Impl;
    public func getArrayArray(): JArray<?JArray<Impl>> {
      return JArray<?JArray<Impl>>(1)
    }

    // Array component type: [[Lg.Impl;
    public func getArrayArrayArray(): JArray<JArray<?JArray<Impl>>> {
      return JArray<JArray<?JArray<Impl>>>(1)
    }

    // Array component type: boolean
    public func getBoolArr(): JArray<Bool> {
        return JArray<Bool>(1);
    }

    // Array component type: long
    public func getInt64Arr(): JArray<Int64> {
        return JArray<Int64>(1);
    }

    // Array component type: double
    public func getFloat64Arr(): JArray<Float64> {
        return JArray<Float64>(1);
    }

    // Array component type: java.lang.String
    public func getNullableStringArr(): ?JArray<JString> {
        return JArray<JString>(1);
    }

    // Array component type: int
    public func getNullableInt32Arr(): ?JArray<Int32> {
        return JArray<Int32>(1);
    }

    // Array component type: g.Impl
    public func getNullableImplArr(): ?JArray<Impl> {
        return JArray<Impl>(1);
    }

    // Array component type: [Ljava.lang.String;
    public func getStringArrayArr(): JArray<JArray<JString>> {
        return JArray<JArray<JString>>(1);
    }

    // Array component type: [I
    public func getIntArrayArr(): JArray<JArray<Int32>> {
        return JArray<JArray<Int32>>(1);
    }
}

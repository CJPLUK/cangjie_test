/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

@Java
public class ChildClass <: ParentClass {
    public init(param0: JArray<Float64>, param1: Float64, param2: Int32, param3: JArray<UInt16>, param4: JArray<UInt16>,
        param5: JArray<Int64>, param6: JArray<UInt16>, param7: JArray<Int8>, param8: JArray<Float32>,
        param9: JArray<Float32>) {
        super(param9, param6, param7, param4, param0, param2 + param2, param5, param3, param1 + param1, param8)
    }
}

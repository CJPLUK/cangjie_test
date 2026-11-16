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
    public init(param0: Int64, param1: JArray<UInt16>, param2: JArray<Int8>, param3: Float64, param4: Float64,
        param5: JString, param6: JArray<Int32>, param7: JArray<Float32>, param8: Int8, param9: Float64) {
        super(param2, param7, param4 + param4, param6, param1, param8 + param8, param0 + param0, param9 + param9,
            param3 + param3, param5)
    }
}

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
    public init(param0: JArray<Float64>, param1: Int64, param2: Float32, param3: JArray<Int16>, param4: Int64,
        param5: Int8, param6: JArray<Float32>, param7: UInt16, param8: JString, param9: JArray<Int8>) {
        super(param7 + param7, param2 + param2, param6, param9, param1 + param1, param0, param5 + param5, param8, param3,
            param4 + param4)
    }
}

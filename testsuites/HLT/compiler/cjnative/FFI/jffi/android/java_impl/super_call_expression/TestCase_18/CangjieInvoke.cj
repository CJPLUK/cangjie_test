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
    public init(param0: Int64, param1: JArray<Float64>, param2: UInt16, param3: UInt16, param4: JArray<Int32>,
        param5: JArray<Int16>, param6: JString, param7: JArray<Float64>, param8: JArray<Int64>, param9: Float64) {
        super(param8, param5, param1, param9 + param9, param0 + param0, param3 + param3, param4, param6, param2 + param2,
            param7)
    }
}

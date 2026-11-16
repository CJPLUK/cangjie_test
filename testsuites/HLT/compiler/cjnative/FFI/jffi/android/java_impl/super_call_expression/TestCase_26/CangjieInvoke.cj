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
    public init(param0: JArray<Int64>, param1: JArray<Int32>, param2: JArray<Int16>, param3: Int8,
        param4: JArray<Int16>, param5: JArray<Int16>, param6: UInt16, param7: Float64, param8: JArray<Float64>,
        param9: Int32) {
        super(param5, param9 + param9, param6 + param6, param8, param3 + param3, param1, param0, param4, param2,
            param7 + param7)
    }
}

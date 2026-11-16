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
    public init(param0: Int8, param1: Int64, param2: JArray<Int16>, param3: JArray<Int64>, param4: JArray<Int64>,
        param5: Int8, param6: JString, param7: Int8, param8: Int16, param9: Float64) {
        super(param7 + param7, param5 + param5, param4, param6, param1 + param1, param3, param9 + param9, param2,
            param0 + param0, param8 + param8)
    }
}

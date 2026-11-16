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
    public init(param0: JArray<UInt16>, param1: Float32, param2: UInt16, param3: JArray<Int64>, param4: Float64,
        param5: Int32, param6: JArray<UInt16>, param7: JArray<Float64>, param8: JArray<UInt16>, param9: Int16) {
        super(param7, param5 + param5, param9 + param9, param6, param3, param0, param8, param2 + param2, param1 + param1,
            param4 + param4)
    }
}

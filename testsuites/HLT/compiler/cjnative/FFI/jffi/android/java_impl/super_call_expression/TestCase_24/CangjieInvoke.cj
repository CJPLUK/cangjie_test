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
    public init(param0: Float32, param1: Float64, param2: Int16, param3: JArray<Float32>, param4: JArray<Int32>,
        param5: JArray<UInt16>, param6: JArray<Int8>, param7: Int32, param8: Int8, param9: JArray<Float64>) {
        super(param2 + param2, param8 + param8, param1 + param1, param7 + param7, param5, param9, param0 + param0,
            param6, param4, param3)
    }
}

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
    public init(param0: Int8, param1: JArray<Int8>, param2: Int32, param3: JArray<Int32>, param4: JArray<Float32>,
        param5: JArray<Float64>, param6: JArray<Float32>, param7: Int64, param8: Float32, param9: JArray<Float32>) {
        super(param2 + param2, param9, param4, param8 + param8, param6, param7 + param7, param5, param3, param1,
            param0 + param0)
    }
}

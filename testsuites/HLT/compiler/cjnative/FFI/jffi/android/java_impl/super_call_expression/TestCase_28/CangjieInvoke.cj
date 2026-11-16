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
    public init(param0: Int8, param1: JArray<Int8>, param2: JArray<Float64>, param3: JArray<UInt16>,
        param4: JArray<Int8>, param5: Float64, param6: Int64, param7: JArray<Float32>, param8: Int64,
        param9: JArray<Int8>) {
        super(param2, param4, param9, param8 + param8, param6 + param6, param3, param0 + param0, param1, param7,
            param5 + param5)
    }
}

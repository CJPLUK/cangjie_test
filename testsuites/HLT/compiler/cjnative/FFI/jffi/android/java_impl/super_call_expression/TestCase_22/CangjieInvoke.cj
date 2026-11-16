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
    public init(param0: JArray<UInt16>, param1: JArray<Float32>, param2: Int16, param3: JArray<UInt16>,
        param4: JArray<Int16>, param5: JArray<Int64>, param6: JArray<Int8>, param7: JArray<Int64>, param8: Float32,
        param9: Float32) {
        super(param3, param4, param5, param1, param8 + param8, param7, param0, param6, param9 + param9, param2 + param2)
    }
}

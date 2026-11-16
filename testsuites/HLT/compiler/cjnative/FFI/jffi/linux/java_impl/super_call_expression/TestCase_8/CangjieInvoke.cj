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
    public init(param0: JArray<Float32>, param1: Int32, param2: JArray<Int8>, param3: JArray<UInt16>,
        param4: JArray<UInt16>, param5: JArray<Int32>, param6: Float32, param7: JArray<Float32>,
        param8: JArray<Float32>, param9: Int8) {
        super(param1 + param1, param3, param6 + param6, param9 + param9, param8, param2, param4, param0, param7, param5)
    }
}

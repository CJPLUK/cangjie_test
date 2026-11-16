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
    public init(param0: JString, param1: JArray<Int16>, param2: JArray<Int16>, param3: Int64, param4: Int8,
        param5: JArray<Int8>, param6: JArray<Int8>, param7: JArray<UInt16>, param8: Int64, param9: UInt16) {
        super(param9 + param9, param6, param7, param4 + param4, param2, param8 + param8, param5, param1, param0,
            param3 + param3)
    }
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
 
package UNNAMED

import java.lang.*

@Java["com.Father"]
public open foreign class Father {
    public mut prop aBoolean: JArray<Bool>

    public mut prop aInt: JArray<Int32>

    public mut static prop arrayInt: JArray<Int32>

    public init(arg0: JArray<Int32>) 

    public init() 
}

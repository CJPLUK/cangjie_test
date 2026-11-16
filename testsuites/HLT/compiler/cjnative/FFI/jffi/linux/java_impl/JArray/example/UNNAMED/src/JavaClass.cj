/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
 
package UNNAMED

import java.lang.*

@Java["com.JavaClass"]
public open foreign class JavaClass {
    public init() 

    public open func takeArr(arr: JArray<Int64>): Unit

    public open func getArr(): JArray<Int64>

    public open func takeArr2(arr: JArray<JavaClass>): Unit

    public open func getArr2(): JArray<JavaClass>

    public open func getInt(): Int64
}

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
    public mut prop v1: Int32

    public init() 

    @ForeignName["loaction_param"]
    public open func loaction_return(): Unit

    public open func loaction_param(): Unit
}

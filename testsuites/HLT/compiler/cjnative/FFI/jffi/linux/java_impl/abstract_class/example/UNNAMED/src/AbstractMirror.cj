/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
 
package UNNAMED

import java.lang.*

@Java["com.AbstractMirror"]
public abstract open foreign class AbstractMirror {
    public init() 

    public static func staticFunc(): Unit

    protected open func abstractFunc(): Unit

    public open func instanceFunc(): Unit
}

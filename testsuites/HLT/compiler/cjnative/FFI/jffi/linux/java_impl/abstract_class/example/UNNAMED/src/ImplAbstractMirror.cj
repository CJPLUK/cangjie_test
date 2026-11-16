/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
 
package UNNAMED

import java.lang.*

@Java["com.ImplAbstractMirror"]
public open foreign class ImplAbstractMirror <: AbstractMirror {
    public init() 

    public open func abstractFunc(): Unit

    public open func id(arg0: AbstractMirror): AbstractMirror

    public open func idImpl(arg0: ImplAbstractMirror): AbstractMirror
}

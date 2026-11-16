/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
 
// LEVEL: 3
// (Android) DEPENDENCE: com MainInstrumentedTest.java 
// (Android) EXEC: %javac com/*.java %java_interop_util/Logger.java
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f %java_interop_util/logger.cj
// (Android) RUN-EXEC: %run %run_opt %output %run_args

package UNNAMED

import java.lang.*

@Java["com.ImplAbstractMirror"]
public open foreign class ImplAbstractMirror <: AbstractMirror {
    public init() 

    public open func abstractFunc(): Unit

    public open func id(arg0: AbstractMirror): AbstractMirror

    public open func idImpl(arg0: ImplAbstractMirror): AbstractMirror
}

@Java["com.AbstractMirror"]
public abstract open foreign class AbstractMirror {
    public init() 

    public static func staticFunc(): Unit

    protected open func abstractFunc(): Unit

    public open func instanceFunc(): Unit
}

@Java
public class Impl <: JObject {
    public init() {
        let i = ImplAbstractMirror()
        let res = i.id(i)
        ImplAbstractMirror.staticFunc()

        match (res) {
            case AbstractMirror => Logger.println("id match: ok")
            case ImplAbstractMirror => Logger.println("id match: failed")
            case _ => Logger.println("id match: unexpected case")
        }

        match (res) {
            case ImplAbstractMirror => Logger.println("id match: ok")
            case AbstractMirror => Logger.println("id match: failed")
            case _ => Logger.println("id match: unexpected match")
        }

        res.abstractFunc()
        (res as ImplAbstractMirror)?.abstractFunc()

        let res2 = i.idImpl(i)
    }
}

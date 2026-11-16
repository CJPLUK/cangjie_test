// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*
import std.runtime.*
 
private class Stub {
    static var finalizeCounter = 0
    ~init() {
        finalizeCounter++
    }
}
 
@Java
public class Impl <: JObject {
    public static func check(): Unit {
        MyObject.lock()
        while (MyObject.getFinalizeCounter() != 1) {
            MyObject.waitLock()
        }
        MyObject.unlock()
    }
 
    public static func hasCjGCCollected() {
        Stub.finalizeCounter == 1
    }
  
    public static func test() {
        let stub = Stub()
        let obj = MyObject()
        obj.foo()
        gc()
    }
}

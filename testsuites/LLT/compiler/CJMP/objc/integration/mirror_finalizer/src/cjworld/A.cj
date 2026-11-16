// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*
import std.collection.*
import std.runtime.*

private var list = ArrayList<M>()

@ObjC
public class A <: M {
    public func test(): Int64 {
        println("cj: A.test()")

        var cur = 0
        while(true) {
            if (locker.tryLock()) {
                cur = counter
                locker.unlock()
                break
            }
        }
        
        var f = spawn {
            testImpl()
            gc()
        }

        f.get()
        while(true) {
            if (locker.tryLock()) {
                if (cur < counter) {
                    locker.unlock()
                } else {
                    locker.unlock()
                    break
                }
            }
        }
        
        cur
    }

    private func testImpl(): Unit {
        println("cj: A.testImpl()")
        var m = M()
        list.add(m)
        list.remove(at:0)
    }
}

/*

Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
This source file is part of the Cangjie project, licensed under Apache-2.0
with Runtime Library Exception.
See https://cangjie-lang.cn/pages/LICENSE for license information.
*/
import std.sync.*

class SomeObject {
    public let mtx: Mutex = Mutex()
    public let mtx2: ReentrantMutex = ReentrantMutex()

    public func put(x: Int64): Unit {
        synchronized(mtx) {
            println(x)
        }
    }

}

main() {
    let so = SomeObject()
    so.put(1)
}
// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args

public interface MyHashable {
    func hashCode(): Int64 {
        0
    }
    func hashCode(this @local?): Int64 {
        println("local?")
        1
    }
}

public class HashMapLocal<K> where K <: MyHashable {
    init() {}
    init(this @local!) {
        exclave {
        }
    }
    public func get(this @local!, key: K ): Unit {
        exclave {
            let k = key.hashCode()
        }
    }
}

extend Int <: MyHashable {
}

main() {
    let map = HashMapLocal<Int>()@local!
    map.get(1)
}
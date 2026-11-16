// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// A local constructor may initialize one ordinary local field and one demode
// local-to-heap field.  The two writes must select their respective barriers.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan constructor local value: 0, true
// ASSERT: scan constructor heap value: 1, false

class Data {
    var value: Int64
    var onRegion: Bool

    exclave init(this @local!, value: Int64) {
        this.value = value
        this.onRegion = true
    }

    init(value: Int64) {
        this.value = value
        this.onRegion = false
    }
}

class ConstructorHolder {
    var localData: Data
    demode var heapData: Data

    exclave init(this @local?, localValue: Int64, heapValue: Int64) {
        let localData: Data @local! = Data(localValue) @local!
        let heapData = Data(heapValue) @~local
        this.localData = localData
        this.heapData = heapData
    }
}

main(): Unit {
    let holder: ConstructorHolder @local? = ConstructorHolder(0, 1) @local?
    println("constructor local value: ${holder.localData.value}, ${holder.localData.onRegion}")
    println("constructor heap value: ${holder.heapData.value}, ${holder.heapData.onRegion}")
}

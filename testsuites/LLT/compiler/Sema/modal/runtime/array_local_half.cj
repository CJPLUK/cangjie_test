// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output -O2
// EXEC: %run %run_opt %output %run_args
class P {
    var data: Array<Byte>
    init(data: Array<Byte>) {
        this.data = data
    }
}
func skip(p: P @local?): Byte {
    p.data[0]
}
main() {
    let _ = skip(P([b'x']))
}

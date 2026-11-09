// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// SEPARATE-FILE: main.cj
// EXEC: %compiler %cmp_opt first/a.cj second/a.cj --output-type=dylib -O2 -o libabi_demo.%dylib_suffix
// (Linux) EXEC: nm -D libabi_demo.%dylib_suffix | compare %f
// Same-name files share extend indexes. The later file keeps index zero.
// (Linux) ASSERT: scan _CN8abi_demoXlUa$K0_11helperFirstHv
// (Linux) ASSERT: scan _CN8abi_demoXlUa$K_12helperSecondHv
// EXEC: %compiler %cmp_opt main.cj -O2 -L . -labi_demo -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import abi_demo.*

main() {
    if (1.first() != 12 || 1.second() != 23) {
        return 1
    }
    return 0
}

// SEPARATE-FILE: first/a.cj
package abi_demo
public interface IFirst { func first(): Int64 }
extend Int64 <: IFirst {
    private func helperFirst(): Int64 { this + 11 }
    @Frozen
    public func first(): Int64 { helperFirst() }
}

// SEPARATE-FILE: second/a.cj
package abi_demo
public interface ISecond { func second(): Int64 }
extend Int64 <: ISecond {
    private func helperSecond(): Int64 { this + 22 }
    @Frozen
    public func second(): Int64 { helperSecond() }
}

// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %frontendCompiler %dump-parse %cmp_opt %f -o %output %compile_shared_lib_opt

import objc.lang.*

@ObjC
foreign interface M {
    prop x: Int64
    mut prop xm: Int64
    static prop xs: Int64
    static mut prop xms: Int64

    prop y: M
    mut prop ym: M
    static prop ys: M
    static mut prop yms: M
}

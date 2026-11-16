// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %frontendCompiler %dump-parse %cmp_opt %f -o %output %compile_shared_lib_opt

import objc.lang.*

@ObjC
foreign class M {
    public prop x: Int64
    public mut prop xm: Int64
    public static prop xs: Int64
    public static mut prop xms: Int64

    public prop y: M
    public mut prop ym: M
    public static prop ys: M
    public static mut prop yms: M
}

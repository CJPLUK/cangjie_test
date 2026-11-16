// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-0: %frontendCompiler %dump-parse %cmp_opt %f -o %output %compile_shared_lib_opt

@Java["java.anypackage.M"]
foreign interface M {
    func f(): Unit
}

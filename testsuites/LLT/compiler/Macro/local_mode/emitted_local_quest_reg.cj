// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: define_quest.cj
// EXEC: %compiler %cmp_macro define_quest.cj
// EXEC: %run_macro %compiler %cmp_opt --experimental --enable-local-mode %f -o %output
// EXEC: %run %run_opt %output %run_args

import define.*

@M
func dummy() {}

main() {}

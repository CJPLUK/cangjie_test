// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: define_noteq.cj
// EXEC: %compiler %cmp_macro define_noteq.cj
// EXEC: %run_macro %compiler %cmp_opt --experimental --enable-local-mode %f -o %output
// EXEC: %run %run_opt %output %run_args

// Macro output contains '@local!=' (NOTEQ token). IsModalSpecifierPair keeps
// it glued in the regenerated source; ParseModeSpecifier splits the NOTEQ back
// into the modal '!' and the initializer '='.

import define.*

@M
func dummy() {}

main() {}

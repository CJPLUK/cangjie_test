// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE:  define.cj
// EXEC: %compiler %cmp_macro define.cj
// ERRCHECK: %run_macro %compiler %cmp_opt  %f -o %output
// ASSERT: scan expected expression after '-', found a declaration
// ASSERT: scan expected a member name after '.' in qualified name, found '*'
// ASSERT: scan variable declaration in pattern needs either type or initializer
// ASSERT: scan unclosed delimiter: '{'

import define.*

main() {
    4 - @D[0]var x = @B var ye.*

main() {
    4 - @D[0]var x = @B var y = 0 + @D[0]var z = 0 + @X[0](0) + @A(0)
}

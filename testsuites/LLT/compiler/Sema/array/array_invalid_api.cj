// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE)EXEC-PIPE-1: %frontendCompiler %cmp_opt %f 2>&1 | compare %f


main(): Int64 {
    var a: Array<String> = ["aa"]
    var z = a.clone
    a.size = 1
    var x = a.clone(2)
    return 0
}

// The notes point into stdlib sources, whose line numbers move whenever the declarations above
// them gain or lose a line. Match the note shape instead of a fixed line number so this case
// keeps checking the diagnostics rather than the layout of array.cj; the positions inside this
// file stay exact.
// (CJNATIVE)ASSERT: regex-1 error: ambiguous use of 'clone'
// (CJNATIVE)ASSERT: regex-1 ==> .*array_invalid_api\.cj:12:13:
// (CJNATIVE)ASSERT: regex-2 note: found function member of 'Struct-Array<Generics-T>'
// (CJNATIVE)ASSERT: regex-2 ==> \(package std\.core\)array\.cj:\d+:17:
// (CJNATIVE)ASSERT: regex-1 error: cannot assign to immutable value
// (CJNATIVE)ASSERT: regex-1 ==> .*array_invalid_api\.cj:13:5:
// (CJNATIVE)ASSERT: regex-1 note: property 'size' is immutable
// (CJNATIVE)ASSERT: regex-1 ==> \(package std\.core\)array_common\.cj:\d+:17:
// (CJNATIVE)ASSERT: regex-1 error: cannot convert an integer literal to type 'Struct-Range<Int64>'
// (CJNATIVE)ASSERT: regex-1 ==> .*array_invalid_api\.cj:14:21:
// (CJNATIVE)ASSERT: regex-1 3 errors generated, 3 errors printed\.

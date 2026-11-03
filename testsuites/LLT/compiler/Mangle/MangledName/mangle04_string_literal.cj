// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt -g %n.cj -o %n.%suffix
// (CJNATIVE and DEBUG_OPTION) EXEC-PIPE: %frontendCompiler %dump-ir-to-screen %cmp_opt %enableCompileDebug --apc=1 %n.cj 2>&1 | compare %f
// The suffixes are FNV-1a-64 of the literal content printed in the 64-character
// radix-64 alphabet, so they are identical on every platform and standard library.
// (CJNATIVE) ASSERT: regex-auto @"$const_cjstring.dOOthz+StlT" = private global %"record.std.core:String" { i8 addrspace(1)* addrspacecast (i8* bitcast ({ i8*, i64, [3 x i8] }* @"$const_cjstring_data.dOOthz+StlT" to i8*) to i8 addrspace(1)*), i32 0, i32 3 }
// (CJNATIVE) ASSERT: regex-auto @"$const_cjstring.3OGPseCFr6Y" = private global %"record.std.core:String" { i8 addrspace(1)* addrspacecast (i8* bitcast ({ i8*, i64, [5 x i8] }* @"$const_cjstring_data.3OGPseCFr6Y" to i8*) to i8 addrspace(1)*), i32 0, i32 5 }
// (CJNATIVE) ASSERT: regex-auto @"$const_cjstring.cr8IqsqMdIg" = private global %"record.std.core:String" { i8 addrspace(1)* addrspacecast (i8* bitcast ({ i8*, i64, [26 x i8] }* @"$const_cjstring_data.cr8IqsqMdIg" to i8*) to i8 addrspace(1)*), i32 0, i32 26 }
// (CJNATIVE) ASSERT: regex-auto @"$const_cjstring.ek0IJYyXHWP" = private global %"record.std.core:String" { i8 addrspace(1)* addrspacecast (i8* bitcast ({ i8*, i64, [17 x i8] }* @"$const_cjstring_data.ek0IJYyXHWP" to i8*) to i8 addrspace(1)*), i32 0, i32 17 }
// Every distinct literal content owns one RawArray buffer named after the same
// hash, so the buffers cover exactly the four literal contents above.
// (CJNATIVE) ASSERT: regex-auto @"$const_cjstring_data.dOOthz+StlT" = private unnamed_addr constant { i8*, i64, [3 x i8] } { i8* bitcast (%TypeInfo* @"RawArray<UInt8>.ti" to i8*), i64 3, [3 x i8] c"foo" }
// (CJNATIVE) ASSERT: regex-auto @"$const_cjstring_data.3OGPseCFr6Y" = private unnamed_addr constant { i8*, i64, [5 x i8] } { i8* bitcast (%TypeInfo* @"RawArray<UInt8>.ti" to i8*), i64 5, [5 x i8] c"bingo" }
// (CJNATIVE) ASSERT: regex-auto @"$const_cjstring_data.cr8IqsqMdIg" = private unnamed_addr constant { i8*, i64, [26 x i8] } { i8* bitcast (%TypeInfo* @"RawArray<UInt8>.ti" to i8*), i64 26, [26 x i8] c"An exception has occurred:" }
// (CJNATIVE) ASSERT: regex-auto @"$const_cjstring_data.ek0IJYyXHWP" = private unnamed_addr constant { i8*, i64, [17 x i8] } { i8* bitcast (%TypeInfo* @"RawArray<UInt8>.ti" to i8*), i64 17, [17 x i8] c"    Out of memory" }
// (not CJNATIVE and DEBUG_OPTION) EXEC-PIPE: %frontendCompiler %dump-ir-to-screen %cmp_opt %enableCompileDebug %n.cj 2>&1 | compare %f
// (not CJNATIVE) ASSERT: regex-auto @_ZN7default1aE
// (not CJNATIVE) ASSERT: regex-auto @_ZN7default1bE
var a: String = "bingo"
var b: String = "foo"

main() {
    println(a)
    println(b)
    return 0
}

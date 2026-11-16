// DEPENDENCE: %n.old.cj %n.new.cj
// EXEC: %mkdir out
// EXEC: %cpfile %n.old.cj lib.cj
// EXEC: %cpfile %f main.cj

// EXEC: %compiler -Woff all %noStackInfo %incrementalCompile %cmp_opt %compile_lib_opt lib.cj -o A.%lib_extension
// EXEC: %compiler -Woff all %noStackInfo %incrementalCompile %cmp_opt main.cj A.%lib_extension -o out/%output

// EXEC: %cpfile %n.new.cj lib.cj

// EXEC: %compiler -Woff all %noStackInfo %incrementalCompile %cmp_opt %compile_lib_opt lib.cj -o A.%lib_extension > %redirectNull
// EXEC-PIPE-0: %compiler -Woff all %noStackInfo %incrementalCompile %cmp_opt main.cj A.%lib_extension -o out/%output 2>&1 && cat out/.cached/*.log | compare %f
// RUN-EXEC: %run %run_opt out/%output %run_args

import inc.*

main() {
}

// ASSERT: scan begin dump raw modified decls:
// ASSERT: scan added 8CPointer<1T><:2I1X at 14,1
// ASSERT: scan incremental compilation triggered
// ASSERT: scan changed decls to recompile: 13
// ASSERT: scan the changed decl after Spreading is:ExtendDecl in file lib.cj in line 14 in column 1
// ASSERT: scan the changed decl after Spreading is:foo in file lib.cj in line 15 in column 17
// ASSERT: scan the changed decl after Spreading is:ExtendDecl in file c_pointer_resource.cj
// ASSERT: scan incremental sema


// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

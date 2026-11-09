// DEPENDENCE: %n.old.cj %n.new.cj
 // EXEC: %compiler %local %incrementalCompile %cmp_opt %n.old.cj -o %output
// EXEC: %rmfile %n.old.cj
// EXEC: %cpfile %n.new.cj %n.old.cj
// EXEC-PIPE-0: %compiler %local %incrementalCompile %cmp_opt %n.old.cj -o %output 2>&1 && cat .cached/*.log | compare %f
// ASSERT: scan-not rollback
// ASSERT: scan-not "ExtendDecl in file ExtendModalLocal.old.cj in line 17"
// RUN-EXEC-10: %run %run_opt %output %run_args

// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

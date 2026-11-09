// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %cmp_opt %f -Woff all 2>&1 | compare %f
abstract class C {
    public exclave func foo(): String @local!
}
main() {}
/* SCAN
error: abstract function 'foo' cannot be exclave
 ==> sema_abstract_exclave_func.cj:9:25:
  | 
9 |     public exclave func foo(): String @local!
  |                         ^^^ 
  | 

1 error generated, 1 error printed.
*/
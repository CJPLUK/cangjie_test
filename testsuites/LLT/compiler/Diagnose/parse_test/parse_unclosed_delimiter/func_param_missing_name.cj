// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// ERRCHECK: %compiler %noColor %n.cj

func f(x: Int64, Int64) {}

main() {}

/* SCAN
error: expected a argument name after ',' in parameter list, found keyword 'Int64'
  ==> func_param_missing_name.cj:10:18:
   | 
10 | func f(x: Int64, Int64) {}
   |                ~ ^^^^^ expected a argument name here
   |                |
   |                after ',' in parameter list
   | 
help: you could escape keyword as a argument name using '`':
   | 
10 | func f(x: Int64, `Int64`) {}
   |                  ~~~~~~~ 
   | 

1 error generated, 1 error printed.
*/

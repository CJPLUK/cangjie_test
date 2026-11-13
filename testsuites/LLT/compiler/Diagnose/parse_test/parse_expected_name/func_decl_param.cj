// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// ERRCHECK: %compiler %noColor %n.cj

func foo(@):  {}

/* SCAN
error: expected a argument name after '(' in parameter list, found '@'
  ==> func_decl_param.cj:10:10:
   | 
10 | func foo(@):  {}
   |         ~^ expected a argument name here
   |         |
   |         after '(' in parameter list
   | 

error: expected a type name after ':' in function declaration, found '{'
  ==> func_decl_param.cj:10:15:
   | 
10 | func foo(@):  {}
   |            ~  ^ expected a type name here
   |            |
   |            after ':' in function declaration
   | 

2 errors generated, 2 errors printed.
*/

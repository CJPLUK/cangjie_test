// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %cmp_opt 2>&1

class C {
    init() {}
    init(this @local!) { exclave {} }
}
func makeC(): C @local! {
    exclave { C() }
}

let g = { => exclave { makeC() } }()

main() {}

/* SCAN
error: expected data type here, got modal type 'Class-C @local!'
  ==> sema_expected_data_type.cj:17:1:
   | 
17 | let g = { => exclave { makeC() } }()
   | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
   | 

1 error generated, 1 error printed.
*/
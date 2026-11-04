// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.


// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %disableAPC %save_temps_opt=tmps %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %llvmDissembler tmps/%n.opt.bc
// EXEC-PIPE: %cat tmps/%n.opt.ll 2>&1 | compare %f
// ASSERT: scan-2 CJ_MCC_AddLocalFinalizer
// ASSERT: scan-2 CJ_MCC_RemoveLocalFinalizer

class AA {
  init() {}
  exclave init(this @local?) {}
  exclave init(this @local!) {}
}

class DD<T> {
  init() {}

  exclave init(this @local?) {}

  exclave init(this @local!) {}

  ~init(this @local?) {}

  func goo(this @local?) {}
}

func foo(flag: Bool) {
  var d = DD<String>() @local!
  if (flag) {
    return 0
  } else {
    return 1
  }
}

main() {
    foo(true)
}
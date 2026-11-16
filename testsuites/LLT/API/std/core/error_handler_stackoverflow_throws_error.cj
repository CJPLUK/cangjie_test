/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %cmp_opt %disableFuncInlining -o %n.%suffix %f
// Use a fixed initial stack; disable growth only on the worker that triggers overflow.
// (Unix) EXEC: export cjStackSize=1mb && %run %run_opt %n.%suffix %run_args 2>&1 | compare %f
// (Windows) EXEC: (set cjStackSize=1mb) && %run %run_opt %n.%suffix %run_args 2>&1 | compare %f
// ASSERT: scan StackOverflowError
// ASSERT: scan throws an error in the error handler

/* Output will be like: 
An exception has occurred:
StackOverflowError
         at default.test()(/path/to/errorHandlerSOF.cj)
         at default.test()(/path/to/errorHandlerSOF.cj:22)
         at default.test()(/path/to/errorHandlerSOF.cj:22)
         at default.test()(/path/to/errorHandlerSOF.cj:22)
         at default.test()(/path/to/errorHandlerSOF.cj:22)
         ... Some frames are not displayed ...
handle error: StackOverflowError
Thread id: 2 throws an error in the error handler
147289 E CJNatvie Handle signal: 11.
147289 E Thread "errorHandlerSOF" catched unhandled SIGSEGV (Segmentation fault) from runtime frame. signal pc: 0xffffbd38bcfc, addr: 0xffff9cc10028
147289 E   #0  0xffffbd38bcfc in MCC_FutureNotifyAll from /path/to/libcangjie-runtime.so
147289 E   #1  0xffffbd336b5c in ExecuteCangjieStub from /path/to/libcangjie-runtime.so
147289 E   #2  0xffffbd3915f8 in CJ_CJThreadEntry from /path/to/libcangjie-runtime.so
[1]    147289 segmentation fault  ./errorHandlerSOF
*/

import std.runtime.*

foreign {
    func CJ_CJThreadSetStackGrow(enabled: Bool): Int32
}

var a = 0

main() {
  func handler(err: Error): Unit {
    println("handle error: ${err}")
    test()
    println("handler finished")
  }
  Thread.handleUncaughtErrorBy(handler)

  let fut = spawn {
    // Preserve the SDK stack-map mode while bounding this worker's real stack overflow.
    if (unsafe { CJ_CJThreadSetStackGrow(false) } != 0) {
      throw Exception("Failed to disable worker stack growth")
    }
    test()
  }
  
  try {
    fut.get()
  } finally {
    println("quit normally")
  }

  return 0
}

func test(): Unit {
    // Reach the stack limit with a bounded number of frames. Tiny recursive
    // frames otherwise spend the test timeout scanning millions of stack maps.
    let padding = VArray<Int64, $8192>(repeat: 0)
    blackBox(padding)
    test()
    blackBox(padding)
    a++
}

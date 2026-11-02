/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt -O2 %overflow_wrapping %f -o %output

import std.collection.*
import std.process.*
import std.convert.*
import std.sync.*
import std.time.*

let allReady = AtomicBool(false)
let m = Monitor()

func create(cnt: AtomicInt64): Unit {
  spawn { =>
    let x = cnt.fetchAdd(-1) - 1
    if (x == 0) {
      allReady.store(true) 
    } 
    m.lock()
  }
}

func measure(count: Int64): Unit {
  let cnt = AtomicInt64(count)
  
  m.lock()
  for (i in 0..count) {  
    create(cnt)
  }

  while (!allReady.load()) { }

  println("ready") 

  while (true) { }
}

main(): Int64 {
  let args = Process.current.arguments
  let count = Int64.tryParse(args[0]).getOrThrow()

  measure(count)
  0
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt -O2 %overflow_wrapping %f -o %output
// RUN-EXEC: %run %run_opt %output 30000 3 0 %run_args
// RUN-EXEC: %run %run_opt %output 30000 3 1 %run_args

import std.convert.*
import std.collection.*
import std.time.*

var shouldLog = false
var blackBox: Int64 = 0

main(args: Array<String>): Unit {
    if (args.size != 3) {
      println("Usage: program <iterations> <repeats> <mode>")
      println("   where mode == 0 means use ComplexObject")
      println("   where mode == 1 means use ComplexStruct")
      return
    }

    let N    = Int64.tryParse(args[0]).getOrThrow()
    let R    = Int64.tryParse(args[1]).getOrThrow()
    let mode = Int64.tryParse(args[2]).getOrThrow()

    shouldLog = true
    for (i in 0..R) {
      if (mode == 0) {
        measureObject(N)
      } else if (mode == 1) {
        measureStruct(N)
      } else {
        println("Unexpected mode: ${mode}")
        return 
      }
    }
}

func measureObject(N: Int64) {
  let start = DateTime.now()
  blackBox = measureBodyObject(N)
  let end = DateTime.now()

  if (shouldLog) {
    println("ComplexObject with ${N} problem size took ${(end - start).toMilliseconds()} ms. Computation result: ${blackBox}")
  }
}

@OverflowWrapping
func measureBodyObject(N: Int64) {
    var a : ComplexObject
    var sum = 0
    for (i in 0..N) {
        for (j in 0..N) {
            if ( (i + j) > (N /2) ) {
               a = ComplexObject(i, j)               
            } else {
               a = ComplexObject(j, i)               
            }

            sum += a.modulus2()
        }
    }
    return sum
}

class ComplexObject {
    let re : Int64
    let im : Int64

    init(re_ : Int64, im_ : Int64) {
        re = re_
        im = im_
    }

    @OverflowWrapping
    func modulus2() : Int64 {
        re*re + im*im
    }
}

func measureStruct(N: Int64) {
  let start = DateTime.now()
  blackBox = measureBodyStruct(N)
  let end = DateTime.now()

  if (shouldLog) {
    println("ComplexStruct with ${N} problem size took ${(end - start).toMilliseconds()} ms. Computation result: ${blackBox}")
  }
}

@OverflowWrapping
func measureBodyStruct(N: Int64) {
    var a: ComplexStruct 
    var sum = 0
    for (i in 0..N) {
        for (j in 0..N) {
            if ( (i + j) > (N /2) ) {
               a = ComplexStruct(i, j)               
            } else {
               a = ComplexStruct(j, i)               
            }

            sum += a.modulus2()
        }
    }
    return sum
}

struct ComplexStruct {
    let re : Int64
    let im : Int64

    init(re_ : Int64, im_ : Int64) {
        re = re_
        im = im_
    }

    @OverflowWrapping
    func modulus2() : Int64 {
        re*re + im*im
    }
}

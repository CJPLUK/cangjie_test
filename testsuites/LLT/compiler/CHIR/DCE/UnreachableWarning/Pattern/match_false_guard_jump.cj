// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Shared short-circuit success paths stay reachable; false guards still diagnose merged jump bodies.
// EXEC-PIPE-0: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

func guardBreak(flag: Bool): Unit {
    do {
        match (3) {
            case 3 where false => break
            case _ => println("work")
        }
    } while (flag)
}

func guardContinue(flag: Bool): Unit {
    do {
        match (3) {
            case 3 where false => continue
            case _ => println("work")
        }
    } while (flag)
}

func reachableGuards(flag: Bool): Unit {
    match (3) {
        case 3 where flag || false => println("right false")
        case _ => println("fallback")
    }
    match (3) {
        case 3 where false || flag => println("left false")
        case _ => println("fallback")
    }
    match (3) {
        case 3 where flag || (flag && false) => println("nested and")
        case _ => println("fallback")
    }
}

func falseOrBreak(flag: Bool): Unit {
    do {
        match (3) {
            case 3 where false || false => break
            case _ => println("work")
        }
    } while (flag)
}

func falseOrContinue(flag: Bool): Unit {
    do {
        match (3) {
            case 3 where false || false => continue
            case _ => println("work")
        }
    } while (flag)
}

func distinctCases(flag: Bool): Unit {
    do {
        match (3) {
            case 3 where flag => break
            case 3 where false => break
            case _ => println("work")
        }
    } while (false)
}

main() {
    guardBreak(false)
    guardContinue(false)
    reachableGuards(true)
    reachableGuards(false)
    falseOrBreak(false)
    falseOrContinue(false)
    distinctCases(false)
    distinctCases(true)
}

/* SCAN-IN
warning: unreachable pattern
  ==> match_false_guard_jump.cj:13:26:
   | 
13 |             case 3 where false => break
   |                          ^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> match_false_guard_jump.cj:22:26:
   | 
22 |             case 3 where false => continue
   |                          ^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> match_false_guard_jump.cj:46:26:
   | 
46 |             case 3 where false || false => break
   |                          ^^^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> match_false_guard_jump.cj:55:26:
   | 
55 |             case 3 where false || false => continue
   |                          ^^^^^^^^^^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

/* SCAN-IN
warning: unreachable pattern
  ==> match_false_guard_jump.cj:65:26:
   | 
65 |             case 3 where false => break
   |                          ^^^^^ 
   | 
   # note: this warning can be suppressed by setting the compiler option `-Woff unused`
*/

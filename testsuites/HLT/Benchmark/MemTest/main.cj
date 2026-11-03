/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: GcTestCase.cj MemAllocTestCase.cj MemAllocUtil.cj ThreadTest.cj FinalizerAlloc.cj
// EXEC: %compiler %cmp_opt GcTestCase.cj MemAllocTestCase.cj MemAllocUtil.cj ThreadTest.cj FinalizerAlloc.cj %f
// Only compile, not run on ci.

package test.memory

import std.collection.*
import std.random.*
import std.math.*
import std.time.*
import std.runtime.*
import std.sync.*

var total = 10000

main(){
    while (true) {
        total -= 1
        try{
            testcase_1()
        } catch (e:Exception){
            print("Exception Here!")
            e.printStackTrace()
            break
        }
        print("case run ${total}\n")
        if (total < 0){
            break
        }
    }
    return 0
}

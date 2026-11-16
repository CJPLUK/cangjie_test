// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// REGION: 2:16
func run(): Int64 {
    var s1: String = "HELLo " + "HELLO"
    var chs = [r'h', r'e', r'l', r'l', r'o']
    var s2 = String(chs)
    var s4 = s1.substring(0, 5)

    var res1 = s1 != s2

    if (res1 && res2 && res3 && res4 && res5 && res6 && res7 && res8) {
        return 0
    }
    return 1
}

  func case01()    {
      var a =   "  abc  "
    var b     = 1
    if (  "${   foo(a)   }" != "abc") {
        return 1
    }
       if ("${  Aoo(a).a     }" != "abc") {
        return    1
    }
    if ("${b+b}" != "2") {
        return 1
    }
}

func       g() {}
   func t() {  }

// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug -Woff all %f -o allocate.out
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_UselessAllocateElimination.chirtxt "Func @_CN7default4testHv" | compare %f

internal import std.runtime.*
var flag = 0

public class A{
    ~init(){flag+=1}
}

public func test(){
    var a = A()
}

main() {
    test()
    GC()
    sleep(Duration.millisecond * 200)
    print("flag is ${flag}.\n")
    return 0
}

// ASSERT: regex-1 = Allocate\(Class-_CN7default1AE\)
// ASSERT: regex-begin %(?P<object>\d+): Class-_CN7default1AE& = Allocate\(Class-_CN7default1AE\)
// ASSERT: regex-after Void = Apply\(Class-_CN7default1AE&->@_CN7default1A6<init>Hv, %(?P=object)\)

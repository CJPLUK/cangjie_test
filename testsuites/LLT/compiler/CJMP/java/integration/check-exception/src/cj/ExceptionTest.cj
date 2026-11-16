// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package javasample

import java.lang.*

@Java ["javasample.ExceptionTest"]
public foreign open class ExceptionTest {
    public init()
    public func returnValue(): Int32
    public func throwRuntimeException(): Unit
}

@Java["javasample.TestImpl"]
public class TestImpl {
    public init() {}

    // Normal Java call: no exception should be pending.
    public func testCheckExceptionNoPending(): Int32 {
        let helper = ExceptionTest()
        return helper.returnValue()
    }

    // Java method deliberately throws an exception.
    // checkException should detect the pending JNI exception.
    public func testCheckExceptionPending(): Unit {
        let helper = ExceptionTest()
        helper.throwRuntimeException()
    }
}


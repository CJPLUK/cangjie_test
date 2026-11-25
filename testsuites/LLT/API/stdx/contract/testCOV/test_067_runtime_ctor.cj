/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-067: the parameterless constructors of the contract check
// exception types and the message-carrying constructor are exercised by
// constructing the exceptions directly in a test context.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [ requires n > 0 ]
func covRtReq(n: Int64): Int64 {
    n
}

@Test
class Test {
    @TestCase
    func testExceptionCtors() {
        let noArg = ContractCheckRequiresException()
        let withMsg = ContractCheckRequiresException(message: "boom")
        @Expect(withMsg.message, "boom")
        let ens = ContractCheckEnsuresException()
        let thr = ContractCheckThrowsException()
        let inv = ContractCheckInvariantException()
        let asr = ContractCheckAssertException()
        let lp = ContractCheckLoopInvariantException()
        @Expect(ens is ContractCheckEnsuresException, true)
        @Expect(thr is ContractCheckThrowsException, true)
        @Expect(inv is ContractCheckInvariantException, true)
        @Expect(asr is ContractCheckAssertException, true)
        @Expect(lp is ContractCheckLoopInvariantException, true)
        @Expect(noArg is ContractCheckRequiresException, true)
    }

    @TestCase
    func testRequiresStillFires() {
        var caught = false
        try {
            covRtReq(-1)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }
}

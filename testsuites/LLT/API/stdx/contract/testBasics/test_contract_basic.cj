/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*

// Note: testCheckSwitch was removed together with the runtime switch APIs
// setCheckContract()/unsetCheckContract() (design §3.5 change: the switch is
// decided only by the compile-time `--cfg "contract_check=on"`); disabled-state
// behaviour is covered by the contract_verify cases in the stdx tree.

class BankAccount {
    private var balance: Float64

    init(balance: Float64) {
        this.balance = balance
    }

    @Contract[
        requires amount > 0.0
        requires amount <= this.balance
        ensures this.balance == $pre(this.balance) - amount
    ]
    public func withdraw(amount: Float64): Unit {
        this.balance -= amount
    }

    public func getBalance(): Float64 {
        this.balance
    }
}

@Contract[
    throws IllegalArgumentException if x < 0
]
func checkThrows(x: Int64): Unit {
    if (x < 0) {
        throw IllegalArgumentException("negative value")
    }
}

@Contract[
    variable stored: Int64 = 0
    on_public invariant stored >= 0
]
class Counter {
    @Contract[
        requires stored < 10
        ensures stored == $pre(stored) + 1
    ]
    public func inc(): Unit {
        @ghost(stored = stored + 1)
    }

    public func get(): Int64 {
        stored
    }
}

@Contract
func checkPositive(x: Int64): Unit {
    @contractAssert(x > 0)
}

@Contract[
    requires n >= 0
    ensures r: r == n
]
func countUp(n: Int64): Int64 {
    var i = 0
    var sum = 0
    @loopInvariant[i >= 0 && i <= n](while (i < n) {
        i += 1
        sum += i
    })
    i
}

@Test
class Test {
    @BeforeEach
    func setUp(): Unit {
    }

    @AfterEach
    func tearDown(): Unit {
    }

    @TestCase
    func testRequiresPass() {
        let account = BankAccount(100.0)
        account.withdraw(30.0)
        @Expect(account.getBalance(), 70.0)
    }

    @TestCase
    func testRequiresFail() {
        let account = BankAccount(100.0)
        var caught = false
        try {
            account.withdraw(200.0)
        } catch (e: ContractCheckRequiresException) {
            caught = true
            @Expect(e.message.contains("requires amount <= this.balance"), true)
        }
        @Expect(caught, true)
        @Expect(isContractException(ContractCheckRequiresException(message: "requires failed")), true)
    }

    @TestCase
    func testThrows() {
        var caught = false
        try {
            checkThrows(-1)
        } catch (e: IllegalArgumentException) {
            caught = true
        }
        @Expect(caught, true)
        // satisfies the throws contract when condition is false
        checkThrows(1)
    }

    @TestCase
    func testInvariant() {
        let counter = Counter()
        counter.inc()
        @Expect(counter.get(), 1)
        var caught = false
        try {
            for (_ in 0..10) {
                counter.inc()
            }
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    @TestCase
    func testContractAssertAndLoopInvariant() {
        checkPositive(1)
        var caught = false
        try {
            checkPositive(-1)
        } catch (e: ContractCheckAssertException) {
            caught = true
            @Expect(e.message.contains("assertion failed: x > 0"), true)
        }
        @Expect(caught, true)
        @Expect(countUp(5), 5)
    }
}

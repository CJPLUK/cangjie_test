/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

import std.sync.*

class BankAccount {
    private var balanceAmount: Float64 = 0.0
    public let mtx: Mutex = Mutex()

    public func depositAmount(ba: BankAccount, amount: Float64): Unit {
        synchronized(mtx) {
            synchronized(ba.mtx) {
                if (balanceAmount > amount) {
                    ba.balanceAmount += amount
                    balanceAmount -= amount
                }
            }
        }
    }

    public func withdrawAmount(ba: BankAccount, amount: Float64): Unit {
        synchronized(ba.mtx) {
            synchronized(mtx) {
                if (ba.balanceAmount > amount) {
                    ba.balanceAmount -= amount
                    balanceAmount += amount
                }
            }
        }
    }
}

main() {
    let a = BankAccount()
    let b = BankAccount()
    a.depositAmount(b, 1.0)
    a.withdrawAmount(b, 1.0)
}

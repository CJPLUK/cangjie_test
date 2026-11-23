/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-INH-046: an override that renames the parent's formal type
// parameters still replays the inherited member contract. Fixed (defect 16.33;
// see contract-defects-audit.md): the signature key used to be matched
// textually, so `id<U>` lost the contract published for `id<T>`.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract[]
open class InhRenBase {
    @Contract [ensures [eq] ret: false]
    public open func id<T>(x: T): T {
        return x
    }
}

@Contract [inherits from InhRenBase]
class InhRenChild <: InhRenBase {
    public override func id<U>(x: U): U {
        return x
    }
}

@Contract [inherits from InhRenBase]
class InhSameChild <: InhRenBase {
    public override func id<T>(x: T): T {
        return x
    }
}

main() {
    var renamedCaught = false
    try {
        let v = InhRenChild().id<Int64>(1)
        println("renamed: NO-THROW ${v}")
    } catch (e: ContractCheckEnsuresException) {
        renamedCaught = true
    }
    if (!renamedCaught) {
        throw Exception("renamed type-parameter override lost the inherited ensures")
    }
    var sameCaught = false
    try {
        let v = InhSameChild().id<Int64>(1)
        println("same: NO-THROW ${v}")
    } catch (e: ContractCheckEnsuresException) {
        sameCaught = true
    }
    if (!sameCaught) {
        throw Exception("same-name override lost the inherited ensures")
    }
    println("ok")
}

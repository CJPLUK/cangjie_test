// ERRCHECK: %compiler %enableEH %cmp_opt %f -o %output %diag_json
import stdx.effect.{Command, Resumption}

class Eff <: Command<Unit> {}

main():Int64 {
    try {
        42
    } handle (c: Eff, r: Resumption<Unit, String>) {
        43
    }
    return 0
}

// ASSERT: scan sema_resumption_incorrect_return_type


// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %enableEH %cmp_opt %f -o %output %diag_json
import stdx.effect.{Command, Resumption}

class MyEff <: Command<Int64> {}

main(): Int64 {
    try {}
    handle (e: MyEff, r: Resumption<String, Unit>) {}
    0
}

// ASSERT: scan sema_command_resumption_mismatch


// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

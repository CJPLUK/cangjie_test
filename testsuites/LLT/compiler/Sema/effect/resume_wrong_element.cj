// ERRCHECK: %compiler %enableEH %cmp_opt %f -o %output %diag_json
import stdx.effect.{Command, Resumption}

func foo(r: Resumption<Unit, Unit>) {
    resume 34
}

main():Int64 {
    return 0
}

// ASSERT: scan sema_resume_wrong_resumption_type


// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

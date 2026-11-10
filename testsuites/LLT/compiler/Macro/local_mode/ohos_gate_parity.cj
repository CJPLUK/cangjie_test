// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: define_quest.cj
// EXEC: %compiler %cmp_macro define_quest.cj
// EXEC: %run_macro %compiler %cmp_opt --experimental --enable-local-mode %f -o %output
// EXEC: %run %run_opt %output %run_args

// OHOS gate parity: the parser (ParserImpl::SeeingModalInfo) and the macro
// pipeline (IsModalAfterAt) gate on the same '#ifdef __ohos__', so both paths
// must reach the same verdict on every platform. This file exercises the modal
// on both paths in one program.
// (not OHOS) source-side and macro-emitted modals are both accepted
// (OHOS) both paths reject '@local!' / '@local?' identically

import define.*

@M
func dummy() {}

main() {
    let s: Int64 @local! = 7
    println(probe() + s)
    return 0
}

// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %frontendCompiler %local %typecheck %f

main() {
    let malloc = CPointer<UInt8>()
    unsafe {
        CFunc<(CPointer<UInt8>, Int32, UIntNative)->CPointer<UInt8>>(malloc)(malloc, 0, 0)
    }
    0
}
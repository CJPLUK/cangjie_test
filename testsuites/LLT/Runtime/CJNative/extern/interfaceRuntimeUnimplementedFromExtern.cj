// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan static invocation contains unimplemented static function 'fromExtern'

// Negative: an interface satisfies `T <: ForeignRuntime<T>` while leaving the runtime
// functions abstract, so an explicit conversion from `Extern` with `fromExtern` has no
// implementation and must report the ordinary "unimplemented static function" error.
// The dynamic operations and the implicit conversion to `Extern` are tested in
// `interfaceRuntimeUnimplemented.cj`.

interface AbstractRT <: ForeignRuntime<AbstractRT> {}

func cast(e: Extern<AbstractRT>): Int64 { return AbstractRT.fromExtern<Int64>(e) }

main() {}

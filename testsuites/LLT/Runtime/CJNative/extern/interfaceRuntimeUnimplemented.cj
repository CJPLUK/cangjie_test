// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan static invocation contains unimplemented static function 'eval'
// ASSERT: scan static invocation contains unimplemented static function 'toExtern'
// ASSERT: scan static invocation contains unimplemented static function 'fromExtern'

// Negative: an interface satisfies `T <: ForeignRuntime<T>` while leaving the runtime
// functions abstract, so `Extern<T>` operations desugar to static calls that have no
// implementation. Member access, indexing, calls, and updates desugar to `eval`.
// Implicit conversion to `Extern` desugars to `toExtern`, and an explicit conversion
// back desugars to `fromExtern`. Each one must report the ordinary "unimplemented
// static function" error, exactly as a hand-written `T.eval(t)` does. This is the
// regression guard for the former crash: the desugaring resolved the runtime function
// by scanning only the members `T` declares itself, so a runtime type that merely
// inherits them from `ForeignRuntime<T>` yielded a null declaration and aborted.

interface AbstractRT <: ForeignRuntime<AbstractRT> {}

func memberRead(e: Extern<AbstractRT>): Extern<AbstractRT> { return e.field }

func memberWrite(e: Extern<AbstractRT>): Unit {
    e.field = 1
    ()
}

func indexRead(e: Extern<AbstractRT>): Extern<AbstractRT> { return e[0] }

func indexWrite(e: Extern<AbstractRT>): Unit {
    e[0] = 1
    ()
}

func call(e: Extern<AbstractRT>): Extern<AbstractRT> { return e(1) }

func coerce(): Extern<AbstractRT> { return 1 }

func cast(e: Extern<AbstractRT>): Int64 { return AbstractRT.fromExtern<Int64>(e) }

main() {}

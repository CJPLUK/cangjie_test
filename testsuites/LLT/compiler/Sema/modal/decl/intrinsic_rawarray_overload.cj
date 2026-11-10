// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../core/core_mock.cj
// ERRCHECK: %compiler %local --no-prelude %typecheck core_mock.cj %f -Woff all %diag_json 2>&1

package std.core

@Intrinsic
func write<T>(array: RawArray<T>, value: T): Unit

@Intrinsic
func write<T>(array: RawArray<T> @local!, value: T @local!): Unit

@Intrinsic
func write<T>(array: RawArray<T> @local?, value: T @local?): Unit where T <: Copyable

func writeHeap<T>(array: RawArray<T>, value: T): Unit {
    write(array, value)
}

exclave func writeLocal<T>(array: RawArray<T> @local!, value: T @local!): Unit {
    write(array, value)
}

exclave func writeLocalCopyable<T>(array: RawArray<T> @local!, value: T): Unit where T <: Copyable {
    write(array, value)
}

func writeMaybeCopyable<T>(array: RawArray<T> @local?, value: T): Unit where T <: Copyable {
    write(array, value)
}

exclave func writeByte(array: RawArray<UInt8> @local!): Unit {
    write<UInt8>(array, 0)
}

func rejectNonCopyable(array: RawArray<String> @local?, value: String @local?): Unit {
    write(array, value)
}

// ASSERT: scan "DiagKind": "sema_unable_to_infer_generic_func",
// ASSERT: scan "DiagKind": "sema_no_match_function_declaration_for_call",
// ASSERT: scan "Errors": 2,

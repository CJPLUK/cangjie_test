/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %local %import-cangjie-stdx %cmp_opt -o %n.%suffix %f
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_args | compare %f
// Type.toString() includes ModalInfo; Absent keeps the plain type name.

/* SCAN
absent: Int32
must: Int32 @local!
maybe: Int32 @local?
ref_must_base: Int32 @local!
cpointer_maybe: CPointer<Int32 @local?>
hash_absent_ne_must: true
eq_same_modal: true
eq_diff_modal: false
*/

import stdx.chir.*

main() {
    let absent = IntType.getInt32()
    let must = IntType.getInt32(modal: ModalInfo(local: Mode.Must))
    let maybe = IntType.getInt32(modal: ModalInfo(local: Mode.Maybe))

    println("absent: ${absent.toString()}")
    println("must: ${must.toString()}")
    println("maybe: ${maybe.toString()}")

    // RefType applies modal to the underlying data type.
    let refMust = RefType.get(must)
    println("ref_must_base: ${refMust.baseType.toString()}")

    let cptrMaybe = CPointerType.get(maybe)
    println("cpointer_maybe: ${cptrMaybe.toString()}")

    println("hash_absent_ne_must: ${absent.hashCode() != must.hashCode()}")
    println("eq_same_modal: ${must == IntType.getInt32(modal: ModalInfo(local: Mode.Must))}")
    println("eq_diff_modal: ${absent == must}")
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// ERRCHECK: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// T425: index assignment on an ArrayList<String> @local? receiver has no setter to
// select. CJEEP-005 removed the ListOfCopyable @local? mutator surface, so the
// ArrayList class body exposes only the @local! `[]=(this @local!, Int64, T @local!)`
// form and the write must be rejected at compile time. The SCAN-IN block below
// pins the exact diagnostic.
import std.collection.*

func rejectHalfReferenceWrite(list: ArrayList<String> @local?): Unit {
    list[0] = "x"
}

main(): Int64 {
    0
}

/* SCAN-IN
error: cannot assign to this subscript expression
  ==> test_arraylist_half_noncopyable_write_neg.cj:19:5:
   | 
19 |     list[0] = "x"
   |     ^^^^^^^ 
   | 
   # note: you may want to implement 'operator func[](this @local?, index0: Int64, value!: Struct-String)' for type 'Class-ArrayList<Struct-String>'
*/

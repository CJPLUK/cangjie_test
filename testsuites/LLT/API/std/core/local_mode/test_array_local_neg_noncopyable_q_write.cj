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
// T129 non-Copyable Array<String> @local? []= must be rejected by the Copyable constraint/mode contract
// RUN: none (negative case: compilation must fail; SCAN-IN below asserts the diagnostic).
//
// This is the intentional T129 language negative. It is not a runtime-barrier case:
// Array<String> is non-Copyable, so the @local? mutation extension must not be selected.
// On the 0907 SDK the observed diagnostic is "cannot assign to this subscript expression"
// with a note suggesting `operator func[](this @local?, index0: Int64,
// value!: Struct-String @local?)`; the missing overload makes this SKIP-SOURCE rather
// than the target bound diagnostic.

main(): Int64 {
    let receiver: Array<String> @local? = ["before"]
    let replacement: String @local? = "after"
    receiver[0] = replacement
    0
}

/* SCAN-IN
error: cannot assign to this subscript expression
  ==> test_array_local_neg_noncopyable_q_write.cj:24:5:
   | 
24 |     receiver[0] = replacement
   |     ^^^^^^^^^^^ 
   | 
   # note: you may want to implement 'operator func[](this @local?, index0: Int64, value!: Struct-String @local?)' for type 'Struct-Array<Struct-String>'
*/

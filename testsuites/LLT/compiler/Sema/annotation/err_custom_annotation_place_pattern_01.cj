// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %cmp_opt %f -o %output

const K: Int64 = 42

@Annotation
public class Anno {
    public const init(x: Int64) {}
}

main(): Int64 {
    @Anno[K]
    let (a, b) = (1, 2)
    return 0
}

/* SCAN
error: cannot use custom annotation
  ==> err_custom_annotation_place_pattern_01.cj:18:9:
   | 
17 |     @Anno[K]
   |     ~~~~~~~~ 
18 |     let (a, b) = (1, 2)
   |         ^^^^^^ 
   | 
   # note: custom annotations can only be used on non-local declarations

1 error generated, 1 error printed.
*/

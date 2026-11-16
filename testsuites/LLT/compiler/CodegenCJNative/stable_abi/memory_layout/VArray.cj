// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE) EXEC: %compiler %cmp_opt %f --save-temps . -j1 --apc=1 --output-type=staticlib
// (CJNATIVE) EXEC: %llvmDissembler %n.bc -o %n.ll
// (CJNATIVE) EXEC: %cat %n.ll 2>&1 | compare %f
// (CJNATIVE) ASSERT: regex %VArray\.5i = type { \[5 x i32\] }
// (not Windows and CJNATIVE) ASSERT: regex @"VArray<Int32,5>\.ti" = linkonce_odr hidden global %TypeInfo {.*}, !RelatedType !(?P<id>[0-9]+)
// (Windows and CJNATIVE) ASSERT: regex @"VArray<Int32,5>\.ti" = internal global %TypeInfo {.*}, !RelatedType !(?P<id>[0-9]+)
// (CJNATIVE) ASSERT: regex !(?P=id) = !{!"VArray\.5i"}

public let aaa: VArray<Int32, $5> = [2, 3, 1, 3, 2]

// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Repeated static definitions must not cause exponential ancestor traversal.
// N is the number of inheritance edges; every layer has an empty implementation.
// TIMEOUT: 30
// EXEC: %compiler %cmp_opt %compile_lib_opt %f -o %output

interface I_0 { static func sf(): Unit {} }
interface I_1 <: I_0 { static func sf(): Unit {} }
interface I_2 <: I_1 { static func sf(): Unit {} }
interface I_3 <: I_2 { static func sf(): Unit {} }
interface I_4 <: I_3 { static func sf(): Unit {} }
interface I_5 <: I_4 { static func sf(): Unit {} }
interface I_6 <: I_5 { static func sf(): Unit {} }
interface I_7 <: I_6 { static func sf(): Unit {} }
interface I_8 <: I_7 { static func sf(): Unit {} }
interface I_9 <: I_8 { static func sf(): Unit {} }
interface I_10 <: I_9 { static func sf(): Unit {} }
interface I_11 <: I_10 { static func sf(): Unit {} }
interface I_12 <: I_11 { static func sf(): Unit {} }
interface I_13 <: I_12 { static func sf(): Unit {} }
interface I_14 <: I_13 { static func sf(): Unit {} }
interface I_15 <: I_14 { static func sf(): Unit {} }
interface I_16 <: I_15 { static func sf(): Unit {} }
interface I_17 <: I_16 { static func sf(): Unit {} }
interface I_18 <: I_17 { static func sf(): Unit {} }
interface I_19 <: I_18 { static func sf(): Unit {} }
interface I_20 <: I_19 { static func sf(): Unit {} }
interface I_21 <: I_20 { static func sf(): Unit {} }
interface I_22 <: I_21 { static func sf(): Unit {} }
interface I_23 <: I_22 { static func sf(): Unit {} }
interface I_24 <: I_23 { static func sf(): Unit {} }
interface I_25 <: I_24 { static func sf(): Unit {} }
interface I_26 <: I_25 { static func sf(): Unit {} }
interface I_27 <: I_26 { static func sf(): Unit {} }
interface I_28 <: I_27 { static func sf(): Unit {} }
interface I_29 <: I_28 { static func sf(): Unit {} }
interface I_30 <: I_29 { static func sf(): Unit {} }
interface I_31 <: I_30 { static func sf(): Unit {} }
interface I_32 <: I_31 { static func sf(): Unit {} }

main() {}

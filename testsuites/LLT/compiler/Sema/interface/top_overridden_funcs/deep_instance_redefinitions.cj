// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Instance methods share the root-resolution path of static methods.
// Keep every implementation empty so only the inheritance graph grows.
// TIMEOUT: 30
// EXEC: %compiler %cmp_opt %compile_lib_opt %f -o %output

interface I_0 { func sf(): Unit {} }
interface I_1 <: I_0 { func sf(): Unit {} }
interface I_2 <: I_1 { func sf(): Unit {} }
interface I_3 <: I_2 { func sf(): Unit {} }
interface I_4 <: I_3 { func sf(): Unit {} }
interface I_5 <: I_4 { func sf(): Unit {} }
interface I_6 <: I_5 { func sf(): Unit {} }
interface I_7 <: I_6 { func sf(): Unit {} }
interface I_8 <: I_7 { func sf(): Unit {} }
interface I_9 <: I_8 { func sf(): Unit {} }
interface I_10 <: I_9 { func sf(): Unit {} }
interface I_11 <: I_10 { func sf(): Unit {} }
interface I_12 <: I_11 { func sf(): Unit {} }
interface I_13 <: I_12 { func sf(): Unit {} }
interface I_14 <: I_13 { func sf(): Unit {} }
interface I_15 <: I_14 { func sf(): Unit {} }
interface I_16 <: I_15 { func sf(): Unit {} }
interface I_17 <: I_16 { func sf(): Unit {} }
interface I_18 <: I_17 { func sf(): Unit {} }
interface I_19 <: I_18 { func sf(): Unit {} }
interface I_20 <: I_19 { func sf(): Unit {} }
interface I_21 <: I_20 { func sf(): Unit {} }
interface I_22 <: I_21 { func sf(): Unit {} }
interface I_23 <: I_22 { func sf(): Unit {} }
interface I_24 <: I_23 { func sf(): Unit {} }
interface I_25 <: I_24 { func sf(): Unit {} }
interface I_26 <: I_25 { func sf(): Unit {} }
interface I_27 <: I_26 { func sf(): Unit {} }
interface I_28 <: I_27 { func sf(): Unit {} }
interface I_29 <: I_28 { func sf(): Unit {} }
interface I_30 <: I_29 { func sf(): Unit {} }
interface I_31 <: I_30 { func sf(): Unit {} }
interface I_32 <: I_31 { func sf(): Unit {} }

main() {}

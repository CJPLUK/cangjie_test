// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f --output-type=staticlib -Woff all -o %output

interface I {}
func fail(): Nothing { throw Exception() }
func throwFull(): I @local! { throw Exception() }
func throwHalf(): I @local? { throw Exception() }
func callFull(): I @local! { fail() }
func callHalf(): I @local? { fail() }
func explicitFull(): I @local! { return fail() }
func explicitHalf(): I @local? { return fail() }

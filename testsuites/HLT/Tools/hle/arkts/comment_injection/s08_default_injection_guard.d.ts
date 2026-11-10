// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

export interface IDefaultInjectionUnsafe {
    // @default */unquoted_evil_payload/*
    unsafeProp?: string;
    // @default 3.14
    safeNumericProp?: number;
    // @default true
    safeBoolProp?: boolean;
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

__attribute__((overloadable)) void M(void);
__attribute__((overloadable)) void M(int);
void M(double);
__attribute__((overloadable)) void M(void);
void M(double);

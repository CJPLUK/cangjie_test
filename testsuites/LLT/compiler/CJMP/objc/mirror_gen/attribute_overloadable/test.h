/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

#include "overloadable.h"

@class C;

__attribute__((overloadable)) void M(char);
__attribute__((__overloadable__)) void M(short);
void M(void);
OVERLOADABLE1 void M(id);
OVERLOADABLE2 void M(C*);
FAKE_OVERLOADABLE void M(void);

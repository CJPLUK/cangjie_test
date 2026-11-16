/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include "case11.h"

int64_t C_Func(int32_t a1, int64_t a2, int32_t a3, int64_t a4, int32_t a5, int64_t a6, int32_t a7, int64_t a8, int32_t a9, int64_t a10)
{
    printf("C_Func:%" PRId32 "\n", a1);
    printf("C_Func:%" PRId64 "\n", a2);
    printf("C_Func:%" PRId32 "\n", a3);
    printf("C_Func:%" PRId64 "\n", a4);
    printf("C_Func:%" PRId32 "\n", a5);
    printf("C_Func:%" PRId64 "\n", a6);
    printf("C_Func:%" PRId32 "\n", a7);
    printf("C_Func:%" PRId64 "\n", a8);
    printf("C_Func:%" PRId32 "\n", a9);
    printf("C_Func:%" PRId64 "\n", a10);
    int64_t result = C2CJ_Func(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10);
    printf("C_Func:%" PRId64 "\n", result);
    return result;
}
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

typedef struct {
    int64_t x;
    int64_t y;
    int64_t z;
} BiggerStruct;

BiggerStruct PassStructToC_6S(BiggerStruct a, BiggerStruct b, BiggerStruct c, BiggerStruct d, BiggerStruct e,
                              BiggerStruct f)
{
    printf("func PassStructToC_6S\n");
    printf("change CJ struct: x -> %" PRId64 " , y -> %" PRId64 " , z -> %" PRId64 "\n", a.x, a.y, a.z);
    printf("change CJ struct: x -> %" PRId64 " , y -> %" PRId64 " , z -> %" PRId64 "\n", b.x, b.y, b.z);
    printf("change CJ struct: x -> %" PRId64 " , y -> %" PRId64 " , z -> %" PRId64 "\n", c.x, c.y, c.z);
    printf("change CJ struct: x -> %" PRId64 " , y -> %" PRId64 " , z -> %" PRId64 "\n", d.x, d.y, d.z);
    printf("change CJ struct: x -> %" PRId64 " , y -> %" PRId64 " , z -> %" PRId64 "\n", e.x, e.y, e.z);
    printf("change CJ struct: x -> %" PRId64 " , y -> %" PRId64 " , z -> %" PRId64 "\n", f.x, f.y, f.z);
    printf("\n");
    return a;
}

BiggerStruct PassStructToC_6int1S(int32_t a, int32_t b, int32_t c, int32_t d, int32_t e, int32_t f, BiggerStruct fff)
{
    printf("func PassStructToC_6int1S\n");
    printf("6int = %" PRId32 ",%" PRId32 ",%" PRId32 ",%" PRId32 ",%" PRId32 ",%" PRId32 "\n", a, b, c, d, e, f);
    printf("change CJ struct: x -> %" PRId64 " , y -> %" PRId64 " , z -> %" PRId64 "\n", fff.x, fff.y, fff.z);
    printf("\n");
    return fff;
}

int32_t PassStructToC_6int(int32_t a, int32_t b, int32_t c, int32_t d, int32_t e, int32_t f, int32_t g)
{
    printf("6int = %" PRId32 ",%" PRId32 ",%" PRId32 ",%" PRId32 ",%" PRId32 ",%" PRId32 ",%" PRId32 "\n", a, b, c, d, e, f, g);
    printf("\n");
    return 0;
}

BiggerStruct PassStructToC_1S6int(BiggerStruct fff, int32_t a, int32_t b, int32_t c, int32_t d, int32_t e, int32_t f)
{
    printf("func PassStructToC_1S6int\n");
    printf("6int = %" PRId32 ",%" PRId32 ",%" PRId32 ",%" PRId32 ",%" PRId32 ",%" PRId32 "\n", a, b, c, d, e, f);
    printf("change CJ struct: x -> %" PRId64 " , y -> %" PRId64 " , z -> %" PRId64 "\n", fff.x, fff.y, fff.z);
    printf("\n");
    return fff;
}

BiggerStruct PassStructToC_3int1S3int1S(int32_t a, int32_t b, int32_t c, BiggerStruct eee, int32_t d, int32_t e, int32_t f, BiggerStruct fff)
{
    printf("func PassStructToC_3int1S3int1S\n");
    printf("6int = %" PRId32 ",%" PRId32 ",%" PRId32 ",%" PRId32 ",%" PRId32 ",%" PRId32 "\n", a, b, c, d, e, f);
    printf("change CJ struct: x -> %" PRId64 " , y -> %" PRId64 " , z -> %" PRId64 "\n", eee.x, eee.y, eee.z);
    printf("change CJ struct: x -> %" PRId64 " , y -> %" PRId64 " , z -> %" PRId64 "\n", fff.x, fff.y, fff.z);
    printf("\n");
    return fff;
}
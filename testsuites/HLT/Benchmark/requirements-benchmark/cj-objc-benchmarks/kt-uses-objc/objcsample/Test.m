// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import <time.h>
#import <stdio.h>

#import <ktsample/ktsample.h>

#import "M.h"

extern void kt_ktsample_Test_testImpl();

typedef int64_t (^LongUnaryOperator)(int64_t);

void test(int64_t iters, LongUnaryOperator f, const char* name)
{
    int ITER = 3;
    int N = 1000000;

    uint64_t sum = 0;
    for (int j = 0; j < 3; j++) {
        uint64_t t1 = clock_gettime_nsec_np(CLOCK_UPTIME_RAW);
        int64_t x = 0;
        for (int i = 0; i < N; i++) {
            x += f(iters);
        }
        uint64_t t2 = clock_gettime_nsec_np(CLOCK_UPTIME_RAW);
        if (j == 0) {
            printf("%s Iter=%3lld; x=%20lld; time %4llums; per call:", name, (long long) iters, (long long) x, (t2 - t1) / 1000000);
        }
        printf(" %4llu", (t2 - t1) / N);
        sum += t2 - t1;
    } 
    printf("  AVG %4llu ns\n", sum / ITER / N);
}

int main(int argc, char** argv)
{
    printf("ObjC: main\n");
    
    // test(0,   ^(int64_t it) { return [M staticBlackhole:it]; }, "ObjC->ObjC Static  ");
    // test(100, ^(int64_t it) { return [M staticBlackhole:it]; }, "ObjC->ObjC Static  ");
    // test(200, ^(int64_t it) { return [M staticBlackhole:it]; }, "ObjC->ObjC Static  ");

    // M* m = [[M alloc] init];
    // test(0,   ^(int64_t it) { return [m instanceBlackhole:it]; }, "ObjC->ObjC Instance");
    // test(100, ^(int64_t it) { return [m instanceBlackhole:it]; }, "ObjC->ObjC Instance");
    // test(200, ^(int64_t it) { return [m instanceBlackhole:it]; }, "ObjC->ObjC Instance");

    // test(0,   ^(int64_t it) { return [[M get] instanceBlackhole:it]; }, "ObjC->ObjC Get     ");
    // test(100, ^(int64_t it) { return [[M get] instanceBlackhole:it]; }, "ObjC->ObjC Get     ");
    // test(200, ^(int64_t it) { return [[M get] instanceBlackhole:it]; }, "ObjC->ObjC Get     ");

    [KtsampleKTWorldKt kt_ktsample_KTWorld_runImpl];

    return 0;
}

// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "M.h"

int64_t blackhole(int64_t iters) {
    int64_t m = iters;
    int64_t p = 1000 * 1000 * 1000 + 7;
    long x = p;
    if (iters == 0) {
        return x;
    }

    int64_t s = p % m;
    while (s != 0) {
        s = (s + p) % m;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        x ^= x << 19;
        x ^= x >> 11;
        x ^= x << 17;
        x ^= x << 3;
        x ^= x >> 11;
        x ^= x << 7;
        x ^= x << 5;
        x ^= x >> 23;
        x ^= x << 9;
    }

    return x;    
}

M* instance;

@implementation M : NSObject

+ (void)initialize {
    if (self == [M class]) {
        instance = [[M alloc] init];
    }
}

    + (int64_t)staticBlackhole:(int64_t)x {
        return blackhole(x);
    }

    - (int64_t)instanceBlackhole:(int64_t)x {
//        printf("ObjC: M.instanceBlackhole(%lld)\n", (long long)x);
        return blackhole(x);
    }

    + (M*)get {
        return instance;
    }

@end

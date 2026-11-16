// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "A.h"
#import <Foundation/Foundation.h>

int main(int argc, char** argv) {
    int64_t live;

    @autoreleasepool {
        A* a = [[A alloc] init];

        // `test` reads the live count before creating a mirror of its own and returns once that mirror is
        // gone again, so what it returns is what has to be left standing when it comes back: `a` alone.
        live = [a test];
        if ([M counter] != live) {
            printf("objc: leaked in pool = %lld\n", (long long)([M counter] - live));
            return 1;
        }
    }

    // Draining the pool drops the last reference Objective-C holds to `a`, the one @ObjC instance in
    // this test that Objective-C created itself. Nothing else keeps its peer alive, so it has to be gone.
    if ([M counter] != 0) {
        printf("objc: left after pool = %lld\n", (long long)[M counter]);
        return 2;
    }

    return 0;
}

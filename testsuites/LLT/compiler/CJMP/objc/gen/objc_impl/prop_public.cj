// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) RUN-EXEC-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %overflowOpt %import_objc_interop
// (CJNATIVE and not Windows) RUN-EXEC-PIPE: %cat ./objc-gen/A.m | compare %f

/* SCAN-IN
- (A*)p {
    if (self.$registryId == -1) {
        [NSException raise: @"Use before Cangjie counterpart is initialized" format: @"selector `%@` is overridden in Cangjie and cannot be used before Cangjie counterpart is initialized", NSStringFromSelector(_cmd)];
    }
    return (__bridge_transfer A*)CJImpl_ObjC_cjworld_A_p_get(self.$registryId, (__bridge void*)self);
}
*/
/* SCAN-IN
- (void)setP:(A*)value {
    if (self.$registryId == -1) {
        [NSException raise: @"Use before Cangjie counterpart is initialized" format: @"selector `%@` is overridden in Cangjie and cannot be used before Cangjie counterpart is initialized", NSStringFromSelector(_cmd)];
    }
    CJImpl_ObjC_cjworld_A_p_set(self.$registryId, (__bridge void*)self, (__bridge_retained void*)value);
}
*/

package cjworld

import objc.lang.*

@ObjC
public open foreign class M {
    init()
}

@ObjC
public class A <: M {
    public mut prop p: A {
        get() {
            this
        }
        set(value) {

        }
    }
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

@protocol P_;
@protocol P0;
@protocol P1;

typedef id<P_> P_;
typedef id<P0> _Nullable P0;
typedef id<P1> _Nonnull P1;

@interface M

- (P_)f__;
- (P_ _Nullable)f_0;
- (P_ _Nonnull)f_1;

- (P0)f0_;
- (P0 _Nullable)f00;

- (P1)f1_;
- (P1 _Nonnull)f11;

@end

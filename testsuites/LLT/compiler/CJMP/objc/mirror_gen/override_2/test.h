/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

@interface C
- (void)foo:(int)x:(int)y;
- (void)bar:(nonnull id)x:(nonnull id)y;
- (void)baz:(C*)x:(C*)y;
@end

@interface M : C
- (void)foo:(double)x:(double)y;
- (void)bar:(nullable id)x:(nullable id)y;
- (void)baz:(M*)x:(M*)y;
@end

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

enum A : int { a };
enum B : int { b };
enum C : char { c };

@interface M
- (instancetype)initA:(enum A)x;
- (instancetype)initB:(enum B)x;
- (instancetype)initC:(enum C)x;

- (instancetype)initFunc1:(void(*)(void))x;
- (instancetype)initFunc2:(void(*)(void))x;
- (instancetype)initFunc3:(void(*)(int))x;

- (instancetype)initBlock1:(void(^)(void))x;
- (instancetype)initBlock2:(void(^)(void))x;
- (instancetype)initBlock3:(void(^)(int))x;
@end

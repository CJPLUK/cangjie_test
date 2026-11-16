// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import <stdint.h>

@interface M : NSObject

+ (int64_t)staticBlackhole:(int64_t)x;

- (int64_t)instanceBlackhole:(int64_t)x;

+ (M*)get;

@end

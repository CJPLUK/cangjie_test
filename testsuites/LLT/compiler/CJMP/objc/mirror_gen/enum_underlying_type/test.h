/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

typedef unsigned UInteger;

enum M : UInteger { a };

typedef int uint32_t;
typedef long long int_fast32_t;
typedef int ssize_t;

typedef int UserDefinedImportantTypeDef;

enum E : uint32_t;
enum EE : int;
enum EEE : int {
    A, B, C
};
typedef enum EEE EEE;

@interface M
-(void)foo: (uint32_t)x with:(enum E)y;
-(void)bar: (int_fast32_t)x with:(enum EE)y;
-(void)baz: (ssize_t)x with:(EEE)y;
-(void)foobarbaz: (UserDefinedImportantTypeDef)x;
@end


typedef int uint64_t;

typedef enum NSActivityOptions : uint64_t NSActivityOptions;
enum NSActivityOptions : uint64_t {
    O
};

@interface M (NSProcessInfoActivity)
-(void)beginActivityWithOptionsReason:(NSActivityOptions)x;
@end

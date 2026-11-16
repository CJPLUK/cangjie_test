/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

@interface M
- (void)foo:(int)x x:(int)x;
- (void)foo:(int)x:(int)x;
- (void)foo:(int)x2:(int)x:(int)x;
@end

void M1(int);
void M2(int, int x);
void M3(int x, int);
void M4(int, int);
void M5(int _2, int, int);
void M6(int _, int);
void M7(int _1, int _, int);

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

@interface NSString
@end

@interface M1 {
  int toString;
}
@end

@interface M2
@property int toString;
@end

@interface M3
- (int)toString;
- (int)toString: (int)x;
@end

@interface M4 {
  int toString;
}
@property int toString;
- (int)toString;
- (int)toString: (int)x;
@end

@interface M5
- (int)toString;
- (int)toString_;
@end

@interface N1 {
  NSString* toString;
}
@end

@interface N2
@property NSString* toString;
@end

@interface N3
-(NSString*)toString;
-(NSString*)toString: (int)x;
@end

@interface N4 {
  NSString* toString;
}
@property NSString* toString;
-(NSString*)toString;
-(NSString*)toString: (int)x;
@end

@interface N5
- (NSString*)toString;
- (NSString*)toNSString;
- (NSString*)toNSString_;
@end


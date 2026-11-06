/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

@interface NSObject
@end

@interface M1 : NSObject {
  int toString;
}
@end

@interface M2 : NSObject
@property int toString;
@end

@interface M3 : NSObject
-(int)toString;
@end

@interface M4 : NSObject {
  int toString;
}
@property int toString;
-(int)toString;
@end

@interface N {
  int toString;
}
@property int toString;
-(int)toString;
@end

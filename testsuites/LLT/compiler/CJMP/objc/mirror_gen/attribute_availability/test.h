/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

@interface M
- (void)unavailable __attribute__((unavailable));
- (void)iosUnavailable __attribute__((availability(ios,unavailable)));
- (void)macosUnavailable __attribute__((availability(macos,unavailable)));
- (void)iosNotIntroduced __attribute__((availability(ios,strict,introduced=30.0)));
- (void)macosNotIntroduced __attribute__((availability(macos,strict,introduced=30.0)));
- (void)iosAvailable __attribute__((availability(ios,introduced=10.0,obsoleted=30.0)));
- (void)macosAvailable __attribute__((availability(macos,introduced=10.0,obsoleted=30.0)));
- (void)iosObsoleted __attribute__((availability(ios,introduced=10.0,obsoleted=15.0)));
- (void)macosObsoleted __attribute__((availability(macos,introduced=10.0,obsoleted=15.0)));
@end

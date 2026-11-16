/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package com;

public abstract class JavaClass {
  public int goo() {
    System.out.println("in JavaClass goo");
    return 66;
  }

  public static int bar() {
    System.out.println("in JavaClass bar");
    return 1;
  }

  public abstract int newoo();
}

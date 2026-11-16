// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package test;

public class EchoMirror extends EchoBase {
    public String objField = "String";

    public long foo(long arg) {
        return arg + 1;
    }

    public String goo(EchoMirror arg) {
        return "str";
    }

    public long throwJavaException() {
        throw new IllegalStateException("expected Java exception");
    }
}

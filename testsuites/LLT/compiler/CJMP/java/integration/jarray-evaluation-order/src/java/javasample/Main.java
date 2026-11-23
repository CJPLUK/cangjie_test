// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package javasample;

public final class Main {
    private Main() {}

    public static void main(String[] args) {
        TestImpl impl = new TestImpl();

        impl.testArrayEvaluationOrder();
    }
}
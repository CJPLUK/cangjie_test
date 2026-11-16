// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

import test.EchoImpl;

public class Main {
    public static void main(String[] args) {
        EchoImpl impl = new EchoImpl();

        impl.testJObjectConstructor();
        impl.testJStringConstructorWithValue();
        impl.testJStringConstructorEmpty();
        impl.testJStringDefaultConstructor();
        impl.testJavaMirrorConstructor();
        impl.testFieldGetter();
        impl.testFieldSetter();
        impl.testNullableFieldSetter();
        impl.testJavaMethodCall();
        impl.testJavaMethodReturningObject();
        impl.testJArrayConstructor();
        impl.testJArrayMethod();
        impl.testJArrayGetSet();
        impl.testInheritedJavaMethod();
        impl.testJavaExceptionPropagation();
    }
}

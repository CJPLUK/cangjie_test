/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package annopkg

import std.reflect.*

@Annotation
public class CustomAnnotation {
    const CustomAnnotation(public let value: String, public let version: Int64) {}
}

@CustomAnnotation["123", 3]
public class C1 {}
@CustomAnnotation["123", 3]
public class C2 {}
@CustomAnnotation["123", 3]
public class C3 {}
@CustomAnnotation["123", 3]
public class C4 {}
@CustomAnnotation["123", 3]
public class C5 {}

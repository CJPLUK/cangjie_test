/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

import std.reflect.*

@Annotation
public class CustomAnnotation {
    const CustomAnnotation(let value: String, let version: Int64) {}
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
@CustomAnnotation["123", 3]
public class C6 {}
@CustomAnnotation["123", 3]
public class C7 {}
@CustomAnnotation["123", 3]
public class C8 {}
@CustomAnnotation["123", 3]
public class C9 {}
@CustomAnnotation["123", 3]
public class C10 {}

func checkAnnotation(ti: TypeInfo): Int64 {
    if (let Some(a) <- ti.findAnnotation<CustomAnnotation>()) {
        if (a.value != "123" || a.version != 3) {
            return 1
        }
        return 0
    }
    2
}

main() {
    if (checkAnnotation(TypeInfo.of(C1())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C2())) != 0) { return 2 }
    if (checkAnnotation(TypeInfo.of(C3())) != 0) { return 3 }
    if (checkAnnotation(TypeInfo.of(C4())) != 0) { return 4 }
    if (checkAnnotation(TypeInfo.of(C5())) != 0) { return 5 }
    if (checkAnnotation(TypeInfo.of(C6())) != 0) { return 6 }
    if (checkAnnotation(TypeInfo.of(C7())) != 0) { return 7 }
    if (checkAnnotation(TypeInfo.of(C8())) != 0) { return 8 }
    if (checkAnnotation(TypeInfo.of(C9())) != 0) { return 9 }
    if (checkAnnotation(TypeInfo.of(C10())) != 0) { return 10 }
    0
}

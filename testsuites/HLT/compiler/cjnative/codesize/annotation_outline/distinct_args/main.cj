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
public class C3Group1 {}
@CustomAnnotation["123", 3]
public class C3Group2 {}
@CustomAnnotation["123", 3]
public class C3Group3 {}
@CustomAnnotation["123", 3]
public class C3Group4 {}
@CustomAnnotation["123", 3]
public class C3Group5 {}
@CustomAnnotation["123", 4]
public class C4Group1 {}
@CustomAnnotation["123", 4]
public class C4Group2 {}
@CustomAnnotation["123", 4]
public class C4Group3 {}
@CustomAnnotation["123", 4]
public class C4Group4 {}
@CustomAnnotation["123", 4]
public class C4Group5 {}

func checkVersion(ti: TypeInfo, expected: Int64): Int64 {
    if (let Some(a) <- ti.findAnnotation<CustomAnnotation>()) {
        if (a.version != expected) {
            return 1
        }
        return 0
    }
    2
}

main() {
    if (checkVersion(TypeInfo.of(C3Group1()), 3) != 0) { return 1 }
    if (checkVersion(TypeInfo.of(C3Group2()), 3) != 0) { return 2 }
    if (checkVersion(TypeInfo.of(C3Group3()), 3) != 0) { return 3 }
    if (checkVersion(TypeInfo.of(C3Group4()), 3) != 0) { return 4 }
    if (checkVersion(TypeInfo.of(C3Group5()), 3) != 0) { return 5 }
    if (checkVersion(TypeInfo.of(C4Group1()), 4) != 0) { return 6 }
    if (checkVersion(TypeInfo.of(C4Group2()), 4) != 0) { return 7 }
    if (checkVersion(TypeInfo.of(C4Group3()), 4) != 0) { return 8 }
    if (checkVersion(TypeInfo.of(C4Group4()), 4) != 0) { return 9 }
    if (checkVersion(TypeInfo.of(C4Group5()), 4) != 0) { return 10 }
    0
}

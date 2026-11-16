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

@Annotation
public class FlagAnnotation {
    const FlagAnnotation(let enabled: Bool, let ratio: Float64) {}
}

// CustomAnnotation 去重组（10 个同参实例，K=10 → 合并 helper）
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

// FlagAnnotation 去重组（第二种注解类型，10 个同参实例）
@FlagAnnotation[true, 1.5]
public class F1 {}
@FlagAnnotation[true, 1.5]
public class F2 {}
@FlagAnnotation[true, 1.5]
public class F3 {}
@FlagAnnotation[true, 1.5]
public class F4 {}
@FlagAnnotation[true, 1.5]
public class F5 {}
@FlagAnnotation[true, 1.5]
public class F6 {}
@FlagAnnotation[true, 1.5]
public class F7 {}
@FlagAnnotation[true, 1.5]
public class F8 {}
@FlagAnnotation[true, 1.5]
public class F9 {}
@FlagAnnotation[true, 1.5]
public class F10 {}

// 使用点多样性（各自不同实参，K=1，覆盖前端多种 lowering 形状）
@CustomAnnotation["class", 3]
public class AnnoClass {}

public class AnnoHolder {
    @CustomAnnotation["func", 4]
    public static func foo(): Int64 {
        0
    }

    @CustomAnnotation["propVal", 5]
    public static var propVal: Int64 = 0
}

func checkCustomAnnotation(ti: TypeInfo): Int64 {
    if (let Some(a) <- ti.findAnnotation<CustomAnnotation>()) {
        if (a.value != "123" || a.version != 3) {
            return 1
        }
        return 0
    }
    2
}

func checkFlag(ti: TypeInfo): Int64 {
    if (let Some(a) <- ti.findAnnotation<FlagAnnotation>()) {
        if (!a.enabled || a.ratio != 1.5) {
            return 1
        }
        return 0
    }
    2
}

func checkCustomIn(anns: Collection<Annotation>, value: String, version: Int64): Bool {
    for (a in anns) {
        match (a) {
            case ca: CustomAnnotation =>
                if (ca.value == value && ca.version == version) {
                    return true
                }
            case _ => ()
        }
    }
    false
}

main() {
    if (checkCustomAnnotation(TypeInfo.of(C1())) != 0) { return 1 }
    if (checkCustomAnnotation(TypeInfo.of(C2())) != 0) { return 2 }
    if (checkCustomAnnotation(TypeInfo.of(C3())) != 0) { return 3 }
    if (checkCustomAnnotation(TypeInfo.of(C4())) != 0) { return 4 }
    if (checkCustomAnnotation(TypeInfo.of(C5())) != 0) { return 5 }
    if (checkCustomAnnotation(TypeInfo.of(C6())) != 0) { return 6 }
    if (checkCustomAnnotation(TypeInfo.of(C7())) != 0) { return 7 }
    if (checkCustomAnnotation(TypeInfo.of(C8())) != 0) { return 8 }
    if (checkCustomAnnotation(TypeInfo.of(C9())) != 0) { return 9 }
    if (checkCustomAnnotation(TypeInfo.of(C10())) != 0) { return 10 }
    if (checkFlag(TypeInfo.of(F1())) != 0) { return 11 }
    if (checkFlag(TypeInfo.of(F2())) != 0) { return 12 }
    if (checkFlag(TypeInfo.of(F3())) != 0) { return 13 }
    if (checkFlag(TypeInfo.of(F4())) != 0) { return 14 }
    if (checkFlag(TypeInfo.of(F5())) != 0) { return 15 }
    if (checkFlag(TypeInfo.of(F6())) != 0) { return 16 }
    if (checkFlag(TypeInfo.of(F7())) != 0) { return 17 }
    if (checkFlag(TypeInfo.of(F8())) != 0) { return 18 }
    if (checkFlag(TypeInfo.of(F9())) != 0) { return 19 }
    if (checkFlag(TypeInfo.of(F10())) != 0) { return 20 }
    if (!checkCustomIn(TypeInfo.of(AnnoClass()).annotations, "class", 3)) { return 21 }
    if (!checkCustomIn(ClassTypeInfo.of<AnnoHolder>().getStaticFunction("foo", []).annotations, "func", 4)) { return 22 }
    if (!checkCustomIn(ClassTypeInfo.of<AnnoHolder>().getStaticVariable("propVal").annotations, "propVal", 5)) { return 23 }
    0
}

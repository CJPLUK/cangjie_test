/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

import std.reflect.*
import std.runtime.*

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

@CustomAnnotation["123", 3]
public class C11 {}

@CustomAnnotation["123", 3]
public class C12 {}

@CustomAnnotation["123", 3]
public class C13 {}

@CustomAnnotation["123", 3]
public class C14 {}

@CustomAnnotation["123", 3]
public class C15 {}

@CustomAnnotation["123", 3]
public class C16 {}

@CustomAnnotation["123", 3]
public class C17 {}

@CustomAnnotation["123", 3]
public class C18 {}

@CustomAnnotation["123", 3]
public class C19 {}

@CustomAnnotation["123", 3]
public class C20 {}

@CustomAnnotation["123", 3]
public class C21 {}

@CustomAnnotation["123", 3]
public class C22 {}

@CustomAnnotation["123", 3]
public class C23 {}

@CustomAnnotation["123", 3]
public class C24 {}

@CustomAnnotation["123", 3]
public class C25 {}

@CustomAnnotation["123", 3]
public class C26 {}

@CustomAnnotation["123", 3]
public class C27 {}

@CustomAnnotation["123", 3]
public class C28 {}

@CustomAnnotation["123", 3]
public class C29 {}

@CustomAnnotation["123", 3]
public class C30 {}

@CustomAnnotation["123", 3]
public class C31 {}

@CustomAnnotation["123", 3]
public class C32 {}

@CustomAnnotation["123", 3]
public class C33 {}

@CustomAnnotation["123", 3]
public class C34 {}

@CustomAnnotation["123", 3]
public class C35 {}

@CustomAnnotation["123", 3]
public class C36 {}

@CustomAnnotation["123", 3]
public class C37 {}

@CustomAnnotation["123", 3]
public class C38 {}

@CustomAnnotation["123", 3]
public class C39 {}

@CustomAnnotation["123", 3]
public class C40 {}

@CustomAnnotation["123", 3]
public class C41 {}

@CustomAnnotation["123", 3]
public class C42 {}

@CustomAnnotation["123", 3]
public class C43 {}

@CustomAnnotation["123", 3]
public class C44 {}

@CustomAnnotation["123", 3]
public class C45 {}

@CustomAnnotation["123", 3]
public class C46 {}

@CustomAnnotation["123", 3]
public class C47 {}

@CustomAnnotation["123", 3]
public class C48 {}

@CustomAnnotation["123", 3]
public class C49 {}

@CustomAnnotation["123", 3]
public class C50 {}

@CustomAnnotation["123", 3]
public class C51 {}

@CustomAnnotation["123", 3]
public class C52 {}

@CustomAnnotation["123", 3]
public class C53 {}

@CustomAnnotation["123", 3]
public class C54 {}

@CustomAnnotation["123", 3]
public class C55 {}

@CustomAnnotation["123", 3]
public class C56 {}

@CustomAnnotation["123", 3]
public class C57 {}

@CustomAnnotation["123", 3]
public class C58 {}

@CustomAnnotation["123", 3]
public class C59 {}

@CustomAnnotation["123", 3]
public class C60 {}

@CustomAnnotation["123", 3]
public class C61 {}

@CustomAnnotation["123", 3]
public class C62 {}

@CustomAnnotation["123", 3]
public class C63 {}

@CustomAnnotation["123", 3]
public class C64 {}

@CustomAnnotation["123", 3]
public class C65 {}

@CustomAnnotation["123", 3]
public class C66 {}

@CustomAnnotation["123", 3]
public class C67 {}

@CustomAnnotation["123", 3]
public class C68 {}

@CustomAnnotation["123", 3]
public class C69 {}

@CustomAnnotation["123", 3]
public class C70 {}

@CustomAnnotation["123", 3]
public class C71 {}

@CustomAnnotation["123", 3]
public class C72 {}

@CustomAnnotation["123", 3]
public class C73 {}

@CustomAnnotation["123", 3]
public class C74 {}

@CustomAnnotation["123", 3]
public class C75 {}

@CustomAnnotation["123", 3]
public class C76 {}

@CustomAnnotation["123", 3]
public class C77 {}

@CustomAnnotation["123", 3]
public class C78 {}

@CustomAnnotation["123", 3]
public class C79 {}

@CustomAnnotation["123", 3]
public class C80 {}

@CustomAnnotation["123", 3]
public class C81 {}

@CustomAnnotation["123", 3]
public class C82 {}

@CustomAnnotation["123", 3]
public class C83 {}

@CustomAnnotation["123", 3]
public class C84 {}

@CustomAnnotation["123", 3]
public class C85 {}

@CustomAnnotation["123", 3]
public class C86 {}

@CustomAnnotation["123", 3]
public class C87 {}

@CustomAnnotation["123", 3]
public class C88 {}

@CustomAnnotation["123", 3]
public class C89 {}

@CustomAnnotation["123", 3]
public class C90 {}

@CustomAnnotation["123", 3]
public class C91 {}

@CustomAnnotation["123", 3]
public class C92 {}

@CustomAnnotation["123", 3]
public class C93 {}

@CustomAnnotation["123", 3]
public class C94 {}

@CustomAnnotation["123", 3]
public class C95 {}

@CustomAnnotation["123", 3]
public class C96 {}

@CustomAnnotation["123", 3]
public class C97 {}

@CustomAnnotation["123", 3]
public class C98 {}

@CustomAnnotation["123", 3]
public class C99 {}

@CustomAnnotation["123", 3]
public class C100 {}

func checkAnnotation(ti: TypeInfo): Int64 {
    if (let Some(a) <- ti.findAnnotation<CustomAnnotation>()) {
        if (a.value != "123" || a.version != 3) {
            return 1
        }
        return 0
    }
    2
}

func doRound(round: Int64): Int64 {
    let tmp = Array<String>(16, {i => "round${round}-item${i}"})
    if (checkAnnotation(TypeInfo.of(C1())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C2())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C3())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C4())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C5())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C6())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C7())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C8())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C9())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C10())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C11())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C12())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C13())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C14())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C15())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C16())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C17())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C18())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C19())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C20())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C21())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C22())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C23())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C24())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C25())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C26())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C27())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C28())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C29())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C30())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C31())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C32())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C33())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C34())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C35())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C36())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C37())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C38())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C39())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C40())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C41())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C42())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C43())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C44())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C45())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C46())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C47())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C48())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C49())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C50())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C51())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C52())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C53())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C54())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C55())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C56())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C57())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C58())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C59())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C60())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C61())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C62())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C63())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C64())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C65())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C66())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C67())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C68())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C69())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C70())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C71())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C72())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C73())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C74())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C75())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C76())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C77())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C78())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C79())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C80())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C81())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C82())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C83())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C84())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C85())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C86())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C87())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C88())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C89())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C90())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C91())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C92())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C93())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C94())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C95())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C96())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C97())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C98())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C99())) != 0) { return 1 }
    if (checkAnnotation(TypeInfo.of(C100())) != 0) { return 1 }
    if (tmp[0] != "round${round}-item0" || tmp[15] != "round${round}-item15") { return 2 }
    gc()
    0
}

main() {
    for (round in 0..100) {
        if (doRound(round) != 0) {
            return 1
        }
    }
    0
}

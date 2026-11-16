/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_args | compare %f
// OverflowStrategy / UnaryExprKind / BinaryExprKind Equatable cartesian product

/* SCAN
enum eq cartesian: true
linkage enum: true
*/

import stdx.chir.*

main() {
    let ov = [
        OverflowStrategy.NA,
        OverflowStrategy.Wrapping,
        OverflowStrategy.Throwing,
        OverflowStrategy.Saturating
    ]
    var ovEq = 0
    var ovNeq = 0
    for (i in 0..ov.size) {
        for (j in 0..ov.size) {
            if (ov[i] == ov[j]) {
                ovEq += 1
            } else {
                ovNeq += 1
            }
        }
    }

    let un = [UnaryExprKind.Neg, UnaryExprKind.Not, UnaryExprKind.BitNot]
    var unEq = 0
    var unNeq = 0
    for (i in 0..un.size) {
        for (j in 0..un.size) {
            if (un[i] == un[j]) {
                unEq += 1
            } else {
                unNeq += 1
            }
        }
    }

    let bin = [
        BinaryExprKind.Add, BinaryExprKind.Sub, BinaryExprKind.Mul, BinaryExprKind.Div,
        BinaryExprKind.Mod, BinaryExprKind.Exp, BinaryExprKind.LShift, BinaryExprKind.RShift,
        BinaryExprKind.BitAnd, BinaryExprKind.BitOr, BinaryExprKind.BitXor,
        BinaryExprKind.LT, BinaryExprKind.GT, BinaryExprKind.LE, BinaryExprKind.GE,
        BinaryExprKind.Equal, BinaryExprKind.NotEqual, BinaryExprKind.And, BinaryExprKind.Or
    ]
    var binEq = 0
    var binNeq = 0
    for (i in 0..bin.size) {
        for (j in 0..bin.size) {
            if (bin[i] == bin[j]) {
                binEq += 1
            } else {
                binNeq += 1
            }
        }
    }

    var ovNe = 0
    var unNe = 0
    var binNe = 0
    for (i in 0..ov.size) {
        for (j in 0..ov.size) {
            if (ov[i] != ov[j]) {
                ovNe += 1
            }
        }
    }
    for (i in 0..un.size) {
        for (j in 0..un.size) {
            if (un[i] != un[j]) {
                unNe += 1
            }
        }
    }
    for (i in 0..bin.size) {
        for (j in 0..bin.size) {
            if (bin[i] != bin[j]) {
                binNe += 1
            }
        }
    }

    println(
        "enum eq cartesian: ${ovEq == ov.size && ovNeq > 0 && ovNeq == ovNe && unEq == un.size && unNeq > 0 && unNeq == unNe && binEq == bin.size && binNeq > 0 && binNeq == binNe}"
    )

    let linkages = [LinkType.External, LinkType.ExternalWeak, LinkType.Internal, LinkType.LinkonceOdr, LinkType.WeakOdr]
    let names = ["external", "external_weak", "internal", "linkonce_odr", "weak_odr"]
    var linkageEq = true
    for (i in 0..linkages.size) {
        linkageEq = linkageEq && linkages[i].toString() == names[i]
        for (j in 0..linkages.size) {
            linkageEq = linkageEq && ((linkages[i] == linkages[j]) == (i == j))
            linkageEq = linkageEq && ((linkages[i] != linkages[j]) == (i != j))
        }
    }
    println("linkage enum: ${linkageEq}")

}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

struct S1 {
    var a: UInt8
    init(a: UInt8) {
        this.a = a
    }
}

struct S8 {
    var a: Int64
    init(a: Int64) {
        this.a = a
    }
}

struct S16 {
    var a: Int64
    var b: Int64
    init(a: Int64, b: Int64) {
        this.a = a
        this.b = b
    }
}

struct S24 {
    var a: Int64
    var b: Int64
    var c: Int64
    init(a: Int64, b: Int64, c: Int64) {
        this.a = a
        this.b = b
        this.c = c
    }
}

var gCopyLen: Int64 = 4

func checkS1(): Int64 {
    let src = Array<S1>(8, {i => S1(UInt8(i + 1))})
    let dst = Array<S1>(8, {i => S1(0)})
    src.copyTo(dst, 0, 0, gCopyLen)
    for (i in 0..gCopyLen) {
        if (dst[i].a != src[i].a) {
            return 1
        }
    }
    0
}

func checkS8(): Int64 {
    let src = Array<S8>(8, {i => S8(i + 1)})
    let dst = Array<S8>(8, {i => S8(0)})
    src.copyTo(dst, 0, 0, gCopyLen)
    for (i in 0..gCopyLen) {
        if (dst[i].a != src[i].a) {
            return 1
        }
    }
    0
}

func checkS16(): Int64 {
    let src = Array<S16>(8, {i => S16(i, i * 2)})
    let dst = Array<S16>(8, {i => S16(0, 0)})
    src.copyTo(dst, 0, 0, gCopyLen)
    for (i in 0..gCopyLen) {
        if (dst[i].a != src[i].a || dst[i].b != src[i].b) {
            return 1
        }
    }
    0
}

func checkS24(): Int64 {
    let src = Array<S24>(8, {i => S24(i, i * 2, i * 3)})
    let dst = Array<S24>(8, {i => S24(0, 0, 0)})
    src.copyTo(dst, 0, 0, gCopyLen)
    for (i in 0..gCopyLen) {
        if (dst[i].a != src[i].a || dst[i].b != src[i].b || dst[i].c != src[i].c) {
            return 1
        }
    }
    0
}

main() {
    if (checkS1() != 0) {
        return 1
    }
    if (checkS8() != 0) {
        return 2
    }
    if (checkS16() != 0) {
        return 3
    }
    if (checkS24() != 0) {
        return 4
    }
    0
}

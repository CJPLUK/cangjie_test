// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

import kotlin.time.DurationUnit
import kotlin.time.TimeSource
import kotlinx.cinterop.*
import api.M

typealias LongUnaryOperator = (Long) -> Long

fun kt_ktsample_KTWorld_runImpl() {
    run()
}

fun pad3(v: Long): String {
    val pad = if (v < 10L) "  " else if (v < 100L) " " else ""
    return "${pad}${v}"
}

fun pad4(v: Long): String {
    val pad = if (v < 10L) "   " else if (v < 100L) "  " else if (v < 1000L) " " else ""
    return "${pad}${v}"
}

fun pad5(v: Long): String {
    val pad = if (v < 10L) "    " else if (v < 100L) "   " else if (v < 1000L) "  " else if (v < 10000L) " " else ""
    return "${pad}${v}"
}

val N = 2000000L

inline fun test(iters: Long, f: LongUnaryOperator, name: String) {
    val ITER = 5L
    var sum = 0L
    for (j in 1..ITER) {
        val mark = TimeSource.Monotonic.markNow()
        var x = 0L
        for (unused in 1..N) {
            x += f(iters)
        }
        val duration = mark.elapsedNow()
        val diff: Long = duration.toLong(DurationUnit.NANOSECONDS)//t1 - t0
        if (j == 1L) {
            val ms = diff.div(1000000)
            print ("${name} Iter=${pad3(iters)} time ${pad5(ms)} ms; per call:")
        }
        val perCall = diff/N
        print (" ${pad4(perCall)}")
        sum += diff
    } 
    println ("  AVG ${pad4(sum / ITER / N)} ns");
}

inline fun test(f: LongUnaryOperator, name: String) {
    test (0, f, name)
    test (100, f, name)
    test (200, f, name)
}

@OptIn(ExperimentalForeignApi::class)
fun testBasic() {
    val m = M()
    m.instanceBlackhole(42)
    M.Companion.staticBlackhole(42)
    M.Companion.get()!!.instanceBlackhole(42)

    test (0, { n -> M.Companion.staticBlackhole(n) }, "--WARMUP--")
}

@OptIn(ExperimentalForeignApi::class)
fun testObjCStatic() {
    test({ n -> M.Companion.staticBlackhole(n) }, "KT->ObjC static    ")
}

@OptIn(ExperimentalForeignApi::class)
fun testObjCInstance() {
    val obj = M()
    test({ n -> obj.instanceBlackhole(n) }, "KT->ObjC instance  ")
}

@OptIn(ExperimentalForeignApi::class)
fun testObjCGet() {
    test({ n -> M.Companion.get()!!.instanceBlackhole(n) }, "KT->ObjC get       ")
}

fun run() {

    testBasic()

    testObjCStatic()

    testObjCInstance()

    testObjCGet()
}

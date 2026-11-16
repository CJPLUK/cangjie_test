/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt %import-cangjie-stdx -O2 %overflow_wrapping --no-sub-pkg %cmp_utest_opt -Woff=all %f -o %output
// RUN-EXEC: %export cjHeapSize=16gb && %export cjStackSize=64mb && %export JETVMPROP="-Xmx16G -Djet.cj.use.fibers -Djet.fiber.stack.size=64M" && %run_stdx %output %run_utest_opt %run_args --bench --no-color
// TIMEOUT: 1800

import stdx.encoding.json.stream.*
import std.io.*
import std.time.*
import std.collection.*
import std.random.*
import std.unittest.*

let string_size = [4, 8, 16, 64, 256, 1024, 4 * 1024, 16 * 1024, 128 * 1024]
let random = Random()

func buildString(length: Int64): String {
    var str = StringBuilder(length)
    var characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for (i in 0..length) {
        var index = Int64(random.nextUInt64(62))
        str.append(characters[index..index+1])
    }
    return str.toString()
}

func repFor(len: Int64): Int64 {
    if (len <= 1024) {
        1000000
    } else if (len == 4096) {
        100000
    } else {
        10000
    }
}

func getReader(n: Int64, length: Int64): JsonReader {
    var out = ByteBuffer()
    var w = JsonWriter(out)
    var str = buildString(length)
    w.startArray()
    for (_ in 0..n) {
        w.writeValue(str)
    }
    w.endArray()
    w.flush()
    return JsonReader(out)
}

func testReadStrings(r: JsonReader) {
    r.startArray()
    while (let Some(v) <- r.peek()) {
        match(v) {
            case JsonString => r.readValue<String>()
            case EndArray => r.endArray()
                                return
            case _ => r.skip()
        }
    }
}

@Test
@Configure[minDuration: Duration.second * 3]
@Configure[warmup: Duration.second]
@Measure[TimeNow(Nanos)]
public class Test_Json_Read_String {

    @Strategy[len in [4, 8, 16, 64, 256, 1024, 4096, 16384, 131072]]
    func readerData(len: Int64): GenerateEachInputProvider<JsonReader> {
        GenerateEachInputProvider { => getReader(repFor(len), len) }
    }

    @Bench[data in readerData]
    func BenchmarkJsonReadString_G10(data: JsonReader): Unit {
        testReadStrings(data)
    }
}
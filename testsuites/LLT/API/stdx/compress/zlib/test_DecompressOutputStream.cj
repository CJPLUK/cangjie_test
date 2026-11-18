/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler  %import-cangjie-stdx  %cmp_opt %f -o %output %cmp_utest_opt
// EXEC: %set_stdx_path %run %run_opt %output %run_utest_opt

import std.collection.*
import stdx.compress.zlib.*
import std.io.ByteBuffer
import std.fs.*

@Test
class CompressOutputStreamTest {
    @TestCase
    func inputBufferEmptyOutputStreamEmpty(): Unit {
        // Closing without any compressed data written: the stream is not finished, close reports incompleteness
        var dest: ByteBuffer = ByteBuffer()
        var decompressOutputStream: DecompressOutputStream = DecompressOutputStream(dest)
        decompressOutputStream.write(Array<Byte>())
        try {
            decompressOutputStream.close()
            @Assert(false)
        } catch (e: ZlibException) {
            @Expect(e.message, "Unexpected end of compressed data: no input data was written.")
        }
        @Expect(dest.remainLength, 0)
    }

    @TestCase
    func closeTwice(): Unit {
        var dest: ByteBuffer = ByteBuffer()
        var decompressOutputStream: DecompressOutputStream = DecompressOutputStream(dest, bufLen: 256)
        decompressOutputStream.flush()
        try {
            decompressOutputStream.close()
            @Assert(false)
        } catch (e: ZlibException) {
            @Expect(e.message, "Unexpected end of compressed data: no input data was written.")
        }
        // The second close is idempotent and returns directly
        decompressOutputStream.close()
    }
}

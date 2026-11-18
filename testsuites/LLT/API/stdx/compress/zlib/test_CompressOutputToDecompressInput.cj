/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: ./zlib_test.txt
// DEPENDENCE: ./zlib_test2.txt
// EXEC: %compiler  %import-cangjie-stdx  %cmp_opt %f -o %output %cmp_utest_opt
// EXEC: %set_stdx_path %run %run_opt %output %run_utest_opt

import std.collection.*
import stdx.compress.zlib.*
import std.io.ByteBuffer
import std.fs.*
import std.io.*

func compressFileOutputStream(srcFileName: String, destFileName: String, wrapType: WrapType, outputBuflen: Int64): Int64 {
    var count: Int64 = 0
    var srcFile: File = File(srcFileName, Read)
    var destFile: File = File(destFileName, Write)

    var tempBuf: Array<UInt8> = Array<UInt8>(outputBuflen, repeat: 0)
    var compressOutputStream: CompressOutputStream = CompressOutputStream(destFile, wrap: wrapType)
    while (true) {
        var readNum = srcFile.read(tempBuf)
        if (readNum > 0) {
            compressOutputStream.write(tempBuf.slice(0, readNum).toArray())
            count += readNum
        } else {
            break
        }
    }
    compressOutputStream.flush()
    compressOutputStream.close()

    srcFile.close()
    destFile.close()
    return count
}

func decompressFileInputStream(srcFileName: String, destFileName: String, wrapType: WrapType, outputBuflen: Int64): Int64 {
    var count: Int64 = 0
    var srcFile: File = File(srcFileName, Read)
    var destFile: File = File(destFileName, Write)

    var tempBuf: Array<UInt8> = Array<UInt8>(outputBuflen, repeat: 0)
    var decompressInputStream: DecompressInputStream = DecompressInputStream(srcFile, wrap: wrapType)
    while (true) {
        var readNum = decompressInputStream.read(tempBuf)
        if (readNum <= 0) {
            break
        }
        destFile.write(tempBuf.slice(0, readNum).toArray())
        count += readNum
    }
    decompressInputStream.close()

    srcFile.close()
    destFile.close()
    return count
}

func compareFile(fileName1: String, fileName2: String): Bool {
    return File.readFrom(fileName1) == File.readFrom(fileName2)
}

@Test
class CompressOutputToDecompressInputTest {
    @TestCase
    func defaultFile(): Unit {
        let fileNames = ["./zlib_test.txt", "./zlib_test2.txt"]
        for (i in 0..fileNames.size) {
            var source = File(fileNames[i], Read)
            var tempBuf: Array<UInt8> = Array<UInt8>(1024, repeat: 0)

            var dest1: ByteBuffer = ByteBuffer()
            var compressOutputStream: CompressOutputStream = CompressOutputStream(dest1)
            while (true) {
                var readNum = source.read(tempBuf)
                if (readNum == 0) {
                    break
                }
                compressOutputStream.write(tempBuf.slice(0, readNum).toArray())
            }
            compressOutputStream.close()
            source.close()

            @Assert(dest1.length != 0)

            var decompressInputStream: DecompressInputStream = DecompressInputStream(dest1)
            var dest2: ByteBuffer = ByteBuffer()
            while (true) {
                var readNum = decompressInputStream.read(tempBuf)
                if (readNum > 0) {
                    dest2.write(tempBuf.slice(0, readNum).toArray())
                } else {
                    break
                }
            }
            decompressInputStream.close()

            @Assert(dest2.length != 0)

            var sourceAllBytes = File.readFrom(fileNames[i])
            var destAllBytes: Array<UInt8> = readToEnd(dest2)
            @Assert(sourceAllBytes == destAllBytes)
        }
    }

    @TestCase
    func Deflate(): Unit {
        let outputBuflen = 1024
        var arr: Array<Byte> = Array<Byte>(1024 * 1024, {i => UInt8(i % 256)})
        File.writeTo("./zlib.txt", arr)

        @Expect(compressFileOutputStream("./zlib.txt", "./zlib_copmressed.zlib", DeflateFormat, outputBuflen) > 0)

        @Expect(decompressFileInputStream("./zlib_copmressed.zlib", "./zlib_decopmressed.txt", DeflateFormat, outputBuflen) == arr.size)

        @Expect(compareFile("./zlib.txt", "./zlib_decopmressed.txt"))

        remove("./zlib.txt")
        remove("./zlib_copmressed.zlib")
        remove("./zlib_decopmressed.txt")
    }

    @TestCase
    func Gzip(): Unit {
        let outputBuflen = 10000
        var arr: Array<Byte> = Array<Byte>(1024 * 1024, {i => UInt8(i % 256)})
        File.writeTo("./zlib.txt", arr)

        @Expect(compressFileOutputStream("./zlib.txt", "./zlib_copmressed.zlib", GzipFormat, outputBuflen) > 0)

        @Expect(decompressFileInputStream("./zlib_copmressed.zlib", "./zlib_decopmressed.txt", GzipFormat, outputBuflen) == arr.size)

        @Expect(compareFile("./zlib.txt", "./zlib_decopmressed.txt"))

        remove("./zlib.txt")
        remove("./zlib_copmressed.zlib")
        remove("./zlib_decopmressed.txt")
    }

    @TestCase
    func closeThreeTimes(): Unit {
        var source = File("./zlib_test.txt", Read)
        var tempBuf: Array<UInt8> = Array<UInt8>(1024, repeat: 0)

        var dest1: ByteBuffer = ByteBuffer()
        var compressOutputStream: CompressOutputStream = CompressOutputStream(dest1, bufLen: 256)
        while (true) {
            var readNum = source.read(tempBuf)
            if (readNum == 0) {
                break
            }
            compressOutputStream.write(tempBuf.slice(0, readNum).toArray())
        }
        compressOutputStream.close()
        source.close()

        // Test repeated close
        for (_ in 0..3) {
            compressOutputStream.close()
        }
        // Test repeated write
        for (_ in 0..3) {
            try {
                compressOutputStream.write(tempBuf)
                @Assert(false)
                break
            } catch (e: ZlibException) {
                continue
            }
        }

        @Assert(dest1.length != 0)

        var decompressInputStream: DecompressInputStream = DecompressInputStream(dest1, bufLen: 256)
        var dest2: ByteBuffer = ByteBuffer()
        while (true) {
            var readNum = decompressInputStream.read(tempBuf)
            if (readNum > 0) {
                dest2.write(tempBuf.slice(0, readNum).toArray())
            } else {
                break
            }
        }
        decompressInputStream.close()

        // Test repeated close
        for (_ in 0..3) {
            decompressInputStream.close()
        }
        // Test repeated write
        for (_ in 0..3) {
            @Assert(decompressInputStream.read(tempBuf) == 0)
        }

        @Assert(dest2.length != 0)

        var sourceAllBytes = File.readFrom("./zlib_test.txt")
        var destAllBytes: Array<UInt8> = readToEnd(dest2)
        @Assert(sourceAllBytes == destAllBytes)
    }

    @TestCase
    func BufLen(): Unit {
        let tempBuflens = [1024, 1024, 1024, 1024]
        let streamBuflens1 = [256, 10000, 256, 10000]
        let streamBuflens2 = [256, 10000, 10000, 256]
        for (i in 0..tempBuflens.size) {
            var source = File("./zlib_test.txt", Read)
            var tempBuf: Array<UInt8> = Array<UInt8>(tempBuflens[i], repeat: 0)

            var dest1: ByteBuffer = ByteBuffer()
            var compressOutputStream: CompressOutputStream = CompressOutputStream(dest1, bufLen: streamBuflens1[i])
            while (true) {
                var readNum = source.read(tempBuf)
                if (readNum == 0) {
                    break
                }
                compressOutputStream.write(tempBuf.slice(0, readNum).toArray())
            }
            compressOutputStream.close()
            source.close()

            @Assert(dest1.length != 0)

            var decompressInputStream: DecompressInputStream = DecompressInputStream(dest1, bufLen: streamBuflens2[i])
            var dest2: ByteBuffer = ByteBuffer()
            while (true) {
                var readNum = decompressInputStream.read(tempBuf)
                if (readNum > 0) {
                    dest2.write(tempBuf.slice(0, readNum).toArray())
                } else {
                    break
                }
            }
            decompressInputStream.close()

            @Assert(dest2.length != 0)

            var sourceAllBytes = File.readFrom("./zlib_test.txt")
            var destAllBytes: Array<UInt8> = readToEnd(dest2)
            @Assert(sourceAllBytes == destAllBytes)
        }
    }

    @TestCase
    func Level(): Unit {
        let levelArr = [BestSpeed, DefaultCompression, BestCompression]
        for (level in levelArr) {
            var source = File("./zlib_test.txt", Read)
            var tempBuf: Array<UInt8> = Array<UInt8>(1024, repeat: 0)

            var dest1: ByteBuffer = ByteBuffer()
            var compressOutputStream: CompressOutputStream = CompressOutputStream(dest1, compressLevel: level)
            while (true) {
                var readNum = source.read(tempBuf)
                if (readNum == 0) {
                    break
                }
                compressOutputStream.write(tempBuf.slice(0, readNum).toArray())
            }
            compressOutputStream.close()
            source.close()

            @Assert(dest1.length != 0)

            var decompressInputStream: DecompressInputStream = DecompressInputStream(dest1, bufLen: 256)
            var dest2: ByteBuffer = ByteBuffer()
            while (true) {
                var readNum = decompressInputStream.read(tempBuf)
                if (readNum > 0) {
                    dest2.write(tempBuf.slice(0, readNum).toArray())
                } else {
                    break
                }
            }
            decompressInputStream.close()

            @Assert(dest2.length != 0)

            var sourceAllBytes = File.readFrom("./zlib_test.txt")
            var destAllBytes: Array<UInt8> = readToEnd(dest2)
            @Assert(sourceAllBytes == destAllBytes)
        }
    }

    @TestCase
    func DecompressInputDataIncomplete(): Unit {
        var source = File("./zlib_test.txt", Read)
        var tempBuf: Array<UInt8> = Array<UInt8>(1024, repeat: 0)

        var dest1: ByteBuffer = ByteBuffer()
        var compressOutputStream: CompressOutputStream = CompressOutputStream(dest1)
        while (true) {
            var readNum = source.read(tempBuf)
            if (readNum == 0) {
                break
            }
            compressOutputStream.write(tempBuf.slice(0, readNum).toArray())
        }
        compressOutputStream.close()
        source.close()

        @Assert(dest1.length != 0)

        var compressedBytes: Array<UInt8> = readToEnd(dest1)
        var incompleteSource: ByteBuffer = ByteBuffer()
        // Incomplete data to be decompressed
        incompleteSource.write(compressedBytes[0..(compressedBytes.size / 2)])

        var decompressInputStream: DecompressInputStream = DecompressInputStream(incompleteSource)
        var dest2: ByteBuffer = ByteBuffer()

        try {
            while (true) {
                var readNum = decompressInputStream.read(tempBuf)
                if (readNum <= 0) {
                    break
                }
                dest2.write(tempBuf.slice(0, readNum).toArray())
            }
        } catch (e: ZlibException) {
            @Assert(e.message, "Unexpected end of compressed data: no progress (Z_BUF_ERROR), decompression is not finished.")
            return
        } finally {
            decompressInputStream.close()
        }
        @Assert(false)
    }
}

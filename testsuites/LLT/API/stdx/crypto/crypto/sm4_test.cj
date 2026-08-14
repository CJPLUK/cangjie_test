/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: ./file
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt  -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import std.fs.*
import std.io.*
import std.runtime.*
import stdx.encoding.hex.fromHexString
import stdx.encoding.hex.toHexString
import stdx.encoding.base64.toBase64String
import stdx.encoding.base64.*
import stdx.crypto.crypto.*
import stdx.crypto.digest.*
import stdx.crypto.common.*

@Test
class Test_sm4 {
    func test_func_sm4_01(cipher: SM4, input: String): Unit {
        let sm4 = cipher
        var enR = sm4.encrypt(input.toArray())
        var re = sm4.decrypt(enR)
        var enRResult = Array<Byte>(input.size + sm4.blockSize * 8, repeat: 0)
        var enRSize = sm4.encrypt(input.toArray(), to: enRResult)
        var reResult = Array<Byte>(input.size, repeat: 0)
        var reSize = sm4.decrypt(enRResult[0..enRSize], to: reResult)
        @Expect(String.fromUtf8(re), input)
        @Expect(String.fromUtf8(reResult[0..reSize]), input)
        @Expect(cipher.algorithm, "SM4")
    }

    func test_func_sm4_02(mode: OperationMode): Unit {
        var key = "1234567890123456"
        var iv = "123456789012345"
        var aad = "Additional authenticated data."
        var num = 0
        if (mode == OperationMode.GCM) {
            iv = ""
        }
        try {
            test_func_sm4_01(SM4(mode, key.toArray(), iv: iv.toArray()), "hello cangjie!")
        } catch (e: CryptoException) {
            num++
            @Expect(e.message, "Invalid IV size: expected '16' bytes, got '15' bytes.")
        }
        @Expect(num, 1)
    }

    func test_func_sm4_03(mode: OperationMode): Unit {
        var key = "1234567890"
        var iv = "1234567890123456"
        var aad = "Additional authenticated data."
        var num = 0
        try {
            test_func_sm4_01(SM4(mode, key.toArray(), iv: iv.toArray()), "hello cangjie!")
        } catch (e: CryptoException) {
            num++
            @Expect(e.message, "Invalid key size: expected '16' bytes, got '10' bytes.")
        }
        @Expect(num, 1)
    }

    func test_func_sm4_04(mode: OperationMode): Unit {
        var key = "1234567890123456"
        var iv = "1234567890123456"
        var aad = "Additional authenticated data."
        var num = 0
        try {
            test_func_sm4_01(SM4(mode, key.toArray(), iv: iv.toArray(), paddingMode: PaddingMode.NoPadding), "1")
        } catch (e: CryptoException) {
            num++
            @Expect(e.message, "Encryption finalization failed.")
        }
        @Expect(num, 1)
    }

    func test_func_sm4_05(cipher: SM4, expect: String): Unit {
        var input = "hello cangjie"
        let sm4 = cipher
        var enR = sm4.encrypt(input.toArray())
        @Expect(toBase64String(enR), expect)
        var re = sm4.decrypt(enR)
        @Expect(String.fromUtf8(re), input)
    }

    func test_func_sm4_06(cipher: SM4): Unit {
        var SM4Dfile = cipher
        var oriFileName = "./file/sm4filetest.txt"
        var encResult = "./file/encresult.txt"
        var deResult = "./file/deresult.txt"

        let file = File(oriFileName, Read)
        if (exists(encResult)) {
            remove(Path(encResult))
        }
        File.create(encResult)
        let fileenc = File(encResult, ReadWrite)
        var outputStream1 = ByteBuffer()
        SM4Dfile.encrypt(file, outputStream1)
        fileenc.write(readToEnd(outputStream1))
        file.close()
        fileenc.close()
        let file2 = File(encResult, Read)
        if (exists(deResult)) {
            remove(Path(deResult))
        }
        File.create(deResult)

        let filede = File(deResult, ReadWrite)
        var outputStream2 = ByteBuffer()
        SM4Dfile.decrypt(file2, outputStream2)
        filede.write(readToEnd(outputStream2))
        file2.close()
        filede.close()

        let fileOr = File(oriFileName, Read)
        var input = String.fromUtf8(readToEnd(fileOr))
        fileOr.close()
        let fileNew = File(deResult, Read)
        var expect = String.fromUtf8(readToEnd(fileNew))
        fileNew.close()
        @Expect(input, expect)
    }

    func test_func_sm4_07(cipher: SM4, path: String): Unit {
        var deFileName = "./file/result.txt"
        var SM4Dfile = cipher

        let file = File(path, Read)
        var outputStream = ByteBuffer()
        SM4Dfile.decrypt(file, outputStream)

        if (exists(deFileName)) {
            remove(Path(deFileName))
        }
        File.create(deFileName)
        let filede = File(deFileName, OpenMode.Append)
        var out = readToEnd(outputStream)
        filede.write(out)
        filede.close()
    }

    @TestCase
    func test_OperationModeAndPaddingMode(): Unit {
        @Expect(OperationMode.ECB != OperationMode.GCM)
        @Expect(PaddingMode.PKCS7Padding != PaddingMode.NoPadding)
        @Expect(PaddingMode.PKCS7Padding == PaddingMode.PKCS7Padding)
    }

    @TestCase
    func test_tagSize(): Unit {
        var key = "1234567890123456"
        var iv = "1234567890123456"
        var aad = "Additional authenticated data."
        var num = 0
        try {
            SM4(OperationMode.GCM, key.toArray(), tagSize: 10, iv: iv.toArray())
        } catch (e: CryptoException) {
            num++
            @Expect(e.message, "Invalid tag size: must be between '12' and '16', got '10'.")
        }
        @Expect(num, 1)
    }

    @TestCase
    func test_sm4_gc(): Unit {
        var key = "1234567890123456"
        var iv = "1234567890123456"
        var aad = "Additional authenticated data."
        var num = 0
        var sm4 = SM4(OperationMode.ECB, key.toArray(), iv: iv.toArray())
        @Expect(sm4.keySize == key.size)
        @Expect(sm4.ivSize == iv.size)
    }

    @TestCase
    func test_sm4_01(): Unit {
        var key = "1234567890123456"
        var iv = "1234567890123456"
        var aad = "Additional authenticated data."
        test_func_sm4_01(SM4(OperationMode.ECB, key.toArray()), "")
        test_func_sm4_01(SM4(OperationMode.ECB, key.toArray()), "hello cangjie!")
        test_func_sm4_01(SM4(OperationMode.CBC, key.toArray(), iv: iv.toArray()), "")
        test_func_sm4_01(SM4(OperationMode.CBC, key.toArray(), iv: iv.toArray()), "hello cangjie!")
        test_func_sm4_01(SM4(OperationMode.OFB, key.toArray(), iv: iv.toArray()), "")
        test_func_sm4_01(SM4(OperationMode.OFB, key.toArray(), iv: iv.toArray()), "hello cangjie!")
        test_func_sm4_01(SM4(OperationMode.CFB, key.toArray(), iv: iv.toArray()), "")
        test_func_sm4_01(SM4(OperationMode.CFB, key.toArray(), iv: iv.toArray()), "hello cangjie!")

        test_func_sm4_01(SM4(OperationMode.CTR, key.toArray(), iv: iv.toArray()), "")
        test_func_sm4_01(SM4(OperationMode.CTR, key.toArray(), iv: iv.toArray()), "hello cangjie!")
    }

    @TestCase
    func test_sm4_02(): Unit {
        test_func_sm4_02(OperationMode.CBC)
        test_func_sm4_02(OperationMode.OFB)
        test_func_sm4_02(OperationMode.CFB)
        test_func_sm4_02(OperationMode.CTR)
    }

    @TestCase
    func test_sm4_03(): Unit {
        test_func_sm4_03(OperationMode.CBC)
        test_func_sm4_03(OperationMode.OFB)
        test_func_sm4_03(OperationMode.CFB)
        test_func_sm4_03(OperationMode.CTR)
    }

    @TestCase
    func test_sm4_04(): Unit {
        test_func_sm4_04(OperationMode.ECB)
        test_func_sm4_04(OperationMode.CBC)
    }

    @TestCase
    func test_sm4_05(): Unit {
        var key = "1234567890123456"
        var iv = "1234567890123456"
        test_func_sm4_05(SM4(OperationMode.ECB, key.toArray()), "ulPFPP+KUkrgIl9XXLuAfw==")
        test_func_sm4_05(SM4(OperationMode.CBC, key.toArray(), iv: iv.toArray()), "+CbgU1qi3WiLAlkL9N41YA==")
        test_func_sm4_05(SM4(OperationMode.OFB, key.toArray(), iv: iv.toArray()), "2OawrMbWKLiUhZDl9g==")
        test_func_sm4_05(SM4(OperationMode.CFB, key.toArray(), iv: iv.toArray()), "2OawrMbWKLiUhZDl9g==")
        test_func_sm4_05(SM4(OperationMode.CTR, key.toArray(), iv: iv.toArray()), "2OawrMbWKLiUhZDl9g==")
    }

    @TestCase
    func test_sm4_06(): Unit {
        var key = "1234567890123456"
        var iv = "1234567890123456"
        test_func_sm4_06(SM4(OperationMode.ECB, key.toArray()))
        test_func_sm4_06(SM4(OperationMode.CBC, key.toArray(), iv: iv.toArray()))
        test_func_sm4_06(SM4(OperationMode.OFB, key.toArray(), iv: iv.toArray()))
        test_func_sm4_06(SM4(OperationMode.CFB, key.toArray(), iv: iv.toArray()))
        test_func_sm4_06(SM4(OperationMode.CTR, key.toArray(), iv: iv.toArray()))
    }

    @TestCase
    func test_sm4_07(): Unit {
        var key = "1234567890123456"
        var iv = "1234567890123456"
        test_func_sm4_07(SM4(OperationMode.ECB, key.toArray()), "./file/ecbTest.txt")
        test_func_sm4_07(SM4(OperationMode.CBC, key.toArray(), iv: iv.toArray()), "./file/cbcTest.txt")
        test_func_sm4_07(SM4(OperationMode.OFB, key.toArray(), iv: iv.toArray()), "./file/ofbTest.txt")
        test_func_sm4_07(SM4(OperationMode.CFB, key.toArray(), iv: iv.toArray()), "./file/cfbTest.txt")
        test_func_sm4_07(SM4(OperationMode.CTR, key.toArray(), iv: iv.toArray()), "./file/ctrTest.txt")
    }

    @TestCase
    func test_sm4_gcm_roundtrip(): Unit {
        var key = "1234567890123456"
        var iv = "1234567890123456"
        var aad = "Additional authenticated data."
        var plain = "hello cangjie! SM4-GCM roundtrip"
        // GCM output layout: ciphertext || tag
        var sm4 = SM4(OperationMode.GCM, key.toArray(), iv: iv.toArray(), aad: aad.toArray())
        var enR = sm4.encrypt(plain.toArray())
        @Expect(enR.size, plain.size + sm4.tagSize)
        var re = sm4.decrypt(enR)
        @Expect(String.fromUtf8(re), plain)

        // Tamper with the last tag byte: decryption must fail.
        var tampered = enR.clone()
        if (tampered[tampered.size - 1] == 0) {
            tampered[tampered.size - 1] = 1
        } else {
            tampered[tampered.size - 1] = 0
        }
        var num = 0
        try {
            sm4.decrypt(tampered)
        } catch (e: CryptoException) {
            num++
        }
        @Expect(num, 1)

        // Wrong AAD must fail tag verification.
        var numAad = 0
        var sm4WrongAad = SM4(OperationMode.GCM, key.toArray(), iv: iv.toArray(),
            aad: "wrong aad data".toArray())
        try {
            sm4WrongAad.decrypt(enR)
        } catch (e: CryptoException) {
            numAad++
        }
        @Expect(numAad, 1)
    }

    @TestCase
    func test_sm4_gcm_tag_sizes(): Unit {
        var key = "1234567890123456"
        var iv = "1234567890123456"
        var aad = "Additional authenticated data."

        // non-default tag size (12 bytes)
        var plain12 = "hello cangjie!"
        var sm4_12 = SM4(OperationMode.GCM, key.toArray(), iv: iv.toArray(), aad: aad.toArray(), tagSize: 12)
        var enR12 = sm4_12.encrypt(plain12.toArray())
        @Expect(enR12.size, plain12.size + 12)
        @Expect(String.fromUtf8(sm4_12.decrypt(enR12)), plain12)

        // empty payload with AAD
        var sm4Empty = SM4(OperationMode.GCM, key.toArray(), iv: iv.toArray(), aad: aad.toArray())
        var enREmpty = sm4Empty.encrypt(Array<Byte>())
        @Expect(enREmpty.size, sm4Empty.tagSize)
        @Expect(sm4Empty.decrypt(enREmpty).size, 0)

        // payload without AAD
        var plainNoAad = "payload without aad"
        var sm4NoAad = SM4(OperationMode.GCM, key.toArray(), iv: iv.toArray())
        var enRNoAad = sm4NoAad.encrypt(plainNoAad.toArray())
        @Expect(String.fromUtf8(sm4NoAad.decrypt(enRNoAad)), plainNoAad)
    }

    @TestCase
    func test_sm4_gcm_large_payload(): Unit {
        var key = "1234567890123456"
        var iv = "1234567890123456"
        var aad = "Additional authenticated data."
        // payload larger than the internal 1024-byte buffer
        var large = Array<Byte>(3000, {i => UInt8(i % 256)})
        var sm4 = SM4(OperationMode.GCM, key.toArray(), iv: iv.toArray(), aad: aad.toArray())
        var enR = sm4.encrypt(large)
        @Expect(enR.size, large.size + sm4.tagSize)
        var re = sm4.decrypt(enR)
        @Expect(re.size, large.size)
        for (i in 0..large.size) {
            @Expect(re[i], large[i])
        }
    }
}

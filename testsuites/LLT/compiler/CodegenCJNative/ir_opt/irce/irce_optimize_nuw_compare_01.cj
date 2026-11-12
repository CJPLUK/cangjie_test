// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// IRCE optimizeNUWCompare: shared icmp ult (add nuw) between two branches
// in the same loop should not be erased while still used.
// https://gitcode.com/Cangjie/cangjie_compiler/issues/1277

// EXEC: %compiler %cmp_opt -O2 --int-overflow wrapping %n.cj -o %n.%suffix
// EXEC-PIPE: %run %run_opt %n.%suffix

func f(input: UInt64, byte_n: Int64): Int64 {
    var effectiveByteN: Int64 = 8
    if (byte_n == 64) {
        effectiveByteN = 64
    } else if (byte_n == 32) {
        effectiveByteN = 32
    } else if (byte_n == 16) {
        effectiveByteN = 16
    } else if (byte_n == 8) {
        effectiveByteN = 8
    }

    var value: UInt64 = input
    value = value & 0xffu64

    let poly: Array<Int64> = [1, 1, 0, 0, 1]
    let polyN: Int64 = poly.size
    let bufferIndex: Int64 = effectiveByteN
    var buffer: Array<Int64> = Array<Int64>(effectiveByteN, { i => 0 })
    var byteArray: Array<Int64> = Array<Int64>(effectiveByteN, { i => 0 })

    var byteC: Int64 = 1
    var byteIndex: Int64 = 0
    while (value != 0) {
        if (value % 2 == 1) {
            byteIndex = effectiveByteN - byteC
            if (byteIndex >= 0 && byteIndex < effectiveByteN) {
                byteArray[byteIndex] = 1
            }
        }
        byteC++
        value = value >> 1
    }

    var i: Int64 = 0
    while (i + byteIndex < effectiveByteN) {
        if (i + byteIndex >= 0 && i + byteIndex < effectiveByteN) {
            buffer[i] = byteArray[i + byteIndex]
        }
        i++
    }

    let crcOutputN: Int64 = bufferIndex + polyN - 1
    var crcBuffer: Array<Int64> = Array<Int64>(crcOutputN, { i => 0 })
    i = 0
    while (i < bufferIndex) {
        crcBuffer[i] = buffer[i]
        i++
    }

    i = 0
    while (i < bufferIndex) {
        if (crcBuffer[i] == 1) {
            var j: Int64 = 0
            while (j < polyN) {
                crcBuffer[j + i] = crcBuffer[j + i] ^ poly[j]
                j++
            }
        }
        i++
    }

    let byteAdd: Int64 = 3 - crcOutputN % 3
    let outputN: Int64 = byteAdd + crcOutputN
    var crcOutput: Array<Int64> = Array<Int64>(outputN, { i => 0 })

    i = 0
    while (i < outputN - byteAdd) {
        if (i < bufferIndex) {
            crcOutput[i + byteAdd] = buffer[i]
        } else {
            crcOutput[i + byteAdd] = crcBuffer[i]
        }
        i++
    }

    var result: Int64 = 0
    i = 0
    while (i + 2 < outputN) {
        let hexValue: Int64 = 4 * crcOutput[i] + 2 * crcOutput[i + 1] + crcOutput[i + 2]
        result = result * 256 + hexValue
        i = i + 3
    }

    return result
}

main() {
    let r = f(144115188075855872, 27)
    if (r == 0) {
        println("0")
    } else {
        println("unexpected result: ${r}")
        return 1
    }
    return 0
}

// ASSERT: regex-not core dumped
// ASSERT: regex-not stack trace

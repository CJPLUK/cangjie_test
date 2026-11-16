/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkBytes(actual: Array<UInt8> @local?, expected: Array<UInt8>, label: String): Unit {
    check(actual.size == expected.size, label)
    for (i in 0..expected.size) { check(actual[i] == expected[i], label) }
}

func checkOwnedUtf8Source(): Unit {
    let source: Array<UInt8> @local! = [0x41, 0xC2, 0xA2]
    let text: String @local! = String.fromUtf8(source)
    source[0] = 0x5A
    source[2] = 0xA3
    check(text == "A¢" && text.size == 3, "owned UTF-8 source must be copied")
    checkBytes(source, [0x5A, 0xC2, 0xA3], "owned source mutation must execute")
}

func checkSharedUtf8Sources(): Unit {
    let backing: Array<UInt8> @local! = [0x21, 0x41, 0xC2, 0xA2, 0x3F]
    let source: Array<UInt8> @local? = backing.slice(1, 3)
    let text: String @local! = String.fromUtf8(source)
    backing[1] = 0x5A
    backing[3] = 0xA3
    check(text == "A¢" && text.size == 3, "shared local UTF-8 slice must be copied")
    check(backing[0] == 0x21 && backing[4] == 0x3F, "local slice sentinels")
    checkBytes(source, [0x5A, 0xC2, 0xA3], "shared local source mutation must execute")

    let heapBacking: Array<UInt8> = [0x21, 0x41, 0xC2, 0xA2, 0x3F]
    let heapSource: Array<UInt8> @local? = heapBacking.slice(1, 3)
    let heapCopy: String @local! = String.fromUtf8(heapSource)
    heapBacking[1] = 0x59
    heapBacking[3] = 0xA3
    check(heapCopy == "A¢" && heapCopy.size == 3, "shared heap UTF-8 slice must be copied")
    check(heapBacking[0] == 0x21 && heapBacking[4] == 0x3F, "heap slice sentinels")
    checkBytes(heapSource, [0x59, 0xC2, 0xA3], "shared heap source mutation must execute")
}

func checkStringArrayCopies(): Unit {
    let backing: String @local! = "!A¢仓😀?"
    let text: String @local! = backing[1..11]
    let owned: Array<Byte> @local! = text.toArray()
    let sharedText: String @local? = text
    let shared: Array<Byte> @local? = sharedText.toArray()
    let expected = [0x41u8, 0xC2u8, 0xA2u8, 0xE4u8, 0xBBu8,
        0x93u8, 0xF0u8, 0x9Fu8, 0x98u8, 0x80u8]
    checkBytes(owned, expected, "owned byte copy must honor the String offset")
    checkBytes(shared, expected, "shared byte copy must honor the String offset")
    owned[0] = 0x5A
    owned[9] = 0
    shared[0] = 0x59
    shared[9] = 0x21
    check(owned[0] == 0x5A && owned[9] == 0, "owned copy mutation must execute")
    check(shared[0] == 0x59 && shared[9] == 0x21, "shared copy mutation must execute")
    check(text == "A¢仓😀" && sharedText == "A¢仓😀", "byte copies must not mutate the String")
    check(backing == "!A¢仓😀?", "byte copies must not mutate the String backing")
}

func checkEmptyCopies(): Unit {
    let ownedBytes: Array<UInt8> @local! = []
    let owned: String @local! = String.fromUtf8(ownedBytes)
    let heapBytes: Array<UInt8> = []
    let sharedBytes: Array<UInt8> @local? = heapBytes
    let sharedCopy: String @local! = String.fromUtf8(sharedBytes)
    check(owned == "" && sharedCopy == "", "empty UTF-8 copies")
    let view: String @local? = owned
    let ownedArray: Array<Byte> @local! = owned.toArray()
    let sharedArray: Array<Byte> @local? = view.toArray()
    check(ownedArray.size == 0 && sharedArray.size == 0, "empty String byte copies")
}

main(): Int64 {
    checkOwnedUtf8Source()
    checkSharedUtf8Sources()
    checkStringArrayCopies()
    checkEmptyCopies()
    println("ALL PASSED")
    0
}

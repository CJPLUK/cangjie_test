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

class OriginalCollection <: Collection<Int64> {
    exclave init(this @local!) {}
    public prop size: Int64 { get() { 0 } }
    public func isEmpty(): Bool { true }
    public func iterator(): Iterator<Int64> { Array<Int64>().iterator() }
}

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkTexts(actual: Array<String> @local?, expected: Array<String>): Unit {
    check(actual.size == expected.size, "interface array copy size")
    for (i in 0..expected.size) { check(actual[i] == expected[i], "interface array copy payload") }
}

func checkArrayConformer(): Unit {
    let source: Array<String> @local! = ["a", "仓"]
    let owned: Collection<String> @local! = source
    let shared: Collection<String> @local? = source
    let ownedCopy: Array<String> @local! = owned.toArray()
    let sharedCopy: Array<String> @local? = shared.toArray()
    checkTexts(ownedCopy, ["a", "仓"])
    checkTexts(sharedCopy, ["a", "仓"])
    source[0] = "changed"
    ownedCopy[1] = "copy"
    checkTexts(source, ["changed", "仓"])
    checkTexts(ownedCopy, ["a", "copy"])
    checkTexts(sharedCopy, ["a", "仓"])

    let empty: Array<String> @local! = []
    let emptyOwned: Collection<String> @local! = empty
    let emptyShared: Collection<String> @local? = empty
    let first: Array<String> @local! = emptyOwned.toArray()
    let second: Array<String> @local? = emptyShared.toArray()
    check(first.size == 0 && second.size == 0, "empty array interface copies")
}

func checkStringConformer(): Unit {
    let source: String @local! = "A¢"
    let owned: Collection<Byte> @local! = source
    let shared: Collection<Byte> @local? = source
    let ownedCopy: Array<Byte> @local! = owned.toArray()
    let sharedCopy: Array<Byte> @local? = shared.toArray()
    let expected: Array<Byte> = [0x41, 0xC2, 0xA2]
    check(ownedCopy.size == 3 && sharedCopy.size == 3, "String interface byte counts")
    for (i in 0..3) {
        check(ownedCopy[i] == expected[i] && sharedCopy[i] == expected[i], "String interface byte payload")
    }
    ownedCopy[0] = 0x42
    sharedCopy[0] = 0x43
    check(source == "A¢" && ownedCopy[0] == 0x42 && sharedCopy[0] == 0x43,
        "String interface copies have independent storage")

    let empty: String @local! = ""
    let emptyOwned: Collection<Byte> @local! = empty
    let emptyShared: Collection<Byte> @local? = empty
    let first: Array<Byte> @local! = emptyOwned.toArray()
    let second: Array<Byte> @local? = emptyShared.toArray()
    check(first.size == 0 && second.size == 0, "empty String interface copies")
}

func checkDefaultMethods(): Unit {
    let owned: Collection<Int64> @local! = OriginalCollection() @local!
    let shared: Collection<Int64> @local? = owned
    var caught = false
    try { let _: Array<Int64> @local! = owned.toArray() }
    catch (_: UnimplementedException) { caught = true }
    check(caught, "owned Collection default must throw its documented exception")
    caught = false
    try { let _: Array<Int64> @local? = shared.toArray() }
    catch (_: UnimplementedException) { caught = true }
    check(caught, "shared Collection default must throw its documented exception")
}

main(): Int64 {
    checkArrayConformer()
    checkStringConformer()
    checkDefaultMethods()
    println("ALL PASSED")
    0
}

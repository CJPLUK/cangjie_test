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

class Calls {
    var count: Int64 = 0
}

func check(value: Bool, label: String): Unit {
    if (!value) { throw Exception(label) }
}

func checkFactories(): Unit {
    let calls = Calls()
    let some: Option<Int64> @local! = Some(7)
    let result = some.getOrThrow({ => calls.count++; ArithmeticException("unused") })
    check(result == 7 && calls.count == 0, "Some must not evaluate the exception factory")
    let none: Option<Int64> @local! = None
    var caught = false
    try { let _ = none.getOrThrow({ => calls.count++; ArithmeticException("sentinel") }) }
    catch (e: ArithmeticException) { caught = e.message == "sentinel" }
    check(caught && calls.count == 1, "None must evaluate the factory once")
    caught = false
    try { let _ = none.getOrThrow({ => calls.count++; throw IllegalStateException("factory") }) }
    catch (e: IllegalStateException) { caught = e.message == "factory" }
    check(caught && calls.count == 2, "factory exceptions must propagate once")
}

func checkHashes(): Unit {
    let none: Option<Int64> @local? = None
    let some: Option<Int64> @local? = Some(7)
    check(none.hashCode() == 0 && some.hashCode() == 7.hashCode(), "Option hash branches")
    let positive: Float64 @local? = 0.0
    let negative: Float64 @local? = -0.0
    check(positive == negative && positive.hashCode() == negative.hashCode(), "signed zero hash equality")
}

func checkStringOptionHash(value: Option<String> @local?, expected: Int64): Unit {
    check(value.hashCode() == expected, "concrete Option<String> hash")
    let hashable: Hashable @local? = value
    check(hashable.hashCode() == expected, "interface Option<String> hash")
}

func checkReferenceHashes(): Unit {
    let heapText = String([r'A', r'¢', r'仓', r'😀'])
    let expected: Int64 = heapText.hashCode()
    let heapSome: Option<String> = Some(heapText)
    let heapNone: Option<String> = None
    let heapSomeView: Option<String> @local? = heapSome
    let heapNoneView: Option<String> @local? = heapNone
    checkStringOptionHash(heapSomeView, expected)
    checkStringOptionHash(heapNoneView, 0)

    let localText: String @local! = "A¢仓😀"
    let localSome: Option<String> @local! = Some(localText) @local!
    let localNone: Option<String> @local! = None
    let localSomeView: Option<String> @local? = localSome
    let localNoneView: Option<String> @local? = localNone
    checkStringOptionHash(localSomeView, expected)
    checkStringOptionHash(localNoneView, 0)

    let emptyText: String = ""
    let empty: Option<String> @local? = Some(emptyText)
    checkStringOptionHash(empty, emptyText.hashCode())
}

main(): Int64 {
    checkFactories()
    checkHashes()
    checkReferenceHashes()
    println("ALL PASSED")
    0
}

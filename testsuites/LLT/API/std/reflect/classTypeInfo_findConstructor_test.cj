/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %run %run_opt %output %run_utest_opt %run_args 2>&1

/*
 * Test description:
 *      Test class ClassTypeInfo
 *          Test whether parse signature is correct.
 * Test API:
 *      public func getConstructor(signature: String): Option<ConstructorInfo>
 */

import std.reflect.*

@Test
class parseSignatureTest {
    @TestCase
    func signatureAccuracyTest(): Unit {
        let classInfo = Foo() |> TypeInfo.of

        classInfo.getConstructor(parseParameterTypes(""))
        classInfo.getConstructor(parseParameterTypes(" "))

        try {
            classInfo.getConstructor(parseParameterTypes(",,,Int64, String, default.Bar"))
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.contains("Invalid value for 'parameterTypes': does not comply with the specifications"))
        }

        try {
            println(parseParameterTypes("Int64, String, Int64, default.Bar"))
            classInfo.getConstructor(parseParameterTypes("Int64, String, Int64, default.Bar"))
        } catch (e: InfoNotFoundException) {
            println(e.message)
            @Expect(e.message.contains("Cannot find the specified constructor"))
        }

        try {
            classInfo.getConstructor(parseParameterTypes("XXXX"))
        } catch (e: InfoNotFoundException) {
            println(e.message)
            @Expect(e.message.contains("TypeInfo 'XXXX' not found"))
        }
    }
}

public class Foo {
    var _a: Int64 = 0
    var _b: String = ""
    var _c: Bar = Bar(1)
    public init() {}

    public init(a: Int64, b: String, c: Bar) {
        _a = a
        _b = b
        _c = c
    }
}

public class Bar {
    var parm: Int64
    public Bar(v: Int64) {
        parm = v
    }
}

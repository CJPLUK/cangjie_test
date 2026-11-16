/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * - @TestCaseID: TC-2
 * - @TestCaseName: std.reflect — FunctionTypeInfo — SingleParamFunction
 * - @TestCaseType: 功能测试
 * - @Design Description: 基于反射API等价类划分方法，验证(Int64) -> Int64 function type
 * - @Condition: 用例的预置条件
 *   -#仓颉工具链环境已正确安装
 *   -#被测类型的源文件已编译为动态库
 * - @Brief: 描述测试步骤
 *   -#获取TypeInfo引用（byName/byInstance/byTypeArg）
 *   -#通过TypeInfo查询被测类型的成员信息
 *   -#构造实例并读写成员变量/属性
 *   -#调用成员函数并验证返回值
 * - @Expect: 用例的预期结果
 *   -#所有@Expect断言通过，反射API返回值与预期一致
 * - @Priority: P0
 */

// LEVEL: 3
// Description:
// DEPENDENCE: ../utils upstream
// (!target_ohos) EXEC: %compiler %cmp_opt %compile_lib_opt -p utils
// (!target_ohos) EXEC: %compiler %cmp_opt %compile_lib_opt -p upstream
// (!target_ohos) EXEC: %compiler %cmp_opt %f -L . -lutils -lupstream -o %output %cmp_utest_opt
// (!target_ohos) RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import utils.*
import upstream.*
import std.reflect.*

@Test
class TestFunction {
    @TestCase
    func testCase0(): Unit {
        @Expect(FunctionTypeInfo.of({p0: Int64 =>1i64
        }).parameters.size, 1i64)
        @Expect(FunctionTypeInfo.of({p0: Int64 =>1i64
        }).parameters.get(0i64).getOrThrow().name, "Int64")
        @Expect(FunctionTypeInfo.of({p0: Int64 =>1i64
        }).returnType.name, "Int64")
        @Expect[annotations](FunctionTypeInfo.of({p0: Int64 =>1i64
        }).annotations, [])
        @Expect(FunctionTypeInfo.of({p0: Int64 =>1i64
        }).modifiers.toArray().size >= 0i64)
        @Expect(FunctionTypeInfo.of({p0: Int64 =>1i64
        }).superInterfaces.toArray().size >= 0i64)
        @Expect(FunctionTypeInfo.of({p0: Int64 =>1i64
        }).hashCode() == FunctionTypeInfo.of({p0: Int64 =>1i64
        }).hashCode())
        @Expect(FunctionTypeInfo.of({p0: Int64 =>1i64
        }).toString() != "")
        @Expect[anyValue](FunctionTypeInfo.of({p0: Int64 =>1i64
        }).apply({p0: Int64 =>1i64
        }, [1i64]), FunctionTypeInfo.of({p0: Int64 =>1i64
        }).apply({p0: Int64 =>1i64
        }, [1i64]))
        @ExpectThrows[IllegalTypeException](FunctionTypeInfo.of(0i64))
    }
}

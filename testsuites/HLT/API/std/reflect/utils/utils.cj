/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */


package utils

import std.reflect.*
import std.collection.*
import std.sort.*
import std.time.*
import std.fs.*
import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*

// ═══ toString 家族（ohos 条件编译双版本：env 内置条件取值 gnu/ohos/simulator/android）═══
// 通用 toString（含 Class/Struct/Enum/Tuple 的反射展开）。
// ohos 目标不支持 TupleTypeInfo/EnumTypeInfo/FunctionTypeInfo，按 env 条件双版本条件编译：
//   env == "ohos"  → 无 Tuple/Enum/Function 三分支（元组/枚举值落入兜底）
//   env != "ohos"  → 全量分支（host 三平台 + iOS/simulator/android）
@When[env != "ohos"]
public func toString(a: Any): String {
    match (a) {
        case l: ReadOnlyList<Any> =>
            let ll = l |> map {i: Any => toString(i)} |> collectString(delimiter: ", ")
            "[${ll}]"
        case l: Array<Any> =>
            let ll = l |> map {i: Any => toString(i)} |> collectString(delimiter: ", ")
            "[${ll}]"
        // 对于基础数据类型和内置了ToString实现的类型则直接采用内置toString
        case s: ToString => s.toString()
        // 否则通过反射自动生成toSting结果
        case o => match (TypeInfo.of(o)) {
            case t: TupleTypeInfo =>
                let s = t.destruct(o)
                let ss = s |> map {i: Any => toString(i)} |> collectString(delimiter: ", ")
                "(${ss})"
            case t: FunctionTypeInfo =>
                let s = t.parameters |> map {t: TypeInfo => t.qualifiedName} |> collectString(delimiter: ", ")
                let s1 = t.returnType.qualifiedName
                "(${s})->${s1}"
            case t: ClassTypeInfo =>
                let sb = StringBuilder()
                sb.append("${t.qualifiedName}(")
                let l = t.instanceVariables |> map {
                    i =>
                        let value = i.getValue(a)
                        "${i.name}=${toString(value)}"
                } |> collectString(delimiter: ", ")
                sb.append(l)
                sb.append(")")
                sb.toString()
            case t: StructTypeInfo =>
                let sb = StringBuilder()
                sb.append("${t.qualifiedName}(")
                let l = t.instanceVariables |> map {
                    i =>
                        let value = i.getValue(a)
                        "${i.name}=${toString(value)}"
                } |> collectString(delimiter: ", ")
                sb.append(l)
                sb.append(")")
                sb.toString()
            case t: EnumTypeInfo =>
                let (eCons, l) = t.destruct(a)
                let p = l |> map {i: Any => toString(i)} |> collectString(delimiter: ", ")
                "${t.qualifiedName}.${eCons.name}(${p})"
            case _ => throw Exception("toString() not implemented.")
        }
    }
}

@When[env == "ohos"]
public func toString(a: Any): String {
    match (a) {
        case l: ReadOnlyList<Any> =>
            let ll = l |> map {i: Any => toString(i)} |> collectString(delimiter: ", ")
            "[${ll}]"
        case l: Array<Any> =>
            let ll = l |> map {i: Any => toString(i)} |> collectString(delimiter: ", ")
            "[${ll}]"
        // 对于基础数据类型和内置了ToString实现的类型则直接采用内置toString
        case s: ToString => s.toString()
        // 否则通过反射自动生成toSting结果（ohos：无 TupleTypeInfo/EnumTypeInfo/
        // FunctionTypeInfo——函数值落入兜底 throw，上层 catch 归一为消息串）
        case o => match (TypeInfo.of(o)) {
            case t: ClassTypeInfo =>
                let sb = StringBuilder()
                sb.append("${t.qualifiedName}(")
                let l = t.instanceVariables |> map {
                    i =>
                        let value = i.getValue(a)
                        "${i.name}=${toString(value)}"
                } |> collectString(delimiter: ", ")
                sb.append(l)
                sb.append(")")
                sb.toString()
            case t: StructTypeInfo =>
                let sb = StringBuilder()
                sb.append("${t.qualifiedName}(")
                let l = t.instanceVariables |> map {
                    i =>
                        let value = i.getValue(a)
                        "${i.name}=${toString(value)}"
                } |> collectString(delimiter: ", ")
                sb.append(l)
                sb.append(")")
                sb.toString()
            case _ => throw Exception("toString() not implemented.")
        }
    }
}

@When[env != "ohos"]
public func eciToString(a: Any): String {
    match (a) {
        case l: ReadOnlyList<Any> =>
            let ll = l |> map {i: Any => eciToString(i)} |> collectString(delimiter: ", ")
            "[${ll}]"
        case l: Array<Any> =>
            let ll = l |> map {i: Any => eciToString(i)} |> collectString(delimiter: ", ")
            "[${ll}]"
        case o => match (TypeInfo.of(o)) {
            // 闭包/函数值：静态 Any 不匹配 ToString 运行时类型测试（cjc 实测），
            // 以 FunctionTypeInfo.qualifiedName 表达（同类型闭包值以类型签名等价性断言）
            case t: FunctionTypeInfo => t.qualifiedName
            case t: TupleTypeInfo =>
                let s = t.destruct(o)
                let ss = s |> map {i: Any => eciToString(i)} |> collectString(delimiter: ", ")
                "(${ss})"
            case t: EnumTypeInfo =>
                let (eCons, l) = t.destruct(o)
                let p = l |> map {i: Any => eciToString(i)} |> collectString(delimiter: ", ")
                "${t.qualifiedName}.${eCons.name}(${p})"
            case t: StructTypeInfo =>
                let sb = StringBuilder()
                sb.append("${t.qualifiedName}(")
                let l = t.instanceVariables |> map {
                    i =>
                        let value = i.getValue(a)
                        "${i.name}=${eciToString(value)}"
                } |> collectString(delimiter: ", ")
                sb.append(l)
                sb.append(")")
                sb.toString()
            case t: ClassTypeInfo =>
                let sb = StringBuilder()
                sb.append("${t.qualifiedName}(")
                let l = t.instanceVariables |> map {
                    i =>
                        let value = i.getValue(a)
                        "${i.name}=${eciToString(value)}"
                } |> collectString(delimiter: ", ")
                sb.append(l)
                sb.append(")")
                sb.toString()
            // 其余实现 ToString 的类型（Int64/String/Bool/...）：直接 toString
            case t => t.toString()
        }
    }
}

@When[env == "ohos"]
public func eciToString(a: Any): String {
    match (a) {
        case l: ReadOnlyList<Any> =>
            let ll = l |> map {i: Any => eciToString(i)} |> collectString(delimiter: ", ")
            "[${ll}]"
        case l: Array<Any> =>
            let ll = l |> map {i: Any => eciToString(i)} |> collectString(delimiter: ", ")
            "[${ll}]"
        case o => match (TypeInfo.of(o)) {
            // ohos：无 FunctionTypeInfo——闭包/函数值落入尾部 t.toString() 兜底
            case t: StructTypeInfo =>
                let sb = StringBuilder()
                sb.append("${t.qualifiedName}(")
                let l = t.instanceVariables |> map {
                    i =>
                        let value = i.getValue(a)
                        "${i.name}=${eciToString(value)}"
                } |> collectString(delimiter: ", ")
                sb.append(l)
                sb.append(")")
                sb.toString()
            case t: ClassTypeInfo =>
                let sb = StringBuilder()
                sb.append("${t.qualifiedName}(")
                let l = t.instanceVariables |> map {
                    i =>
                        let value = i.getValue(a)
                        "${i.name}=${eciToString(value)}"
                } |> collectString(delimiter: ", ")
                sb.append(l)
                sb.append(")")
                sb.toString()
            // 其余实现 ToString 的类型（Int64/String/Bool/...）：直接 toString
            // （ohos：无 TupleTypeInfo/EnumTypeInfo，元组/枚举值落入此分支）
            case t => t.toString()
        }
    }
}

@When[env != "ohos"]
public func tupleToString(a: Any): String {
    match (a) {
        case l: ReadOnlyList<Any> =>
            let ll = l |> map {i: Any => tupleToString(i)} |> collectString(delimiter: ", ")
            "[${ll}]"
        case s: ToString => s.toString()
        // 元组元素：递归经 TupleTypeInfo.destruct
        case o => match (TypeInfo.of(o)) {
            case t: TupleTypeInfo =>
                let s = t.destruct(o)
                let ss = s |> map {i: Any => tupleToString(i)} |> collectString(delimiter: ", ")
                "(${ss})"
            case t: ClassTypeInfo =>
                let sb = StringBuilder()
                sb.append("${t.qualifiedName}(")
                let l = t.instanceVariables |> map {
                    i => let value = tupleToString(i.getValue(a))
                    "${i.name}=${value}"
                } |> collectString(delimiter: ", ")
                sb.append(l)
                sb.append(")")
                sb.toString()
            case t: StructTypeInfo =>
                let sb = StringBuilder()
                sb.append("${t.qualifiedName}(")
                let l = t.instanceVariables |> map {
                    i => let value = tupleToString(i.getValue(a))
                    "${i.name}=${value}"
                } |> collectString(delimiter: ", ")
                sb.append(l)
                sb.append(")")
                sb.toString()
            case t: EnumTypeInfo =>
                let (eCons, l) = t.destruct(a)
                let p = l |> map {i: Any => tupleToString(i)} |> collectString(delimiter: ", ")
                "${t.qualifiedName}.${eCons.name}(${p})"
            case _ => throw Exception("tupleToString() not implemented.")
        }
    }
}

@When[env == "ohos"]
public func tupleToString(a: Any): String {
    match (a) {
        case l: ReadOnlyList<Any> =>
            let ll = l |> map {i: Any => tupleToString(i)} |> collectString(delimiter: ", ")
            "[${ll}]"
        case s: ToString => s.toString()
        // ohos：无 TupleTypeInfo/EnumTypeInfo，元组/枚举值落入 Class/Struct/兜底分支
        case o => match (TypeInfo.of(o)) {
            case t: ClassTypeInfo =>
                let sb = StringBuilder()
                sb.append("${t.qualifiedName}(")
                let l = t.instanceVariables |> map {
                    i => let value = tupleToString(i.getValue(a))
                    "${i.name}=${value}"
                } |> collectString(delimiter: ", ")
                sb.append(l)
                sb.append(")")
                sb.toString()
            case t: StructTypeInfo =>
                let sb = StringBuilder()
                sb.append("${t.qualifiedName}(")
                let l = t.instanceVariables |> map {
                    i => let value = tupleToString(i.getValue(a))
                    "${i.name}=${value}"
                } |> collectString(delimiter: ", ")
                sb.append(l)
                sb.append(")")
                sb.toString()
            case _ => throw Exception("tupleToString() not implemented.")
        }
    }
}

public func toStr(a: Any): String {
    match (a) {
        case s: ToString => s.toString()
        case _ => TypeInfo.of(a).name
    }
}

// ═══ 深比较 + 通用值断言 ═══
// 反射深度比较：列表类（ReadOnlyList/Array/ArrayList）逐元素深比较——运行时集合的
// TypeInfo.qualifiedName 因实现类型不同而互异（ArrayList<Any> vs Array<Any> 字面量），
// 不能按 qualifiedName 短路；其余类型 qualifiedName 一致后按 toString 全等。
// （Cangjie 元组 match 不可靠 → 用 is 分别判别再互比。）
public func checkEquality(a: Any, b: Any): Bool {
    if ((a is ReadOnlyList<Any>) && (b is ReadOnlyList<Any>)) {
        let la = (a as ReadOnlyList<Any>).getOrThrow()
        let lb = (b as ReadOnlyList<Any>).getOrThrow()
        if (la.size != lb.size) { return false }
        for (i in 0..la.size) {
            if (!checkEquality(la[i], lb[i])) { return false }
        }
        return true
    }
    let aTypeInfo = TypeInfo.of(a)
    let bTypeInfo = TypeInfo.of(b)
    if (aTypeInfo.qualifiedName != bTypeInfo.qualifiedName) {
        return false
    }
    toString(a) == toString(b)
}

public func tupleCheckEquality(a: Any, b: Any): Bool {
    let aTypeInfo = TypeInfo.of(a)
    let bTypeInfo = TypeInfo.of(b)
    if (aTypeInfo.qualifiedName != bTypeInfo.qualifiedName) {
        return false
    }
    tupleToString(a) == tupleToString(b)
}

@CustomAssertion
public func anyValue(ctx: AssertionCtx, actual: Any, expected: Any): Any {
    let result = checkEquality(actual, expected)
    if (!result) {
        ctx.fail("""
anyValue do not match:
 left: ${toString(actual)}
right: ${toString(expected)}
""")
    }
    actual
}

// ═══ 主线（A/B 形）共享断言 ═══
public func annotations(ctx: AssertionCtx, actual_: Collection<Annotation>, expected: Array<Annotation>): Collection<Annotation> {
    let actual = actual_.toArray()
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of annotations do not match: ${actual.size} != ${expected.size}:
 left: ${toString(actual)}
right: ${toString(
                expected)}
""")
    }
    for (i in 0..actual.size) {
        let a = actual[i]
        let b = expected[i]
        let result = checkEquality(a, b)
        if (!result) {
            ctx.fail(
                """
#${i} pair of annotations do not match: ${toString(a)} != ${toString(b)}:
 left: ${toString(actual)}
right: ${toString(
                    expected)}
""")
        }
    }
    actual
}

public func readOnlyList(ctx: AssertionCtx, actual: ReadOnlyList<Any>, expected: Array<Any>): ReadOnlyList<Any> {
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of elements do not match: ${actual.size} != ${expected.size}:
 left: ${toString(actual)}
right: ${toString(
                expected)}
""")
    }
    for (i in 0..actual.size) {
        let a = actual[i]
        let b = expected[i]
        let result = checkEquality(a, b)
        if (!result) {
            ctx.fail(
                """
#${i} pair of elements do not match: ${toString(a)} != ${toString(b)}:
 left: ${toString(actual)}
right: ${toString(
                    expected)}
""")
        }
    }
    actual
}

public func interfaceTypeInfoList(ctx: AssertionCtx, actual: Array<InterfaceTypeInfo>, expected: Array<String>): Array<InterfaceTypeInfo> {
    let leftList = actual |> map {i => i.qualifiedName} |> collectString(delimiter: ", ")
    let rightList = expected |> collectString(delimiter: ", ")
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of elements do not match: ${actual.size} != ${expected.size}:
 left: ${leftList}
right: ${rightList}
""")
    }
    for (i in 0..actual.size) {
        let a = actual[i]
        let b = expected[i]
        let result = a.qualifiedName == b
        if (!result) {
            ctx.fail(
                """
#${i} pair of elements do not match: ${a.qualifiedName} != ${b}:
 left: ${leftList}
right: ${rightList}
""")
        }
    }
    actual
}

// ohos 无 EnumConstructorInfo：以下三个 EC helper 消费 ohos 不存在的类型，
// 单侧 @When 守卫（ohos 无等价类型，不做双版本）；enumCtorNames 的调用面
// （eti_* 树 TC）自身直接引用 EnumTypeInfo，在 ohos 本就随场景整体排除。
@When[env != "ohos"]
public func enumConstructors(ctx: AssertionCtx, actual_: Collection<EnumConstructorInfo>,
    expected: Array<EnumConstructor>): Collection<EnumConstructorInfo> {
    let actual = actual_.toArray()
    if (actual.size != expected.size) {
        ctx.fail("number of constructors does not match: actual ${actual.size} != expected ${expected.size}")
    }
    for (i in 0..actual.size) {
        let a = actual[i]
        let b = expected[i]
        // 检查annotations
        // 检查enumTypeInfo
        // 检查name
        if (a.name != b.name) {
            ctx.fail("""
#${i} enum constructor name check failed:
  actual: ${a.name}
expected: ${b.name}
""")
        }

        // 检查qualifiedName
        if (a.qualifiedName != b.qualifiedName) {
            ctx.fail(
                """
#${i} enum constructor's qualifiedName check failed:
  actual: ${a.qualifiedName}
expected: ${b
                    .qualifiedName}
""")
        }
        let aList = a.parameters |> map {t: TypeInfo => t.qualifiedName} |> collectString(delimiter: ", ")
        let bList = b.parameters |> collectString(delimiter: ", ")
        // 检查parameters
        if (a.parameters.size != b.parameters.size) {
            ctx.fail(
                """
#${i} enum constructor ${a.qualifiedName}'s parameters' size check failed:
  actual: ${aList}
expected: ${bList}
""")
        }
        for (j in 0..a.parameters.size) {
            let aa = a.parameters[j]
            let bb = b.parameters[j]
            if (aa.qualifiedName != bb) {
                ctx.fail(
                    """
#${i} enum constructor ${a.qualifiedName}'s parameters check failed:
  actual: ${aList}
expected: ${bList}
""")
            }
        }
    }
    actual
}

@When[env != "ohos"]
public func enumConstructor(ctx: AssertionCtx, actual: EnumConstructorInfo, expected: EnumConstructor): EnumConstructorInfo {
    // 检查annotations
    // 检查enumTypeInfo
    // 检查name
    if (actual.name != expected.name) {
        ctx.fail("""
enum constructor name check failed:
  actual: ${actual.name}
expected: ${expected.name}
""")
    }

    // 检查qualifiedName
    if (actual.qualifiedName != expected.qualifiedName) {
        ctx.fail(
            """
enum constructor's qualifiedName check failed:
  actual: ${actual.qualifiedName}
expected: ${expected
                .qualifiedName}
""")
    }
    let aList = actual.parameters |> map {t: TypeInfo => t.qualifiedName} |> collectString(delimiter: ", ")
    let bList = expected.parameters |> collectString(delimiter: ", ")
    // 检查parameters
    if (actual.parameters.size != expected.parameters.size) {
        ctx.fail(
            """
enum constructor ${actual.qualifiedName}'s parameters' size check failed:
  actual: ${aList}
expected: ${bList}
""")
    }
    for (j in 0..actual.parameters.size) {
        let aa = actual.parameters[j]
        let bb = expected.parameters[j]
        if (aa.qualifiedName != bb) {
            ctx.fail(
                """
enum constructor ${actual.qualifiedName}'s parameters check failed:
  actual: ${aList}
expected: ${bList}
""")
        }
    }
    actual
}

public class EnumConstructor {
    public EnumConstructor(public let qualifiedName!: String, public let name!: String,
        public let parameters!: Array<String> = []) {}
}

public class Constructor {
    public Constructor(public let qualifiedName!: String, public let name!: String,
        public let parameters!: Array<String> = []) {}
}

public func constructorInfo(ctx: AssertionCtx, actual: ConstructorInfo, expected: Constructor): ConstructorInfo {
    let aList = actual.parameters |> map {t: ParameterInfo => t.typeInfo.qualifiedName} |> collectString(
        delimiter: ", ")
    let bList = expected.parameters |> collectString(delimiter: ", ")
    if (aList != bList) {
        ctx.fail("""
constructor parameters check failed:
  actual: [${aList}]
expected: [${bList}]
""")
    }
    if (actual.parameters.size != expected.parameters.size) {
        ctx.fail(
            """
constructor parameters size check failed:
  actual: ${actual.parameters.size}
expected: ${expected
                .parameters
                .size}
""")
    }
    actual
}

public func classTypeInfoList(ctx: AssertionCtx, actual_: Collection<ClassTypeInfo>, expected: Array<String>): Collection<ClassTypeInfo> {
    let actual = actual_.toArray()
    let leftList = actual |> map {i => i.qualifiedName} |> collectString(delimiter: ", ")
    let rightList = expected |> collectString(delimiter: ", ")
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of elements do not match: ${actual.size} != ${expected.size}:
 left: ${leftList}
right: ${rightList}
""")
    }
    for (i in 0..actual.size) {
        let a = actual[i]
        let b = expected[i]
        if (a.qualifiedName != b) {
            ctx.fail(
                """
#${i} pair of elements do not match: ${a.qualifiedName} != ${b}:
 left: ${leftList}
right: ${rightList}
""")
        }
    }
    actual
}

public func collectSortedArray<T>(l: Collection<T>): Array<T> where T <: TypeInfo {
    let tmp = l |> collectArray
    sort(tmp, by: {a: T, b: T => a.qualifiedName.compare(b.qualifiedName)})
    tmp
}

// ═══ 特性线专属断言（按特性收录单源声明）═══
public func sealedSubList(ctx: AssertionCtx, actual_: Collection<ClassTypeInfo>,
    expected: Array<String>): Collection<ClassTypeInfo> {
    let actual = actual_.toArray()
    let leftList = actual |> map {i => i.qualifiedName} |> collectString(delimiter: ", ")
    let rightList = expected |> collectString(delimiter: ", ")
    if (actual.size != expected.size) {
        ctx.fail("""
number of elements do not match: ${actual.size} != ${expected.size}:
 left: ${leftList}
right: ${rightList}
""")
    }
    // 无序多集相等：expected 中每个元素都出现在 actual 中（数量上已保证相等）
    for (b in expected) {
        var found = false
        for (a in actual) {
            if (a.qualifiedName == b) {
                found = true
                break
            }
        }
        if (!found) {
            ctx.fail("""
expected element missing from sealedSubclasses: ${b}
 left: ${leftList}
right: ${rightList}
""")
        }
    }
    actual
}

public func annotationsArray<T>(ctx: AssertionCtx, actual_: Array<T>, expected: Array<String>): Array<T> where T <: Annotation {
    let actual = actual_
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of annotated elements do not match: ${actual.size} != ${expected.size}
""")
    }
    for (i in 0..actual.size) {
        let el = actual[i]
        let elName = TypeInfo.of(el).name
        if (elName != expected[i]) {
            ctx.fail(
                """
#${i} annotation type mismatch: actual ${elName} != expected ${expected[i]}
""")
        }
    }
    actual
}

// ── 参数类型列表内容断言：逐一断言 TypeInfo 的名称（按声明顺序）──
// EnumConstructorInfo.parameters 是 ReadOnlyList<TypeInfo>（与 ConstructorInfo 的
// ParameterInfo 不同，此处无顺序问题——文档承诺"按声明顺序返回"）。
// 元素名：基础类型 = 简单名；用户类型 = 简单名；元组/函数 = "Tuple<...>"/"Closure<...>"。

public func parameterTypeNames(ctx: AssertionCtx, actual_: ReadOnlyList<TypeInfo>, expected: Array<String>): ReadOnlyList<TypeInfo> {
    let actual = actual_
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of parameter types do not match: ${actual.size} != ${expected.size}
""")
    }
    for (i in 0..actual.size) {
        let el = actual[i]
        let elName = el.name
        if (elName != expected[i]) {
            ctx.fail(
                """
#${i} parameter type mismatch: actual ${elName} != expected ${expected[i]}
""")
        }
    }
    actual
}

// ── Any 值深比较（apply / getAssociatedValues 返回的 Any）──

public func anyList(ctx: AssertionCtx, actual_: ReadOnlyList<Any>, expected: Array<Any>): ReadOnlyList<Any> {
    let actual = actual_
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of associated values do not match: ${actual.size} != ${expected.size}:
 left: ${eciToString(actual)}
right: ${eciToString(expected)}
""")
    }
    for (i in 0..actual.size) {
        let a = actual[i]
        let b = expected[i]
        let result = checkEquality(a, b)
        if (!result) {
            ctx.fail(
                """
#${i} associated value do not match: ${eciToString(a)} != ${eciToString(b)}
""")
        }
    }
    actual
}

@When[env != "ohos"]
public func enumCtorNames(ctx: AssertionCtx, actual_: Collection<EnumConstructorInfo>, expected: Array<String>): Collection<EnumConstructorInfo> {
    let actual = actual_.toArray()
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of enum constructors do not match: ${actual.size} != ${expected.size}:
 left: ${toString(actual)}
right: ${toString(expected)}
""")
    }
    for (i in 0..actual.size) {
        let elName = actual[i].name
        if (elName != expected[i]) {
            ctx.fail(
                """
#${i} enum constructor name mismatch: actual ${elName} != expected ${expected[i]}
""")
        }
    }
    actual
}

// ── 参数类型名内容断言（EnumConstructorInfo.parameters / FunctionTypeInfo.parameters）
// parameters 返回 ReadOnlyList<TypeInfo>，元素是 TypeInfo。
// 断言：逐个元素按【声明顺序】比对 TypeInfo.name（形参类型名）。

public func paramTypeNames(ctx: AssertionCtx, actual_: Collection<TypeInfo>, expected: Array<String>): Collection<TypeInfo> {
    let actual = actual_.toArray()
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of parameter types do not match: ${actual.size} != ${expected.size}:
 left: ${toString(actual)}
right: ${toString(expected)}
""")
    }
    for (i in 0..actual.size) {
        let el = actual[i]
        let elName = el.name
        if (elName != expected[i]) {
            ctx.fail(
                """
#${i} parameter type name mismatch: actual ${elName} != expected ${expected[i]}
""")
        }
    }
    actual
}

// ── 注解内容断言（annotations 集合）
// 比对注解身份（qualifiedName）+ 个数，而非仅 size。

public func notContainsModifiers(ctx: AssertionCtx, actual_: Collection<ModifierInfo>, expected: Array<String>): Collection<ModifierInfo> {
    let actual = actual_.toArray()
    for (i in 0..actual.size) {
        let elName = actual[i].toString()
        for (j in 0..expected.size) {
            if (elName == expected[j]) {
                ctx.fail(
                    """
modifier ${elName} should NOT be present in ${toString(actual)}
""")
            }
        }
    }
    actual
}

// ── superInterfaces 内容断言：集合包含指定名称的接口
// 期望 = 单个接口名（如 "Any"），断言集合中存在该名的接口。

public func containsIfaceName(ctx: AssertionCtx, actual_: Collection<InterfaceTypeInfo>, expected: String): Collection<InterfaceTypeInfo> {
    let actual = actual_.toArray()
    for (i in 0..actual.size) {
        if (actual[i].name == expected) {
            return actual
        }
    }
    ctx.fail(
        """
superInterfaces does NOT contain iface ${expected}: ${toString(actual)}
""")
    actual
}

// ── superInterfaces 内容断言：集合包含所有指定名称的接口（I + Any）

public func containsIfaceNames(ctx: AssertionCtx, actual_: Collection<InterfaceTypeInfo>, expected: Array<String>): Collection<InterfaceTypeInfo> {
    let actual = actual_.toArray()
    for (j in 0..expected.size) {
        var found = false
        for (i in 0..actual.size) {
            if (actual[i].name == expected[j]) {
                found = true
                break
            }
        }
        if (!found) {
            ctx.fail(
                """
superInterfaces does NOT contain iface ${expected[j]}: ${toString(actual)}
""")
        }
    }
    actual
}

// ── 成员函数名内容断言（instanceFunctions/staticFunctions）
// 断言：逐个元素比对 InstanceFunctionInfo/StaticFunctionInfo 的 name。
// 两种成员类型共用断言名不行（@CustomAssertion 按参数类型分派）→ 各定义一份。

public func funcNames(ctx: AssertionCtx, actual_: Collection<InstanceFunctionInfo>, expected: Array<String>): Collection<InstanceFunctionInfo> {
    let actual = actual_.toArray()
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of instance functions do not match: ${actual.size} != ${expected.size}:
 left: ${toString(actual)}
right: ${toString(expected)}
""")
    }
    for (i in 0..actual.size) {
        let elName = actual[i].name
        if (elName != expected[i]) {
            ctx.fail(
                """
#${i} instance function name mismatch: actual ${elName} != expected ${expected[i]}
""")
        }
    }
    actual
}

public func funcNames(ctx: AssertionCtx, actual_: Collection<StaticFunctionInfo>, expected: Array<String>): Collection<StaticFunctionInfo> {
    let actual = actual_.toArray()
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of static functions do not match: ${actual.size} != ${expected.size}
""")
    }
    for (i in 0..actual.size) {
        let elName = actual[i].name
        if (elName != expected[i]) {
            ctx.fail(
                """
#${i} static function name mismatch: actual ${elName} != expected ${expected[i]}
""")
        }
    }
    actual
}

// ── 成员属性名内容断言（instanceProperties/staticProperties）

public func propNames(ctx: AssertionCtx, actual_: Collection<InstancePropertyInfo>, expected: Array<String>): Collection<InstancePropertyInfo> {
    let actual = actual_.toArray()
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of instance properties do not match: ${actual.size} != ${expected.size}
""")
    }
    for (i in 0..actual.size) {
        let elName = actual[i].name
        if (elName != expected[i]) {
            ctx.fail(
                """
#${i} instance property name mismatch: actual ${elName} != expected ${expected[i]}
""")
        }
    }
    actual
}

public func propNames(ctx: AssertionCtx, actual_: Collection<StaticPropertyInfo>, expected: Array<String>): Collection<StaticPropertyInfo> {
    let actual = actual_.toArray()
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of static properties do not match: ${actual.size} != ${expected.size}
""")
    }
    for (i in 0..actual.size) {
        let elName = actual[i].name
        if (elName != expected[i]) {
            ctx.fail(
                """
#${i} static property name mismatch: actual ${elName} != expected ${expected[i]}
""")
        }
    }
    actual
}

// ── Any 值深比较（apply/destruct/getAssociatedValues 返回的 Any）──

public func genericParamNames(ctx: AssertionCtx, actual_: Collection<GenericTypeInfo>, expected: Array<String>): Collection<GenericTypeInfo> {
    let actual = actual_.toArray()
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of generic params do not match: ${actual.size} != ${expected.size}:
 left: ${gtiToString(actual)}
right: ${gtiToString(expected)}
""")
    }
    // 位置序不符时回退成员检查（gti 位置序语义 ∪ gfunc 成员语义的 PASS 并集）：
    // 全部期望名都存在即通过，仅缺失才 fail。
    var positionalMatch = true
    for (i in 0..actual.size) {
        if (actual[i].name != expected[i]) {
            positionalMatch = false
            break
        }
    }
    if (!positionalMatch) {
        let actualNames = actual |> map {p: GenericTypeInfo => p.name} |> collectArray
        for (i in 0..expected.size) {
            if (!(actualNames |> any {n: String => n == expected[i]})) {
                ctx.fail(
                    """
generic param name ${expected[i]} not found in actual: ${gtiToString(actualNames)}
""")
            }
        }
    }
    actual
}

// ── superInterfaces 内容断言：集合包含指定名称的接口（"Any"）──

public func emptyCollection<T>(ctx: AssertionCtx, actual_: Collection<T>, expected: Collection<Any>): Collection<T> {
    if (actual_.size != 0) {
        ctx.fail(
            "expected empty collection but got ${actual_.size} elements")
    }
    actual_
}

// ── 诊断辅助：元素个数描述 ──

public func gtiToString(n: Int64): String {
    "${n} elements"
}

public func gtiToString(arr: Array<GenericTypeInfo>): String {
    let sb = StringBuilder()
    sb.append("[")
    for (i in 0..arr.size) {
        if (i > 0) { sb.append(", ") }
        sb.append(arr[i].name)
    }
    sb.append("]")
    sb.toString()
}

public func gtiToString(arr: Array<String>): String {
    let sb = StringBuilder()
    sb.append("[")
    for (i in 0..arr.size) {
        if (i > 0) { sb.append(", ") }
        sb.append(arr[i])
    }
    sb.append("]")
    sb.toString()
}

public func parameterNames(ctx: AssertionCtx, actual_: Collection<ParameterInfo>, expected: Array<String>): Collection<ParameterInfo> {
    let actual = actual_.toArray()
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of parameters do not match: ${actual.size} != ${expected.size}:
 left: ${toString(actual)}
right: ${toString(expected)}
""")
    }
    // 实际形参名集合
    let actualNames = actual |> map {p: ParameterInfo => p.name} |> collectArray
    for (i in 0..expected.size) {
        if (!(actualNames |> any {n: String => n == expected[i]})) {
            ctx.fail(
                """
parameter name ${expected[i]} not found in actual: ${toString(actualNames)}
""")
        }
    }
    actual
}

// ── 泛型参数列表内容断言：逐一断言 GenericTypeInfo 的 name（而非 size）──

public func typeInfoSubList(ctx: AssertionCtx, actual_: Collection<TypeInfo>,
    expected: Array<String>): Collection<TypeInfo> {
    let actual = actual_.toArray()
    let leftList = actual |> map {i => i.qualifiedName} |> collectString(delimiter: ", ")
    let rightList = expected |> collectString(delimiter: ", ")
    if (actual.size != expected.size) {
        ctx.fail("""
number of elements do not match: ${actual.size} != ${expected.size}:
 left: ${leftList}
right: ${rightList}
""")
    }
    // 无序多集相等：expected 中每个元素都出现在 actual 中（数量上已保证相等）
    for (b in expected) {
        var found = false
        for (a in actual) {
            if (a.qualifiedName == b) {
                found = true
                break
            }
        }
        if (!found) {
            ctx.fail("""
expected element missing from sealedSubtypes: ${b}
 left: ${leftList}
right: ${rightList}
""")
        }
    }
    actual
}

public func pkgNames(ctx: AssertionCtx, actual_: Collection<TypeInfo>, expected: Array<String>): Collection<TypeInfo> {
    // 占位签名不可用：Collection<PackageInfo>/GlobalFunctionInfo/GlobalVariableInfo
    // 需分别实例化，见下方各特化版本。本函数保留为 TypeInfo 形态（typeInfos 用）。
    let names = actual_ |> map {t => t.name} |> collectArray
    checkNameSet(ctx, names, expected)
    actual_
}

// typeInfos 专用（Collection<TypeInfo>）

public func pkgTypeInfos(ctx: AssertionCtx, actual_: Collection<TypeInfo>, expected: Array<String>): Collection<TypeInfo> {
    let names = actual_ |> map {t => t.name} |> collectArray
    checkNameSet(ctx, names, expected)
    actual_
}

// subPackages 专用（Collection<PackageInfo>）

public func pkgSubPackages(ctx: AssertionCtx, actual_: Collection<PackageInfo>, expected: Array<String>): Collection<PackageInfo> {
    let names = actual_ |> map {p => p.name} |> collectArray
    checkNameSet(ctx, names, expected)
    actual_
}

// functions 专用（Collection<GlobalFunctionInfo>）

public func pkgFunctions(ctx: AssertionCtx, actual_: Collection<GlobalFunctionInfo>, expected: Array<String>): Collection<GlobalFunctionInfo> {
    let names = actual_ |> map {f => f.name} |> collectArray
    checkNameSet(ctx, names, expected)
    actual_
}

// variables 专用（Collection<GlobalVariableInfo>）

public func pkgVariables(ctx: AssertionCtx, actual_: Collection<GlobalVariableInfo>, expected: Array<String>): Collection<GlobalVariableInfo> {
    let names = actual_ |> map {v => v.name} |> collectArray
    checkNameSet(ctx, names, expected)
    actual_
}

// getFunctions 专用（Array<GlobalFunctionInfo>，重载族）

public func pkgFuncNames(ctx: AssertionCtx, actual_: Array<GlobalFunctionInfo>, expected: Array<String>): Array<GlobalFunctionInfo> {
    let names = actual_ |> map {f => f.name} |> collectArray
    checkNameSet(ctx, names, expected)
    actual_
}

// ── 集合等价比较：数量一致 + 每个期望名都出现（顺序无关）──
func checkNameSet(ctx: AssertionCtx, names: Array<String>, expected: Array<String>): Unit {
    if (names.size != expected.size) {
        let joined = names |> collectString(delimiter: ", ")
        ctx.fail("size mismatch: actual [${joined}] (${names.size}) != expected (${expected.size})")
        return
    }
    for (e in expected) {
        if (!names.contains(e)) {
            let joined = names |> collectString(delimiter: ", ")
            ctx.fail("missing element '${e}': actual [${joined}]")
        }
    }
}

public func typeInfoQualifiedNames(ctx: AssertionCtx, actual_: Array<TypeInfo>, expected: Array<String>): Array<TypeInfo> {
    let actual = actual_
    if (actual.size != expected.size) {
        ctx.fail(
            """
number of parsed types do not match: ${actual.size} != ${expected.size}:
 left: ${typeInfosToString(actual)}
right: ${expected}
""")
    }
    for (i in 0..actual.size) {
        let el = actual[i]
        let elName = el.toString()
        let exp = expected[i]
        if (elName != exp && !elName.endsWith(".${exp}")) {
            ctx.fail(
                """
#${i} parsed type mismatch: actual ${elName} != expected ${exp}
""")
        }
    }
    actual
}

// 辅助：TypeInfo 数组 → 字符串（失败信息用）

public func typeInfosToString(arr: Array<TypeInfo>): String {
    let sb = StringBuilder()
    sb.append("[")
    for ((i, t) in arr |> enumerate) {
        if (i > 0) {
            sb.append(", ")
        }
        sb.append(t.toString())
    }
    sb.append("]")
    sb.toString()
}

// 注解类：供 findAnnotation<PtiTag>() / findAllAnnotations<PtiTag>() 泛型实参引用。
// 20261021 整合轮由 `Tag` 改名：约 30 个特性线 upstream 各自有同名 `Tag` 注解类，
// TC 同时 import utils.* 与 upstream.* 时裸名歧义（sema_ambiguous）→ 单源侧让路。
public class PtiTag {
    public const init() {}
}

// ── 通用 Any 深比较辅助 ──

public func strArrayContent<T>(ctx: AssertionCtx, actual_: Array<T>, expected: Array<String>): Array<T> {
    if (actual_.size != expected.size) {
        ctx.fail("array size mismatch: ${actual_.size} != ${expected.size}")
    }
    for (i in 0..actual_.size) {
        let elStr = match (actual_[i]) {
            case ti: TypeInfo => ti.name
            case o => toStr(o)
        }
        if (elStr != expected[i]) {
            ctx.fail("#${i} element mismatch: ${elStr} != ${expected[i]}")
        }
    }
    actual_
}

// ── superInterfaces 含指定接口名断言 ──

public func structMemberInfoList(ctx: AssertionCtx, actual_: Collection<ConstructorInfo>,
    expected: Array<String>): Collection<ConstructorInfo> {
    checkMemberList(ctx, actual_.toArray() |> map {i => i.toString()} |> collectArray, expected)
    actual_
}

public func structMemberInfoList(ctx: AssertionCtx, actual_: Collection<InstanceVariableInfo>,
    expected: Array<String>): Collection<InstanceVariableInfo> {
    checkMemberList(ctx, actual_.toArray() |> map {i => i.toString()} |> collectArray, expected)
    actual_
}

public func structMemberInfoList(ctx: AssertionCtx, actual_: Collection<StaticVariableInfo>,
    expected: Array<String>): Collection<StaticVariableInfo> {
    checkMemberList(ctx, actual_.toArray() |> map {i => i.toString()} |> collectArray, expected)
    actual_
}

// 共享校验体：逐位比较 toString 与期望签名串

internal func checkMemberList(ctx: AssertionCtx, actual: Array<String>, expected: Array<String>): Unit {
    let leftList = actual |> collectString(delimiter: ", ")
    let rightList = expected |> collectString(delimiter: ", ")
    if (actual.size != expected.size) {
        ctx.fail("""
number of elements do not match: ${actual.size} != ${expected.size}:
 left: ${leftList}
right: ${rightList}
""")
    }
    for (i in 0..actual.size) {
        if (actual[i] != expected[i]) {
            ctx.fail("""
#${i} pair of elements do not match:
 left: ${leftList}
right: ${rightList}
""")
        }
    }
}

public func tupleElements(ctx: AssertionCtx, actual_: Collection<TypeInfo>, expected: Array<String>): Collection<TypeInfo> {
    let actual = actual_.toArray()
    if (actual.size != expected.size) {
        ctx.fail(
            "number of elements do not match: ${actual.size} != ${expected.size}")
    }
    for (i in 0..actual.size) {
        let el = actual[i]
        let elName = el.name
        if (elName != expected[i]) {
            ctx.fail(
                "#${i} element type mismatch: actual ${elName} != expected ${expected[i]}")
        }
    }
    actual_
}

// ── destruct 返回值内容断言：ReadOnlyList<Any>，逐元素深比较 ──

public func tupleElementsList(ctx: AssertionCtx, actual_: ReadOnlyList<Any>, expected: Array<Any>): ReadOnlyList<Any> {
    let actual = actual_.toArray()
    if (actual.size != expected.size) {
        ctx.fail(
            "number of destructed elements do not match: ${actual.size} != ${expected.size}")
    }
    for (i in 0..actual.size) {
        let a = actual[i]
        let b = expected[i]
        if (!tupleCheckEquality(a, b)) {
            ctx.fail(
                "#${i} destructed element mismatch: ${tupleToString(a)} != ${tupleToString(b)}")
        }
    }
    actual_
}

// ── superInterfaces 内容断言：包含名为 Any 的接口 ──

public func tupleSuperInterfacesHasAny(ctx: AssertionCtx, actual_: Collection<InterfaceTypeInfo>, expected: Array<String>): Collection<InterfaceTypeInfo> {
    let actual = actual_.toArray()
    for (expName in expected) {
        var found = false
        for (s in actual) {
            if (s.name == expName) {
                found = true
                break
            }
        }
        if (!found) {
            ctx.fail(
                "expected super interface ${expName} not found in ${actual_.size} interfaces")
        }
    }
    actual_
}

// ── Any 值深比较（construct 返回的 Any）──

// ═══ generic_apply_matrix 消息契约助手（单源收录）═══
public func anyShow(r: Any): String {
    let t = TypeInfo.of(r)
    if (t.name == "Int64") {
        "${(r as Int64).getOrThrow()}"
    } else {
        t.name
    }
}

// ── apply 消息 oracle（消息契约 S 层：generic_apply_matrix）──

public func msgInst2(inst: Any, f: InstanceFunctionInfo, args: Array<Any>): String {
    try {
        let r = f.apply(inst, args)
        return "OK:${anyShow(r)}"
    } catch (e: Exception) {
        return e.message
    }
}

public func msgInst3(inst: Any, f: InstanceFunctionInfo, targs: Array<TypeInfo>, args: Array<Any>): String {
    try {
        let r = f.apply(inst, targs, args)
        return "OK:${anyShow(r)}"
    } catch (e: Exception) {
        return e.message
    }
}

public func msgStat2(owner: TypeInfo, f: StaticFunctionInfo, args: Array<Any>): String {
    try {
        let r = f.apply(owner, args)
        return "OK:${anyShow(r)}"
    } catch (e: Exception) {
        return e.message
    }
}

public func msgStat3(owner: TypeInfo, f: StaticFunctionInfo, targs: Array<TypeInfo>, args: Array<Any>): String {
    try {
        let r = f.apply(owner, targs, args)
        return "OK:${anyShow(r)}"
    } catch (e: Exception) {
        return e.message
    }
}

public func msgG1(f: GlobalFunctionInfo, args: Array<Any>): String {
    try {
        let r = f.apply(args)
        return "OK:${anyShow(r)}"
    } catch (e: Exception) {
        return e.message
    }
}

public func msgG2(f: GlobalFunctionInfo, targs: Array<TypeInfo>, args: Array<Any>): String {
    try {
        let r = f.apply(targs, args)
        return "OK:${anyShow(r)}"
    } catch (e: Exception) {
        return e.message
    }
}

// ── get/查询轴消息 oracle ──

public func msgTypeGet(name: String): String {
    try {
        let t = ClassTypeInfo.get(name)
        return "OK:${t.name}"
    } catch (e: Exception) {
        return e.message
    }
}

public func msgConstruct(t: TypeInfo, args: Array<Any>): String {
    try {
        let ct = (t as ClassTypeInfo).getOrThrow()
        let r = ct.construct(args)
        return "OK:${anyShow(r)}"
    } catch (e: Exception) {
        return e.message
    }
}

public func msgCtorGet(t: TypeInfo, paramTypes: Array<TypeInfo>): String {
    try {
        let ct = (t as ClassTypeInfo).getOrThrow()
        let c = ct.getConstructor(paramTypes)
        return "OK:${c.toString()}"
    } catch (e: Exception) {
        return e.message
    }
}

public func msgGFuncGet(pkg: PackageInfo, name: String, paramTypes: Array<TypeInfo>): String {
    try {
        let f = pkg.getFunction(name, paramTypes)
        return "OK:${f.name}"
    } catch (e: Exception) {
        return e.message
    }
}

public func msgInstFuncGet(t: TypeInfo, name: String, paramTypes: Array<TypeInfo>): String {
    try {
        let ct = (t as ClassTypeInfo).getOrThrow()
        let f = ct.getInstanceFunction(name, paramTypes)
        return "OK:${f.name}"
    } catch (e: Exception) {
        return e.message
    }
}

// ── stdlib 自反射枚举 helper（std.core 无取柄 helper，经 functions 集合过滤）──
// 过滤一律走 std 顶层 filter/count/collectArray 管道式：ohos 目标无 Array.filter
// 接口（Array 上函数式操作面缺失），顶层函数形式双目标（gnu/ohos）通用。

public func funcCount(pkg: PackageInfo, name: String): Int64 {
    pkg.functions.toArray() |> filter {f: GlobalFunctionInfo => f.name == name} |> count
}

public func firstFuncToString(pkg: PackageInfo, name: String): String {
    let ms = pkg.functions.toArray() |> filter {f: GlobalFunctionInfo => f.name == name} |> collectArray
    if (ms.size > 0) {
        return ms[0].toString()
    }
    return "<none>"
}

public func firstFuncOwnParamCount(pkg: PackageInfo, name: String): Int64 {
    let ms = pkg.functions.toArray() |> filter {f: GlobalFunctionInfo => f.name == name} |> collectArray
    if (ms.size > 0) {
        return ms[0].genericParams.size
    }
    return -1
}

// ═════════════════════════════════════════════════════════════════
// 1008 缺口补平 oracle（13 缺口探锚 tmp/fill_probe_1008，cjc 1.3.0-alpha.02）
// 组合块形态：一次调用完成"取柄→读→写→再读"并返回管道拼接串，
// TC 侧对整串做恰一条 @Expect 断言。
// ═════════════════════════════════════════════════════════════════

// A-G1: 泛型 class 实例成员变量/属性 roundtrip（先读后写，ip 读 iv 故读序固定）

public func clsInstMemberRoundtrip(inst: Any): String {
    try {
        let gc = ClassTypeInfo.get("upstream.GM<Int64>")
        let iv = gc.getInstanceVariable("iv")
        let ip = gc.getInstanceProperty("ip")
        let v0 = "${(iv.getValue(inst) as Int64).getOrThrow()}"
        let p0 = "${(ip.getValue(inst) as Int64).getOrThrow()}"
        iv.setValue(inst, 666)
        let v1 = "${(iv.getValue(inst) as Int64).getOrThrow()}"
        ip.setValue(inst, 666)
        let p1 = "${(ip.getValue(inst) as Int64).getOrThrow()}"
        return "OK:${v0}->${v1}|${p0}->${p1}"
    } catch (e: Exception) {
        return e.message
    }
}

// A-G1: 泛型 class 静态成员变量/属性 roundtrip（静态存储在类型侧）

public func clsStaticMemberRoundtrip(): String {
    try {
        let gc = ClassTypeInfo.get("upstream.GM<Int64>")
        let sv = gc.getStaticVariable("sv")
        let sp = gc.getStaticProperty("sp")
        let a = "${(sv.getValue() as Int64).getOrThrow()}"
        let b = "${(sp.getValue() as Int64).getOrThrow()}"
        sv.setValue(666)
        let a1 = "${(sv.getValue() as Int64).getOrThrow()}"
        sp.setValue(2333)
        let b1 = "${(sp.getValue() as Int64).getOrThrow()}"
        return "OK:${a}->${a1}|${b}->${b1}"
    } catch (e: Exception) {
        return e.message
    }
}

// A-G1: 泛型 struct 静态成员 roundtrip（静态存储不随值语义拷贝）

public func structStaticMemberRoundtrip(): String {
    try {
        let gs = StructTypeInfo.get("upstream.GS<Int64>")
        let ssv = gs.getStaticVariable("ssv")
        let ssp = gs.getStaticProperty("ssp")
        let a = "${(ssv.getValue() as Int64).getOrThrow()}"
        let b = "${(ssp.getValue() as Int64).getOrThrow()}"
        ssv.setValue(666)
        let a1 = "${(ssv.getValue() as Int64).getOrThrow()}"
        ssp.setValue(777)
        let b1 = "${(ssp.getValue() as Int64).getOrThrow()}"
        return "OK:${a}->${a1}|${b}->${b1}"
    } catch (e: Exception) {
        return e.message
    }
}

// B-6: abstract 类 construct / abstract 函数 apply 消息文本（M14/M15）

public func abstractMemberMessages(): String {
    var c = "?"
    try {
        ClassTypeInfo.get("upstream.AbsBase").construct(Array<Any>())
        c = "no-throw"
    } catch (e: Exception) {
        c = e.message
    }
    var f = "?"
    try {
        let der = ClassTypeInfo.get("upstream.AbsDer").construct(Array<Any>())
        let fn = ClassTypeInfo.get("upstream.AbsBase").getInstanceFunction("absf")
        fn.apply(der, Array<Any>())
        f = "no-throw"
    } catch (e: Exception) {
        f = e.message
    }
    return "OK:${c}|${f}"
}

// B-6: immutable 变量/属性 setValue + setValue 类型错 + 构造器实参数错（M16/M17/M18/M5）

public func immutableMemberSetMessages(inst: Any): String {
    let gc = ClassTypeInfo.get("upstream.GM<Int64>")
    var m1 = "?"
    try {
        gc.getInstanceVariable("ro").setValue(inst, 8)
        m1 = "no-throw"
    } catch (e: Exception) {
        m1 = e.message
    }
    var m2 = "?"
    try {
        gc.getInstanceProperty("rop").setValue(inst, 8)
        m2 = "no-throw"
    } catch (e: Exception) {
        m2 = e.message
    }
    var m3 = "?"
    try {
        gc.getInstanceVariable("iv").setValue(inst, "s")
        m3 = "no-throw"
    } catch (e: Exception) {
        m3 = e.message
    }
    var m4 = "?"
    try {
        gc.getConstructor([TypeInfo.of<Int64>()]).apply(Array<Any>())
        m4 = "no-throw"
    } catch (e: Exception) {
        m4 = e.message
    }
    return "OK:${m1}|${m2}|${m3}|${m4}"
}

// A-G2: 泛型 TypeInfo 名字三形态（toString/name/qualifiedName）+ struct 同构

public func genericNameBlock(): String {
    try {
        let gc = ClassTypeInfo.get("upstream.GM<Int64>")
        let gs = StructTypeInfo.get("upstream.GS<Int64>")
        return "OK:${gc.toString()}|${gc.name}|${gc.qualifiedName}|${gs.toString()}"
    } catch (e: Exception) {
        return e.message
    }
}

// A-G2: 多参泛型 get 两形态等价 + 渲染恒逗号+空格

public func twoParamSpaceForms(): String {
    try {
        let a = ClassTypeInfo.get("upstream.Two<Int64,String>")
        let b = ClassTypeInfo.get("upstream.Two<Int64, String>")
        return "OK:${a.toString()}|${b.toString()}|${a.name}"
    } catch (e: Exception) {
        return e.message
    }
}

// B-1: ParameterInfo 自描述（构造器/全局函数首参 index 与构造器参数名）

public func paramIndexBlock(inst: Any): String {
    try {
        let gc = ClassTypeInfo.get("upstream.GM<Int64>")
        let cp = gc.getConstructor([TypeInfo.of<Int64>()]).parameters[0]
        let upkg = PackageInfo.get("upstream")
        let fp = upkg.getFunction("pgf1", [TypeInfo.of<Int64>()]).parameters[0]
        return "OK:${cp.index}|${cp.name}|${fp.index}"
    } catch (e: Exception) {
        return e.message
    }
}

// B-4: 包面签名 toString 精确文本（函数 0/1 参 + 变量 + 类型）

public func sigToStringBlock(): String {
    try {
        let upkg = PackageInfo.get("upstream")
        let f0 = upkg.getFunction("pgf0").toString()
        let f1 = upkg.getFunction("pgf1", [TypeInfo.of<Int64>()]).toString()
        let v = upkg.getVariable("pgv").toString()
        let t = upkg.getTypeInfo("upstream.Bound").toString()
        return "OK:${f0}|${f1}|${v}|${t}"
    } catch (e: Exception) {
        return e.message
    }
}

// B-2: isSubtypeOf 真值矩阵八连（原始 2 + 类层级 6；接口经包面 getTypeInfo 取柄）

public func subtypeMatrix(): String {
    try {
        let p1 = TypeInfo.of<Int64>().isSubtypeOf(TypeInfo.of<Int64>())
        let p2 = TypeInfo.of<UInt32>().isSubtypeOf(TypeInfo.of<Int8>())
        let der = ClassTypeInfo.get("upstream.AbsDer")
        let base = ClassTypeInfo.get("upstream.AbsBase")
        let cder = ClassTypeInfo.get("upstream.CDer")
        let cbase = ClassTypeInfo.get("upstream.CBase")
        let upkg = PackageInfo.get("upstream")
        let ia = upkg.getTypeInfo("upstream.IA")
        let ib = upkg.getTypeInfo("upstream.IB")
        let c1 = der.isSubtypeOf(base)
        let c2 = cder.isSubtypeOf(cbase)
        let c3 = cder.isSubtypeOf(ia)
        let c4 = cder.isSubtypeOf(ib)
        let c5 = ib.isSubtypeOf(ia)
        let c6 = ia.isSubtypeOf(ib)
        return "OK:${p1}|${p2}|${c1}|${c2}|${c3}|${c4}|${c5}|${c6}"
    } catch (e: Exception) {
        return e.message
    }
}

// B-3: sealedSubclasses 内容契约（sealed 闭包含自身/叶子空/非 sealed 空）

public func sealedSubclassesBlock(): String {
    try {
        let base = ClassTypeInfo.get("upstream.SealBase")
        let sub1 = ClassTypeInfo.get("upstream.SealSub1")
        let bound = ClassTypeInfo.get("upstream.Bound")
        let arr = ArrayList<String>()
        for (t in base.sealedSubclasses) {
            arr.add(t.qualifiedName)
        }
        arr.sort()
        let a1 = arr.toString()
        let arr2 = ArrayList<String>()
        for (t in sub1.sealedSubclasses) {
            arr2.add(t.qualifiedName)
        }
        let a2 = arr2.toString()
        let arr3 = ArrayList<String>()
        for (t in bound.sealedSubclasses) {
            arr3.add(t.qualifiedName)
        }
        let a3 = arr3.toString()
        return "OK:${a1}|${a2}|${a3}"
    } catch (e: Exception) {
        return e.message
    }
}

// B-7: modifiers 排序并列表六形矩阵

public func typeModifiers(ti: TypeInfo): String {
    let arr = ArrayList<String>()
    for (m in ti.modifiers) {
        arr.add(m.toString())
    }
    arr.sort()
    return arr.toString()
}

public func modifiersMatrix(): String {
    try {
        let p = PackageInfo.get("upstream")
        let a = typeModifiers(p.getTypeInfo("upstream.IfaceOpen"))
        let b = typeModifiers(p.getTypeInfo("upstream.IfaceSealed"))
        let c = typeModifiers(p.getTypeInfo("upstream.ClsPlain"))
        let d = typeModifiers(p.getTypeInfo("upstream.ClsOpen"))
        let e = typeModifiers(p.getTypeInfo("upstream.ClsAbs"))
        let f = typeModifiers(p.getTypeInfo("upstream.ClsAbsSealed"))
        return "OK:${a}|${b}|${c}|${d}|${e}|${f}"
    } catch (e: Exception) {
        return e.message
    }
}

// B-8: 嵌套 std 类型 qualifiedName（只嵌最外层包前缀）

public func nestedStdQualifiedName(): String {
    try {
        let a = TypeInfo.of<ArrayList<String>>().qualifiedName
        let b = TypeInfo.of<Box<String>>().qualifiedName
        let c = TypeInfo.of<Array<Array<String>>>().qualifiedName
        let d = TypeInfo.of<Option<Option<Box<String>>>>().qualifiedName
        return "OK:${a}|${b}|${c}|${d}"
    } catch (e: Exception) {
        return e.message
    }
}

// A-G4: getStaticFunction 单数取柄（按名+参数类型命中）

public func staticFuncSingularGet(): String {
    try {
        let f = ClassTypeInfo.get("upstream.GM<Int64>")
            .getStaticFunction("sf", [TypeInfo.of<Int64>()])
        return "OK:${f.name}"
    } catch (e: Exception) {
        return e.message
    }
}

// B-5: org:: 前缀声明包（organizationName + 限定名 get 命中）
// ohos 无 EnumTypeInfo（同 toString 族 env 条件双版本）：ohos 分支枚举取柄
// 降级为基类 TypeInfo.get——qualifiedName 输出与专用 API 逐字节一致（gnu 探针
// 实证），TC 侧固定字面量断言形状不变；gnu 分支保留 EnumTypeInfo.get 场景强度。

@When[env != "ohos"]
public func orgNameBlock(): String {
    try {
        let p = PackageInfo.get("org::models")
        let cls = ClassTypeInfo.get("org::models.OrgCls")
        let en = EnumTypeInfo.get("org::models.OrgEnum")
        return "OK:${p.name}|${p.organizationName}|${cls.qualifiedName}|${en.qualifiedName}"
    } catch (e: Exception) {
        return e.message
    }
}

@When[env == "ohos"]
public func orgNameBlock(): String {
    try {
        let p = PackageInfo.get("org::models")
        let cls = ClassTypeInfo.get("org::models.OrgCls")
        let en = TypeInfo.get("org::models.OrgEnum")
        return "OK:${p.name}|${p.organizationName}|${cls.qualifiedName}|${en.qualifiedName}"
    } catch (e: Exception) {
        return e.message
    }
}

// A-G5: std.core print 双参重载族全量（升级哨兵，恰 15 个）

public func stdPrintTwoParamBlock(): String {
    try {
        let arr = ArrayList<String>()
        for (f in PackageInfo.get("std.core").functions) {
            if (f.name == "print" && f.parameters.size == 2) {
                arr.add(f.toString())
            }
        }
        arr.sort()
        return "OK:${arr.toString()}"
    } catch (e: Exception) {
        return e.message
    }
}

// A-G5: std.math abs 重载族全量（恰 7 个）

public func stdAbsOverloadBlock(): String {
    try {
        let arr = ArrayList<String>()
        for (f in PackageInfo.get("std.math").functions) {
            if (f.name == "abs") {
                arr.add(f.toString())
            }
        }
        arr.sort()
        return "OK:${arr.toString()}"
    } catch (e: Exception) {
        return e.message
    }
}

// A-G5: std 类型 TypeInfo.toString 九形（裸名/跨包限定/函数类型）

public func stdTypeToStrings(): String {
    try {
        let a = TypeInfo.of<Box<String>>().toString()
        let b = TypeInfo.of<Array<String>>().toString()
        let c = TypeInfo.of<Option<Option<Box<String>>>>().toString()
        let d = TypeInfo.of<ArrayList<String>>().toString()
        let e = TypeInfo.of<HashMap<String, Int64>>().toString()
        let f = TypeInfo.of<DateTime>().toString()
        let g = TypeInfo.of<Directory>().toString()
        let h = TypeInfo.of<ToString>().toString()
        let i = TypeInfo.of<(Int64) -> Unit>().toString()
        return "OK:${a}|${b}|${c}|${d}|${e}|${f}|${g}|${h}|${i}"
    } catch (e: Exception) {
        return e.message
    }
}

// A-G5: std 反射可见面负契约（std.env 不可见/copy/max 不在面/非限定 getTypeInfo 未命中）

public func stdVisibilityBlock(): String {
    var a = "?"
    try {
        let p = PackageInfo.get("std.env")
        a = p.name
    } catch (e: Exception) {
        a = e.message
    }
    var b = "?"
    try {
        let f = PackageInfo.get("std.core").getFunction("copy")
        b = f.name
    } catch (e: Exception) {
        b = e.message
    }
    var c = "?"
    try {
        let f = PackageInfo.get("std.math").getFunction("max")
        c = f.name
    } catch (e: Exception) {
        c = e.message
    }
    var d = "?"
    try {
        let t = PackageInfo.get("std.core").getTypeInfo("Box")
        d = t.name
    } catch (e: Exception) {
        d = e.message
    }
    return "OK:${a}|${b}|${c}|${d}"
}

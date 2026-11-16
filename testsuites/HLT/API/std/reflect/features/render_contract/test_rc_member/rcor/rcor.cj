/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

 package rcor

import std.reflect.*
import std.collection.*
import std.time.*
import rcont.*
import rcon.*

// ── 1) 基础类型 toString 谱系 + Int/UInt 别名 + of(实例) 限定名 ──
public func rcPrim(): String {
    try {
        "Int8=${TypeInfo.of<Int8>()}|Int16=${TypeInfo.of<Int16>()}|Int32=${TypeInfo.of<Int32>()}|Int64=${TypeInfo.of<Int64>()}|IntNative=${TypeInfo.of<IntNative>()}|UInt8=${TypeInfo.of<UInt8>()}|UIntNative=${TypeInfo.of<UIntNative>()}|Float16=${TypeInfo.of<Float16>()}|Float64=${TypeInfo.of<Float64>()}|Bool=${TypeInfo.of<Bool>()}|Rune=${TypeInfo.of<Rune>()}|Unit=${TypeInfo.of<Unit>()}|Nothing=${TypeInfo.of<Nothing>()}|Int=${TypeInfo.of<Int>()}|UInt=${TypeInfo.of<UInt>()}|ofInstC1=${TypeInfo.of(C1())}|ofInstS1=${TypeInfo.of(S1())}"
    } catch (e: Exception) {
        "EXC:${e.message}"
    }
}

// ── 2) gfunc 签名谱系（rcon 包级函数 g0-g4）──
public func rcGFunc(): String {
    try {
        let pkg = PackageInfo.get("rcon")
        let f0 = pkg.getFunction("g0", TypeInfo.of<Unit>())
        let f1 = pkg.getFunction("g1", TypeInfo.of<Int8>(), TypeInfo.of<Int16>(), TypeInfo.of<Int32>(), TypeInfo.of<Int64>())
        let f2 = pkg.getFunction("g2", TypeInfo.of<UInt8>(), TypeInfo.of<UInt16>(), TypeInfo.of<UInt32>(), TypeInfo.of<UInt64>())
        let f3 = pkg.getFunction("g3", TypeInfo.of<Float16>(), TypeInfo.of<Float32>(), TypeInfo.of<Float64>())
        let f4 = pkg.getFunction("g4", TypeInfo.of<Unit>(), TypeInfo.get("rcont.C1"), TypeInfo.get("rcont.S1"), TypeInfo.of<Bool>())
        "g0=${f0}|g1=${f1}|g2=${f2}|g3=${f3}|g4=${f4}"
    } catch (e: Exception) {
        "EXC:${e.message}"
    }
}

// ── 3) gvar 类型谱系（gv0-gv3）──
public func rcGVar(): String {
    try {
        let pkg = PackageInfo.get("rcon")
        "gv0=${pkg.getVariable("gv0")}|gv1=${pkg.getVariable("gv1")}|gv2=${pkg.getVariable("gv2")}|gv3=${pkg.getVariable("gv3")}"
    } catch (e: Exception) {
        "EXC:${e.message}"
    }
}

// ── 4) CPlain 成员集合组合渲染（数组包裹形态，含 ctor 声明序）──
public func rcMemberArrays(): String {
    try {
        let ct = (TypeInfo.of<CPlain>() as ClassTypeInfo).getOrThrow()
        let ctors = ct.constructors |> map {a: ConstructorInfo => a.toString()} |> collectArray
        let ifns = TypeInfo.of<CPlain>().instanceFunctions |> map {a: InstanceFunctionInfo => a.toString()} |> collectArray
        let sfns = TypeInfo.of<CPlain>().staticFunctions |> map {a: StaticFunctionInfo => a.toString()} |> collectArray
        let iprs = TypeInfo.of<CPlain>().instanceProperties |> map {a: InstancePropertyInfo => a.toString()} |> collectArray
        let sprs = TypeInfo.of<CPlain>().staticProperties |> map {a: StaticPropertyInfo => a.toString()} |> collectArray
        let ivrs = ct.instanceVariables |> map {a: InstanceVariableInfo => a.toString()} |> collectArray
        let svrs = ct.staticVariables |> map {a: StaticVariableInfo => a.toString()} |> collectArray
        "ctors=${ctors}|ifns=${ifns}|sfns=${sfns}|iprs=${iprs}|sprs=${sprs}|ivrs=${ivrs}|svrs=${svrs}"
    } catch (e: Exception) {
        "EXC:${e.message}"
    }
}

// ── 5) 空集 "[]" 形态（原始类型函数/接口属性/struct 静态函数三向）──
public func rcEmpty(): String {
    try {
        let ifns = TypeInfo.of<Int64>().instanceFunctions |> collectArray
        let ifnsC = TypeInfo.of<I1>().instanceProperties |> collectArray
        let ifnsS = TypeInfo.of<SG<Int64>>().staticFunctions |> collectArray
        //  ifacePr：I1.instanceProperties（接口实例属性；I1 无实例属性 → []）
        "primFn=${ifns}|ifacePr=${ifnsC}|structStaticFn=${ifnsS}"
    } catch (e: Exception) {
        "EXC:${e.message}"
    }
}

// ── 6) 接口/抽象类 open abstract 组合前缀 ──
public func rcAbstractPrefix(): String {
    try {
        let itf = TypeInfo.of<IAb>()
        let ifns = itf.instanceFunctions |> map {a: InstanceFunctionInfo => a.toString()} |> collectArray
        let iprs = itf.instanceProperties |> map {a: InstancePropertyInfo => a.toString()} |> collectArray
        let sfns = itf.staticFunctions |> map {a: StaticFunctionInfo => a.toString()} |> collectArray
        let sprs = itf.staticProperties |> map {a: StaticPropertyInfo => a.toString()} |> collectArray
        let cab = TypeInfo.of<CAb>()
        let cabFns = cab.instanceFunctions |> map {a: InstanceFunctionInfo => a.toString()} |> collectArray
        let cabPrs = cab.instanceProperties |> map {a: InstancePropertyInfo => a.toString()} |> collectArray
        "iIfns=${ifns}|iIprs=${iprs}|iSfns=${sfns}|iSprs=${sprs}|cFns=${cabFns}|cPrs=${cabPrs}"
    } catch (e: Exception) {
        "EXC:${e.message}"
    }
}

// ── 7) open 具体类前缀（外部注释掉的不确定形，自证）──
public func rcOpenPrefix(): String {
    try {
        let oct = (TypeInfo.of<COpen>() as ClassTypeInfo).getOrThrow()
        let iprs = oct.instanceProperties |> map {a: InstancePropertyInfo => a.toString()} |> collectArray
        let ivrs = oct.instanceVariables |> map {a: InstanceVariableInfo => a.toString()} |> collectArray
        let ifns = oct.instanceFunctions |> map {a: InstanceFunctionInfo => a.toString()} |> collectArray
        "openPrs=${iprs}|openVrs=${ivrs}|openFns=${ifns}"
    } catch (e: Exception) {
        "EXC:${e.message}"
    }
}

// ── 8) 泛型名归一化（无空格 get → 有空格 toString / 嵌套 / 元组实参）──
public func rcGenericNames(): String {
    try {
        let ofForm = TypeInfo.of<CG<Int64, String>>()
        let getForm = ClassTypeInfo.get("rcon.CG<Int64,String>")
        let nested = TypeInfo.of<CG2<CG<Int64, String>>>()
        let tupleArg = TypeInfo.of<CG<(Int64, String), Bool>>()
        let sg = TypeInfo.of<SG<Int64>>()
        "of=${ofForm}|get=${getForm}|nested=${nested}|tupleArg=${tupleArg}|sg=${sg}"
    } catch (e: Exception) {
        "EXC:${e.message}"
    }
}

// ── 9) Tuple / Function(Closure) 类型名渲染 ──
public func rcTupleClosure(): String {
    try {
        let tup = TupleTypeInfo.of(("xxx", 123))
        let tupGet = TupleTypeInfo.get("Tuple<String, Int64>")
        let ft = FunctionTypeInfo.of<(Int64, Float64) -> (Float64, Int64)>()
        let tupName = "name=${tup.name},qn=${tup.qualifiedName},ts=${tup}"
        let tupGetName = "name=${tupGet.name},ts=${tupGet}"
        let ftName = "name=${ft.name},qn=${ft.qualifiedName}"
        "${tupName}|${tupGetName}|${ftName}"
    } catch (e: Exception) {
        "EXC:${e.message}"
    }
}

// ── 10) ctor 组合序（声明序验证，CPlain/CAb/C1 三类）──
public func rcCtorComposition(): String {
    try {
        let cp = (TypeInfo.of<CPlain>() as ClassTypeInfo).getOrThrow().constructors |> map {a: ConstructorInfo => a.toString()} |> collectArray
        let cab = (TypeInfo.of<CAb>() as ClassTypeInfo).getOrThrow().constructors |> map {a: ConstructorInfo => a.toString()} |> collectArray
        let c1 = (TypeInfo.of<C1>() as ClassTypeInfo).getOrThrow().constructors |> map {a: ConstructorInfo => a.toString()} |> collectArray
        "cplain=${cp}|cab=${cab}|c1=${c1}"
    } catch (e: Exception) {
        "EXC:${e.message}"
    }
}

// ── 11) std.core 类型短名（Array/String 走 StructTypeInfo、Hashable 走 InterfaceTypeInfo）──
public func rcStdCoreTypeNames(): String {
    try {
        let box = ClassTypeInfo.get("std.core.Box<std.core.String>")
        let sb = ClassTypeInfo.get("std.core.StringBuilder")
        let arr = StructTypeInfo.get("std.core.Array<std.core.String>")
        let str = StructTypeInfo.get("std.core.String")
        let hash = InterfaceTypeInfo.get("std.core.Hashable")
        "box=${box}|sb=${sb}|arr=${arr}|str=${str}|hash=${hash}"
    } catch (e: Exception) {
        "EXC:${e.message}"
    }
}

// ── 12) std.core 函数签名（sleep/print 重载族/max 泛型 filter+first）──
public func rcStdCoreFuncs(): String {
    try {
        let core = PackageInfo.get("std.core")
        let sleep = core.getFunction("sleep", [TypeInfo.of<Duration>()])
        let pb = core.getFunction("print", [TypeInfo.of<Bool>(), TypeInfo.of<Bool>()])
        let pi = core.getFunction("print", [TypeInfo.of<Int32>(), TypeInfo.of<Bool>()])
        var maxTs = "maxNone"
        match (core.functions |> filter {f: GlobalFunctionInfo => f.name == "max"} |> first) {
            case Some(t) => maxTs = "${t}"
            case None => ()
        }
        "sleep=${sleep}|pb=${pb}|pi=${pi}|max=${maxTs}"
    } catch (e: Exception) {
        "EXC:${e.message}"
    }
}

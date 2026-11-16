/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

 package ranno

import std.reflect.*
import rann.*

// 用户自定义类型别名（round-4 G9 of<T> 别名解析形态的靶别名）
type MyI = Int64

// ── 穿透族 ──
public func raTypeAnnoCounts(): String {
    try {
        let c = TypeInfo.get("rann.CRich").annotations.size
        let i = TypeInfo.get("rann.IRich").annotations.size
        let s = TypeInfo.get("rann.SRich").annotations.size
        return "OK:${c}|${i}|${s}"
    } catch (e: Exception) { return e.toString() }
}

public func raMemberAnnoCounts(): String {
    try {
        let ct = (TypeInfo.of(CRich(3)) as ClassTypeInfo).getOrThrow()
        let f = ct.getInstanceFunction("fm").annotations.size
        let v = ct.getInstanceVariable("fv").annotations.size
        let k = ct.getConstructor(TypeInfo.of<Int64>()).annotations.size
        return "OK:${f}|${v}|${k}"
    } catch (e: Exception) { return e.toString() }
}

public func raParamAnnoCounts(): String {
    try {
        let ct = (TypeInfo.of(CRich(3)) as ClassTypeInfo).getOrThrow()
        let ctor = ct.getConstructor(TypeInfo.of<Int64>())
        return "OK:${ctor.parameters[0].annotations.size}|${ctor.parameters.size}"
    } catch (e: Exception) { return e.toString() }
}

public func raInterfaceMember(): String {
    try {
        let it = TypeInfo.get("rann.IRich")
        let f = (it as InterfaceTypeInfo).getOrThrow().getInstanceFunction("ifm")
        return "OK:${f.annotations.size}|${it.annotations.size}"
    } catch (e: Exception) { return e.toString() }
}

public func raStructVar(): String {
    try {
        let st = TypeInfo.get("rann.SRich")
        let v = (st as StructTypeInfo).getOrThrow().getInstanceVariable("sv")
        return "OK:${v.annotations.size}|${st.annotations.size}"
    } catch (e: Exception) { return e.toString() }
}

public func raFindPresence(): String {
    try {
        let c = TypeInfo.of(CRich(3))
        let ct = (c as ClassTypeInfo).getOrThrow()
        let t = if (c.findAnnotation<RAOne>().isSome()) { 1 } else { 0 }
        let f = if (ct.getInstanceFunction("fm").findAnnotation<RAMix>().isSome()) { 1 } else { 0 }
        let p = if (ct.getConstructor(TypeInfo.of<Int64>()).parameters[0].findAnnotation<RAOne>().isSome()) { 1 } else { 0 }
        return "OK:${t}|${f}|${p}"
    } catch (e: Exception) { return e.toString() }
}

// ── payload 族（双段 getOrThrow 后读字段）──
public func raPayloadType(): String {
    try {
        let c = TypeInfo.of(CRich(3))
        let one = (c.findAnnotation<RAOne>().getOrThrow() as RAOne).getOrThrow().value
        let mix = (c.findAnnotation<RAMix>().getOrThrow() as RAMix).getOrThrow()
        return "OK:${one}|${mix.p2}|${mix.p3}"
    } catch (e: Exception) { return e.toString() }
}

public func raPayloadFunc(): String {
    try {
        let ct = (TypeInfo.of(CRich(3)) as ClassTypeInfo).getOrThrow()
        let mix = (ct.getInstanceFunction("fm").findAnnotation<RAMix>().getOrThrow() as RAMix).getOrThrow()
        return "OK:${mix.p2}|${mix.p3}"
    } catch (e: Exception) { return e.toString() }
}

public func raPayloadVar(): String {
    try {
        let ct = (TypeInfo.of(CRich(3)) as ClassTypeInfo).getOrThrow()
        let one = (ct.getInstanceVariable("fv").findAnnotation<RAOne>().getOrThrow() as RAOne).getOrThrow().value
        return "OK:${one}"
    } catch (e: Exception) { return e.toString() }
}

public func raPayloadParam(): String {
    try {
        let ct = (TypeInfo.of(CRich(3)) as ClassTypeInfo).getOrThrow()
        let one = (ct.getConstructor(TypeInfo.of<Int64>()).parameters[0].findAnnotation<RAOne>().getOrThrow() as RAOne).getOrThrow().value
        return "OK:${one}"
    } catch (e: Exception) { return e.toString() }
}

public func raPayloadIface(): String {
    try {
        let it = TypeInfo.get("rann.IRich")
        let f = (it as InterfaceTypeInfo).getOrThrow().getInstanceFunction("ifm")
        let mix = (f.findAnnotation<RAMix>().getOrThrow() as RAMix).getOrThrow()
        return "OK:${mix.p2}"
    } catch (e: Exception) { return e.toString() }
}

public func raPayloadMiss(): String {
    try {
        let n = if (TypeInfo.get("rann.SRich").findAnnotation<RAMix>().isNone()) { "none" } else { "unexpected" }
        return "OK:${n}"
    } catch (e: Exception) { return e.toString() }
}

// ── 相等语义族 ──
public func raEqSame(): String {
    try {
        let a = TypeInfo.of(CRich(3))
        let b = TypeInfo.of(CRich(9))
        return "OK:${a == b}"
    } catch (e: Exception) { return e.toString() }
}

public func raEqPrim(): String {
    try {
        let a = TypeInfo.of(Int64(1))
        let b = TypeInfo.of(Int64(2))
        return "OK:${a == b}"
    } catch (e: Exception) { return e.toString() }
}

public func raEqCross(): String {
    try {
        let a = TypeInfo.of(CRich(3))
        let b = TypeInfo.of(Int64(1))
        return "OK:${a == b}"
    } catch (e: Exception) { return e.toString() }
}

public func raHashSelf(): String {
    try {
        let a = TypeInfo.of(CRich(3))
        let b = TypeInfo.of(CRich(9))
        return "OK:${a.hashCode() == b.hashCode()}"
    } catch (e: Exception) { return e.toString() }
}

// ── construct 族 ──
public func raConstructDrill(): String {
    try {
        let ct = (TypeInfo.of(CRich(3)) as ClassTypeInfo).getOrThrow()
        let inst = (ct.construct([Int64(3)]) as CRich).getOrThrow()
        return "OK:${inst.fv}"
    } catch (e: Exception) { return e.toString() }
}

public func raConstructAbstract(): String {
    try {
        let ca = (TypeInfo.of<CAbs>() as ClassTypeInfo).getOrThrow()
        let x = ca.construct([])
        return "OK:${TypeInfo.of(x).name}"
    } catch (e: Exception) { return e.toString() }
}

public func raConstructMiss(): String {
    try {
        let ct = (TypeInfo.of(CRich(3)) as ClassTypeInfo).getOrThrow()
        let x = ct.construct([Int64(1), Int64(2)])
        return "OK:${TypeInfo.of(x).name}"
    } catch (e: Exception) { return e.toString() }
}

public func raConstructThrow(): String {
    try {
        let c = (TypeInfo.of<CThrow>() as ClassTypeInfo).getOrThrow()
        let x = c.construct([])
        return "OK:${TypeInfo.of(x).name}"
    } catch (e: Exception) { return e.toString() }
}

// ── ParameterInfo 族（1008 复审缺口 C-G6 补平，探针 tmp/probe_pi_1008）──
// 契约（1.3.0-alpha.02 探针定谳）：
//   getAllAnnotations()=参数全量注解数组（双注解参数 2、单注解 1）；
//   findAllAnnotations<T>()=按 T 筛选（注 T 命中、未注 T=0）、payload
//   经 as 强转二段可达；toString()=渲染参数类型名（Int64/String/Float64
//   三型实证，非参数名）；== 值语义（同构造器同位置跨 lookup 相等、
//   不同位置/跨类不等）；hashCode 跨 lookup 稳定、跨参数/跨类不等。

public func raParamGetAll(): String {
    try {
        let ct = (TypeInfo.of(PTwo(1, 2)) as ClassTypeInfo).getOrThrow()
        let ps = ct.getConstructor(TypeInfo.of<Int64>(), TypeInfo.of<Int64>()).parameters
        return "OK:${ps[0].getAllAnnotations().size}|${ps[1].getAllAnnotations().size}"
    } catch (e: Exception) { return e.toString() }
}

public func raParamFindAll(): String {
    try {
        let ct = (TypeInfo.of(PTwo(1, 2)) as ClassTypeInfo).getOrThrow()
        let p0 = ct.getConstructor(TypeInfo.of<Int64>(), TypeInfo.of<Int64>()).parameters[0]
        let hit = p0.findAllAnnotations<RAOne>().size
        let sel = p0.findAllAnnotations<RAMix>().size
        let miss = p0.findAllAnnotations<RAEmpty>().size
        return "OK:${hit}|${sel}|${miss}"
    } catch (e: Exception) { return e.toString() }
}

public func raParamFindAllPayload(): String {
    try {
        let ct = (TypeInfo.of(PTwo(1, 2)) as ClassTypeInfo).getOrThrow()
        let p0 = ct.getConstructor(TypeInfo.of<Int64>(), TypeInfo.of<Int64>()).parameters[0]
        let all = p0.findAllAnnotations<RAOne>()
        let v = (all[0] as RAOne).getOrThrow().value
        return "OK:${v}"
    } catch (e: Exception) { return e.toString() }
}

public func raParamToString(): String {
    try {
        let ct = (TypeInfo.of(PTwo(1, 2)) as ClassTypeInfo).getOrThrow()
        let ps = ct.getConstructor(TypeInfo.of<Int64>(), TypeInfo.of<Int64>()).parameters
        return "OK:${ps[0].toString()}|${ps[1].toString()}"
    } catch (e: Exception) { return e.toString() }
}

public func raParamEq(): String {
    try {
        let ct = (TypeInfo.of(PTwo(1, 2)) as ClassTypeInfo).getOrThrow()
        let ctor = ct.getConstructor(TypeInfo.of<Int64>(), TypeInfo.of<Int64>())
        let p0 = ctor.parameters[0]
        let p0b = ctor.parameters[0]
        let p1 = ctor.parameters[1]
        return "OK:${p0 == p0b}|${p0 != p0b}|${p0 == p1}|${p0 != p1}"
    } catch (e: Exception) { return e.toString() }
}

public func raParamHash(): String {
    try {
        let ct = (TypeInfo.of(PTwo(1, 2)) as ClassTypeInfo).getOrThrow()
        let ctor = ct.getConstructor(TypeInfo.of<Int64>(), TypeInfo.of<Int64>())
        let p0 = ctor.parameters[0]
        let p0b = ctor.parameters[0]
        let p1 = ctor.parameters[1]
        return "OK:${p0.hashCode() == p0b.hashCode()}|${p0.hashCode() == p1.hashCode()}"
    } catch (e: Exception) { return e.toString() }
}

// ── TypeInfo 裸接收者族（1008 round-3 缺口 G7 补平）──
// 契约：TypeInfo 声明成员 getAllAnnotations/findAllAnnotations<T> 可不经子类
// 强转直接调用（对照先例：annotations prop 裸接收者 92 处在库）；值与子类
// 接收者一致。round-3 全域严格归因前全语料 0 处裸接收者调用（1412 处同名
// 调用全为子类/成员信息类接收者——同名伪信用第四型）。

public func raTypeInfoGetAll(): String {
    try {
        let c = TypeInfo.get("rann.CRich").getAllAnnotations().size
        let s = TypeInfo.get("rann.SRich").getAllAnnotations().size
        let n = TypeInfo.of(PTwo(1, 2)).getAllAnnotations().size
        return "OK:${c}|${s}|${n}"
    } catch (e: Exception) { return e.toString() }
}

public func raTypeInfoFindAll(): String {
    try {
        let t = TypeInfo.of(CRich(3))
        let one = t.findAllAnnotations<RAOne>().size
        let mix = t.findAllAnnotations<RAMix>().size
        let empty = t.findAllAnnotations<RAEmpty>().size
        let miss = TypeInfo.of(PTwo(1, 2)).findAllAnnotations<RAOne>().size
        let v = (t.findAllAnnotations<RAOne>()[0] as RAOne).getOrThrow().value
        return "OK:${one}|${mix}|${empty}|${miss}|${v}"
    } catch (e: Exception) { return e.toString() }
}

// ── 散文行为声明族（1008 round-4 缺口 G9/G10/G11 补平，探针 tmp/probe_r4_1008）──
// 契约：of<T> 别名解析到实际类型（内置别名 Int→Int64 / UInt→UInt64 / 用户别名
// MyI→Int64，手册 of<T> 注记）；abstract class 隐式 open 语义（isOpen=true 且
// isAbstract=true，手册 isOpen 注记）；Object 无直接父类（superClass isNone，
// 手册 superClass 注记「理论上只有 Object 没有直接父类」）。

public func raAliasAcq(): String {
    try {
        return "OK:${TypeInfo.of<Int>().name}|${TypeInfo.of<UInt>().name}|${TypeInfo.of<MyI>().name}"
    } catch (e: Exception) { return e.toString() }
}

public func raAbstractOpen(): String {
    try {
        let ac = (TypeInfo.of<CAbs>() as ClassTypeInfo).getOrThrow()
        return "OK:${ac.isOpen()}|${ac.isAbstract()}"
    } catch (e: Exception) { return e.toString() }
}

public func raObjectRoot(): String {
    try {
        let ob = (TypeInfo.of<Object>() as ClassTypeInfo).getOrThrow()
        return "OK:${ob.superClass.isNone()}"
    } catch (e: Exception) { return e.toString() }
}

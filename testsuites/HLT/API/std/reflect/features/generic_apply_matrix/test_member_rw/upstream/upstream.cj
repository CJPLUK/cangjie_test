/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

 package upstream

import std.reflect.*

// ── 被测形状（消息契约探针同构）──
public class Bound {
    public init() {}
}

// 违反约束实例化 get 的甄别形状（GCon<Int64> 应抛，GCon<Bound> 合法）
public class GCon<T> where T <: Bound {
    public init() {}
    public func m(x: T): T { x }
}

public class GC1<T> {
    public init() {}
    public func plain0(): Unit {}
    public func g1(x: T): T { x }
    public func g3<A, B, C>(a: A): A where A <: Bound { a }
    public static func sNon(x: Int64): Int64 { x + 1 }
    public static func sId<T>(x: T): T { x }
}

public struct GS1<T> {
    public init() {}
    public func sp(x: T): T { x }
    public func fp(): Unit {}
}

public class OC {
    public init() {}
    public operator func +(p: OC): OC { p }
}

public func gNon(x: Int64): Int64 { x + 1 }
public func gId<T>(x: T): T { x }
public func gB<A>(a: A): A where A <: Bound { a }

// ── 1008 缺口补平形状（探针 tmp/fill_probe_1008/upstream 同构）──
// A-G1: 泛型类成员读写形状（实例成员用 T，静态成员用具体类型）
public class GM<T> {
    public init(v: T) {
        iv = v
    }
    public var iv: T
    public let ro: Int64 = 7
    public mut prop ip: T {
        get() { iv }
        set(v) { iv = v }
    }
    public prop rop: Int64 {
        get() { 42 }
    }
    public static var sv: Int64 = 114514
    public static mut prop sp: Int64 {
        get() { sv }
        set(v) { sv = v }
    }
    public static func sf(x: Int64): Int64 {
        x + 1
    }
}

// A-G1: 泛型 struct 成员读写形状
public struct GS<T> {
    public GS(public var v0: T) {}
    public mut prop p0: T {
        get() { v0 }
        set(v) { v0 = v }
    }
    public static var ssv: Int64 = 5
    public static mut prop ssp: Int64 {
        get() { ssv }
        set(v) { ssv = v }
    }
}

// A-G2: 多参泛型 toString 形状
public class Two<A, B> {
    public init() {}
}

// B-3: sealed 层级（sealed 须 abstract，sealed 自带 public）
abstract sealed class SealBase {
    public init() {}
}

public class SealSub1 <: SealBase {
    public init() {}
}

public class SealSub2 <: SealBase {
    public init() {}
}

// B-6: abstract 形状（cjnative：无体函数即抽象，禁 abstract 修饰符）
public abstract class AbsBase {
    public init() {}
    public func absf(): Int64
}

public class AbsDer <: AbsBase {
    public init() {}
    public override func absf(): Int64 {
        9
    }
}

// B-7: 修饰符矩阵
public interface IfaceOpen {}

sealed interface IfaceSealed {}

public open class ClsOpen {
    public init() {}
}

public abstract class ClsAbs {
    public init() {}
}

abstract sealed class ClsAbsSealed {
    public init() {}
}

public class ClsPlain {
    public init() {}
}

// B-2: 层级链
public interface IA {}

public interface IB <: IA {}

public open class CBase {
    public init() {}
}

public class CDer <: CBase & IA {
    public init() {}
}

// B-4: toString 形状源
public func pgf0(): Unit {}

public func pgf1(x: Int64): Int64 {
    x
}

public var pgv: Int64 = 5

// ── 1008 工厂 helper ──
public func mkGM(): GM<Int64> {
    GM<Int64>(111)
}

public func mkGS(): GS<Int64> {
    GS<Int64>(111)
}

// A-G1: 泛型 struct 实例成员值语义（setValue 不抛但不持久，值语义钉死）
// 形状敏感（1008 G4 实证）：sinst 必须是 helper 内的类型化局部量
// GS<Int64>——每次 getValue/setValue(sinst, ...) 现场装箱临时副本，
// 写进临时箱蒸发（探针 111->111）。若经 Any 形参传入则进入时已被
// 装箱，setValue 穿箱写、getValue 读同一箱 → 666"持久"（箱局域）。
// 可见性由 boxing 状态决定，TC 钉死类型化局部量形态（探针逐字）。
// 归属 upstream（同包引用 GS/mkGS，utils 不新增跨包导入）
public func structInstMemberValueSemantics(): String {
    try {
        let gs = StructTypeInfo.get("upstream.GS<Int64>")
        let sinst: GS<Int64> = mkGS()
        let v0 = gs.getInstanceVariable("v0")
        let p0 = gs.getInstanceProperty("p0")
        let a = "${(v0.getValue(sinst) as Int64).getOrThrow()}"
        v0.setValue(sinst, 666)
        let a1 = "${(v0.getValue(sinst) as Int64).getOrThrow()}"
        let b = "${(p0.getValue(sinst) as Int64).getOrThrow()}"
        p0.setValue(sinst, 666)
        let b1 = "${(p0.getValue(sinst) as Int64).getOrThrow()}"
        return "OK:${a}->${a1}|${b}->${b1}"
    } catch (e: Exception) {
        return e.message
    }
}

// ── 工厂/取柄 helper（生成 TC 的表达式词表）──
public func mkGC1(): GC1<Int64> { GC1<Int64>() }
public func mkGS1(): GS1<Int64> { GS1<Int64>() }
public func mkOC(): OC { OC() }
public func mkBound(): Bound { Bound() }

public func cti(inst: Any): ClassTypeInfo {
    (TypeInfo.of(inst) as ClassTypeInfo).getOrThrow()
}

public func sti(inst: Any): StructTypeInfo {
    (TypeInfo.of(inst) as StructTypeInfo).getOrThrow()
}

public func cifunc(inst: Any, name: String): InstanceFunctionInfo {
    cti(inst).getInstanceFunctions(name)[0]
}

public func sifunc(inst: Any, name: String): InstanceFunctionInfo {
    sti(inst).getInstanceFunctions(name)[0]
}

public func csfunc(name: String): StaticFunctionInfo {
    cti(mkGC1()).getStaticFunctions(name)[0]
}

public func gfunc(name: String): GlobalFunctionInfo {
    gpkg().getFunctions(name)[0]
}

public func gpkg(): PackageInfo {
    PackageInfo.get("upstream")
}

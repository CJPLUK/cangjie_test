/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

 package rann

@Annotation
public class RAEmpty {
    public const init() {}
}

@Annotation
public class RAOne {
    public let value: Int64
    public const init(v: Int64) { this.value = v }
}

@Annotation
public class RAMix {
    public let ratio: Float64
    public let tag: Rune
    public let p2: String
    public let p3: Int64
    public const init(r: Float64, t: Rune, p2!: String, p3!: Int64) {
        this.ratio = r
        this.tag = t
        this.p2 = p2
        this.p3 = p3
    }
}

@RAEmpty
@RAOne[7]
@RAMix[1.5, r'x', p2: "hi", p3: 9]
public class CRich {
    @RAOne[11]
    public var fv: Int64 = 0

    @RAMix[2.5, r'y', p2: "m", p3: 12]
    public func fm(): Unit {}

    @RAEmpty
    public init(@RAOne[3] a: Int64) {
        this.fv = a
    }
}

@RAEmpty
@RAOne[5]
public interface IRich {
    @RAMix[3.5, r'z', p2: "i", p3: 13]
    public func ifm(): Unit
}

@RAOne[6]
public struct SRich {
    @RAOne[8]
    public var sv: Int64 = 0
    public init() {}
}

public abstract class CAbs {
    public const init() {}
}

public class CThrow {
    public init() {
        throw Exception("init exception.")
    }
}

// 1008 复审缺口 C-G6：双注解参数 + 双参构造（ParameterInfo 六成员甄别靶，
// 探针 tmp/probe_pi_1008 同构）——param0 双注解叠栈（@RAOne+@RAMix，
// getAllAnnotations=2 甄别力），param1 单注解；@RAEmpty 只挂 ctor 不挂参
// （findAll<RAEmpty> 未注型 miss=0 单一归因）
public class PTwo {
    public var fv: Int64 = 0

    @RAEmpty
    public init(@RAOne[3] @RAMix[1.5, r'p', p2: "pt", p3: 9] a: Int64, @RAOne[4] b: Int64) {
        this.fv = a + b
    }
}

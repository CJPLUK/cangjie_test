// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*


@ObjC
public class A <: M {
    public let letPrimitive: Int64
    public let letClass: M
    public let letInterface: ProtoM

    public var varPrimitive: Int64
    public var varClass: M
    public var varInterface: ProtoM

    public static let sLetPrimitive: Int64 = 42
    public static let sLetClass: M = M()
    public static let sLetInterface: ProtoM = M1()

    public static var sVarPrimitive: Int64 = -123
    public static var sVarClass: M = M()
    public static var sVarInterface: ProtoM = M()

    public init() {
        print("cj: A()\n", flush: true)
        letPrimitive = 256
        letClass = M()
        letInterface = M()

        varPrimitive = 14
        varClass = M()
        varInterface = M1()
    }

    public func identity(): Unit {
        println("cj: I'm a class A instance")
        println("cj: Now, I will call super.identity()")
        super.identity()
    }

    public func check(): Unit {
        println("cj: I implement ProtoM1 method `check`")
    
        println("cj: A.sLetPrimitive = ${A.sLetPrimitive}")

        println("cj: A.sLetClass.identity():")
        A.sLetClass.identity()
    
        println("cj: A.sLetInterface.identity():")
        A.sLetInterface.identity()
        
        println("cj: A.sVarPrimitive = ${A.sVarPrimitive}")
        println("cj: Now I change the A.sVarPrimitive")
        A.sVarPrimitive = 100500

        println("cj: A.sVarClass.identity():")
        A.sVarClass.identity()
    
        println("cj: A.sVarInterface.identity():")
        A.sVarInterface.identity()
        println("cj: Now I change the A.sVarInterface")
        A.sVarInterface = M1()
        
        println("cj: a.varPrimitive = ${varPrimitive}")
        println("cj: Now I change the a.varPrimitive")
        varPrimitive = 3228

        println("cj: a.varClass.identity():")
        varClass.identity()
    
        println("cj: a.varInterface.identity():")
        varInterface.identity()
        println("cj: Now I change the a.varInterface")
        varInterface = M()
    }
}

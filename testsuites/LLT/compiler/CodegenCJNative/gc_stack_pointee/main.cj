// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Regression for stack-pointee GC roots: a promoted closure environment can
// hold the address of another promoted stack object.  The safepoint must keep
// both the environment and its stack pointees live.  This is an IR-level test:
// compile only, then check the struct-live list at the fun38 safepoint.
// EXEC: %compiler %warnOffAll %cmp_opt %enableO2 %f --save-temps . -o %output
// EXEC: %llvmDissembler cj_world.opt.bc -o main.opt.ll
// EXEC-PIPE: %cat main.opt.ll 2>&1 | compare %f
// ASSERT: scan "struct-live"({ %TypeInfo*, %"ObjLayout.cj_world:$ClN8cj_world5fun38HlNNat6OptionICNat6ObjectEEY2_Y2_EL7_E$0" }* %2, { %TypeInfo*, %"ObjLayout.cj_world:LocalBox" }* %3, { %TypeInfo*, %"ObjLayout.cj_world:LocalBox" }* %5)

package cj_world

// import cinterop.*
import std.runtime.*
import std.sync.*
import std.ref.*
import std.time.*

var allocBlocker: Bool = false
var terminationRequest: Bool = false

// The body is kept intact because shrinking it lets PEA remove the promoted
// closure environment that this regression needs to inspect.
let fuzzStartTime = DateTime.now()

func shouldTerminate(): Bool {
    if (terminationRequest) { return true }
    if (DateTime.now() - fuzzStartTime <= Duration.second * 30) { return false }
    terminationRequest = true
    return true
}

func error(message: String): Nothing {
   throw Exception(message)
}

interface CangjieIndexAccess {
   func loadCangjieField(index: Int64): ?Object
   func storeCangjieField(index: Int64, value: ?Object): Unit
}

// 可变的引用包装：let 引用不变，内部 value 可变，绕过 lambda 不能捕获 var 的限制
class LocalBox {
    public var value: ?Object
    public init(v: ?Object) { this.value = v }
}

// 弱引用包装：通过 CangjieIndexAccess 协议，在 loadField/storeField 中自动解包/包装 WeakRef
class WeakBox <: CangjieIndexAccess {
    private var weakRef: ?WeakRef<Object> = None
    public func loadCangjieField(index: Int64): ?Object {
        match (weakRef) { case Some(w) => w.value; case None => None }
    }
    public func storeCangjieField(index: Int64, value: ?Object) {
        weakRef = match (value) {
            case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER))
            case None => None
        }
    }
}

// 数组类：用 Array<?Object> 实现 index access
class CangjieArrayBox <: CangjieIndexAccess {
    private let values: Array<?Object>
    CangjieArrayBox(size: Int64, seed: ?Object) {
        let s = max(size, 1)
        this.values = Array(s) {i => if (i == 0) { seed } else { None }}
    }

    override public func loadCangjieField(index: Int64): ?Object {
        values[index % values.size]
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        values[index % values.size] = value
    }
}

private func anyToBool(value: ?Object): Bool {
    match (value) {
        case Some(b: Bool) => b
        case Some(i: Int64) => i != 0
        case _ => false
    }
}

private func anyToArrayBox(value: ?Object, size: Int64): CangjieArrayBox {
    match (value) {
        case Some(a: CangjieArrayBox) => a
        case _ => CangjieArrayBox(size, value)
    }
}

// 二维嵌套数组箱：Array<CangjieArrayBox> 两级真实引用数组。逐元素写穿两层
// Array::operator[]（B1 1013：外部分代材料 gc_roots_05 的 WriteStruct 崩溃形态）
class CangjieMatrixBox <: CangjieIndexAccess {
    private let inners: Array<CangjieArrayBox>
    CangjieMatrixBox(outer: Int64, inner: Int64, seed: ?Object) {
        let o = max(outer, 1)
        let i = max(inner, 1)
        this.inners = Array(o) {k => CangjieArrayBox(i, if (k == 0) { seed } else { None })}
    }

    override public func loadCangjieField(index: Int64): ?Object {
        inners[index % inners.size]
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        // 两级写：外层选箱 + 内层写槽，两层 operator[] 都在写路径上
        inners[index % inners.size].storeCangjieField(index / inners.size, value)
    }
}

extend Object {
    func loadField(index: Int64): ?Object {
        match (this) {
            case instance: CangjieIndexAccess => instance.loadCangjieField(index)
            // case _: ObjCIndexAccessProtocol => loadObjCField(index)
            case _ =>
            // error("Invalid loadField call")
            None<Object>
        }
    }
    func storeField(index: Int64, value: ?Object): Unit {
        match (this) {
            case instance: CangjieIndexAccess => instance.storeCangjieField(index, value)
            // case _: ObjCIndexAccessProtocol => storeObjCField(index, value)
            case _ => // error("Invalid storeField call")
            None<Object>
        }
    }
}

extend Option<Object> {
    func loadField(index: Int64): ?Object {
        match (this) {
            case Some(instance: CangjieIndexAccess) => instance.loadCangjieField(index)
            // case _: ObjCIndexAccessProtocol => loadObjCField(index)
            case _ => // error("Invalid loadField call")
            None<Object>
        }
    }
    func storeField(index: Int64, value: ?Object): Unit {
        match (this) {
            case Some(instance: CangjieIndexAccess) => instance.storeCangjieField(index, value)
            // case _: ObjCIndexAccessProtocol => storeObjCField(index, value)
            case _ => // error("Invalid storeField call")
            None<Object>
        }
    }
}

private let allowedThreadsCount = AtomicInt64(1000)

private func tryRegisterThread(): Bool {
    if (allowedThreadsCount.fetchSub(1) <= 0) {
        allowedThreadsCount.fetchAdd(1)
        false
    } else {
        true
    }
}

private func unregisterThread(): Unit {
    allowedThreadsCount.fetchAdd(1)
}

private let counter = AtomicInt64(0)

private func spawnThread(block: () -> Unit): Unit {
    if (!tryRegisterThread()) {
        return
    }
    let number = counter.fetchAdd(1)
    spawn {
        block()
        unregisterThread()
    }
}

private func call(localsCount: Int64, blockLocalsCount: Int64, block: (Int64) -> ?Object): ?Object {
    if (terminationRequest) { return None }
    let nextLocalsCount = localsCount + blockLocalsCount
    if (nextLocalsCount > 400) {
        return None
    }
    return block(nextLocalsCount)
}


func performGC() { gc(heavy: true) }

private func run(block: () -> Unit): Unit { block() }

private func alloc(block: () -> ?Object): ?Object {
    if (!allocBlocker) { return block() }
    return None
}

main(): Int64 {
    let box = LocalBox(None<Object>)
    let _ = fun38(0, None, box.value, None)
    return 0
}
            private var g0: ?Object = None
private var g1: ?Object = None
private let g2 = WeakBox()
private var g3: ?Object = None
private let g4 = WeakBox()
private var g5: ?Object = None
private var g6: ?Object = None
private let g7 = WeakBox()
private let g8 = WeakBox()
private var g9: ?Object = None
private let g10 = WeakBox()
private var g11: ?Object = None
private let g12 = WeakBox()
private var g13: ?Object = None
private var g14: ?Object = None
private let g15 = WeakBox()
private let g16 = WeakBox()
private var g17: ?Object = None
private let g18 = WeakBox()
class Class19 <: CangjieIndexAccess {
    Class19(f0: ?Object, f1: ?Object, f2: ?Object, f3: ?Object, f4: ?Object, f5: ?Object) {
        this.f0_weak = match (f0) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
        this.f1 = f1
        this.f2 = f2
        this.f3 = f3
        this.f4_weak = match (f4) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
        this.f5 = f5
    }
    private var f0_weak: ?WeakRef<Object> = None
    var f1: ?Object = None
    var f2: ?Object = None
    var f3: ?Object = None
    private var f4_weak: ?WeakRef<Object> = None
    var f5: ?Object = None
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 6) {
            case 0 => match (f0_weak) { case Some(w) => w.value; case None => None }
            case 1 => f1
            case 2 => f2
            case 3 => f3
            case 4 => match (f4_weak) { case Some(w) => w.value; case None => None }
            case 5 => f5
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 6) {
            case 0 => f0_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case 1 => f1 = value
            case 2 => f2 = value
            case 3 => f3 = value
            case 4 => f4_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case 5 => f5 = value
            case _ => error("impossible")
        }
    }
}

class Class20 <: CangjieIndexAccess {
    Class20(f0: ?Object, f1: ?Object, f2: ?Object, f3: ?Object) {
        this.f0 = f0
        this.f1 = f1
        this.f2 = f2
        this.f3_weak = match (f3) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
    }
    var f0: ?Object = None
    var f1: ?Object = None
    var f2: ?Object = None
    private var f3_weak: ?WeakRef<Object> = None
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 4) {
            case 0 => f0
            case 1 => f1
            case 2 => f2
            case 3 => match (f3_weak) { case Some(w) => w.value; case None => None }
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 4) {
            case 0 => f0 = value
            case 1 => f1 = value
            case 2 => f2 = value
            case 3 => f3_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case _ => error("impossible")
        }
    }
}

class Class21 <: CangjieIndexAccess {
    Class21(f0: ?Object) {
        this.f0 = f0
    }
    var f0: ?Object = None
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 1) {
            case 0 => f0
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 1) {
            case 0 => f0 = value
            case _ => error("impossible")
        }
    }
}

class Class22 <: CangjieIndexAccess {
    Class22(f0: ?Object, f1: ?Object, f2: ?Object, f3: ?Object, f4: ?Object) {
        this.f0 = f0
        this.f1_weak = match (f1) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
        this.f2 = f2
        this.f3 = f3
        this.f4 = f4
    }
    var f0: ?Object = None
    private var f1_weak: ?WeakRef<Object> = None
    var f2: ?Object = None
    var f3: ?Object = None
    var f4: ?Object = None
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 5) {
            case 0 => f0
            case 1 => match (f1_weak) { case Some(w) => w.value; case None => None }
            case 2 => f2
            case 3 => f3
            case 4 => f4
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 5) {
            case 0 => f0 = value
            case 1 => f1_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case 2 => f2 = value
            case 3 => f3 = value
            case 4 => f4 = value
            case _ => error("impossible")
        }
    }
}

class Class23 <: CangjieIndexAccess {
    Class23(f0: ?Object, f1: ?Object, f2: ?Object, f3: ?Object, f4: ?Object, f5: ?Object) {
        this.f0_weak = match (f0) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
        this.f1 = f1
        this.f2 = f2
        this.f3 = f3
        this.f4 = f4
        this.f5_arr = anyToArrayBox(f5, 4)
    }
    private var f0_weak: ?WeakRef<Object> = None
    var f1: ?Object = None
    var f2: ?Object = None
    var f3: ?Object = None
    var f4: ?Object = None
    private var f5_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 6) {
            case 0 => match (f0_weak) { case Some(w) => w.value; case None => None }
            case 1 => f1
            case 2 => f2
            case 3 => f3
            case 4 => f4
            case 5 => f5_arr
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 6) {
            case 0 => f0_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case 1 => f1 = value
            case 2 => f2 = value
            case 3 => f3 = value
            case 4 => f4 = value
            case 5 => f5_arr = anyToArrayBox(value, 4)
            case _ => error("impossible")
        }
    }
}

class Class24 <: CangjieIndexAccess {
    Class24(f0: ?Object) {
        this.f0_arr = anyToArrayBox(f0, 4)
    }
    private var f0_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 1) {
            case 0 => f0_arr
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 1) {
            case 0 => f0_arr = anyToArrayBox(value, 4)
            case _ => error("impossible")
        }
    }
}

class Class25 <: CangjieIndexAccess {
    Class25(f0: ?Object, f1: ?Object, f2: ?Object, f3: ?Object) {
        this.f0_arr = anyToArrayBox(f0, 4)
        this.f1_weak = match (f1) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
        this.f2_arr = anyToArrayBox(f2, 4)
        this.f3_weak = match (f3) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
    }
    private var f0_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    private var f1_weak: ?WeakRef<Object> = None
    private var f2_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    private var f3_weak: ?WeakRef<Object> = None
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 4) {
            case 0 => f0_arr
            case 1 => match (f1_weak) { case Some(w) => w.value; case None => None }
            case 2 => f2_arr
            case 3 => match (f3_weak) { case Some(w) => w.value; case None => None }
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 4) {
            case 0 => f0_arr = anyToArrayBox(value, 4)
            case 1 => f1_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case 2 => f2_arr = anyToArrayBox(value, 4)
            case 3 => f3_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case _ => error("impossible")
        }
    }
}

class Class26 <: CangjieIndexAccess {
    Class26(f0: ?Object, f1: ?Object) {
        this.f0 = f0
        this.f1 = f1
    }
    var f0: ?Object = None
    var f1: ?Object = None
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 2) {
            case 0 => f0
            case 1 => f1
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 2) {
            case 0 => f0 = value
            case 1 => f1 = value
            case _ => error("impossible")
        }
    }
}

class Class27 <: CangjieIndexAccess {
    Class27(f0: ?Object, f1: ?Object, f2: ?Object, f3: ?Object, f4: ?Object, f5: ?Object, f6: ?Object) {
        this.f0 = f0
        this.f1 = f1
        this.f2_weak = match (f2) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
        this.f3 = f3
        this.f4_weak = match (f4) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
        this.f5 = f5
        this.f6 = f6
    }
    var f0: ?Object = None
    var f1: ?Object = None
    private var f2_weak: ?WeakRef<Object> = None
    var f3: ?Object = None
    private var f4_weak: ?WeakRef<Object> = None
    var f5: ?Object = None
    var f6: ?Object = None
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 7) {
            case 0 => f0
            case 1 => f1
            case 2 => match (f2_weak) { case Some(w) => w.value; case None => None }
            case 3 => f3
            case 4 => match (f4_weak) { case Some(w) => w.value; case None => None }
            case 5 => f5
            case 6 => f6
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 7) {
            case 0 => f0 = value
            case 1 => f1 = value
            case 2 => f2_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case 3 => f3 = value
            case 4 => f4_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case 5 => f5 = value
            case 6 => f6 = value
            case _ => error("impossible")
        }
    }
}

class Class28 <: CangjieIndexAccess {
    Class28(f0: ?Object, f1: ?Object, f2: ?Object, f3: ?Object) {
        this.f0 = f0
        this.f1 = f1
        this.f2 = f2
        this.f3 = f3
    }
    var f0: ?Object = None
    var f1: ?Object = None
    var f2: ?Object = None
    var f3: ?Object = None
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 4) {
            case 0 => f0
            case 1 => f1
            case 2 => f2
            case 3 => f3
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 4) {
            case 0 => f0 = value
            case 1 => f1 = value
            case 2 => f2 = value
            case 3 => f3 = value
            case _ => error("impossible")
        }
    }
}

class Class29 <: CangjieIndexAccess {
    Class29(f0: ?Object, f1: ?Object, f2: ?Object, f3: ?Object, f4: ?Object, f5: ?Object, f6: ?Object) {
        this.f0_arr = anyToArrayBox(f0, 4)
        this.f1 = f1
        this.f2 = f2
        this.f3_arr = anyToArrayBox(f3, 4)
        this.f4 = f4
        this.f5_weak = match (f5) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
        this.f6_arr = anyToArrayBox(f6, 4)
    }
    private var f0_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    var f1: ?Object = None
    var f2: ?Object = None
    private var f3_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    var f4: ?Object = None
    private var f5_weak: ?WeakRef<Object> = None
    private var f6_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 7) {
            case 0 => f0_arr
            case 1 => f1
            case 2 => f2
            case 3 => f3_arr
            case 4 => f4
            case 5 => match (f5_weak) { case Some(w) => w.value; case None => None }
            case 6 => f6_arr
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 7) {
            case 0 => f0_arr = anyToArrayBox(value, 4)
            case 1 => f1 = value
            case 2 => f2 = value
            case 3 => f3_arr = anyToArrayBox(value, 4)
            case 4 => f4 = value
            case 5 => f5_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case 6 => f6_arr = anyToArrayBox(value, 4)
            case _ => error("impossible")
        }
    }
}

class Class30 <: CangjieIndexAccess {
    Class30(f0: ?Object, f1: ?Object, f2: ?Object) {
        this.f0_weak = match (f0) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
        this.f1_arr = anyToArrayBox(f1, 4)
        this.f2_arr = anyToArrayBox(f2, 4)
    }
    private var f0_weak: ?WeakRef<Object> = None
    private var f1_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    private var f2_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 3) {
            case 0 => match (f0_weak) { case Some(w) => w.value; case None => None }
            case 1 => f1_arr
            case 2 => f2_arr
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 3) {
            case 0 => f0_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case 1 => f1_arr = anyToArrayBox(value, 4)
            case 2 => f2_arr = anyToArrayBox(value, 4)
            case _ => error("impossible")
        }
    }
}

class Class31 <: CangjieIndexAccess {
    Class31(f0: ?Object, f1: ?Object, f2: ?Object, f3: ?Object, f4: ?Object, f5: ?Object, f6: ?Object) {
        this.f0_arr = anyToArrayBox(f0, 4)
        this.f1 = f1
        this.f2 = f2
        this.f3 = f3
        this.f4 = f4
        this.f5 = f5
        this.f6_weak = match (f6) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
    }
    private var f0_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    var f1: ?Object = None
    var f2: ?Object = None
    var f3: ?Object = None
    var f4: ?Object = None
    var f5: ?Object = None
    private var f6_weak: ?WeakRef<Object> = None
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 7) {
            case 0 => f0_arr
            case 1 => f1
            case 2 => f2
            case 3 => f3
            case 4 => f4
            case 5 => f5
            case 6 => match (f6_weak) { case Some(w) => w.value; case None => None }
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 7) {
            case 0 => f0_arr = anyToArrayBox(value, 4)
            case 1 => f1 = value
            case 2 => f2 = value
            case 3 => f3 = value
            case 4 => f4 = value
            case 5 => f5 = value
            case 6 => f6_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case _ => error("impossible")
        }
    }
}

class Class33 <: CangjieIndexAccess {
    Class33(f0: ?Object, f1: ?Object, f2: ?Object, f3: ?Object, f4: ?Object, f5: ?Object, f6: ?Object, f7: ?Object, f8: ?Object, f9: ?Object, f10: ?Object, f11: ?Object, f12: ?Object, f13: ?Object, f14: ?Object, f15: ?Object, f16: ?Object, f17: ?Object, f18: ?Object, f19: ?Object) {
        this.f0_weak = match (f0) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
        this.f1 = f1
        this.f2_arr = anyToArrayBox(f2, 4)
        this.f3 = f3
        this.f4 = f4
        this.f5 = f5
        this.f6_weak = match (f6) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
        this.f7 = f7
        this.f8 = f8
        this.f9 = f9
        this.f10 = f10
        this.f11 = f11
        this.f12 = f12
        this.f13_arr = anyToArrayBox(f13, 4)
        this.f14_arr = anyToArrayBox(f14, 4)
        this.f15_arr = anyToArrayBox(f15, 4)
        this.f16_weak = match (f16) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
        this.f17 = f17
        this.f18_weak = match (f18) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
        this.f19 = f19
    }
    private var f0_weak: ?WeakRef<Object> = None
    var f1: ?Object = None
    private var f2_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    var f3: ?Object = None
    var f4: ?Object = None
    var f5: ?Object = None
    private var f6_weak: ?WeakRef<Object> = None
    var f7: ?Object = None
    var f8: ?Object = None
    var f9: ?Object = None
    var f10: ?Object = None
    var f11: ?Object = None
    var f12: ?Object = None
    private var f13_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    private var f14_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    private var f15_arr: CangjieArrayBox = CangjieArrayBox(4, None)
    private var f16_weak: ?WeakRef<Object> = None
    var f17: ?Object = None
    private var f18_weak: ?WeakRef<Object> = None
    var f19: ?Object = None
    override public func loadCangjieField(index: Int64): ?Object {
        return match (index % 20) {
            case 0 => match (f0_weak) { case Some(w) => w.value; case None => None }
            case 1 => f1
            case 2 => f2_arr
            case 3 => f3
            case 4 => f4
            case 5 => f5
            case 6 => match (f6_weak) { case Some(w) => w.value; case None => None }
            case 7 => f7
            case 8 => f8
            case 9 => f9
            case 10 => f10
            case 11 => f11
            case 12 => f12
            case 13 => f13_arr
            case 14 => f14_arr
            case 15 => f15_arr
            case 16 => match (f16_weak) { case Some(w) => w.value; case None => None }
            case 17 => f17
            case 18 => match (f18_weak) { case Some(w) => w.value; case None => None }
            case 19 => f19
            case _ => None
        }
    }

    override public func storeCangjieField(index: Int64, value: ?Object) {
        match (index % 20) {
            case 0 => f0_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case 1 => f1 = value
            case 2 => f2_arr = anyToArrayBox(value, 4)
            case 3 => f3 = value
            case 4 => f4 = value
            case 5 => f5 = value
            case 6 => f6_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case 7 => f7 = value
            case 8 => f8 = value
            case 9 => f9 = value
            case 10 => f10 = value
            case 11 => f11 = value
            case 12 => f12 = value
            case 13 => f13_arr = anyToArrayBox(value, 4)
            case 14 => f14_arr = anyToArrayBox(value, 4)
            case 15 => f15_arr = anyToArrayBox(value, 4)
            case 16 => f16_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case 17 => f17 = value
            case 18 => f18_weak = match (value) { case Some(obj) => Some(WeakRef<Object>(obj, CleanupPolicy.EAGER)); case None => None }
            case 19 => f19 = value
            case _ => error("impossible")
        }
    }
}


func fun34(localsCount: Int64, l0: ?Object, l1: ?Object, l2: ?Object, l3: ?Object, l4: ?Object, l5: ?Object): ?Object {
    try {
        let l6 = LocalBox(alloc({ => Class23(None, None, None, None, None, None) }))
        g8.storeField(0, l6.value)
        let l7 = LocalBox(alloc({ => Class30(None, None, None) }))
        g8.storeField(0, l7.value)
        let l8 = LocalBox(alloc({ => Class24(None) }))
        g8.storeField(0, l8.value)
        let l9 = LocalBox(alloc({ => Class29(None, None, None, None, None, None, None) }))
        g8.storeField(0, l9.value)
        let l10 = LocalBox(g8.loadField(0).loadField(0))
        let l11 = LocalBox(l3.loadField(6291351558286336806).loadField(6345224424739710493).loadField(8736796685684332))
        let l12 = LocalBox(alloc({ => Class28(None, None, None, None) }))
        let l13 = LocalBox(g16.loadField(0).loadField(2946849264662110978).loadField(2692698032465576478).loadField(4267277367584708332))
        g4.loadField(4213863532732755683).loadField(2433756424882952594).storeField(4965944536883985932, g7.loadField(0).loadField(5471622132911536834).loadField(6791644145777318399).loadField(3712155059375492743).loadField(955421721984641979))
        performGC()
        let l14 = LocalBox(alloc({ => Class25(None, None, None, None) }))
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun35(localsCount: Int64, l0: ?Object, l1: ?Object): ?Object {
    try {
        g16.loadField(4601590044521928003).loadField(3351343922912923094).loadField(754083423289357664).storeField(7495664533577544683, l0.loadField(5485418926826056539))
        spawnThread {
            if (shouldTerminate()) { return }
            spawnThread {
                if (shouldTerminate()) { return }
                getGCCount()
                getGCFreedSize()
                getGCTime()
                getGCCount()
                getGCFreedSize()
                getGCTime()
                for (_ in 0..7) {
                    if (shouldTerminate()) { break }
                    alloc({ => Class25(None, None, None, None) })
                }
                getGCCount()
                getGCFreedSize()
                getGCTime()
                performGC()
                getGCCount()
                getGCFreedSize()
                getGCTime()
                getGCCount()
                getGCFreedSize()
                getGCTime()
                for (_ in 0..7) {
                    if (shouldTerminate()) { break }
                    alloc({ => Class25(None, None, None, None) })
                }
                getGCCount()
                getGCFreedSize()
                getGCTime()
            }
            spawnThread {
                if (shouldTerminate()) { return }
                for (_ in 0..14) {
                    if (shouldTerminate()) { break }
                    alloc({ => Class25(None, None, None, None) })
                }
                performGC()
                for (_ in 0..7) {
                    if (shouldTerminate()) { break }
                    alloc({ => Class25(None, None, None, None) })
                }
                performGC()
                for (_ in 0..14) {
                    if (shouldTerminate()) { break }
                    alloc({ => Class25(None, None, None, None) })
                }
                performGC()
            }
        }
        for (_ in 0..21) {
            if (shouldTerminate()) { break }
            alloc({ => Class25(None, None, None, None) })
        }
        performGC()
        for (_ in 0..7) {
            if (shouldTerminate()) { break }
            alloc({ => Class25(None, None, None, None) })
        }
        getGCCount()
        getGCFreedSize()
        getGCTime()
        performGC()
        let l2 = LocalBox(g11.loadField(8219719524253261522).loadField(3241630227637869645).loadField(8900499720740714451).loadField(2037449147525964896).loadField(5501342095719102595).loadField(2378288734674576531).loadField(7877165468117259749))
        let l3 = LocalBox(call(localsCount, 10, { it => fun37(it, l1.loadField(4336533588498765206), g4.loadField(0), None, None, None, None, None) }))
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun36(localsCount: Int64, l0: ?Object, l1: ?Object): ?Object {
    try {
        let l2 = LocalBox(alloc({ => Class22(None, None, None, None, None) }))
        l2.value.loadField(4669701530622623675).loadField(7062148321283900439).storeField(4546898003650237552, g10.loadField(0).loadField(7796166363767203590))
        spawnThread {
            if (shouldTerminate()) { return }
            let localsCount = 0
            call(localsCount, 10, { it => fun43(it, g6.loadField(5130213333351231408).loadField(5963697982670195660).loadField(6576201001591381150).loadField(6029798714644782883), l2.value.loadField(3175126637704160111).loadField(7885764690187768830).loadField(555328416940473486).loadField(416388450467069723), l1.loadField(6546813064857096958).loadField(8232344240371592964).loadField(3129745635738803854).loadField(605675684358761122)) })
        }
        spawnThread {
            if (shouldTerminate()) { return }
            let localsCount = 0
            call(localsCount, 11, { it => fun48(it, g3.loadField(7380839587529382288).loadField(4127814084349701586).loadField(3327008091645096288), l0) })
        }
        spawnThread {
            if (shouldTerminate()) { return }
            spawnThread {
                if (shouldTerminate()) { return }
                for (_ in 0..13) {
                    if (shouldTerminate()) { break }
                    alloc({ => Class20(None, None, None, None) })
                }
                performGC()
                for (_ in 0..5) {
                    if (shouldTerminate()) { break }
                    alloc({ => Class20(None, None, None, None) })
                }
                performGC()
                for (_ in 0..13) {
                    if (shouldTerminate()) { break }
                    alloc({ => Class20(None, None, None, None) })
                }
                performGC()
            }
            spawnThread {
                if (shouldTerminate()) { return }
                for (_ in 0..5) {
                    if (shouldTerminate()) { break }
                    alloc({ => Class20(None, None, None, None) })
                }
                performGC()
                for (_ in 0..13) {
                    if (shouldTerminate()) { break }
                    alloc({ => Class20(None, None, None, None) })
                }
                performGC()
                for (_ in 0..13) {
                    if (shouldTerminate()) { break }
                    alloc({ => Class20(None, None, None, None) })
                }
                performGC()
            }
        }
        for (_ in 0..5) {
            if (shouldTerminate()) { break }
            alloc({ => Class20(None, None, None, None) })
        }
        performGC()
        for (_ in 0..13) {
            if (shouldTerminate()) { break }
            alloc({ => Class20(None, None, None, None) })
        }
        performGC()
        spawnThread {
            if (shouldTerminate()) { return }
            let localsCount = 0
            call(localsCount, 12, { it => fun45(it, l2.value.loadField(5931777701110050101).loadField(5450793587020884348).loadField(6751971678279325398).loadField(723683442131088994).loadField(4392130254150349527).loadField(5653016542121837991)) })
        }
        let l3 = LocalBox(g8.loadField(0).loadField(8217722022608210842).loadField(4808780850796214776).loadField(5399899934386339916).loadField(1785339074301008811))
        try {
            let l4 = LocalBox(g18.loadField(0))
        }
        finally {
            performGC()
            for (_ in 0..13) {
                if (shouldTerminate()) { break }
                alloc({ => Class29(None, None, None, None, None, None, None) })
            }
        }
        let l4 = LocalBox(call(localsCount, 4, { it => fun35(it, g14.loadField(5174145763221374062).loadField(1326257724371994917).loadField(9158411534344731303).loadField(3633673683300486052).loadField(8108644332960925553), l1.loadField(7088234110166662448).loadField(7920237294507342926).loadField(7245600785048054427).loadField(5456131856334582684).loadField(1010752084240593625).loadField(8572848995516670910)) }))
        for (_ in 0..35) {
            if (shouldTerminate()) { break }
            alloc({ => Class30(None, None, None) })
        }
        g10.storeField(4376894483243749490, l4.value.loadField(2495623244649869331).loadField(5553109791431865216).loadField(396413123977868812).loadField(3784659845740094))
        spawnThread {
            if (shouldTerminate()) { return }
            let localsCount = 0
            call(localsCount, 10, { it => fun43(it, g11.loadField(203700717106909572).loadField(3027860501897232653), g18.loadField(0).loadField(761802485681329051), g1.loadField(2421901961457563838)) })
        }
        let l5 = LocalBox(alloc({ => Class27(None, None, None, None, None, None, None) }))
        performGC()
        if (anyToBool(g18.loadField(0).loadField(3951290084617264982).loadField(5878841455025302307).loadField(4167607726263818493))) {
            let l6 = LocalBox(alloc({ => Class28(None, None, None, None) }))
        }
        else {
            spawnThread {
                if (shouldTerminate()) { return }
                let localsCount = 0
                call(localsCount, 10, { it => fun44(it, g10.loadField(0).loadField(6650057247043678872).loadField(5500838729776667997).loadField(7291314566898789490).loadField(5634119990666837843).loadField(8432444207500166669).loadField(1855270934342360924).loadField(8090267859749213654).loadField(513520459826118255).loadField(6430714015382123522).loadField(8058062548968310732).loadField(2737952387677964695).loadField(5777270952103417569).loadField(3775780510863690658).loadField(5146766067289646232).loadField(8594655314152913407).loadField(6121746472552465399).loadField(3569217195896366026).loadField(7962809382267691726).loadField(3654341845035150197)) })
            }
        }
        return l5.value.loadField(8222252808140723486).loadField(1667440657326051992)
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun37(localsCount: Int64, l0: ?Object, l1: ?Object, l2: ?Object, l3: ?Object, l4: ?Object, l5: ?Object, l6: ?Object): ?Object {
    try {
        g16.loadField(3616783627610043987).loadField(3016297654960828488).storeField(1650669720119605115, g6.loadField(4015557964551915070).loadField(923688169015993913).loadField(5506940973749851858))
        try {
            g0.loadField(6224795939490059273).loadField(5859488536994185901).storeField(6660400895239321851, g7.loadField(0).loadField(2191916976450833008))
            let l7 = LocalBox(g14)
            let l8 = LocalBox(alloc({ => Class30(None, None, None) }))
        }
        finally {
            performGC()
            for (_ in 0..9) {
                if (shouldTerminate()) { break }
                alloc({ => Class31(None, None, None, None, None, None, None) })
            }
        }
        let l7 = LocalBox(call(localsCount, 4, { it => fun35(it, g3.loadField(1960945792848169205), l1.loadField(6992668916953530099).loadField(746416377809028921).loadField(2069802651864324890).loadField(174640383683264192).loadField(7776679935267761173).loadField(7418088025041467722)) }))
        performGC()
        g16.storeField(0, l4.loadField(6242043803148998151).loadField(4707141010668489363).loadField(3274659428470624178))
        g10.loadField(1500898157587592462).loadField(6256500065098364508).loadField(6794108827552528772).loadField(356949836413981012).storeField(4626829145683287160, l0.loadField(5351308698558285954).loadField(7476935802521116729).loadField(8747172357981390244))
        g8.loadField(647553165172014721).loadField(8354334365946009314).loadField(4818269701716147595).storeField(6398774025328481824, g3.loadField(1938205902966772661).loadField(2833251478612857867))
        try {
            spawnThread {
                if (shouldTerminate()) { return }
                let localsCount = 0
                call(localsCount, 6, { it => fun39(it, l5.loadField(8783998595091409312).loadField(4855067420447156751)) })
            }
            g0.storeField(34335788124607036, l1.loadField(2165890588471179420).loadField(6852618623902734357))
            performGC()
        }
        finally {
            performGC()
            for (_ in 0..11) {
                if (shouldTerminate()) { break }
                alloc({ => Class31(None, None, None, None, None, None, None) })
            }
        }
        throw Exception("fuzz throw")
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun38(localsCount: Int64, l0: ?Object, l1: ?Object, l2: ?Object): ?Object {
    try {
        let l3 = LocalBox(l1.loadField(2481422180876416484).loadField(2787141509377994130).loadField(8002454681061791304).loadField(7156907508923236991).loadField(5532619763216083151))
        let l4 = LocalBox(call(localsCount, 10, { it => fun37(it, l1.loadField(7304105304229236871).loadField(8876450789919980619).loadField(472902713061439353).loadField(4741638812687755769).loadField(3713812221573066858).loadField(1000029370159680071).loadField(6239655419281101643).loadField(5958593968138423992).loadField(8904164943995326084).loadField(6972104070017348553).loadField(256662454843972489).loadField(930425040634757576).loadField(8803267425993982004).loadField(4102671931850493130).loadField(6664788039846221264).loadField(4525493264730374382).loadField(2035617955250241720).loadField(8634396615766198697).loadField(5896609794220415336), None, None, None, None, None, None) }))
        try {
            let l5 = LocalBox(alloc({ => Class19(None, None, None, None, None, None) }))
            g13.loadField(5254711906133185746).loadField(833380551173363939).loadField(4495724270996208679).storeField(1790575698830231790, l5.value.loadField(15736352045067399).loadField(5159623583837631839).loadField(956977738053315313).loadField(8070167677133997111))
            let l6 = LocalBox(alloc({ => Class22(None, None, None, None, None) }))
            let l7 = LocalBox(alloc({ => Class28(None, None, None, None) }))
        }
        finally {
            performGC()
            for (_ in 0..6) {
                if (shouldTerminate()) { break }
                alloc({ => Class20(None, None, None, None) })
            }
        }
        g2.storeField(5711453953330204804, l1.loadField(4133567573202093408))
        let l5 = LocalBox(call(localsCount, 10, { it => fun43(it, g13, None, None) }))
        let l6 = LocalBox(alloc({ => Class31(None, None, None, None, None, None, None) }))
        spawnThread {
            if (shouldTerminate()) { return }
            let localsCount = 0
            call(localsCount, 15, { it => fun34(it, g13.loadField(1240837801204284158).loadField(597355105917777993).loadField(4696484425887799305).loadField(1216774729911426323).loadField(7140420636739614977), l1.loadField(7466576960128908592).loadField(7841461394412790706), None, None, None, None) })
        }
        l5.value.storeField(1801305200259725410, g7.loadField(0).loadField(4520194693563097907).loadField(3368392696383161926).loadField(5914301511207271939).loadField(8007907957441727959))
        let l7 = LocalBox(call(localsCount, 8, { it => fun47(it, l6.value.loadField(5735708115979465169).loadField(1993031877022683845).loadField(8171273766882771619).loadField(4452204656455802817).loadField(3440454438088785021), g2.loadField(0).loadField(6182606817069885266).loadField(3152934516175933088).loadField(2805280018154504919).loadField(8739491149951379044).loadField(6917583626211961605).loadField(8150013853060278655), l4.value.loadField(1834523127899845508).loadField(8977174387026374189).loadField(3627788986897761455).loadField(9163129416084874312).loadField(4774556742877589794).loadField(5771712297451594597).loadField(1930178032603301019)) }))
        for (_ in 0..49) {
            if (shouldTerminate()) { break }
            alloc({ => Class31(None, None, None, None, None, None, None) })
        }
        let l8 = LocalBox(alloc({ => Class29(None, None, None, None, None, None, None) }))
        run {
            let l9 = LocalBox(g3.loadField(2622845810960836351).loadField(3646179420299893074))
        }
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun39(localsCount: Int64, l0: ?Object): ?Object {
    try {
        let l1 = LocalBox(call(localsCount, 8, { it => fun36(it, None, None) }))
        for (_ in 0..17) {
            if (shouldTerminate()) { break }
            alloc({ => Class24(None) })
        }
        l1.value.loadField(2525539540998242721).loadField(3628780485160447724).storeField(8801860228441107589, g11)
        performGC()
        let l2 = LocalBox(alloc({ => Class33(None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None) }))
        g5.loadField(1175377249543515564).loadField(1226406695721022661).storeField(7777268416856728749, g9.loadField(8823908126907091280).loadField(4228639759210227057).loadField(1892986262900642514))
        try {
            spawnThread {
                if (shouldTerminate()) { return }
                let localsCount = 0
                call(localsCount, 13, { it => fun46(it, l1.value.loadField(1353249295835169158), g15.loadField(0).loadField(1978341257774621963).loadField(4425927231512459887).loadField(83999011269460898).loadField(4889350376146668231).loadField(3628256432780526667).loadField(1141961076560519608).loadField(950316703371375058).loadField(2391743042938833933)) })
            }
            let l3 = LocalBox(None<Object>)
            let l4 = LocalBox(call(localsCount, 10, { it => fun44(it, l2.value.loadField(8657865003896683140)) }))
            let l5 = LocalBox(call(localsCount, 12, { it => fun45(it, l0.loadField(6482264766059004591).loadField(91659760638863131).loadField(7442806519677770396).loadField(3933638825327319723).loadField(6649964477645320579)) }))
        }
        finally {
            performGC()
            for (_ in 0..14) {
                if (shouldTerminate()) { break }
                alloc({ => Class23(None, None, None, None, None, None) })
            }
        }
        for (_ in 0..8) {
            if (shouldTerminate()) { break }
            alloc({ => Class24(None) })
        }
        g4.loadField(3585948561195349108).loadField(981691804313898158).loadField(6519436052164802971).storeField(1286856100885602108, g1.loadField(6039129731777708261))
        return l1.value.loadField(3924066289288933219)
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun40(localsCount: Int64, l0: ?Object): ?Object {
    try {
        if (anyToBool(l0.loadField(8261416295992553743).loadField(3768446369271168783).loadField(8778741270959079240))) {
            for (_ in 0..44) {
                if (shouldTerminate()) { break }
                alloc({ => Class22(None, None, None, None, None) })
            }
        }
        else {
            let l1 = LocalBox(l0.loadField(5289074623533187143))
            l1.value.loadField(5004818414067048941).loadField(8024713011581290197).loadField(7680643673954490925).loadField(727943924814018470).loadField(1317936171446454500).storeField(6392527368192226148, l0.loadField(3651200250092856458).loadField(4028358103561608497).loadField(7787725881840879677))
            let l2 = LocalBox(alloc({ => Class23(None, None, None, None, None, None) }))
        }
        performGC()
        spawnThread {
            if (shouldTerminate()) { return }
            let localsCount = 0
            call(localsCount, 13, { it => fun38(it, g10.loadField(0).loadField(1320391674423817970).loadField(5550713191923567163).loadField(2919732314204521732), g13.loadField(3553206309923530137).loadField(598831038643232857).loadField(5306033361953590279), g17.loadField(4537078063317570458).loadField(1045865312108341939).loadField(4372022057648412717).loadField(7554381030295878806).loadField(9051761343174688392).loadField(4587076857475424521).loadField(7163368110420585475).loadField(166321478623161396)) })
        }
        let l1 = LocalBox(alloc({ => Class24(None) }))
        let l2 = LocalBox(call(localsCount, 13, { it => fun42(it, g15.loadField(0).loadField(4817064690498803187).loadField(3215734960033205700).loadField(8313695491440049060), None) }))
        let l3 = LocalBox(alloc({ => Class24(None) }))
        let l4 = LocalBox(alloc({ => Class23(None, None, None, None, None, None) }))
        l3.value.loadField(0).storeField(2, l4.value)
        let l5 = LocalBox(alloc({ => Class29(None, None, None, None, None, None, None) }))
        l4.value.loadField(0).storeField(3, l5.value)
        let l6 = LocalBox(alloc({ => Class30(None, None, None) }))
        l5.value.loadField(0).storeField(0, l6.value)
        let l7 = LocalBox(alloc({ => Class24(None) }))
        l6.value.loadField(0).storeField(1, l7.value)
        l7.value.storeField(0, l3.value)
        let l8 = LocalBox(alloc({ => Class22(None, None, None, None, None) }))
        l7.value.loadField(0).storeField(0, l8.value)
        l8.value.storeField(0, l3.value)
        let l9 = LocalBox(alloc({ => Class27(None, None, None, None, None, None, None) }))
        l8.value.loadField(0).storeField(0, l9.value)
        performGC()
        let l10 = LocalBox(g6.loadField(4219065597581636658).loadField(7654769030986421227).loadField(5558702497750370416).loadField(1542316172177062833).loadField(4815003874350559428).loadField(851275187544000094).loadField(7727501656867034253))
        let l11 = LocalBox(l4.value.loadField(4471735422737132600).loadField(6331051028775111784).loadField(8859039990639434609).loadField(5726488112198100240))
        try {
            let l12 = LocalBox(alloc({ => Class25(None, None, None, None) }))
        }
        finally {
            performGC()
            for (_ in 0..9) {
                if (shouldTerminate()) { break }
                alloc({ => Class25(None, None, None, None) })
            }
        }
        let l12 = LocalBox(g1.loadField(2436179212865646795).loadField(7981063638910597238).loadField(4554413393104978850))
        let l13 = LocalBox(l5.value)
        let l14 = LocalBox(g1.loadField(1494437624420095013).loadField(6395098427742193539).loadField(8177134112950276704))
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun41(localsCount: Int64, l0: ?Object, l1: ?Object): ?Object {
    try {
        try {
            g12.loadField(6482144753869946165).loadField(5961821091826418516).storeField(1016651182986090293, g15.loadField(0).loadField(2386135044561447234).loadField(5008515604037867607).loadField(8602045181590366394))
            let l2 = LocalBox(call(localsCount, 8, { it => fun36(it, g17.loadField(1424646383302199329).loadField(2945147551901059103).loadField(9175135340134762722), g5.loadField(5637729782127717173).loadField(998756385775758026).loadField(3498789900140684918)) }))
            let l3 = LocalBox(call(localsCount, 13, { it => fun38(it, g4.loadField(0).loadField(7121506036916635258), g13.loadField(6339957114919450489).loadField(7077606554578517213).loadField(4696453674327759246).loadField(6324322140731738366).loadField(4160942864725694581).loadField(5839584343898616879).loadField(8076275392333169165), l1.loadField(9183542721158075858).loadField(1172829069705410915).loadField(8607949489731856063).loadField(8849041310482194563).loadField(6429273166274155552).loadField(4957195291823675252).loadField(5817799879154391085)) }))
        }
        finally {
            performGC()
            for (_ in 0..4) {
                if (shouldTerminate()) { break }
                alloc({ => Class28(None, None, None, None) })
            }
        }
        let l2 = LocalBox(alloc({ => Class22(None, None, None, None, None) }))
        let l3 = LocalBox(alloc({ => Class31(None, None, None, None, None, None, None) }))
        l3.value.storeField(0, l2.value)
        let l4 = LocalBox(alloc({ => Class33(None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None) }))
        l4.value.storeField(0, l2.value)
        let l5 = LocalBox(alloc({ => Class31(None, None, None, None, None, None, None) }))
        try {
            let l6 = LocalBox(call(localsCount, 13, { it => fun38(it, l5.value.loadField(6829595530261130039).loadField(2379979547350501852).loadField(8399242597582035245).loadField(7311312279054431032).loadField(7699786411392438930).loadField(801811368587493017), g1.loadField(1737064881464719347), None) }))
            let l7 = LocalBox(alloc({ => Class28(None, None, None, None) }))
        }
        finally {
            performGC()
            for (_ in 0..13) {
                if (shouldTerminate()) { break }
                alloc({ => Class24(None) })
            }
        }
        l4.value = g15.loadField(0).loadField(2664862272939166217).loadField(5089925998124148437).loadField(5565406307710713057).loadField(7795104436009706351).loadField(6072553279840658640)
        performGC()
        l3.value.storeField(9120422068431416924, g11.loadField(4622255439293205708))
        let l6 = LocalBox(alloc({ => Class30(None, None, None) }))
        if (anyToBool(l5.value.loadField(8238811789310091136).loadField(222019440201059457).loadField(7058616175932166928))) {
            let l7 = LocalBox(alloc({ => Class21(None) }))
            let l8 = LocalBox(alloc({ => Class23(None, None, None, None, None, None) }))
            spawnThread {
                if (shouldTerminate()) { return }
                let localsCount = 0
                call(localsCount, 8, { it => fun47(it, l1.loadField(4258790795917634526).loadField(889703401298174925).loadField(709626417404380452).loadField(8095477799116075796).loadField(7103163424592752560).loadField(7099276774220396293), l7.value.loadField(5199768815893956341).loadField(3871698578330614176).loadField(8557251220858623601), l1.loadField(8203905249589358838).loadField(2803954443619830557).loadField(5793713320281369838).loadField(7345462125360573132)) })
            }
            spawnThread {
                if (shouldTerminate()) { return }
                let localsCount = 0
                call(localsCount, 13, { it => fun38(it, None, None, None) })
            }
        }
        else {
            let l7 = LocalBox(alloc({ => Class23(None, None, None, None, None, None) }))
            let l8 = LocalBox(alloc({ => Class22(None, None, None, None, None) }))
            let l9 = LocalBox(alloc({ => Class25(None, None, None, None) }))
            let l10 = LocalBox(g8.loadField(0).loadField(6853905331944752705).loadField(4832011944261706440).loadField(413620014928461029))
        }
        g8.storeField(5217257981994010332, l1.loadField(8781776849838013732).loadField(2211376521741610990).loadField(1193298824962925239).loadField(6623783937163441912).loadField(1334244328032889805).loadField(6641637585502233057))
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun42(localsCount: Int64, l0: ?Object, l1: ?Object): ?Object {
    try {
        let l2 = LocalBox(call(localsCount, 6, { it => fun39(it, g17.loadField(4771851508234141812).loadField(7679171298188315623).loadField(1883549389772527521).loadField(6344522456967249746).loadField(2726935444768067542).loadField(5906611283796834537).loadField(5643943164489454976).loadField(8469756125594846685)) }))
        try {
            let l3 = LocalBox(alloc({ => Class23(None, None, None, None, None, None) }))
        }
        finally {
            performGC()
            for (_ in 0..5) {
                if (shouldTerminate()) { break }
                alloc({ => Class19(None, None, None, None, None, None) })
            }
        }
        let l3 = LocalBox(alloc({ => Class21(None) }))
        l2.value = g16.loadField(0).loadField(5537123105738952541).loadField(8904565825423616632).loadField(4410981757119392263).loadField(6004336684727823115).loadField(3376663807504652542)
        l2.value.loadField(8077880601905775890).loadField(7862265050075786386).storeField(4146900349037376411, g5.loadField(9033706532794396522))
        g13.storeField(637650418731203000, g18.loadField(0).loadField(8991863596422771977).loadField(5997480407867886021))
        let l4 = LocalBox(alloc({ => Class23(None, None, None, None, None, None) }))
        spawnThread {
            if (shouldTerminate()) { return }
            let localsCount = 0
            call(localsCount, 18, { it => fun40(it, g12.loadField(0)) })
        }
        for (_ in 0..60) {
            if (shouldTerminate()) { break }
            alloc({ => Class23(None, None, None, None, None, None) })
        }
        let l5 = LocalBox(alloc({ => Class20(None, None, None, None) }))
        let l6 = LocalBox(alloc({ => Class33(None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None) }))
        g12.storeField(0, l5.value)
        g12.storeField(0, l6.value)
        l6.value = None
        g12.storeField(0, None)
        performGC()
        let l7 = LocalBox(g1.loadField(0))
        l5.value.loadField(3180293115676053423).storeField(3244109561948401573, g3.loadField(6959266856466880987).loadField(7602828548055636793).loadField(5349356232399250773).loadField(4268749628257568846).loadField(1861282805790460589))
        run {
            let l8 = LocalBox(alloc({ => Class30(None, None, None) }))
            g2.storeField(4581401554703248035, l2.value.loadField(794167157030388011).loadField(5373216687761481088).loadField(6100588607688214658).loadField(4112358058120369862))
            let l9 = LocalBox(call(localsCount, 10, { it => fun43(it, g12.loadField(0).loadField(7844180871393749351).loadField(1816812338989724303).loadField(4242140175149100443).loadField(1632217686150457821).loadField(3277193914884485405).loadField(3592225773804900628).loadField(771390411234532584).loadField(3594501236684077615), g3.loadField(6393067824322241989).loadField(480854923209859330).loadField(5946506022547983327), None) }))
            g9.loadField(1604659564055172850).storeField(2107777789343871750, g12.loadField(0).loadField(1495957576678800316).loadField(6873218301126648693).loadField(4346710683822214486).loadField(9015552601592225898).loadField(4041036577716509746).loadField(6881699969781729801))
            g3.storeField(8896292101125660691, g1.loadField(5020636632839803304).loadField(1787429397944146963).loadField(7132001086422110176).loadField(8020273368225582684).loadField(5290608527528499167))
        }
        let l8 = LocalBox(alloc({ => Class22(None, None, None, None, None) }))
        let l9 = LocalBox(alloc({ => Class26(None, None) }))
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun43(localsCount: Int64, l0: ?Object, l1: ?Object, l2: ?Object): ?Object {
    try {
        let l3 = LocalBox(call(localsCount, 4, { it => fun35(it, g4.loadField(0), None) }))
        g9.storeField(1678348266218268293, l3.value.loadField(5367502484901975339))
        let l4 = LocalBox(alloc({ => Class20(None, None, None, None) }))
        let l5 = LocalBox(alloc({ => Class19(None, None, None, None, None, None) }))
        l4.value.storeField(0, l5.value)
        g10.storeField(0, l4.value)
        performGC()
        let l6 = LocalBox(alloc({ => Class30(None, None, None) }))
        l5.value.storeField(0, l6.value)
        g10.storeField(0, l5.value)
        performGC()
        let l7 = LocalBox(alloc({ => Class26(None, None) }))
        l6.value.storeField(0, l7.value)
        g10.storeField(0, l6.value)
        performGC()
        let l8 = LocalBox(g10.loadField(0).loadField(0))
        spawnThread {
            if (shouldTerminate()) { return }
            let localsCount = 0
            call(localsCount, 15, { it => fun41(it, l1.loadField(2618449112882864714).loadField(927532497690112487).loadField(1152142075694832211).loadField(3155462521352177689), g2.loadField(0).loadField(2446138047135082262).loadField(675860504694191249)) })
        }
        let l9 = LocalBox(alloc({ => Class29(None, None, None, None, None, None, None) }))
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun44(localsCount: Int64, l0: ?Object): ?Object {
    try {
        let l1 = LocalBox(g0.loadField(1120294756048291076).loadField(211974676898193850))
        let l2 = LocalBox(alloc({ => Class21(None) }))
        spawnThread {
            if (shouldTerminate()) { return }
            let localsCount = 0
            call(localsCount, 13, { it => fun38(it, l2.value.loadField(2833552226726490834), None, None) })
        }
        let l3 = LocalBox(alloc({ => Class29(None, None, None, None, None, None, None) }))
        let l4 = LocalBox(alloc({ => Class30(None, None, None) }))
        let l5 = LocalBox(alloc({ => Class25(None, None, None, None) }))
        let l6 = LocalBox(alloc({ => Class24(None) }))
        let l7 = LocalBox(alloc({ => Class27(None, None, None, None, None, None, None) }))
        let l8 = LocalBox(alloc({ => Class23(None, None, None, None, None, None) }))
        l3.value.storeField(0, l4.value)
        l4.value.storeField(0, l5.value)
        l5.value.storeField(0, l6.value)
        l6.value.storeField(0, l7.value)
        l7.value.storeField(0, l8.value)
        l8.value.storeField(0, l3.value)
        spawnThread {
            if (shouldTerminate()) { return }
            let localsCount = 0
            call(localsCount, 8, { it => fun47(it, g13.loadField(3520880252447328740), None, None) })
        }
        let l9 = LocalBox(alloc({ => Class27(None, None, None, None, None, None, None) }))
        l8.value.loadField(1641387813351039554).loadField(4233884562859487928).storeField(2830678412385621568, l5.value.loadField(8371289051148642488).loadField(873223176396974174).loadField(8810387037097738775).loadField(1709898123763837854))
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun45(localsCount: Int64, l0: ?Object): ?Object {
    try {
        if (anyToBool(g11.loadField(3631843850369523048))) {
            let l1 = LocalBox(call(localsCount, 13, { it => fun46(it, g3.loadField(8866877910638939376).loadField(8119324680255028091).loadField(1562557520258368846).loadField(218188962791835985), l0.loadField(2229971947866320661)) }))
        }
        else {
            let l1 = LocalBox(call(localsCount, 13, { it => fun46(it, None, None) }))
            let l2 = LocalBox(call(localsCount, 13, { it => fun42(it, g8.loadField(0).loadField(6972788543653127371).loadField(4435384146711591278).loadField(2517065377633727119), None) }))
            let l3 = LocalBox(call(localsCount, 13, { it => fun38(it, g17.loadField(2842577567753975291).loadField(1724923032447283238).loadField(8988958732653040042).loadField(7486739700114491611), g17.loadField(7285063941979636043).loadField(5993223103273285934), None) }))
            spawnThread {
                if (shouldTerminate()) { return }
                let localsCount = 0
                call(localsCount, 4, { it => fun35(it, g13, None) })
            }
        }
        let l1 = LocalBox(alloc({ => Class21(None) }))
        g11 = l1.value
        let l2 = LocalBox(None<Object>)
        g11.storeField(0, l2.value)
        let l3 = LocalBox(alloc({ => Class27(None, None, None, None, None, None, None) }))
        g11.storeField(0, l3.value)
        let l4 = LocalBox(g11.loadField(0))
        let l5 = LocalBox(call(localsCount, 13, { it => fun42(it, g6.loadField(3406959269883685450).loadField(1073527840863548229).loadField(5207428493546337067).loadField(826780062171573983), None) }))
        for (_ in 0..17) {
            if (shouldTerminate()) { break }
            alloc({ => Class30(None, None, None) })
        }
        if (anyToBool(g13.loadField(7733036719717929322).loadField(934996300873670072).loadField(2911520897769496087).loadField(6296291822340371132).loadField(5260459377380739647).loadField(449800326726766085).loadField(887156741849633532))) {
            spawnThread {
                if (shouldTerminate()) { return }
                let localsCount = 0
                call(localsCount, 13, { it => fun46(it, g9.loadField(1677413912680240186).loadField(5390616129882303805).loadField(5228633023494618712).loadField(4190707551223528692).loadField(3139859355389544930), g6.loadField(5930231901705292621)) })
            }
            let l6 = LocalBox(alloc({ => Class27(None, None, None, None, None, None, None) }))
        }
        else {
            let l6 = LocalBox(g3)
        }
        l2.value.storeField(7418455231281405825, l0.loadField(5745472794607698752).loadField(4056282756087940618).loadField(6833866033538764475).loadField(1155554978324428777).loadField(1424064602308051233).loadField(1013681433564207292))
        for (_ in 0..57) {
            if (shouldTerminate()) { break }
            alloc({ => Class24(None) })
        }
        if (anyToBool(g18.loadField(0))) {
            spawnThread {
                if (shouldTerminate()) { return }
                let localsCount = 0
                call(localsCount, 13, { it => fun42(it, None, None) })
            }
        }
        else {
            l2.value.loadField(7465442439881872911).loadField(8724963705767520776).storeField(2173580090091140814, g9.loadField(1389453267865381645).loadField(1213408910005640996).loadField(376690289730125256).loadField(8521393306122375397).loadField(6315016591051926162).loadField(5513132638257673654))
            let l6 = LocalBox(l4.value)
            g8.loadField(1640901974335785848).loadField(8256626420056953151).loadField(4798595169301999025).loadField(5726023189938137914).loadField(3009914592439641115).loadField(6983093370024196299).storeField(8334915257147117113, g9.loadField(848504744035021237).loadField(6958916759930804997))
            let l7 = LocalBox(alloc({ => Class22(None, None, None, None, None) }))
        }
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun46(localsCount: Int64, l0: ?Object, l1: ?Object): ?Object {
    try {
        spawnThread {
            if (shouldTerminate()) { return }
            let localsCount = 0
            call(localsCount, 4, { it => fun35(it, l0.loadField(251594974143116298).loadField(4525811956712099316), l1.loadField(2251355226168723884).loadField(5326334211683565091).loadField(7653984833779315641).loadField(8999422343393033972).loadField(5407789282503871846).loadField(4191692609488781834)) })
        }
        let l2 = LocalBox(g10.loadField(0).loadField(7768112029346521289))
        let l3 = LocalBox(alloc({ => Class28(None, None, None, None) }))
        if (anyToBool(l2.value.loadField(6897696848431617448).loadField(8902406035921018966))) {
            let l4 = LocalBox(call(localsCount, 8, { it => fun36(it, None, None) }))
            let l5 = LocalBox(alloc({ => Class21(None) }))
        }
        else {
            l2.value.loadField(1074139278614118421).loadField(3541386931117704782).loadField(4683148604897335526).storeField(1903848189264927815, l0.loadField(382164366253441270).loadField(5604536898331240793).loadField(4906246949791470875))
        }
        l2.value.loadField(454063467320277073).loadField(7399925013234791111).loadField(2027395899815876408).loadField(4940505904932967765).loadField(7714126202412276724).loadField(1558697169367347855).storeField(6483608014958668726, g8.loadField(0).loadField(6567784531492048326).loadField(8430952097112785322).loadField(6171337163410576253).loadField(4757751867468276539).loadField(8394742373730919241).loadField(47964426003930677).loadField(3019549343851271774))
        let l4 = LocalBox(call(localsCount, 18, { it => fun40(it, None) }))
        let l5 = LocalBox(alloc({ => Class29(None, None, None, None, None, None, None) }))
        run {
            let l6 = LocalBox(l3.value.loadField(7181041622273701818).loadField(7601569819974341228).loadField(5530087324418189547).loadField(8065492960131461465).loadField(1759123186583863266).loadField(8823814420920813495).loadField(4602995758985314732).loadField(125864999264008007))
            let l7 = LocalBox(alloc({ => Class30(None, None, None) }))
            performGC()
            let l8 = LocalBox(l2.value.loadField(4856085253129488472))
            spawnThread {
                if (shouldTerminate()) { return }
                let localsCount = 0
                call(localsCount, 15, { it => fun34(it, g11.loadField(6300962959104405893), None, None, None, None, None) })
            }
        }
        g1.storeField(6415074046841262761, g3.loadField(6618900077878132118).loadField(7616944431978650221))
        l3.value.loadField(8245691172459256397).loadField(4078117159415104013).storeField(2860042669429652620, g13.loadField(2576501316286805617).loadField(4161810979460355222).loadField(3629348632630278458).loadField(8847886029340215133).loadField(8835810944848910639))
        try {
            let l6 = LocalBox(call(localsCount, 15, { it => fun41(it, l1.loadField(7604408878976534234).loadField(4558959373258367963).loadField(7268037064584287136), l0.loadField(5144970422810963035).loadField(7407400977315505217).loadField(1772659429168636267).loadField(1505556353362152007)) }))
            performGC()
        }
        finally {
            performGC()
            for (_ in 0..14) {
                if (shouldTerminate()) { break }
                alloc({ => Class30(None, None, None) })
            }
        }
        performGC()
        g6.loadField(2245549108124305415).storeField(4572756671255035892, g5)
        g14.loadField(6077993303517177725).storeField(6462282902372004067, g11)
        let l6 = LocalBox(alloc({ => Class25(None, None, None, None) }))
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun47(localsCount: Int64, l0: ?Object, l1: ?Object, l2: ?Object): ?Object {
    try {
        let l3 = LocalBox(alloc({ => Class24(None) }))
        performGC()
        let l4 = LocalBox(l3.value.loadField(5637632038272048031).loadField(4884768655915098479).loadField(5159399368560690328))
        g18.storeField(2416069531823667129, l0.loadField(2086969489818880670).loadField(8229517519334832237))
        spawnThread {
            if (shouldTerminate()) { return }
            let l5 = LocalBox(alloc({ => Class27(None, None, None, None, None, None, None) }))
            g0 = l5.value
            performGC()
        }
        for (_ in 0..9) {
            if (shouldTerminate()) { break }
            alloc({ => Class27(None, None, None, None, None, None, None) })
        }
        performGC()
        let l5 = LocalBox(g0)
        g0 = None
        let l6 = LocalBox(call(localsCount, 10, { it => fun43(it, l2.loadField(7157652581781942696), l2, None) }))
        let l7 = LocalBox(call(localsCount, 8, { it => fun47(it, g14.loadField(5546611363528521376).loadField(2563270944873907789).loadField(7195740117985387109).loadField(484056969789132130).loadField(1316255165253231582), g15.loadField(0).loadField(4325027968606946077).loadField(126934826641546650).loadField(3861542872595614900), None) }))
        return l2.loadField(7051581995094161068).loadField(6688457392422029118).loadField(6019490179273500065).loadField(2156831408717284188).loadField(7461578514825955102)
        return None
    }
    catch (_: Exception) {
        return None
    }
}

func fun48(localsCount: Int64, l0: ?Object, l1: ?Object): ?Object {
    try {
        let l2 = LocalBox(l1.loadField(6154177708921992366).loadField(7192839177726578424).loadField(3025366455794188541).loadField(6321794342787628859).loadField(813198202072582824).loadField(3893893078792953155).loadField(919778293176033492).loadField(3617185082268727944))
        let l3 = LocalBox(alloc({ => Class24(None) }))
        let l4 = LocalBox(alloc({ => Class33(None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None) }))
        g3 = g10.loadField(0).loadField(1815239113999183194).loadField(679141224144013661).loadField(2304617656239138241).loadField(3526336912376575864).loadField(9185138635174831384)
        let l5 = LocalBox(l2.value.loadField(5753767814801008781))
        try {
            spawnThread {
                if (shouldTerminate()) { return }
                let localsCount = 0
                call(localsCount, 12, { it => fun45(it, g1.loadField(3061481886740453569)) })
            }
        }
        finally {
            performGC()
            for (_ in 0..12) {
                if (shouldTerminate()) { break }
                alloc({ => Class24(None) })
            }
        }
        let l6 = LocalBox(g9)
        let l7 = LocalBox(call(localsCount, 13, { it => fun46(it, g11.loadField(7788663702951641089), g12.loadField(0).loadField(8571771610703062799)) }))
        g2.loadField(8008261644612197434).loadField(2871596744037666249).storeField(4880361283549634762, g3.loadField(2084963850220939910).loadField(633531380313829550))
        g2.storeField(8817462517422335042, g16.loadField(0).loadField(5509549425264486355))
        spawnThread {
            if (shouldTerminate()) { return }
            let localsCount = 0
            call(localsCount, 18, { it => fun40(it, l5.value.loadField(2403602147920124391).loadField(1891021962072998309).loadField(2780433530264839600).loadField(1442589306503990911).loadField(4896043497506661959).loadField(5257040816446771609).loadField(7640576192820558428)) })
        }
        if (anyToBool(l5.value.loadField(4471358055085537661).loadField(2881764543400687448))) {
            let l8 = LocalBox(call(localsCount, 13, { it => fun46(it, l0.loadField(2583179171982832046).loadField(6683681163890154967), None) }))
            let l9 = LocalBox(g8.loadField(0).loadField(2499739973673080149).loadField(7773308107707676222))
            let l10 = LocalBox(alloc({ => Class21(None) }))
        }
        else {
            let l8 = LocalBox(l0.loadField(1996916915221914567).loadField(6462286047978919556).loadField(6960500515458977866).loadField(4805923523195313053).loadField(7176563436567016195).loadField(6641648054590364878).loadField(8204154364718114516).loadField(8726550221307157327).loadField(8690314870439144162).loadField(1835593283041136681).loadField(1771957575530926087).loadField(6002063895316420032))
        }
        l3.value.storeField(105138713907397010, g11.loadField(2610858052652760720).loadField(3489653383580842653).loadField(6430768058234312464).loadField(2276676409568290249).loadField(3291570706678770032).loadField(2915496092248323898).loadField(3924353041816157750).loadField(4058823016983234237))
        return None
    }
    catch (_: Exception) {
        return None
    }
}

// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Realistic data flow exercising forced casts through: multiline parsing
// boundaries, ordinary class members/methods/arrays/helpers carrying Extern
// values, nested Extern handles, and generic forwarding / callbacks / pipelines.

class DummyRuntime <: ForeignRuntime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> { return e }
    public static func indexedAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> { return e }
    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> { return e }
    public static func fromExtern<R>(h: Extern<DummyRuntime>): R { return (Extern<DummyRuntime>.getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRuntime> { return Extern<DummyRuntime>(v) }
}

// ---- multiline parsing ----
class Foo {
    let value: Int64
    public init(value: Int64) { this.value = value }
}

class Holder {
    let value: Int64
    public init(value: Int64) { this.value = value }
    public func next(): Holder { Holder(value + 1) }
    public func add(left: Int64, right: Int64): Int64 { value + left + right }
}

class Box<T> {
    let value: T
    public init(value: T) { this.value = value }
}

func makeFooExtern(v: Int64): Extern<DummyRuntime> { Extern<DummyRuntime>(Foo(v)) }
func makeBoxExtern(): Extern<DummyRuntime> { Extern<DummyRuntime>(Box<Int64>(7)) }
func makeFooExternWithArgs(prefix: Int64, value: Int64): Extern<DummyRuntime> { Extern<DummyRuntime>(Foo(prefix + value)) }

func checkMultiline(): Unit {
    let base = makeFooExtern(1)

    let multilineMember: Foo = (Foo)base
        .member
    let multilineIndex: Foo = (Foo)base
        [0]
    let multilineMixed: Foo = (Foo)base
        .member
        [0]
        (1)
    let multilineTarget: Box<Int64> = (Box<
        Int64>)makeBoxExtern()
    let multilineCallOperand: Foo = (Foo)makeFooExternWithArgs(
        2,
        3
    )

    let holder = Holder(10)
    let normalMember = holder
        .value
    let normalChain = holder
        .next()
        .value
    let parenthesizedNormal = (holder)
        .value
    let normalParenExpr = (normalMember +
        normalChain +
        parenthesizedNormal)
    let normalMultilineCall = holder.add(
        normalMember,
        normalChain
    )

    if (multilineMember.value != 1 || multilineIndex.value != 1 ||
        multilineMixed.value != 1 || multilineTarget.value != 7 ||
        multilineCallOperand.value != 5 ||
        normalMember != 10 || normalChain != 11 ||
        parenthesizedNormal != 10 || normalParenExpr != 31 ||
        normalMultilineCall != 31) {
        throw Exception("multiline forced cast parsing failed")
    }
}

// ---- nested extern data flow ----
class User {
    let id: Int64
    let name: String
    public init(id: Int64, name: String) {
        this.id = id
        this.name = name
    }
}

class Response {
    public let body: Extern<DummyRuntime>
    public init(body: Extern<DummyRuntime>) { this.body = body }
    public func forward(): Extern<DummyRuntime> { body }
}

class Repository {
    let cached: Extern<DummyRuntime>
    public init(cached: Extern<DummyRuntime>) { this.cached = cached }
    public func load(useCache: Bool, fallback: Extern<DummyRuntime>): Extern<DummyRuntime> {
        if (useCache) { cached } else { fallback }
    }
}

func pass(value: Extern<DummyRuntime>): Extern<DummyRuntime> { value }
func select(values: Array<Extern<DummyRuntime>>, index: Int64): Extern<DummyRuntime> { values[index] }
func unwrapNested(value: Extern<DummyRuntime>): Extern<DummyRuntime> { (Extern<DummyRuntime>)value }

func checkDataFlow(): Unit {
    let cached = Extern<DummyRuntime>(User(1, "cached"))
    let fallback = Extern<DummyRuntime>(User(2, "fallback"))
    let repository = Repository(cached)
    let response = Response(repository.load(
        false,
        fallback
    ))

    let fromField: User = (User)response.body
    let fromMethod: User = (User)response.forward()
    let fromPassedMember: User = (User)pass(repository.cached)
    let fromArray: User = (User)select(
        [cached, fallback],
        1
    )

    let nested = Extern<DummyRuntime>(Extern<DummyRuntime>(User(3, "nested")))
    let inner: Extern<DummyRuntime> = (Extern<DummyRuntime>)nested
    let fromNested: User = (User)inner
    let fromNestedHelper: User = (User)unwrapNested(nested)

    if (fromField.id != 2 || fromField.name != "fallback" ||
        fromMethod.id != 2 || fromPassedMember.id != 1 ||
        fromArray.id != 2 || fromNested.id != 3 ||
        fromNestedHelper.name != "nested") {
        throw Exception("nested extern data flow failed")
    }
}

// ---- generic callback pipeline ----
class Item {
    let value: Int64
    public init(value: Int64) { this.value = value }
}

class Slot<T> {
    public let value: T
    public init(value: T) { this.value = value }
    public func get(): T { value }
}

func identity<T>(value: T): T { value }

func mapExtern<T, R>(value: Extern<T>, transform: (Extern<T>) -> R): R where T <: ForeignRuntime<T> {
    transform(value)
}

func flatMapExtern<T>(
    value: Extern<T>,
    transform: (Extern<T>) -> Extern<T>
): Extern<T> where T <: ForeignRuntime<T> {
    transform(value)
}

func makeReader<T>(): (Extern<T>) -> Item where T <: ForeignRuntime<T> {
    {value: Extern<T> => (Item)value}
}

func castThroughGeneric<T>(value: Extern<T>): Item where T <: ForeignRuntime<T> {
    (Item)identity(value)
}

func checkPipeline(): Unit {
    let source = Extern<DummyRuntime>(Item(10))
    let slot = Slot<Extern<DummyRuntime>>(source)

    let fromGeneric = castThroughGeneric<DummyRuntime>(slot.get())
    let fromCallback = mapExtern<DummyRuntime, Item>(
        identity(source),
        {value: Extern<DummyRuntime> =>
            (Item)value
        }
    )
    let forwarded = flatMapExtern<DummyRuntime>(
        source,
        {value: Extern<DummyRuntime> =>
            identity(value)
        }
    )
    let fromFlatMap: Item = (Item)forwarded

    let reader = makeReader<DummyRuntime>()
    let fromReturnedCallback = reader(
        slot.value
    )

    let values = [
        mapExtern<DummyRuntime, Item>(source, {value => (Item)value}),
        castThroughGeneric<DummyRuntime>(identity(source)),
        (Item)flatMapExtern<DummyRuntime>(source, {value => value})
    ]

    if (fromGeneric.value != 10 || fromCallback.value != 10 ||
        fromFlatMap.value != 10 || fromReturnedCallback.value != 10 ||
        values[0].value != 10 || values[1].value != 10 ||
        values[2].value != 10) {
        throw Exception("generic callback forced cast pipeline failed")
    }
}

main() {
    checkMultiline()
    checkDataFlow()
    checkPipeline()
}

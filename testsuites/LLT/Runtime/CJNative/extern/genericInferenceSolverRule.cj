// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Type arguments of generic calls are inferred as if each part of type Extern<T> of a parameter accepted any argument,
// which is converted. Covers each parameter shape, the inference of the runtime R of Extern<R>, type variable bounds,
// return types, overload resolution and the different forms of calls.

var conversions = 0

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { e }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { e }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { e }
    public static func fromExtern<R>(e: Extern<RT>): R { throw Exception() }

    public static func toExtern<R>(value: R): Extern<RT> {
        conversions++
        Extern<RT>(value)
    }
}

class RT2 <: ForeignRuntime<RT2> {
    public static func memberAccess(e: Extern<RT2>, name: String): Extern<RT2> { e }
    public static func indexedAccess(e: Extern<RT2>, index: Any): Extern<RT2> { e }
    public static func memberUpdate(e: Extern<RT2>, name: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT2>, index: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT2>, args: Array<Any>): Extern<RT2> { e }
    public static func fromExtern<R>(e: Extern<RT2>): R { throw Exception() }

    public static func toExtern<R>(value: R): Extern<RT2> {
        conversions++
        Extern<RT2>(value)
    }
}

class Box<T> {
    Box(let value: T) {}
}

func check(name: String, ok: Bool, expectedConversions: Int64): Unit {
    if (!ok || conversions != expectedConversions) {
        throw Exception("${name}: conversions=${conversions}, expected ${expectedConversions}")
    }
    conversions = 0
}

// Parameters without type variables containing Extern<RT>.
func plain<T>(p: Extern<RT>, x: T): T { x }
func arrayOf<T>(p: Array<Extern<RT>>, x: T): T { x }
func nestedArrays<T>(p: Array<Array<Extern<RT>>>, x: T): T { x }
func tupleOf<T>(p: (Extern<RT>, Int8), x: T): T { x }
func resultOf<T>(p: () -> Extern<RT>, x: T): T { p(); x }
func taking<T>(p: (Extern<RT>) -> Int64, x: T): T { p(Extern<RT>(0)); x }
func optionOf<T>(p: ?Extern<RT>, x: T): T { x }

// Parameters mixing Extern<RT> and type variables.
func second<T>(p: (Extern<RT>, T)): T { p[1] }
func firstOfPairs<T>(p: Array<(T, Extern<RT>)>): T { p[0][0] }
func firstOfRows<T>(p: Array<Array<(T, Extern<RT>)>>): T { p[0][0][0] }
func callResult<T>(p: () -> (Extern<RT>, T)): T { p()[1] }
func callWithExtern<T>(p: (Extern<RT>) -> T): T { p(Extern<RT>(0)) }
func callToExtern<T>(p: (T) -> Extern<RT>, x: T): Int64 { p(x); 1 }
func sizeOf<T>(p: Collection<(Extern<RT>, T)>): Int64 { p.size }

func firstOf<T>(p: Iterable<(Extern<RT>, T)>): ?T {
    for (x in p) {
        return x[1]
    }
    None
}

func optionalPair<T>(p: ?(Extern<RT>, T)): Int64 { 1 }
func twoRuntimes<T>(p: (Extern<RT>, T, Extern<RT2>)): T { p[1] }
func twoTyVars<T, U>(p: (T, Extern<RT>, U)): U { p[2] }
func idealFirst<T>(p: (T, Extern<RT>)): T { p[0] }

// Extern<R>, where R is inferred.
func runtimeOf<R>(a: Extern<R>, b: Extern<R>): Int64 where R <: ForeignRuntime<R> { 1 }
func runtimeArray<R>(p: Array<Extern<R>>): Int64 where R <: ForeignRuntime<R> { p.size }
func runtimeAndArray<R>(e: Extern<R>, p: Array<Extern<R>>): Int64 where R <: ForeignRuntime<R> { p.size }
func runtimeOption<R>(p: ?Extern<R>): Int64 where R <: ForeignRuntime<R> { 1 }
func runtimeResult<R>(p: () -> Extern<R>): Int64 where R <: ForeignRuntime<R> { 1 }
func resultAndRuntime<R>(p: () -> Extern<R>, e: Extern<R>): Int64 where R <: ForeignRuntime<R> { p(); 1 }
func runtimeFromResult<R>(p: (Int64) -> Extern<R>): Int64 where R <: ForeignRuntime<R> { p(1); 1 }
func runtimeTaking<R>(p: (Extern<R>) -> Int64): Int64 where R <: ForeignRuntime<R> { 1 }
func runtimeTuple<R>(p: (Extern<R>, Int64)): Int64 where R <: ForeignRuntime<R> { 1 }
func runtimeAndT<R, T>(a: Extern<R>, b: Extern<R>, x: T): T where R <: ForeignRuntime<R> { x }
func runtimeInGeneric<U>(x: U): Int64 { runtimeOf(Extern<RT>(0), x) }
func withRuntimeOf<S>(e: Extern<S>): Int64 where S <: ForeignRuntime<S> { runtimeOf(e, 1) }
func untypedAndRuntime<R>(g: (Int64) -> Extern<R>, e: Extern<R>): Int64 where R <: ForeignRuntime<R> { g(1); 1 }

type Alias<R> = Extern<R>

func aliasRuntime<R>(a: Alias<R>, b: Alias<R>): Int64 where R <: ForeignRuntime<R> { 1 }

// Type variable bounds.
func sizeWith<T>(xs: Array<T>, p: Extern<RT>): Int64 { xs.size }
func withOther<T>(x: T, p: Extern<RT>): Int64 { 1 }
func shown<T>(x: T, p: Extern<RT>): String where T <: ToString { x.toString() }
func sizeAndExterns<T>(xs: Array<T>, ys: Array<Extern<RT>>): Int64 { xs.size }
func sizeAndValue<T>(xs: Array<T>, y: T): Int64 { xs.size }
func externThenTwo<T>(p: Extern<RT>, q: T, r: T): T { q }
func valueExternValue<T>(p: T, q: Extern<RT>, r: T): Int64 { 1 }
func optionWith<T>(p: ?T, q: Extern<RT>): ?T { p }
func optionOfT<T>(p: ?T): ?T { p }
func sizeOfT<T>(p: Array<T>): Int64 { p.size }
func applied<T>(p: (T) -> T, x: T): T { p(x) }

// Return types.
func same<R>(e: Extern<R>): Extern<R> where R <: ForeignRuntime<R> { e }
func make<T>(x: T): T { x }
func wrap<T>(x: T): Array<T> { [x] }

// Overloads.
func externOrAny<T>(x: T, p: Extern<RT>): Int64 { 1 }
func externOrAny<T>(x: T, p: Any): Int64 { 2 }
func externOrT<T>(x: T, p: Extern<RT>): Int64 { 1 }
func externOrT<T>(x: T, p: T): Int64 { 2 }
func genericOrPlain<T>(x: T, p: Extern<RT>): Int64 { 1 }
func genericOrPlain(x: Int64, p: Extern<RT>): Int64 { 2 }
func runtimeOrConcrete<R>(p: Extern<R>): Int64 where R <: ForeignRuntime<R> { 1 }
func runtimeOrConcrete(p: Extern<RT>): Int64 { 2 }
func mixedOrT<T>(p: (Extern<RT>, T)): Int64 { 1 }
func mixedOrT<T>(p: T): Int64 { 2 }

// Forms of calls.
func named<T>(x: T, p!: Extern<RT>): T { x }
func defaulted<T>(x: T, p!: Extern<RT> = Extern<RT>(0)): T { x }
func variadic<T>(x: T, p: Array<Extern<RT>>): T { x }
func trailing<T>(x: T, p: () -> Extern<RT>): T { p(); x }
func piped<T>(x: T): Extern<RT> { Extern<RT>(0) }
func untypedToExtern<T>(g: (T) -> Extern<RT>, x: T): Int64 { g(x); 1 }
func applyTo<T>(g: (T) -> Int64, x: T, p: Extern<RT>): Int64 { g(x) }
func inGeneric<U>(u: U): U { plain(u, u) }
func boundedInGeneric<U>(u: U): U where U <: ToString & Hashable { plain(u, u) }
func secondInGeneric<U>(u: U): U { second((u, u)) }
func plainOfT<U>(u: U): Int64 { plain(u, 1) }

class K {
    func f<T>(x: T, p: Extern<RT>): T { x }
    static func g<T>(x: T, p: Extern<RT>): T { x }
}

class G<T> {
    G(p: Extern<RT>, let x: T) {}
}

struct S<T> {
    S(p: (Extern<RT>, T), let x: T) {}
}

class H<T> {
    let x: T
    init(x: T, p: Extern<RT>) {
        this.x = x
    }
}

enum En<T> {
    | A(T, Extern<RT>)
}

extend Int64 {
    func f<T>(x: T, p: Extern<RT>): T { x }
}

extend<U> Array<U> {
    func g<T>(x: T, p: Extern<RT>): T { x }
}

open class Base<T> {
    init(p: Extern<RT>, x: T) {}
}

class Derived <: Base<Int64> {
    init() {
        super(1, 2)
    }
}

class Generic<U> {
    func m<T>(x: T, p: Extern<RT>, u: U): T { x }
}

struct Counter {
    var count = 0
    mut func add<T>(x: T, p: Extern<RT>): T {
        count++
        x
    }
}

main() {
    let e = Extern<RT>(0)
    let e2 = Extern<RT2>(0)
    let none: ?Int64 = None

    check("integer", plain(1, 2) == 2, 1)
    check("string", plain("s", 2) == 2, 1)
    check("same runtime", plain(e, 2) == 2, 0)
    check("other runtime", plain(e2, 2) == 2, 1)
    check("lambda", plain({ => 1 }, 2) == 2, 1)
    check("option value", plain(none, 2) == 2, 1)
    check("tuple value", plain((1, "a"), 2) == 2, 1)
    check("value of the type argument", plain(2, 2) == 2, 1)
    check("array literal", arrayOf([1, "a"], 2) == 2, 2)
    check("empty array literal", arrayOf([], 2) == 2, 0)
    check("existing Extern array", arrayOf([e], 2) == 2, 0)
    check("nested array literal", nestedArrays([[1], ["s"]], 3) == 3, 2)
    check("tuple literal", tupleOf((1, 2), 3) == 3, 1)
    check("lambda result", resultOf({ => 1 }, 3) == 3, 1)
    check("lambda parameter", taking({ y => 1 }, 3) == 3, 0)
    check("option none", optionOf(None, 3) == 3, 0)
    check("option of Extern", optionOf(e, 3) == 3, 0)

    check("mixed tuple", second((1, "s")) == "s", 1)
    check("mixed array", firstOfPairs([("a", 1)]) == "a", 1)
    check("mixed existing Extern array", firstOfPairs([("a", e)]) == "a", 0)
    check("mixed nested arrays", firstOfRows([[("a", 1)], [("b", 2)]]) == "a", 2)
    check("mixed lambda result", callResult({ => (1, "s") }) == "s", 1)
    check("mixed lambda parameter", callWithExtern({ y => "s" }) == "s", 0)
    check("lambda returning Extern", callToExtern({ y: Int64 => y }, 2) == 1, 1)
    check("collection", sizeOf([(1, "s")]) == 1, 1)
    check("iterable", firstOf([(1, "s")]) == Some("s"), 1)
    check("option boxing", optionalPair((1, "s")) == 1, 1)
    check("two runtimes", twoRuntimes((1, "s", 2)) == "s", 2)
    check("other runtime in tuple", second((e2, "s")) == "s", 1)
    check("two type variables", twoTyVars((1, 2, "u")) == "u", 1)
    check("ideal type", idealFirst((1.5, 2)) == 1.5, 1)

    check("runtime and conversion", runtimeOf(e, 1) == 1, 1)
    check("conversion before runtime", runtimeOf(1, e) == 1, 1)
    check("runtime from array literal", runtimeArray([e, e]) == 2, 0)
    check("runtime from existing array", runtimeArray([e]) == 1, 0)
    check("runtime and literal elements", runtimeAndArray(e, [1, 2]) == 2, 2)
    check("runtime from option", runtimeOption(e) == 1, 0)
    check("runtime from lambda result", runtimeResult({ => e }) == 1, 0)
    check("lambda result and runtime", resultAndRuntime({ => 1 }, e) == 1, 1)
    check("runtime from result of untyped lambda", runtimeFromResult({ x => e }) == 1, 0)
    check("runtime from lambda parameter", runtimeTaking({ x: Extern<RT> => 1 }) == 1, 0)
    check("runtime from tuple", runtimeTuple((e, 1)) == 1, 0)
    check("runtime and type argument", runtimeAndT(e, "s", 3) == 3, 1)
    check("runtime in generic context", runtimeInGeneric(1) == 1, 1)
    check("generic runtime", withRuntimeOf(e) == 1, 1)
    check("untyped lambda and runtime", untypedAndRuntime({ x => x }, e) == 1, 1)
    check("generic type alias", aliasRuntime(e, 1) == 1, 1)

    check("array and Extern parameter", sizeWith([1], 2) == 1, 1)
    check("other runtime for type argument", withOther(e2, 2) == 1, 1)
    check("upper bound", shown(1, 2) == "1", 1)
    check("array of Extern for type argument", sizeAndExterns([e], [1]) == 1, 1)
    check("explicit Extern type argument", sizeAndValue<Extern<RT>>([e], 1) == 1, 1)
    check("Extern then two values", externThenTwo(1, 2, 3) == 2, 1)
    check("Extern value for type argument", valueExternValue(e, 1, e) == 1, 1)
    check("option of type argument", optionWith(e, 1).isSome(), 1)
    check("option of Extern type argument", optionOfT(e).isSome(), 0)
    check("array of Extern type argument", sizeOfT([e, e]) == 2, 0)
    applied({ v => v }, e)
    check("function of Extern type argument", true, 0)

    let other: Extern<RT2> = same(e)
    check("return converted to other runtime", true, 1)
    let made: Extern<RT> = make(1)
    check("return converted as a whole", true, 1)
    let wrapped: Array<Extern<RT>> = wrap(e)
    check("return array of Extern", wrapped.size == 1, 0)

    check("overload Extern or Any", externOrAny(0, 1) == 1, 1)
    check("overload Extern or Any, other runtime", externOrAny(0, e2) == 1, 1)
    check("overload Extern or type argument", externOrT(0, "s") == 1, 1)
    check("overload generic or plain", genericOrPlain(0, 1) == 2, 1)
    check("overload runtime or concrete", runtimeOrConcrete(e) == 2, 0)
    check("overload runtime or concrete, conversion", runtimeOrConcrete(1) == 2, 1)
    check("overload mixed or type argument", mixedOrT((1, "s")) == 1, 1)

    check("named argument", named(2, p: 1) == 2, 1)
    check("default argument", defaulted(2) == 2, 0)
    check("variadic arguments", variadic(2, 1, "s") == 2, 2)
    check("trailing closure", trailing(2) { 1 } == 2, 1)
    let piped = 1 |> piped
    check("pipeline", true, 0)
    check("method", K().f(2, 1) == 2, 1)
    check("static method", K.g(2, 1) == 2, 1)
    check("primary constructor", G(1, 2).x == 2, 1)
    check("struct constructor", S((1, 3), 2).x == 2, 1)
    check("constructor", H(2, 1).x == 2, 1)
    let constructed = En.A(2, 1)
    check("enum constructor", true, 1)
    check("extension", 5.f(2, 1) == 2, 1)
    check("lambda argument", applyTo({ v => v }, 2, 1) == 2, 1)
    check("untyped lambda to Extern", untypedToExtern({ x => x }, 2) == 1, 1)
    check("generic extension", [0].g(2, 1) == 2, 1)
    Derived()
    check("super constructor", true, 1)
    check("generic method of generic class", Generic<Int64>().m(2, 1, 3) == 2, 1)
    var counter = Counter()
    check("mutating method", counter.add(2, 1) == 2 && counter.count == 1, 1)
    let generic: ?Generic<Int64> = Generic<Int64>()
    check("optional chaining", generic?.m(2, 1, 3) == Some(2), 1)
    check("if argument", plain(if (generic.isSome()) { 1 } else { 2 }, 3) == 3, 1)
    check("match argument", plain(match (generic) { case _ => "s" }, 3) == 3, 1)
    check("nested generic call", plain("s", plain(1, 2)) == 2, 2)
    check("generic argument", plain(make(2), 1) == 1, 1)
    check("generic context", inGeneric(3) == 3, 1)
    check("bounded generic context", boundedInGeneric(3) == 3, 1)
    check("mixed tuple in generic context", secondInGeneric(3) == 3, 1)
    check("type argument for Extern", plainOfT("s") == 1, 1)
    check("ideal literals", plain(2.5, 1) == 1, 1)
    let spawned = spawn { plain(1, 2) }
    check("spawn", spawned.get() == 2, 1)
    0
}

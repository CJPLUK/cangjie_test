// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// 4.1 字面量
func foo(): Int64 {
    10u8 // UInt8 literal
    10i16 // Int16 literal
    1024u32 // UInt32 literal
    1024 // Int64 literal
    1024.512_f32 // Float32 literal
    1024.512 // Float64 literal
    'a' // Rune literal
    true // Bool literal
    "Cangjie" // String literal
    () // Unit literal
    [1, 2, 3] // Array<Int64> literal
    (1, 2, 3) // (Int64, Int64, Int64) literal
    return 0
}

// 4.2 变量名和函数名
let intNum: Int64 = 100 // 'intNum' is the name of a variable, whose value and type are '100' and 'Int64', respectively.

/* 'add' is the name of a function, whose value and type are '(p1: Int64, p2: Int64) => {p1 + p2}' and '(Int64, Int64) -> Int64', respectively. */
func add(p1: Int64, p2: Int64) {
    p1 + p2
}

// 4.2.1 泛型函数名作为表达式
func identity<T>(a: T) { // identity is a generic function
    return a
}

var c = identity<Int32> // ok: Int32 is given as a type argument

interface Add<T> {
    operator func +(a: T): T
}

func add<T>(i: T, j: Int64): Int64 where T <: Add<Int64> { // f1
    return i + j;
}

func add<T>(i: T, j: T): T where T <: Add<T> { // f2
    return i + j;
}

// 4.3 条件表达式
func foo1(): Int64 {
    let x = 100

    // if expression without else branch
    if (x > 0) {
        print("x is larger than 0")
    }
    // if expression with else branch
    if (x > 0) {
        print("x is larger than 0")
    } else {
        print("x is not larger than 0")
    }

    // if expression with nested if expression
    if (x > 0) {
        print("x is larger than 0")
    } else if (x < 0) {
        print("x is lesser than 0")
    } else {
        print("x equals to 0")
    }
    return 0
}

func foo2(): Int64 {
    let x: Option<Int64> = Option<Int64>.Some(100)
    if (let Some(v) <- x) {
        print("x has value")
    }

    if (let Some(v) <- x) {
        print("x has value: ${v}") // can access v
    } else {
        print("x has not value") // cannot access v
    }

    if (let a <- 1 && a > 0) { // ok
        print(a) // ok
    }

    if (let a <- x && let Some(b) <- a) { // ok
        print(a) // ok
        print(b) // ok
    }

    if (let Some(1) | Some(a) <- x) {} // error

    if (let a <- 1 || let b <- 2) {} // error, the binding pattern cannot appear on either side of the '||' operation

    if ((true || true) && let a <- 1) {} // ok, '||' operation has no bindingpattern for the child items around

    if (let a <- true && true) {}

    // Equivalent to this
    if ((let a <- true) && true) {}

    if (let a <- true || true) {}

    // Equivalent to this
    if ((let a <- true) || true) {}
    return 0
}

// if 表达式的类型
struct S1 {}

struct S2 {}

interface I1 {}

class C1 <: I1 {}

class C2 <: I1 {}

interface I2 {}

class D1 <: I1 & I2 {}

class D2 <: I1 & I2 {}

func test12() {
    if (true) { // OK. The type of this if expression is Unit.
        S1()
    } else {
        S2()
    }

    if (true) { // OK. The type of this if expression is Unit.
        C1()
    } else {
        C2()
    }
    return if (true) { // Error. The `if` expression is returned. There is no least common supertype of `D1` and `D2`.
        D1()
    } else {
        D2()
    }
}

// 4.4 模式匹配表达式
let score: Int64 = 90
var scoreResult: String = match (score) {
    case 0 => "zero"
    case 10 | 20 | 30 | 40 | 50 => "fail"
    case 60 => "pass"
    case 70 | 80 => "good"
    case 90 | 100 => "excellent" // matched
    case _ => "not a valid score"
}

let score1 = 80
var result: String = match {
    case score1 < 60 => "fail"
    case score1 < 70 => "pass"
    case score1 < 90 => "good" // matched
    case _ => "excellent"
}

// 4.4.1.1 常量模式
func f() {
    let score: Int64 = 90
    var scoreResult: String = match (score) {
        case 0 => "zero"
        case 10 | 20 | 30 | 40 | 50 => "fail"
        case 70 | 80 => "good"
        case 90 => "excellent" // matched
        case _ => "not a valid score"
    }
}

// 4.4.1.2 通配符模式
let score2: Int64 = 90
var scoreResult1: String = match (score2) {
    case 60 => "pass"
    case 70 | 80 => "good"
    case 90 | 100 => "excellent" // matched
    case _ => "fail" // wildcard pattern: used for default case
}

// 4.4.1.3 绑定模式
let score: Int64 = 90
var scoreResult: String = match (score) {
    case 60 => "pass"
    case 70 | 80 => "good"
    case 90 | 100 => "excellent" // matched
    case failScore => // binding pattern
        let passNeed = 60 - failScore
        "failed with ${failScore}, and ${passNeed} need to pass"
}

// 4.4.1.4 Tuple 模式
let scoreTuple = ("Allen", 90)
var scoreResult: String = match (scoreTuple) {
    case ("Bob", 90) => "Bob got 90"
    case ("Allen", score) => "Allen got ${score}" // matched
    case ("Allen", 100) | ("Bob", 100) => "Allen or Bob got 100"
    case (_, _) => ""
}

// 4.4.1.5 类型模式
open class Point {
    var x: Int32 = 1
    var y: Int32 = 2
    init(x: Int32, y: Int32) {
        this.x = x
        this.y = y
    }
}

class ColoredPoint <: Point {
    var color: String = "green"
    init(x: Int32, y: Int32, color: String) {
        super(x, y)
        this.color = color
    }
}

let normalPt = Point(5, 10)
let colorPt = ColoredPoint(8, 24, "red")
var rectangleArea1: Int32 = match (normalPt) {
    case _: Point => normalPt.x * normalPt.y // matched
    case _ => 0
}

var rectangleArea2: Int32 = match (colorPt) {
    case cpt: Point => cpt.x * cpt.y // matched
    case _ => 0
}

// 4.4.1.6 enum 模式
enum TimeUnit {
    | Year(Float32)
    | Month(Float32, Float32)
    | Day(Float32, Float32, Float32)
    | Hour(Float32, Float32, Float32, Float32)
}

let oneYear = TimeUnit.Year(1.0)

var howManyHours: Float32 = match (oneYear) {
    case Year(y) => y * Float32(365 * 24) // matched
    case Month(y, m) => y * Float32(365 * 24) + m * Float32(30 * 24)
    case Day(y, m, d) => y * Float32(365 * 24) + m * Float32(30 * 24) + d * Float32(24)
    case Hour(y, m, d, h) => y * Float32(365 * 24) + m * Float32(30 * 24) + d * Float32(24) + h
}

let twoYear = TimeUnit.Year(2.0)
var howManyYears: Float32 = match (twoYear) {
    case Year(y) | Month(y, m) => y // error: variable cannot be introduced in patterns connected by '|'
    case Year(y) | Month(x, _) => y // error: variable cannot be introduced in patterns connected by '|'
    case Year(y) | Month(y, _) => y // error: variable cannot be introduced in patterns connected by '|'
}

enum Foo {
    A | B | C
}

func f() {
    let x = Foo.A
    match (x) {
        case A => 0 // enum pattern
        case B => 1 // enum pattern
        case C => 2 // enum pattern
        case D => 3 // binding pattern
    }
}

enum TimeUnit {
    | Year(Float32)
    | Month(Float32, Float32)
    | Day(Float32, Float32, Float32)
    | Hour(Float32, Float32, Float32, Float32)
}

let oneYear = TimeUnit.Year(1.0)

var howManyHours: Float32 = match (oneYear) { // error: match must be exhaustive
    case Year(y) => y * Float32(365 * 24)
    case Month(y, m) => y * Float32(365 * 24) + m * Float32(30 * 24)
}

// 4.4.4 Pattern Guards
let oneYear = Year(1.0)
var howManyHours: Float32 = match (oneYear) {
    case Year(y) where y > 0.0f32 => y * Float32(365 * 24) // matched
    case Year(y) where y <= 0.0f32 => 0.0
    case Month(y, m) where y > 0.0f32 && m > 0.0f32 => y * Float32(365 * 24) + m * Float32(30 * 24)
    case Day(y, m, d) where y > 0.0f32 && m > 0.0f32 && d > 0.0f32 => y * Float32(365 * 24) + m * Float32(30 * 24) +
        d * Float32(24)
    case Hour(y, m, d, h) where y > 0.0f32 && m > 0.0f32 && d > 0.0f32 && h > 0.0f32 => y * Float32(365 * 24) +
        m * Float32(30 * 24) + d * Float32(24) + h
    case _ => 0.0
}

// 4.5 循环表达式
func for1(): Int64 {
    let intArray: Array<Int32> = [0, 1, 2, 3, 4]
    for (item in intArray) {
        print(item) // output: 01234
    }

    let intRange = 0..5
    for (number in intRange where number > 2) {
        print(number) // output: 34
    }

    return 0
}

func while1(): Int64 {
    var hundred = 0
    while (hundred < 100) { // until hundred = 100
        hundred++
    }
    return 0
}

func while2(): Int64 {
    var x: Option<Int64> = Option<Int64>.Some(100)
    while (let Some(v) <- x) {
        print("x has value")
        break
    }

    while (let a <- 1 && a > 0) { // ok
        print(a) // ok
        break
    }

    while (let a <- x && let Some(b) <- a) { // ok
        print(a) // ok
        print(b) // ok
        break
    }

    while (let Some(1) | Some(a) <- x) {
        break
    } // error

    while (let a <- 1 || let b <- 2) {} // error, the binding pattern cannot appear on either side of the '||' operation

    while ((true || true) && let a <- 1) {
        break
    } // ok, '||' operation has no binding pattern for the child items around

    while (let a <- true && true) {}

    // Equivalent to this
    while ((let a <- true) && true) {}

    while (let a <- true || true) {}

    // Equivalent to this
    while ((let a <- true) || true) {}

    return 0
}

// 4.5.3 do-while 表达式
func doWhile1(): Int64 {
    var hundred = 0
    do {
        hundred++
    } while (hundred < 100)
    return 0
}

func doWhile2() {
    while (true) {
        println("outer") // printed once
        do {
            println("inner") // printed once
        } while (break) // stop the execution of the outer loop
        println("unreached") // not printed
    }
}

// 4.7.1 break 表达式
func break1(): Int64 {
    var index: Int32 = 0
    while (index < 50) {
        index = index + 1
        if ((index % 4 == 0) && (index % 6 == 0)) {
            print("${index} is divisible by both 4 and 6") // output: 12
            break
        }
    }
    return 0
}

func break2(): Int64 {
    var index: Int64 = 0
    for (i in 0..5) {
        index = i
        while (index < 20) {
            index = index + 1
            if ((index % 4 == 0) && (index % 6 == 0)) {
                print("${index} is divisible by both 4 and 6")
                break
            }
        }
        print("${i}th test")
    }
    return 0
}

// 4.7.2 continue 表达式
func continue1(): Int64 {
    var index: Int32 = 0
    while (index < 50) {
        index = index + 1
        if ((index % 4 == 0) && (index % 6 == 0)) {
            print("${index} is divisible by both 4 and 6")
            continue
        }
        print("${index} is not what we want")
    }
    return 0
}

// 4.7.3 return 表达式

// return expression
func larger(a: Int32, b: Int32): Int32 {
    if (a >= b) {
        return a
    } else {
        return b
    }
}

// return expression
func equal(a: Int32, b: Int32): Unit {
    if (a == b) {
        print("a is equal to b")
        return
    } else {
        print("a is not equal to b")
    }
}

// 4.7.4 throw 表达式
func div(a: Int32, b: Int32): Int32 {
    if (b != 0) {
        return a / b
    } else {
        throw ArithmeticException()
    }
}

// a?.b.c?.d is equivalent to the following match expression.
func foo() {
    match (a) {
        case Some(va) =>
            let x = va.b.c
            match (x) {
                case Some(vc) => Some(vc.d)
                case None => None<Td>
            }
        case None => None<Td>
    }
}

// 操作符 ? 应用举例
// The usuage of ?.
class C {
    var item: Int64 = 100
}

let c = C()
let c1 = Option<C>.Some(c)
let c2 = Option<C>.None
let r1 = c1?.item // r1 = Option<Int64>.Some(100)
let r2 = c2?.item // r2 = Option<Int64>.None

func test1() {
    c1?.item = 200 // c.item = 200
    c2?.item = 300 // no effect
}

// The usuage of ?()
let foo = {i: Int64 => i + 1}
let f1 = Option<(Int64) -> Int64>.Some(foo)
let f2 = Option<(Int64) -> Int64>.None
let r3 = f1?(1) // r3 = Option<Int64>.Some(2)
let r4 = f2?(1) // r4 = Option<Int64>.None

// The usuage of ?[] for tuple access
let tuple = (1, 2, 3)
let t1 = Option<(Int64, Int64, Int64)>.Some(tuple)
let t2 = Option<(Int64, Int64, Int64)>.None
let r7 = t1?[0] // r7 = Option<Int64>.Some(1)
let r8 = t2?[0] // r8 = Option<Int64>.None

func test3() {
    t1?[0] = 10 // error: 't1?[0]' is immutable
    t2?[1] = 20 // error: 't2?[0]' is immutable
}

// 4.14 自增自减表达式
func daIncreaseOrdecreaseExpr() {
    var i: Int32 = 5
    i++ // i = 6
    i-- // i = 5
    var j = 0
    j = i-- // semantics error
}

// 4.15 算术表达式
let num1: Int64 = 8
let num2 = -num1 // num2 = -8, with 'Int64' type
let num3 = -(-num1) // num3 = 8, with 'Int64' type

let a = 2 + 3 // add： 5
let b = 3 - 1 // sub： 2
let c = 3 * 4 // multi： 12
let d = 6.6 / 1.1 // division： 6
let e = 4 % 3 // mod： 1

let q1 = 7 / 3 // integer division: 2
let q2 = -7 / 3 // integer division: -2
let q3 = 7 / -3 // integer division: -2
let q4 = -7 / -3 // integer division: 2
let r1 = 7 % 3 // integer remainder: 1
let r2 = -7 % 3 // integer remainder: -1
let r3 = 7 % -3 // integer remainder: 1
let r4 = -7 % -3 // integer remainder: -1

let p1 = 2 ** 3 // p1 = 8
let p2 = 2 ** UInt64(3 ** 2) // p2 = 512
let p3 = 2.0 ** 3 // p3 = 8.0
let p4 = 2.0 ** 3 ** 2 // p4 = 512.0
let p5 = 2.0 ** 3.0 // p5 = 8.0
let p6 = 2.0 ** 3.0 ** 2.0 // p6 = 512.0

@OverflowThrowing
func test1(x: Int8, y: Int8) { // if x equals to 127 and y equals to 3
    let z = x + y // throwing OverflowException
}

@OverflowWrapping
func test2(x: Int8, y: Int8) { // if x equals to 127 and y equals to 3
    let z = x + y // z equals to -126
}

@OverflowSaturating
func test3(x: Int8, y: Int8) { // if x equals to 127 and y equals to 3
    let z = x + y // z equals to 127
}

// is 操作符
func is1(): Int64 {
    var testVT = 1 is Int64 // testVT = true
    testVT = 1 is String // testVT = false
    testVT = true is Int64 // testVT = false
    testVT = [1, 2, 3] is Array<Int64> // testVT = true
    let base1: Base = Base()
    let base2: Base = Derived1()
    let base3: Base = Derived2()
    let derived1: Derived1 = Derived1()
    let derived2: Derived2 = Derived2()
    var test = base1 is Base // test = true
    test = base1 is Derived1 // test = false
    test = base1 is Derived2 // test = false
    test = base2 is Base // test = true
    test = base2 is Derived1 // test = true
    test = base2 is Derived2 // test = false
    test = base3 is Base // test = true
    test = base3 is Derived1 // test = false
    test = base3 is Derived2 // test = true
    test = derived1 is Base // test = true
    test = derived1 is Derived1 // test = true
    test = derived1 is Derived2 // test = false
    test = derived2 is Base // test = true
    test = derived2 is Derived1 // test = false
    test = derived2 is Derived2 // test = true
    return 0
}

// 4.17.2 as 操作符
func as1(): Int64 {
    let base1: Base = Base()
    let base2: Base = Derived1()
    let base3: Base = Derived2()
    let derived1: Derived1 = Derived1()
    let derived2: Derived2 = Derived2()
    let castOP1 = base1 as Base // castOP = Option<Base>.Some(base1)
    let castOP2 = base1 as Derived1 // castOP = Option<Derived1>.None
    let castOP3 = base1 as Derived2 // castOP = Option<Derived2>.None
    let castOP4 = base2 as Base // castOP = Option<Base>.Some(base2)
    let castOP5 = base2 as Derived1 // castOP = Option<Derived1>.Some(base2)
    let castOP6 = base2 as Derived2 // castOP = Option<Derived2>.None
    let castOP7 = base3 as Base // castOP = Option<Base>.Some(base3)
    let castOP8 = base3 as Derived1 // castOP = Option<Derived1>.None
    let castOP9 = base3 as Derived2 // castOP = Option<Derived2>.Some(base3)
    let castOP10 = derived1 as Base // castOP = Option<Base>.Some(derived1)
    let castOP11 = derived1 as Derived1 // castOP = Option<Derived1>.Some(derived1)
    let castOP12 = derived1 as Derived2 // castOP = Option<Derived2>.None
    let castOP13 = derived2 as Base // castOP = Option<Base>.Some(derived2)
    let castOP14 = derived2 as Derived1 // castOP = Option<Derived1>.None
    let castOP15 = derived2 as Derived2 // castOP = Option<Derived2>.Some(derived2)
    return 0
}

// 位运算表达式
func foo(): Unit {
    !10 // The result is -11
    !20 // The result is -21
    10 << 1 // The result is 20
    10 << 1 << 1 // The result is 40
    10 >> 1 // The result is 5
    10 & 15 // The result is 10
    10 ^ 15 // The result is 5
    10 | 15 // The result is 15
    1 ^ 8 & 15 | 24 // The result is 25
}

let p: Int8 = -30
let q = p << 2 // q = -120
let r = p >> 2 // r = -8
let r = p >> -2 // error
let x: UInt8 = 30
let b = x << 3 // b = 240
let b = x >> 1 // b = 15
let x1: UInt8 = 30 // 0b00011110
let y1 = x1 >> 11 // compilation error

// 4.21 coalescing 表达式
func coalescing1(): Int64 {
    let v1 = Option<Int64>.Some(100)
    let v2 = Option<Int64>.None
    let r1 = v1 ?? 0
    let r2 = v2 ?? 0
    print("${r1}") // output: 100
    print("${r2}") // output: 0
    return 0
}

//4.22.1 pipeline 操作符
func f(x: Int32): Int32 {
    x + 1
}

let a: Int32 = 1
var res = a |> f // ok
var res1 = a |> {x: Int32 => x + 1} // ok

func h(b: Bool) {
    b
}

let res3 = a < 0 || a > 10 |> h // Equivalence：(a < 0 || a > 10) |> h

func g<T>(x: T): T {
    x
}

var res4 = a |> g<Int32> // ok

let obj = A()
let a: Int32 = 1
let res = a |> obj // Equivalence：obj(a)

// 4.22.2 composition 操作符
func f(x: Int32): Float32 {
    Float32(x)
}

func g(x: Float32): Int32 {
    Int32(x)
}

var fg = f ~> g // Equivalence: {x: Int32 => g(f(x))}
let lambdaComp = {x: Int32 => x} ~> f // ok

func h1<T>(x: T): T {
    x
}

func h2<T>(x: T): T {
    x
}

var hh = h1<Int32> ~> h2<Int32> // ok

// COMPOSITION with operator `()` overloading
class A {
    operator func ()(x: Int32): Int32 {
        x
    }
}

class B {
    operator func ()(x: Float32): Float32 {
        x
    }
}

let objA = A()
let objB = B()
let af = objA ~> f // ok
let fb = f ~> objB // ok
let aa = objA ~> objA // ok

// 4.23 赋值表达式
func tuple1(): Int64 {
    var a: Int64
    var b: Int64
    (a, b) = (1, 2) // a == 1, b == 2
    (a, b) = (b, a) // swap, a == 2, b == 1
    (a, _) = (3, 4) // a == 3
    (_, _) = (5, 6) // no assignment
    return 0
}

func tuple2(): Int64 {
    var a: Int64
    var b: Int64
    (a, b) = (1, 2)
    // desugar
    let temp = (1, 2)
    a = temp[0]
    b = temp[1]
    return 0
}

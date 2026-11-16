/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

 package upstream
public class SimpleFuncClass {
public var value: Int64 = 0i64

public init() {
}
public func getValue(): Int64  {
this.value
}

public func setValue(v: Int64): Unit  {
this.value = v
}

public func greet(name: String): String  {
"Hello " + name
}

}
public class MultiFuncClass {
public init() {
}
public func add(a: Int64, b: Int64): Int64  {
a + b
}

public func concat(a: String, b: String): String  {
a + b
}

}
public class OverloadFuncClass {
public init() {
}
public func process(): Int64  {
0i64
}

public func process(x: Int64): Int64  {
x
}

public func process(s: String): String  {
s
}

}
public open class OpenFuncShape {
public open func hook(): Unit  {
}

public func plain(): Int64  {
7i64
}

}
public class GenericFuncShape {
public init() {
}
public func identity<T>(x: T): T  {
x
}

}
public class ThrowingFuncShape {
public init() {
}
public func fail(): Int64  {
throw Exception("boom")
}

public func ok(): Int64  {
42i64
}

}
public class OperatorShape {
public init() {
}
public operator func +(other: OperatorShape): OperatorShape  {
OperatorShape()
}

}
public struct StructFuncShape  {
public var value: Int64 = 0i64

public init() {
}
public func getValue(): Int64  {
this.value
}

public func echo(v: Int64): Unit  {
}

public func greet(name: String): String  {
"Hello " + name
}

}
public struct StructGenericFuncShape  {
public init() {
}
public func echo(v: Int64): Unit  {
}

public func identity<T>(x: T): T  {
x
}

}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

 package upstream
public class SimpleStaticFuncShape {
public static func sfGetValue(): Int64  {
42i64
}

public static func sfDouble(v: Int64): Int64  {
v * 2i64
}

public static func sfGreet(name: String): String  {
"Hello " + name
}

public static func sfLog(): Unit  {
}

}
public class MultiStaticFuncShape {
public static func sfAdd(x: Int64, y: Int64): Int64  {
x + y
}

public static func sfConcat(a: String, b: String): String  {
a + b
}

}
public class OverloadStaticFuncShape {
public static func process(): Int64  {
0i64
}

public static func process(x: Int64): Int64  {
x
}

public static func process(s: String): String  {
s
}

}
public class GenericStaticFuncShape {
public static func genIdent<T>(x: T): T  {
x
}

}
public class ThrowingStaticFuncShape {
public static func fail(): Int64  {
throw Exception("boom")
}

public static func ok(): Int64  {
42i64
}

}
public struct StructStaticFuncShape  {
public init() {
}
public static func sfGetValue(): Int64  {
42i64
}

public static func sfDouble(v: Int64): Int64  {
v * 2i64
}

public static func sfGreet(name: String): String  {
"Hello " + name
}

}
public struct StructGenericStaticFuncShape  {
public init() {
}
public static func echo(v: Int64): Unit  {
}

public static func genIdent<T>(x: T): T  {
x
}

}

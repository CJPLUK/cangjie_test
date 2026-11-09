// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Minimal std.core mock for modal / RawArray coverage tests (see cangjie_compiler/unittests/Modules/CangjieFiles/coremock.cj).

package std.core

public open class Object {
    public const init() {}
}

public open class Exception <: Object {
    public init() {}
    public init(message: String) {}
}

public interface CType {}

public interface Copyable {}

public interface Any {}

public interface ToString {}

public enum Option<T> {
    | None
    | Some(T)
}

public interface Equatable<T> {}

public interface Hashable {}

public struct String {
    public const init() {}

    public operator func ==(right: String): Bool {
        return true
    }
    public operator func !=(right: String): Bool {
        return false
    }
    public operator func +(right: String): String {
        return ""
    }
}

public type Byte = UInt8

public struct Array<T> {}

public interface Collection<T> {}

func composition<T1, T2, T3>(f: (T1) -> T2, g: (T2) -> T3): (T1) -> T3 {
    return { x: T1 => g(f(x)) }
}

func arrayInitByCollection<T>(array: RawArray<T>, collection: Collection<T>): RawArray<T> {
    array
}

func arrayInitByFunction<T>(array: RawArray<T>, initElement: (Int64) -> T): RawArray<T> {
    array
}

func handleException(): Unit {}

func createOverflowExceptionMsg(): String {
    return ""
}

func createArithmeticExceptionMsg(): String {
    return ""
}

func getCommandLineArgs(): Array<String> {
    return Array<String>()
}

// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan definitions and declarations are always of type 'Unit'
// ASSERT: scan the type of an 'if' expression without an 'else' branch is always 'Unit'
// ASSERT: scan try-with-resources expressions are of type 'Unit'
// ASSERT: scan expected 'Enum-Extern<Class-DummyRT>', found 'Unit'
// ASSERT: scan 8 errors generated

public class DummyRT <: ForeignRuntime<DummyRT> {
    public static func eval(t: Extern<DummyRT>): Extern<DummyRT> {
        t
    }

    public static func fromExtern<R>(e: Extern<DummyRT>): R {
        throw ExternConversionException()
    }

    public static func toExtern<R>(v: R): Extern<DummyRT> {
        Extern<DummyRT>.ExternPayload(v)
    }
}

class Res <: Resource {
    public func isClosed(): Bool {
        false
    }

    public func close(): Unit {}
}

func declLast(): Extern<DummyRT> {
    let z = 1
}

func loopBody(): Extern<DummyRT> {
    while (false) {}
}

main() {
    let c = true
    let noElse: Extern<DummyRT> = if (c) { 1 }
    let declBranch: Extern<DummyRT> = if (c) { 1 } else { let _ = 1 }
    let withResources: Extern<DummyRT> = try (r = Res()) { 1 } catch (e: Exception) { 2 }
    // Loops are never converted as a whole and are always of type Unit.
    let w: Extern<DummyRT> = while (c) {}
    let dw: Extern<DummyRT> = do {} while (c)
    let f: Extern<DummyRT> = for (_ in 0..2) {}
}

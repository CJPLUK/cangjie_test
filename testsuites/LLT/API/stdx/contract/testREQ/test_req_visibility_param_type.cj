/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// A member condition checker is emitted as a generated member of the host type.
// It used to be unconditionally `public`, so an `internal`/`private` member whose
// parameter (or return) type is not public became a compile error:
// "'public' declaration uses 'internal' types". The checker now mirrors the
// checked member's visibility, keeping the original legal declaration compilable.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

private class PrivateHidden {
    public let v: Int64 = 1
}

internal class InternalHidden {
    public let v: Int64 = 2
}

@Contract[]
public class VisibilityBox {
    @Contract [
        requires h.v > 0
    ]
    internal func internalArg(h: InternalHidden): Int64 {
        h.v
    }

    @Contract [
        requires h.v > 0
    ]
    private func privateArg(h: PrivateHidden): Int64 {
        h.v
    }

    func callPrivate(): Int64 {
        privateArg(PrivateHidden())
    }
}

main() {
    let box = VisibilityBox()
    if (box.internalArg(InternalHidden()) != 2) {
        throw Exception("internal member should run")
    }
    if (box.callPrivate() != 1) {
        throw Exception("private member should run")
    }
    println("ok")
}

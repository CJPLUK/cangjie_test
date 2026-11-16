// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC: %mkdir java-gen
// (CJNATIVE and not Windows) EXEC: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop -L.
// (CJNATIVE and not Windows) RUN-EXEC-PIPE: %cat ./java-gen/A.java | compare %f

/* SCAN-IN
import static cangjie.lang.LibraryLoader.loadLibrary;
import cangjie.lang.internal.$$NativeConstructorMarker;

public class A extends M {
    static {
        loadLibrary("cjworld.theworld");
    }

    private long $rid;

    public A() {
        super(1);
        initCJObject();
    }

    private A($$NativeConstructorMarker __init__) {
        super(1);
    }

    private final native void initCJObject();

    public A(long x) {
        super(x, x);
        initCJObjectl(x);
    }

    private A(long x, $$NativeConstructorMarker __init__) {
        super(x, x);
    }

    private final native void initCJObjectl(long x);

    public final void p(A[] o) {
        pCN9java_lang6JArrayICN16cjworld_theworld1AEE(this.$rid, o);
    }

    private final native void pCN9java_lang6JArrayICN16cjworld_theworld1AEE(long $rid, A[] o);

    public final void r(char[] o) {
        rCN9java_lang6JArrayItE(this.$rid, o);
    }

    private final native void rCN9java_lang6JArrayItE(long $rid, char[] o);

    private final native void deleteCJObject(long $rid);

    @Override
    protected void finalize() {
        deleteCJObject(this.$rid);
    }
}
*/

package cjworld.theworld

import java.lang.*

@Java["M"]
public open foreign class M {
    init()
    init(x: Int)
    init(x: Int, y: Int)
}

@Java["A"]
public class A <: M {
    public init() {
        super(1)
        println("Hello from Cangjie!")
    }
    public init(x: Int) {
        super(x, x)
        let a = JArray<Int64>(3)
        a[1]
        a[0] = -22
    }

    public func p(o: JArray<A>) {
        var a = JArray<A>(33)
        a[1]
        a[22] = A()
        a = o
    }

    public func r(o: JArray<UInt16>): Unit {
        JArray<Bool>(12)
    }
}

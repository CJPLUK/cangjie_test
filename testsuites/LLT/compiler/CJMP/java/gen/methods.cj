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

    public final void f() {
        f(this.$rid);
    }

    private final native void f(long $rid);

    public final void oneArg(long x) {
        oneArgl(this.$rid, x);
    }

    private final native void oneArgl(long $rid, long x);

    public final void twoArgs(long x, boolean y) {
        twoArgslb(this.$rid, x, y);
    }

    private final native void twoArgslb(long $rid, long x, boolean y);

    private final native void deleteCJObject(long $rid);

    @Override
    protected void finalize() {
        deleteCJObject(this.$rid);
    }
}

*/

package cjworld.theworld

import java.lang.JObject

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
    }

    public func f() {
        println(1)
    }

    public func oneArg(x: Int) {
        println(x)
    }

    public func twoArgs(x: Int, y: Bool) {
        println(x)
        println(y)
    }
}

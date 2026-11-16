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

    public final M getT() {
        return getTImpl(this.$rid);
    }

    private final native M getTImpl(long $rid);

    public final void setT(M t) {
        setTImpl(this.$rid, t);
    }

    private final native void setTImpl(long $rid, M t);

    public A(long x, long y) {
        super();
        initCJObjectll(x, y);
    }

    private A(long x, long y, $$NativeConstructorMarker __init__) {
        super();
    }

    private final native void initCJObjectll(long x, long y);

    public A() {
        super(superC3A0(), superC3A1());
        initCJObject();
    }

    private A($$NativeConstructorMarker __init__) {
        super(superC3A0(), superC3A1());
    }

    private final native void initCJObject();

    private static final native A superC3A0();
    private static final native M superC3A1();
    public A(int x) {
        super(superC4A0());
        initCJObjecti(x);
    }

    private A(int x, $$NativeConstructorMarker __init__) {
        super(superC4A0());
    }

    private final native void initCJObjecti(int x);

    private static final native A superC4A0();
    public final void f(M arg) {
        fCN16cjworld_theworld1ME(this.$rid, arg);
    }

    private final native void fCN16cjworld_theworld1ME(long $rid, M arg);

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
    init(x: M)
    init(x: A, y: M)
}

@Java["A"]
public class A <: M {
    private var a: M = M()
    public mut prop t: M {
        get() {
            return a
        }
        set(x) {
            a = x
        }
    }

    public init(x: Int64, y: Int64) {}

    public init() {
        super(A(1, 1), M())
    }

    public init(x: Int32) {
        super(A())
    }

    public func f(arg: M) {

    }
}

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

    public A(long f, int x) {
        super(superC3A0P0P1(f, x));
        initCJObjectli(f, x);
    }

    private A(long f, int x, $$NativeConstructorMarker __init__) {
        super(superC3A0P0P1(f, x));
    }

    private final native void initCJObjectli(long f, int x);

    private static final native long superC3A0P0P1(long f, int x);
    public A(long f) {
        super(superC4A0P0(f));
        initCJObjectl(f);
    }

    private A(long f, $$NativeConstructorMarker __init__) {
        super(superC4A0P0(f));
    }

    private final native void initCJObjectl(long f);

    private static final native long superC4A0P0(long f);
    public static final long fieldInitStatic(long f, int x) {
        return fieldInitStaticli(f, x);
    }

    private static final native long fieldInitStaticli(long f, int x);

    public static final long fieldInitStatic(long f) {
        return fieldInitStaticl(f);
    }

    private static final native long fieldInitStaticl(long f);

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

    public static func fieldInitStatic(f: Int64, x: Int32): Int64 {
        f * 2
    }

    public static func fieldInitStatic(f: Int64): Int64 {
        f * 3
    }

    public init(f: Int64, x: Int32) {
        super(fieldInitStatic(f, x))
    }

    public init(f: Int64) {
        super(fieldInitStatic(f))
    }
}

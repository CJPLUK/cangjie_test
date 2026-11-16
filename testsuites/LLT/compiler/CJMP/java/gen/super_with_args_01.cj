// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC: %mkdir java-gen
// (CJNATIVE and not Windows) EXEC: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop -L.
// (CJNATIVE and not Windows) RUN-EXEC-PIPE: %cat ./java-gen/Impl.java | compare %f

/* SCAN-IN
package cj;

import com.java.lib.MyObject;
import static cangjie.lang.LibraryLoader.loadLibrary;
import cangjie.lang.internal.$$NativeConstructorMarker;

public class Impl extends MyObject {
    static {
        loadLibrary("cj");
    }

    private long $rid;

    public Impl() {
        super(1);
        initCJObject();
    }

    private Impl($$NativeConstructorMarker __init__) {
        super(1);
    }

    private final native void initCJObject();

    public Impl(long value) {
        super(superC1A0P0(value));
        initCJObjectl(value);
    }

    private Impl(long value, $$NativeConstructorMarker __init__) {
        super(superC1A0P0(value));
    }

    private final native void initCJObjectl(long value);

    private static final native long superC1A0P0(long value);
    public Impl(long x, long y) {
        super(superC2A0P0P1(x, y));
        initCJObjectll(x, y);
    }

    private Impl(long x, long y, $$NativeConstructorMarker __init__) {
        super(superC2A0P0P1(x, y));
    }

    private final native void initCJObjectll(long x, long y);

    private static final native long superC2A0P0P1(long x, long y);
    public Impl(long x, long y, long z) {
        super(superC3A0P0P1P2(x, y, z));
        initCJObjectlll(x, y, z);
    }

    private Impl(long x, long y, long z, $$NativeConstructorMarker __init__) {
        super(superC3A0P0P1P2(x, y, z));
    }

    private final native void initCJObjectlll(long x, long y, long z);

    private static final native long superC3A0P0P1P2(long x, long y, long z);
    public Impl(long x, long y, long z, long u) {
        super(superC4A0P0P1P2P3(x, y, z, u));
        initCJObjectllll(x, y, z, u);
    }

    private Impl(long x, long y, long z, long u, $$NativeConstructorMarker __init__) {
        super(superC4A0P0P1P2P3(x, y, z, u));
    }

    private final native void initCJObjectllll(long x, long y, long z, long u);

    private static final native long superC4A0P0P1P2P3(long x, long y, long z, long u);
    private final native void deleteCJObject(long $rid);

    @Override
    protected void finalize() {
        deleteCJObject(this.$rid);
    }
}

*/

package cj

import java.lang.*

@Java["com.java.lib.MyObject"]
public open foreign class MyObject {
    public init(value: Int64)
    public open func getValue(): Int64
}

var gv: Int64 = 1

func gf(x: Int64): Int64 {
    x + 1
}

@Java
public class Impl <: MyObject {
    public init() {
        super(1)
    }

    public init(value: Int64) {
        super(value + 1)
    }

    public init(x: Int64, y: Int64) {
        super(y + x)
    }

    public init(x: Int64, y: Int64, z: Int64) {
        super(y + x + gv + gf(z))
    }

    public init(x: Int64, y: Int64, z: Int64, u: Int64) {
        super(if (x > y) {x} else {y} + match {
            case z > u => u
            case u > z => z
            case _ => u
        })
    }
}

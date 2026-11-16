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
        super(superC0A0());
        initCJObject();
    }

    private Impl($$NativeConstructorMarker __init__) {
        super(superC0A0());
    }

    private final native void initCJObject();

    private static final native long superC0A0();
    public Impl(long value) {
        super(superC1A0P0(value));
        initCJObjectl(value);
    }

    private Impl(long value, $$NativeConstructorMarker __init__) {
        super(superC1A0P0(value));
    }

    private final native void initCJObjectl(long value);

    private static final native MyObject superC1A0P0(long value);
    public Impl(long x, long y) {
        super(superC2A0P0P1(x, y));
        initCJObjectll(x, y);
    }

    private Impl(long x, long y, $$NativeConstructorMarker __init__) {
        super(superC2A0P0P1(x, y));
    }

    private final native void initCJObjectll(long x, long y);

    private static final native Impl superC2A0P0P1(long x, long y);
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
    public init(value: MyObject)
    public open func getValue(): Int64
}

@Java
public class Impl <: MyObject {
    public init() {
        // Primitive argument
        super(2 + 3)
    }

    public init(value: Int64) {
        // JavaMirror argument
        super(MyObject(value))
    }

    public init(x: Int64, y: Int64) {
        // JavaImpl argument
        super(Impl(x * y))
    }
}

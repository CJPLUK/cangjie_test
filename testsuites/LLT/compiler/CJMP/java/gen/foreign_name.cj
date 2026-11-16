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
        super();
        initCJObject();
    }

    private A($$NativeConstructorMarker __init__) {
        super();
    }

    private final native void initCJObject();

    public static final native int foo();

    public final int bar() {
        return bar(this.$rid);
    }

    private final native int bar(long $rid);

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
    public init()

    @ForeignName["id"]
    public let myId: Int32

    @ForeignName["foo"]
    public static func myFoo(): Int32

    @ForeignName["bar"]
    public open func myBar(): Int32
}

@Java["A"]
public class A <: M {
    public init() {
        super()
    }

    public static func myFoo(): Int32 { return 0; }

    public open func myBar(): Int32 {
        return 0;
    }
}

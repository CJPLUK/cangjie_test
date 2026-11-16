// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop -L.
// (CJNATIVE and not Windows) RUN-EXEC-PIPE: %cat ./java-gen/A.java | compare %f

/* SCAN-IN
import other.Cla$s;
import static cangjie.lang.LibraryLoader.loadLibrary;
import cangjie.lang.internal.$$NativeConstructorMarker;

public class A extends Cla$s.Inner {
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

    public final Clas$.Inner.InnerCla$s useTypes(Clas$ a1, Clas$.Inner a2, Cla$s a3, Cla$s.Inner.InnerCla$s a4) {
        return useTypesCN16cjworld_theworld5OuterECN16cjworld_theworld5InnerECN16cjworld_theworld17OtherPackageOuterECN16cjworld_theworld15OtherInnerInnerE(this.$rid, a1, a2, a3, a4);
    }

    private final native Clas$.Inner.InnerCla$s useTypesCN16cjworld_theworld5OuterECN16cjworld_theworld5InnerECN16cjworld_theworld17OtherPackageOuterECN16cjworld_theworld15OtherInnerInnerE(long $rid, Clas$ a1, Clas$.Inner a2, Cla$s a3, Cla$s.Inner.InnerCla$s a4);

    private final native void deleteCJObject(long $rid);

    @Override
    protected void finalize() {
        deleteCJObject(this.$rid);
    }
}

*/

package cjworld.theworld

import java.lang.JObject

@Java["Clas\\$"]
public open foreign class Outer {
    init()
}

@Java["Clas\\$$Inner"]
public open foreign class Inner {
    init()
}

@Java["Clas\\$$Inner$InnerCla\\$s"]
public open foreign class InnerInner {
    init()
}

@Java["other.Cla\\$s"]
public open foreign class OtherPackageOuter {
    init()
}

@Java["other.Cla\\$s$Inner"]
public open foreign class OtherInner {
    init()
}

@Java["other.Cla\\$s$Inner$InnerCla\\$s"]
public open foreign class OtherInnerInner {
    init()
}

@Java["A"]
public class A <: OtherInner {
    public init() {
        super()
        println("Hello from Cangjie!")
    }

    public func useTypes(a1: Outer, a2: Inner, a3: OtherPackageOuter, a4: OtherInnerInner): InnerInner {
        return InnerInner()
    }
}

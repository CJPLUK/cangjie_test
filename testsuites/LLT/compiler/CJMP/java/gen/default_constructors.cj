// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC: %mkdir java-gen
// (CJNATIVE and not Windows) EXEC: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop -L.
// (CJNATIVE and not Windows) RUN-EXEC-PIPE: %cat ./java-gen/CangjieInvoke_Father.java | compare %f

/* SCAN-IN
import static cangjie.lang.LibraryLoader.loadLibrary;
import cangjie.lang.internal.$$NativeConstructorMarker;

public class CangjieInvoke_Father {
    static {
        loadLibrary("cjworld.theworld");
    }

    private long $rid;

    public CangjieInvoke_Father() {
        super();
        initCJObject();
    }

    private CangjieInvoke_Father($$NativeConstructorMarker __init__) {
        super();
    }

    private final native void initCJObject();

    public final boolean test() {
        return test(this.$rid);
    }

    private final native boolean test(long $rid);

    private final native void deleteCJObject(long $rid);

    @Override
    protected void finalize() {
        deleteCJObject(this.$rid);
    }
}

*/

package cjworld.theworld

import java.lang.JObject

@Java
public class CangjieInvoke_Father <: JObject {
    public init() {}

    public func test(): Bool {
        println("in CangjieInvoke_Father Func")
        false
    }
}

@Java
public class CangjieInvoke <: JObject {
    public init() {
        println("in CangjieInvoke Init")
    }

    public func test() {
        println("in CangjieInvoke Func")
        return CangjieInvoke_Father().test()
    }
}

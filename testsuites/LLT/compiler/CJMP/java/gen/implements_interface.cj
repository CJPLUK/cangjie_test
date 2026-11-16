// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC: %mkdir java-gen
// (CJNATIVE and not Windows) EXEC: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop -L.
// (CJNATIVE and not Windows) RUN-EXEC-PIPE: %cat ./java-gen/C2.java | compare %f
// (CJNATIVE and not Windows) ASSERT: regex public class C2 implements I2, I3 {|public class C2 implements I3, I2 {

/* SCAN-IN
import static cangjie.lang.LibraryLoader.loadLibrary;
import cangjie.lang.internal.$$NativeConstructorMarker;
*/


/* SCAN-IN
    static {
        loadLibrary("cjworld.theworld");
    }

    private long $rid;

    public C2() {
        super();
        initCJObject();
    }

    private C2($$NativeConstructorMarker __init__) {
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
public foreign interface I2 {
    func test(): Bool
}

@Java
public foreign interface I3 {
    func test(): Bool
}

@Java
public class C2 <: I2 & I3 {
    public init() {
        println("in C2 Init")
    }

    public func test() {
        println("in C2 Func")
        return false
    }
}

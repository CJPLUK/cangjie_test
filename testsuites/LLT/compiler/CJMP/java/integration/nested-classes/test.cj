// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) DEPENDENCE: ./java
// (CJNATIVE and not Windows) RUN-EXEC-0: cjc %compile_shared_lib_opt %f %import_java_interop --output-javagen-dir=java/cj
// (CJNATIVE and not Windows) RUN-EXEC-0: %javac %cp_cj_loader_java_interop java/com/java/lib/*.java java/cj/*.java -h ./ -d ./
// (CJNATIVE and not Windows) RUN-EXEC-PIPE: %java %cp_cj_loader_java_interop -Djava.library.path=./ cj.Main 2>& 1 | compare %f
package cj

import java.lang.*

@Java["com.java.lib.Cla\\$s"]
public foreign class Class {
    public init()
}

@Java["com.java.lib.Cla\\$s$Inner"]
public foreign class Class_Inner {
    public init()

    public func getInner(): Class_Inner_InnerClass
}

@Java["com.java.lib.Cla\\$s$Inner$InnerClas\\$"]
public foreign class Class_Inner_InnerClass {
    public init()
}

@Java
public class Main <: JObject {
    @ForeignName["main"]
    public static func entry(args: JArray<JString>): Unit {
        print("cj: Main()\n", flush: true)
        println(Class().toString())
        println(Class_Inner().toString())
        println(Class_Inner().getInner().toString())
        print("cj: Main() end\n", flush: true)
    }
}

/* SCAN-IN
cj: Main()
[0] Cla$s
[1] Cla$s.Inner
[2] Cla$s.Inner.InnerClas$
cj: Main() end
*/

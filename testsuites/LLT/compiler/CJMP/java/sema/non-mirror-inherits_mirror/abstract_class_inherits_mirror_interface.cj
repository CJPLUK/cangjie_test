// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt %import_java_interop  --output-javagen-dir=./ 2>& 1 | compare %f 

import java.lang.*

@Java["com.MyJavaMirrorInterface"]
public foreign interface MyJavaMirrorInterface {
    func sayHello(): Unit
}

public interface PureAbstractClass <: MyJavaMirrorInterface {}

// ASSERT: scan sema_java_mirror_subtype_must_be_annotated
// ASSERT: scan 'PureAbstractClass' must be annotated with either '@Java' or '@Java foreign'

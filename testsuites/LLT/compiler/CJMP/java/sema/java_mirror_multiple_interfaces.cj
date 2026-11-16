// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop -L.

import java.lang.JObject

@Java
public foreign interface I1 {
}

@Java
public foreign interface I2 {
}

@Java
foreign class JForeignClass <: I1 & I2 {
}

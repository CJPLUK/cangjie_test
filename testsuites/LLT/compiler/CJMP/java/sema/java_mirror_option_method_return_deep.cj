// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

import java.lang.JObject

@Java
foreign class OtherMirror {
   public init()
}

@Java
foreign class M {
    public func foo(): ?????JObject
    public func self(): ??M
    public func other(): ???OtherMirror
}

// ASSERT: scan sema_java_mirror_method_ret_unsupported
// ASSERT: scan 'Enum-Option<Enum-Option<Enum-Option<Enum-Option<Enum-Option<Class-JObject>>>>>' is not java-compatible type
// ASSERT: scan 'Enum-Option<Enum-Option<Class-M>>' is not java-compatible type
// ASSERT: scan 'Enum-Option<Enum-Option<Enum-Option<Class-OtherMirror>>>' is not java-compatible type
// ASSERT: scan "Errors": 3

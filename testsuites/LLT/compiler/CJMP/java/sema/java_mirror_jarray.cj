// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

import java.lang.*

@Java
foreign class M {
    public func foo(a: JArray<JObject>): Unit
    public func foo(a: JArray<?JObject>): Unit
    public func fooOpt(a: ?JArray<JObject>): Unit
    public func fooOpt(a: ?JArray<?JObject>): Unit

    public func retArr1(): JArray<JObject>
    public func retArr2(): JArray<M>
    public func retArrNested(): JArray<JArray<JObject>>
    public func retArrNested2(): JArray<JArray<JArray<JObject>>>
    public func retArrOpt(): JArray<?JObject>
    public func retOptArr(): ?JArray<JObject>
    public func retOptArr2(): ?JArray<?JObject>

    public func retComplicated(): ?JArray<JArray<?JArray<Option<JArray<JArray<JObject>>>>>>
    public func complicated(arg: ?JArray<JArray<?JArray<Option<JArray<JArray<JObject>>>>>>): ?JArray<JArray<?JArray<Option<JArray<JArray<JObject>>>>>>
}

/**
 * Test note: check possible array signatures and positions
 */

// ASSERT: scan-not error

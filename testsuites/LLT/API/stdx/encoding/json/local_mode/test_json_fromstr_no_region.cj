/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// UPDATE 2026-09-11: SDK local_mode-localmods-20260911-final 已修复本文件原阻塞器，恢复 EXEC（原阻塞记录见下）。
// UPDATE 2026-09-21: 本地重建 stdx (feat-stdx-json-local-mode-session) 下本隔离用例 cjc+run ALL PASSED，run 步骤恢复 EXEC。
// EXEC: %compiler %local %import-cangjie-stdx %cmp_opt %f -o %output
// EXEC: %set_stdx_path %run %run_opt %output %run_args
//
// LM-DOC-20260910: T509 isolated provenance probe.  The only local value in
// this compilation unit is the String @local? view passed to fromStr and the
// JsonValue @local! result.  No helper, anchor object, heap/local control pair,
// or unrelated local allocation is permitted to change region placement.
// Expected doc behavior is JsArray, size 0, exit 0.

import stdx.encoding.json.*

main(): Int64 {
    let heapText: String = "[]"
    let borrowed: String @local? = heapText
    let value: JsonValue @local! = JsonValue.fromStr(borrowed)
    match (value.kind()) {
        case JsonKind.JsArray => ()
        case _ =>
            println("FAIL: T509_result_kind")
            return 1
    }
    let array: JsonArray @local! = value.asArray()
    if (array.size() != 0) {
        println("FAIL: T509_result_size")
        return 1
    }
    println("ALL PASSED")
    return 0
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// UPDATE 2026-09-21: 本地重建 stdx (feat-stdx-json-local-mode-session) 提供 JSON local surface；0917 SDK 实证通过，恢复 EXEC。
// Evidence: cjc+run ALL PASSED — 本地重建 stdx 可链接（旧 SKIP-COMPILE 记录的 wyhash 链接缺失不再复现），raw U+0000-U+001F 均抛 JsonException。
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %f -o %output
// EXEC: %set_stdx_path %run %run_opt %output %run_args
//
// LM-DOC-20260910: T516 source-gap control. RFC JSON string members must
// reject raw U+0000/U+000A/U+001F rather than accepting and escaping them;
// the exact JsonException oracle is retained for rerun after the linker fix.
// This heap-only source-gap check is independent of local-mode overload parity.

import stdx.encoding.json.*

func expectRejected(source: String, label: String): Int64 {
    try {
        let _: JsonValue = JsonValue.fromStr(source)
        println("FAIL: ${label}_accepted_raw_control")
        1
    } catch (_: JsonException) {
        0
    }
}

main(): Int64 {
    var failed: Int64 = 0
    failed += expectRejected("\"a\u{0000}b\"", "T516_raw_u0000")
    failed += expectRejected("\"a\u{000a}b\"", "T516_raw_u000a")
    failed += expectRejected("\"a\u{001f}b\"", "T516_raw_u001f")
    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}

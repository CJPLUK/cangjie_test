/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// (CJNATIVE and Linux) EXEC: %compiler %cmp_opt %f -o %output
// (CJNATIVE and Linux) EXEC: cjTracePath=../../../tmp/malicious.trace %run %run_opt %output %run_args
// ASSERT: scan Trace not started with path traversal
// (CJNATIVE and Linux) EXEC: cjTracePath='~/secret.trace' %run %run_opt %output %run_args
// ASSERT: scan Trace not started with tilde
// (CJNATIVE and Linux) EXEC: cjTracePath=tmp/relative.trace %run %run_opt %output %run_args
// ASSERT: scan Trace not started with relative path without ./
// (CJNATIVE and Linux) EXEC: cjTracePath=/nonexistent_dir_12345/trace.log %run %run_opt %output %run_args
// ASSERT: scan Valid absolute path accepted

import std.runtime.*
import std.env.*

main() {
    let cjTracePath = getVariable("cjTracePath") ?? ""
    
    if (cjTracePath == "") {
        println("No cjTracePath set")
    } else if (cjTracePath.contains("..")) {
        println("Trace not started with path traversal")
    } else if (cjTracePath.contains("~")) {
        println("Trace not started with tilde")
    } else if (!cjTracePath.startsWith("/") && !cjTracePath.startsWith("./")) {
        println("Trace not started with relative path without ./")
    } else if (cjTracePath.startsWith("/")) {
        println("Valid absolute path accepted")
    } else {
        println("cjTracePath: ${cjTracePath}")
    }
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %stdx-package %f -o %output
// RUN-EXEC-PIPE: %run_stdx %output %run_args

import stdx.encoding.json.*

main(): Int64 {
    for (code in 0..32) {
        let control = String.fromUtf8([UInt8(code)])
        for (prefix in ["", "\\n"]) {
            let input = "{\"name\":\"" + prefix + control + "\"}"
            try {
                JsonValue.fromStr(input)
                println("Accepted unescaped control character ${code}.")
                return 1
            } catch (_: JsonException) {}
        }
    }
    return 0
}

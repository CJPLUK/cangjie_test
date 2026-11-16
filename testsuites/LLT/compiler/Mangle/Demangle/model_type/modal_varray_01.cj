/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %local %cmp_opt %f -o %output
// ERRCHECK: %run %run_opt %output %run_args
// ASSERT: scan-begin at pkg1.pkg2::vthrow(VArray<Int64,$4> @ local?)

// A/V/P container bodies are not 'E'-terminated: the trailing <type-mode> belongs to the
// container itself, so the frame name renders the modal after the whole `VArray<Int64,$4>`.

package pkg1.pkg2

func vthrow(a: VArray<Int64, $4> @local?) {
    throw Exception()
}

main() {
    var v: VArray<Int64, $4> @ local? = [1, 2, 3, 4]
    vthrow(v)
    return 0
}

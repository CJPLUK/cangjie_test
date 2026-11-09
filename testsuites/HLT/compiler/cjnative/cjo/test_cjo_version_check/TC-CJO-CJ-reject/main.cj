/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// 用例: TC-CJO-CJ-reject(组: CJMP)
// 意图: 公共部分 cjo 不兼容 → 预加载报版本 error,且无部分加载产物


// DEPENDENCE: c p ../tools
// EXEC-0: %compiler %cmp_opt --experimental c/c.cj --output-type=chir --output-dir ./c
// EXEC: %python tools/cjo_mutate.py --patch-cjo c/cmp.cjo --set-cjo-version next-minor
// EXEC-PIPE-1: %compiler %cmp_opt --experimental p/p.cj --common-part-chir=c/cmp.chir --common-part-cjo=c/cmp.cjo --output-type=dylib --output-dir ./p 2>&1 | compare %f
// ASSERT: scan is incompatible: compiled with cjc
// (Linux)EXEC: test ! -f ./p/libp.so
// (Windows)EXEC: powershell -c "if (Test-Path ./p/libp.dll) { exit 1 }"


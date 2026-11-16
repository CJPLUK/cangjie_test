/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// 用例: TC-CJO-CJ-compat(组: CJMP)
// 意图: 预加载兼容公共部分 CJO 成功并继续后续流程;无版本诊断


// DEPENDENCE: c p
// EXEC-0: %compiler %cmp_opt --experimental c/c.cj --output-type=chir --output-dir ./c
// EXEC-PIPE-0: %compiler %cmp_opt --experimental p/p.cj --common-part-chir=c/cmp.chir --common-part-cjo=c/cmp.cjo --output-type=dylib --output-dir ./p 2>&1 | compare %f
// ASSERT: scan-not is incompatible: compiled with cjc
// ASSERT: scan-not validation of


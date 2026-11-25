/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-031: two packages both define `Amb` and both persist a record;
// the consumer's bare `inherits from Amb` matches both records, which is
// reported as ambiguous contract metadata and the inheritance falls back to
// unavailable metadata.
// DEPENDENCE: cov_meta_lib_p1.cj
// DEPENDENCE: cov_meta_lib_p2.cj
// EXEC: rm -rf %n_meta && mkdir -p %n_meta
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=covmeta1 %compiler %import-cangjie-stdx %cmp_opt cov_meta_lib_p1.cj --output-type=staticlib -o lib%n_cm1.a
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=covmeta2 %compiler %import-cangjie-stdx %cmp_opt cov_meta_lib_p2.cj --output-type=staticlib -o lib%n_cm2.a
// EXEC-PIPE-1: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=covmetacons %compiler %import-cangjie-stdx %cmp_opt --import-path . -L . -l %n_cm1 -l %n_cm2 %f -o %output 2>&1 | compare %f
// ASSERT: scan ambiguous contract metadata
// ASSERT: scan parent contract metadata is unavailable
// ASSERT: scan-not core dumped

import stdx.contract.macros.*
import covmeta1.*
import covmeta2.*

@Contract [ inherits from Amb ]
class AmbChild <: covmeta1.Amb {
    public init() {
        super()
    }
}

main() {
}

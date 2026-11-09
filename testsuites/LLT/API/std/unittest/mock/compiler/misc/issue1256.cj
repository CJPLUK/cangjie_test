// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// SEPARATE-FILE: com.cj
// EXEC-0: %compiler %noColor --experimental com.cj --output-type=chir --mock=on
package core
public common func f(p0: Int64): Int64

// SEPARATE-FILE: f1.cj
// EXEC-0: %compiler %noColor --experimental f1.cj --common-part-chir=core.chir --common-part-cjo=core.cjo --output-type=chir --mock=on
package core
public specific func f(p0: Int64): Int64 {
    return p0
}

// SEPARATE-FILE: f2.cj
// EXEC-0: %compiler %noColor --experimental f2.cj --common-part-chir=core.chir --common-part-cjo=core.cjo --output-type=chir --mock=on
package core

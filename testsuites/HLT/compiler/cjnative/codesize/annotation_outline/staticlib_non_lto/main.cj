/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

import annopkg.*
import std.reflect.*

main() {
    if (let Some(a) <- TypeInfo.of(C1()).findAnnotation<CustomAnnotation>()) {
        if (a.value != "123" || a.version != 3) {
            return 1
        }
    } else {
        return 2
    }
    0
}

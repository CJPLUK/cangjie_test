/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

main() {
    let src = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let dst = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    src.copyTo(dst, 0, 0, 10)
    if (dst[0] != 1 || dst[9] != 10) {
        return 1
    }
    0
}

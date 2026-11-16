/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

main() {
    let src = Array<Int64>(268435456, repeat: 0)
    let dst = Array<Int64>(268435456, repeat: 0)
    src.copyTo(dst, 0, 0, 268435456)
    0
}

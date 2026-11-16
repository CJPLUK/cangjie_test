/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

var gSrcStart: Int64 = 1
var gDstStart: Int64 = 2
var gCopyLen: Int64 = 4

main() {
    let arr = [1, 2, 3, 4, 5, 6, 7, 8]
    arr.copyTo(arr, gSrcStart, gDstStart, gCopyLen)
    if (arr[0] != 1 || arr[1] != 2 || arr[2] != 2 || arr[3] != 3 || arr[4] != 4 || arr[5] != 5 || arr[6] != 7 || arr[7] != 8) {
        return 1
    }

    let src = [10, 11, 12, 13, 14, 15, 16, 17]
    let dst = [0, 0, 0, 0, 0, 0, 0, 0]
    src.copyTo(dst, 2, 3, gCopyLen)
    if (dst[0] != 0 || dst[1] != 0 || dst[2] != 0 || dst[3] != 12 || dst[4] != 13 || dst[5] != 14 || dst[6] != 15 || dst[7] != 0) {
        return 1
    }
    0
}

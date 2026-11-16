/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

func copyTwoSegments() {
    let src = Array<Int64>(536870910, repeat: 0)
    let dst = Array<Int64>(536870910, repeat: 0)
    src.copyTo(dst, 0, 0, 536870910)
}

func copyThreeSegments() {
    let src = Array<Int64>(805306365, repeat: 0)
    let dst = Array<Int64>(805306365, repeat: 0)
    src.copyTo(dst, 0, 0, 805306365)
}

func copyTwoSegmentsRemainder() {
    let src = Array<Int64>(536870911, repeat: 0)
    let dst = Array<Int64>(536870911, repeat: 0)
    src.copyTo(dst, 0, 0, 536870911)
}

main() {
    copyTwoSegments()
    copyThreeSegments()
    copyTwoSegmentsRemainder()
    0
}

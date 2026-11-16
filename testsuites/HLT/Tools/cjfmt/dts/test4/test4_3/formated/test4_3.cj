/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

macro package define

var a = @M[
    @sourceLine()
    ](@sourceLine())

func test(
    a!: String = @sourceLine(),
    b!: String = @sourceLine()
) {
    return a
}

public macro M(input: Tokens) {
    return quote(
        @sourceLine(
        )
        )
}

public macro N(input: Tokens) {
    return quote(
        @sourceLine(
    )
    ) + quote(+) + input
}

main() {
    var packageName = @sourceLine(

    )
    var b = [
        "1",
        "2",
        @sourceLine()
    ]
    var c = @sourceLine(
        1
    )
    var packageName1 = @M(
        @sourceLine()
    )
    @sourceLine(

    )
}

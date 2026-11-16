// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

class Response<T> {
}

exclave func handle(r: Response<Int> @local!, success: ?(?Response<Int> @local?) -> Unit) {
    let s = success.getOrThrow()
    s(r)
}

main() {}

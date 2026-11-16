/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

func recurse(n: Int64): Int64 {
    if (n > 100000000) {
        return n
    }
    recurse(n + 1) + 1
}

func doIt(): Int64 {
    try {
        recurse(0)
        1
    } catch (e: StackOverflowError) {
        return 0
    } catch (_) {
        return 2
    }
    1
}

main() {
    if (doIt() != 0) {
        return 1
    }
    0
}

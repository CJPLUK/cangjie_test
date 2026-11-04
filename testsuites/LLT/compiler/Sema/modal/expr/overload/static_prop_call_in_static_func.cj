// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

class StaticPropUser {
    private static prop baseValue: Int64 {
        get() {
            return 41
        }
    }

    public static func readFromStaticFunc(): Int64 {
        return baseValue
    }
}

main() {}
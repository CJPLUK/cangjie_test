/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// ERRCHECK: %compiler %cmp_opt %f -o %output

enum TimeUnit1<T> {
    One(TimeUnit2<T>)
}

enum TimeUnit2<T> {
    Two(TimeUnit3<T>)
}

enum TimeUnit3<T> {
    Three(TimeUnit4<T>)
}

enum TimeUnit4<T> {
    Four(TimeUnit5<T>)
}

enum TimeUnit5<T> {
    Five
}

func run(): Int64 {
    var time0 = TimeUnit1<Int32>.One(Two(Three(Four(Five)))) // can be inferred
    var time1 = TimeUnit1.One(Two(Three(Four(Five)))) // failed
    var res: Int32 = match (time1) {
        case One(Two(Three(Four(Five)))) => 4
        case _ => 5
    }

    if (res == 4) {
        return 0
    } else {
        return 1
    }
}

main(): Int64 {
    return run()
}
// ASSERT: scan sema_generic_type_without_type_argument

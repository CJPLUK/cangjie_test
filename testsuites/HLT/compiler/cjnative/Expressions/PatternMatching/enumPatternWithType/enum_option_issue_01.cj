/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// ERRCHECK: %compiler %cmp_opt %f -o %output

enum A<T> {
    EA
    | EB(T)
}

enum TimeUnit<T> {
    Month
    | Year(A<T>)
}

let c = Year(EA)

main() {
    1
}
// ASSERT: scan sema_generic_type_without_type_argument

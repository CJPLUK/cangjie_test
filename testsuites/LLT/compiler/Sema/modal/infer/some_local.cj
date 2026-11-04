// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
// EXEC: %frontendCompiler %local %f
exclave func foo<K,V>(k: K@local!, v: V@local!): ?(K,V)@local! {
    Some((k,v)) // see line 11
}
exclave func bar<K,V>(k: K@local!, v: V@local!): ?(K,V)@local! {
    Some<(K,V)>((k,v))
}
main() {}
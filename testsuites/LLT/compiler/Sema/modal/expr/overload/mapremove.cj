// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
class Map<T> {
    func removeIf(pred: ()->Bool) {}
}

class Item {
    public func isEmpty() { true }
    public func isEmpty(this @local?) { true }
}
main() {
    let map = Map<Item>()
    let item = Item()
    map.removeIf(item.isEmpty)
}
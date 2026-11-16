// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

class A {
    func a() {
        var str: String = """
            TouchType: ${event
                .eventType
                .toString()}
            timestamp: ${event.timestamp}
            Distance between touch point and touch element:
            x: ${event
                .touches[0]
                .x}
            y: ${event
                .touches[0]
                .y}
            Component localPos:(${event
                .target
                .area
                .position
                .x}, ${event
                    .target
                    .area
                    .position
                    .y})
            Component globalPos:(${event
                .target
                .area
                .globalPosition
                .x}, ${event
                    .target
                    .area
                    .globalPosition
                    .y})
            width: ${event
                .target
                .area
                .width}
            height: ${event
                .target
                .area
                .height}
        """
    }
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
package UNNAMED

import java.lang.*

@Java["com.example.myapplication.Logger"]
public open foreign class _Logger {
    public static func print(message: JString): Unit
    public static func println(message: JString): Unit
}

class Logger {
    public static func print(message: ToString): Unit {
        _Logger.print(JString(message.toString()))
    }
    public static func println(message: ToString): Unit {
        _Logger.println(JString(message.toString()))
    }
}

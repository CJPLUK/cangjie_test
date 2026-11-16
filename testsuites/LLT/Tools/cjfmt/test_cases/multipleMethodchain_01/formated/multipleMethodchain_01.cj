// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

import cjoy.*

main(): Int64 {
    // 创建joy实例
    let joy = Joy.default()
    // 带参路由：GET /{name}
    joy
        .router
        .get(
            "/{name}",
            {
                ctx: JoyContext =>
                    let name = ctx.getParam("name") ?? "no name"
                    ctx.string("name in parameter path, name=${name}")
            }
        )
    // 静态路由：GET /abc
    joy
        .router
        .get("/abc", {
            ctx: JoyContext => ctx.string("static path abc")
        })
    // 启动服务
    joy.run("127.0.0.1", 18881)
    return 0
}

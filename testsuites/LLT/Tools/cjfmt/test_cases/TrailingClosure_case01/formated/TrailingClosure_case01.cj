// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

internal import ohos.ark_interop.*
internal import ohos.hilog.*
internal import std.time.*

func foo111(jsContext: JSContext, jsCallInfo: JSCallInfo): JSValue {
    jsContext
        .global["getAccessTokenId"]
        .asFunction(jsContext)
        .call()
        .asPromise(jsContext)
        .then(
            jsContext.function {
                jsContext: JSContext, jsCallInfo: JSCallInfo =>
                    let accessTokenId = jsCallInfo[0]
                    jsContext.undefined().toJSValue()
            }
        )
    jsContext.undefined().toJSValue()
}

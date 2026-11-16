// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package abstract

import java.lang.JObject

@Java["com.java.lib.Abstract"]
public abstract foreign class Abstract {
    public abstract open func foo(): Abstract
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package plugin_to_string_dump

import stdx.chir.*
import stdx.plugin.*

/**
 * Dump markers from Package.toString() to exercise to_string_utils paths
 * on compiler-lowered Function / Block IR (internal fields filled by deserialize).
 */
@CHIRPlugin
class ToStringDump {
    public override func run(pkg: Package): Bool {
        let d = pkg.toString()
        println("has predecessors: ${d.contains("predecessors:")}")
        println("has funcKind: ${d.contains("funcKind:")}")
        println("has paramDftHost: ${d.contains("paramDftValHostParam:")}")
        println("has paramDftFunc: ${d.contains("paramDftValFunc:")}")
        println("has propLocation: ${d.contains("propLocation:")}")
        println("has fastNative: ${d.contains("[fastNative]")}")
        println("has genericDecl: ${d.contains("genericDecl:")}")
        println("toString dump ok")
        return true
    }
}

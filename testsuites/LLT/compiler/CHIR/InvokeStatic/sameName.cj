// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %enableFuncInlining %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

interface ConfigObject {
    static func parse(tv: ?TomlValue): String
}

interface ConfigString <: ConfigObject {
    static func parse(tv: ?TomlValue): String {
        if (let Some(v) <- tv && let Some(tstr) <- (v as TomlString)) {
            parse(tstr.value)
        } else {
            "haha"
        }
    }
    static func parse(value: String): String
}

abstract class TomlValue {

}
class TomlString <: TomlValue {
    TomlString(let value: String) {}
}

main() {
    
}
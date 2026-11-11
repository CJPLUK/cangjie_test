// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class Explicit {
    public let u: Int64 = 9
    const init(this @local!) { exclave {} }
    const init(this @local?) { exclave {} }
}

class Modified {
    public let u: Int64 = 9
    const exclave init(this @local!) {}
    const exclave init(this @local?) {}
}

struct Value {
    public let u: Int64 = 9
    const init(this @local!) { exclave {} }
    const exclave init(this @local?) {}
}

const EFull: Int64 = (Explicit() @local!).u
const EHalf: Int64 = (Explicit() @local?).u
const MFull: Int64 = (Modified() @local!).u
const MHalf: Int64 = (Modified() @local?).u
const VFull: Int64 = (Value() @local!).u
const VHalf: Int64 = (Value() @local?).u

class Holder {
    public static const EFull: Int64 = (Explicit() @local!).u
    public static const EHalf: Int64 = (Explicit() @local?).u
    public static const MFull: Int64 = (Modified() @local!).u
    public static const MHalf: Int64 = (Modified() @local?).u
}

main(): Int64 {
    const le: Int64 = (Explicit() @local!).u
    const lm: Int64 = (Modified() @local?).u
    const lv: Int64 = (Value() @local!).u
    if (EFull != 9 || EHalf != 9 || MFull != 9 || MHalf != 9 || VFull != 9 || VHalf != 9) {
        return 1
    }
    if (Holder.EFull != 9 || Holder.EHalf != 9 || Holder.MFull != 9 || Holder.MHalf != 9) {
        return 2
    }
    if (le != 9 || lm != 9 || lv != 9) { return 3 }
    return 0
}

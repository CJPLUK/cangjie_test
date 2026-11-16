// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (Linux and CJNATIVE) EXEC: %compiler %cmp_opt %f --save-temps . -j1 --apc=1 --output-type=dylib -o %output
// (Linux and CJNATIVE) EXEC-PIPE: { %llvmDissembler %n.bc -o -; readelf --dyn-syms -W %output; } | compare %f

// A unit value is materialized as one Unit.Val global per module: every module that uses the unit
// value emits its own copy and never imports it from another DSO. weak_odr must therefore be kept
// for dedup at static link time, but the symbol must be hidden, so that it is dropped from .dynsym
// and in-DSO references are resolved at link time instead of being preemptible.
// (Linux and CJNATIVE) ASSERT: regex @Unit\.Val = weak_odr hidden global %Unit\.Type
// (Linux and CJNATIVE) ASSERT: regex-not ^ *[0-9]+: +[0-9a-f]+ +[0-9]+ +OBJECT +(WEAK|GLOBAL) +\S+ +[0-9A-Z]+ +Unit\.Val$

// Reverse guard: Unit.ti has a unique owner (std.core) and is imported across DSOs, so it must stay
// an exported dynamic symbol -- hiding must not be widened beyond Unit.Val.
// (Linux and CJNATIVE) ASSERT: regex ^ *[0-9]+: +[0-9a-f]+ +[0-9]+ +OBJECT +GLOBAL +\S+ +UND +Unit\.ti$

public let unitVal: Unit = ()

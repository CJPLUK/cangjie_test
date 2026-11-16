// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (Linux and CJNATIVE) EXEC: %compiler %cmp_opt %f --output-type=dylib -o %output
// (Linux and CJNATIVE) EXEC-PIPE: { readelf --dyn-syms -W %output; readelf -s -W %output; readelf -d -W %output; } | compare %f

// cjld.shared.lds links every Cangjie shared library. The ELF boundary symbols and the legacy
// single-underscore _CJMetadataStart are link-script internals, so they are defined with
// PROVIDE_HIDDEN and must never reach .dynsym: exporting them hands out the runtime address of the
// data/metadata segment boundaries to any dlsym caller.
// (Linux and CJNATIVE) ASSERT: regex-not ^ *[0-9]+: +[0-9a-f]+ +[0-9]+ +NOTYPE +(GLOBAL|WEAK) +\S+ +[0-9A-Z]+ +(_edata|__bss_start|__bss_start__|_bss_end__|__bss_end__|__end__|_end|_CJMetadataStart)$

// Reverse guard: Cjstart.S references the double-underscore __CJMetadataStart, so it must stay
// defined (PROVIDE_HIDDEN => LOCAL, not exported); and DT_INIT/DT_FINI must still point at the crt
// initialization/finalization routines, which work by address and must not be affected by the
// script change. (edata/end stay plain PROVIDE on purpose: glibc compatibility names.)
// (Linux and CJNATIVE) ASSERT: regex ^ *[0-9]+: +[0-9a-f]+ +[0-9]+ +NOTYPE +LOCAL +\S+ +[0-9A-Z]+ +__CJMetadataStart$
// (Linux and CJNATIVE) ASSERT: scan (INIT)
// (Linux and CJNATIVE) ASSERT: scan (FINI)

public func run(): Int64 {
    return 0
}

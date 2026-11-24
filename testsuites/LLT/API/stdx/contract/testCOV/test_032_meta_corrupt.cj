/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-032: reads .cmeta records that were deliberately damaged after
// the parent library was built: broken magic, broken section keywords
// (CLSE/MATTR/PATTR), a clause text that no longer parses, a stale fingerprint
// (accepted with a warning), a missing trailing fingerprint (accepted), a
// truncated record and a record describing a different type. Valid records
// with origin type arguments of the PRIM/FUNC/PREFIX/TUPLE kinds are read
// through the same compile.
// DEPENDENCE: cov_persist_lib_corrupt.cj
// EXEC: rm -rf %n_meta && mkdir -p %n_meta
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=covmeta %compiler %import-cangjie-stdx %cmp_opt cov_persist_lib_corrupt.cj --output-type=staticlib -o lib%n.a
// EXEC: cp %n_meta/covmeta.CovCorruptMagic.cmeta %n_meta/covmeta.CovCorruptWrong.cmeta
// EXEC: python3 -c "p='%n_meta/covmeta.CovCorruptMagic.cmeta';d=open(p,'rb').read();open(p,'wb').write(d.replace(b'CFGMETA',b'CFGXETA',1))"
// EXEC: python3 -c "p='%n_meta/covmeta.CovCorruptClause.cmeta';d=open(p,'rb').read();open(p,'wb').write(d.replace(b' CLSE ',b' XLSE ',1))"
// EXEC: python3 -c "p='%n_meta/covmeta.CovCorruptMember.cmeta';d=open(p,'rb').read();open(p,'wb').write(d.replace(b' MATTR ',b' XATTR ',1))"
// EXEC: python3 -c "p='%n_meta/covmeta.CovCorruptProperty.cmeta';d=open(p,'rb').read();open(p,'wb').write(d.replace(b' PATTR ',b' QATTR ',1))"
// EXEC: python3 -c "p='%n_meta/covmeta.CovCorruptParse.cmeta';d=open(p,'rb').read();open(p,'wb').write(d.replace(b'invariant [xi]',b'invar1ant [xi]'))"
// EXEC: python3 -c "p='%n_meta/covmeta.CovCorruptStale.cmeta';d=open(p,'rb').read();open(p,'wb').write(d.replace(b'[si] 1 > 0',b'[si] 1 < 9'))"
// EXEC: python3 -c "p='%n_meta/covmeta.CovCorruptNoFp.cmeta';d=open(p,'rb').read();open(p,'wb').write(d[:-8])"
// EXEC: python3 -c "p='%n_meta/covmeta.CovCorruptTrunc.cmeta';d=open(p,'rb').read();open(p,'wb').write(d[:40])"
// EXEC-PIPE-0: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=covmeta %compiler %import-cangjie-stdx %cmp_opt %f -o %n.%suffix --import-path . -L . -l %n %cmp_utest_opt 2>&1 | compare %f
// ASSERT: scan record for `CovCorruptMagic` is unreadable or written by an incompatible
// ASSERT: scan record for `CovCorruptClause` is unreadable
// ASSERT: scan record for `CovCorruptMember` is unreadable
// ASSERT: scan record for `CovCorruptProperty` is unreadable
// ASSERT: scan record for `CovCorruptParse` could not be parsed
// ASSERT: scan stale or corrupt .cmeta record for CovCorruptStale
// ASSERT: scan record for `CovCorruptWrong` describes `covmeta.CovCorruptMagic` instead
// ASSERT: scan record for `CovCorruptTrunc` is unreadable
// ASSERT: scan-not core dumped

import stdx.contract.macros.*
import covmeta.*

@Contract
class CovMetaWMagic <: CovCorruptMagic {
    public init() {}

    public func apply(x: Int64): Int64 {
        x
    }
}

@Contract
class CovMetaWClause <: CovCorruptClause {
    public init() {}

    public func apply(x: Int64): Int64 {
        x
    }
}

@Contract
class CovMetaWMember <: CovCorruptMember {
    public init() {
        super()
    }

    public override func noArg(): Int64 {
        super.noArg()
    }
}

@Contract
abstract class CovMetaWProp <: CovCorruptProperty {
    private var store: Int64 = 1

    public mut prop item: Int64 {
        get() {
            store
        }
        set(v) {
            store = v
        }
    }

    public init() {}
}

@Contract
class CovMetaWParse <: CovCorruptParse {
    public init() {}

    public func apply(x: Int64): Int64 {
        x
    }
}

@Contract
class CovMetaWStale <: CovCorruptStale {
    public init() {}

    public func apply(x: Int64): Int64 {
        x
    }
}

@Contract
class CovMetaWNoFp <: CovCorruptNoFp {
    public init() {}

    public func apply(x: Int64): Int64 {
        x
    }
}

@Contract
class CovMetaWTrunc <: CovCorruptTrunc {
    public init() {}

    public func apply(x: Int64): Int64 {
        x
    }
}

@Contract
class CovMetaWWrong <: CovCorruptWrong {
    public init() {}

    public func apply(x: Int64): Int64 {
        x
    }
}

@Contract
class CovMetaWMid <: CovCorruptMid<Int64> {
    public init() {}

    public func apply(x: (Int64, Int64)): (Int64, Int64) {
        x
    }

    public func pick(x: (Int64, Int64)): (Int64, Int64) {
        x
    }
}

@Contract
class CovMetaWPrim <: CovCorruptPrim {
    public init() {}

    public func apply(x: Int64): Int64 {
        x
    }
}

@Contract
class CovMetaWFunc <: CovCorruptFunc {
    public init() {}

    public func apply(x: (Int64) -> Int64): (Int64) -> Int64 {
        x
    }
}

@Contract
class CovMetaWOpt <: CovCorruptOpt {
    public init() {}

    public func apply(x: ?Int64): ?Int64 {
        x
    }
}

@Contract
class CovMetaWLeaf <: CovCorruptLeaf {
    private var store: Int64 = 1

    public mut prop item: Int64 {
        get() {
            store
        }
        set(v) {
            store = v
        }
    }

    public init() {}
}

main() {
    0
}

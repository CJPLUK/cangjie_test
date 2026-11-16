/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

 package dlutils

import std.reflect.*

public func dlLoadMeta(path: String): String {
    try {
        let m = PackageInfo.load(path)
        return "OK:${m.name}|${m.qualifiedName}|${m.version}"
    } catch (e: Exception) {
        return e.message
    }
}

public func dlLoadTwo(p1: String, p2: String): String {
    try {
        let m1 = PackageInfo.load(p1)
        let m2 = PackageInfo.load(p2)
        return "OK:${m1.qualifiedName}|${m2.qualifiedName}"
    } catch (e: Exception) {
        return e.message
    }
}

public func dlPkgTypeGet(path: String, qual: String): String {
    try {
        let m = PackageInfo.load(path)
        let t = m.getTypeInfo(qual)
        return "OK:${t.name}|${t.qualifiedName}"
    } catch (e: Exception) {
        return e.message
    }
}

public func dlPkgVarGet(path: String, name: String): String {
    try {
        let m = PackageInfo.load(path)
        let v = m.getVariable(name)
        return "OK:${v.name}"
    } catch (e: Exception) {
        return e.message
    }
}

public func dlVarMissMsg(path: String, name: String): String {
    try {
        let m = PackageInfo.load(path)
        let v = m.getVariable(name)
        return "OK:${v.name}"
    } catch (e: Exception) {
        return e.message
    }
}

public func dlPkgFuncGet(path: String, name: String): String {
    try {
        let m = PackageInfo.load(path)
        let f = m.getFunction(name)
        return "OK:${f.name}"
    } catch (e: Exception) {
        return e.message
    }
}

public func dlPkgCounts(path: String): String {
    try {
        let m = PackageInfo.load(path)
        return "OK:${m.typeInfos.size}|${m.variables.size}|${m.functions.size}"
    } catch (e: Exception) {
        return e.message
    }
}

public func dlPkgConstruct(path: String, qual: String): String {
    try {
        let m = PackageInfo.load(path)
        let ct = (m.getTypeInfo(qual) as ClassTypeInfo).getOrThrow()
        let inst = ct.construct([])
        return "OK:${TypeInfo.of(inst).name}"
    } catch (e: Exception) {
        return e.message
    }
}

public func dlLoadMsg(path: String): String {
    // illegal path 族消息按平台形态归一（形态表见 spec.cj 消息契约区）：
    // Windows "Failed to load '<p>': illegal path." / Linux "Failed to load `<p>` because of illegal path."
    try {
        let m = PackageInfo.load(path)
        return "OK:${m.qualifiedName}"
    } catch (e: IllegalArgumentException) {
        if (e.message == "Failed to load '${path}': illegal path."
            || e.message == "Failed to load `${path}` because of illegal path.") {
            return "OK:illegal-path"
        }
        return "UNEXPECTED:${e.message}"
    } catch (e: Exception) {
        return e.message
    }
}

public func dlLoadFakeMsg(path: String): String {
    // load-failed 族消息按平台形态归一（形态表见 spec.cj 消息契约区）：
    // Windows "Failed to load package from '<p>'." / Linux "Package `<p>` load failed."
    // path 无后缀，运行时补平台后缀后命中平台各自的文本伪装 fixture
    try {
        PackageInfo.load(path)
        return "OK:fake-loaded"
    } catch (e: ReflectException) {
        if (e.message == "Failed to load package from '${path}'."
            || e.message == "Package `${path}` load failed.") {
            return "OK:load-failed"
        }
        return "UNEXPECTED:${e.message}"
    } catch (e: Exception) {
        return e.message
    }
}

public func dlLoadTwice(path: String): String {
    // already-loaded 族消息按平台形态归一（形态表见 spec.cj 消息契约区）：
    // Windows "File '<p>' is already loaded." / Linux "Try to load the same file twice, path: `<p>`."
    try {
        let m = PackageInfo.load(path)
        try {
            PackageInfo.load(path)
            return "OK:double-load-no-throw"
        } catch (e2: ReflectException) {
            if (e2.message == "File '${path}' is already loaded."
                || e2.message == "Try to load the same file twice, path: `${path}`.") {
                return "OK:already-loaded"
            }
            return "UNEXPECTED:${e2.message}"
        } catch (e2: Exception) {
            return "UNEXPECTED:${e2.message}"
        }
    } catch (e: Exception) {
        return "first-load:${e.message}"
    }
}

// ── loaded 包变量值读取与改写 roundtrip ──

// 非 public 包级变量可见性：variables 枚举
// 不含非 public 成员 → 找不到目标时返回 "OK:absent"（缺席即事实，
// 不虚构取柄路径）。public 变量命中时才走到 getValue()（Int64 存储）
public func dlPkgVarValue(path: String, name: String): String {
    try {
        let m = PackageInfo.load(path)
        var found = "absent"
        for (v in m.variables) {
            if (v.name == name) {
                found = "${(v.getValue() as Int64).getOrThrow()}"
            }
        }
        return "OK:${found}"
    } catch (e: Exception) {
        return e.message
    }
}

// public 包级 Int8 变量 getValue→setValue→getValue 持久
// 形参 Int64（IntegerLiteral 渲染为 -12i64，cjc 拒 Int64 字面量
// 直配 Int8 形参），箱内 Int8(nv) 显式转换
public func dlInt8VarRoundtrip(path: String, name: String, nv: Int64): String {
    try {
        let m = PackageInfo.load(path)
        var r = "??"
        for (v in m.variables) {
            if (v.name == name) {
                let v0 = "${(v.getValue() as Int8).getOrThrow()}"
                v.setValue(Int8(nv))
                r = "${v0}->${(v.getValue() as Int8).getOrThrow()}"
            }
        }
        return "OK:${r}"
    } catch (e: Exception) {
        return e.message
    }
}

// ── PackageInfo.parentPackage / rootPackage ──
//   顶层包两 prop 均自返（不抛）；
//   子包独载（父/root 未加载）两 prop 抛 InfoNotFoundException——root 消息
//   报 root 段名、parent 消息报父完整限定名，oracle 按平台形态归一为
//   "!INF:<点名>"（保留点名语义，形态表见 spec.cj 消息契约区）；
//   父先载后子包：parentPackage 跨 dylib 解析真父，rootPackage 仍独立解析
//   （父载≠root 载）。
// catch 臂按 InfoNotFoundException 具体型归一（误型落通用臂产生异串 → TC 红信号）。

// InfoNotFoundException 消息按平台形态归一：
// Windows "Cannot find specified package '<p>'." /
// Linux "Cannot find specified package: `<p>`."；两形均须点名 <p>
func dlNormPkgMiss(e: InfoNotFoundException, pkg: String): String {
    if (e.message == "Cannot find specified package '${pkg}'."
        || e.message == "Cannot find specified package: `${pkg}`.") {
        return "!INF:${pkg}"
    }
    return "!UNEXPECTED:${e.message}"
}

// 单 load 双 prop（进程级去重：同 dylib 恰 load 一次），rootPkg/parentPkg
// 为两 prop 未命中时消息应点名的包（root=root 段名，parent=父完整限定名），
// 返 "OK:<root>|<parent>"，各槽=名或 "!INF:<点名>"
public func dlPkgParentRoot(path: String, rootPkg: String, parentPkg: String): String {
    try {
        let m = PackageInfo.load(path)
        var r = "?"
        var p = "?"
        try {
            r = m.rootPackage.name
        } catch (e: InfoNotFoundException) {
            r = dlNormPkgMiss(e, rootPkg)
        }
        try {
            p = m.parentPackage.name
        } catch (e: InfoNotFoundException) {
            p = dlNormPkgMiss(e, parentPkg)
        }
        return "OK:${r}|${p}"
    } catch (e: Exception) {
        return e.message
    }
}

// 父先载 + 子包后载（跨 dylib 真父解析），childRootPkg/childParentPkg 为
// 子包两 prop 未命中时消息应点名的包（root=root 段名，parent=父完整限定名），
// 返 "OK:<父name>|<child.root>|<child.parent.name>|<child.parent.qualifiedName>"
public func dlPkgParentRootTwo(pParent: String, pChild: String, childRootPkg: String, childParentPkg: String): String {
    try {
        let parent = PackageInfo.load(pParent)
        let child = PackageInfo.load(pChild)
        var r = "?"
        var p = "?"
        try {
            r = child.rootPackage.name
        } catch (e: InfoNotFoundException) {
            r = dlNormPkgMiss(e, childRootPkg)
        }
        try {
            let x = child.parentPackage
            p = "${x.name}|${x.qualifiedName}"
        } catch (e: InfoNotFoundException) {
            p = dlNormPkgMiss(e, childParentPkg)
        }
        return "OK:${parent.name}|${r}|${p}"
    } catch (e: Exception) {
        return e.message
    }
}

public func dlPkgLoadNoSuffix(path: String): String {
    // 手册注记「路径中的共享库文件名不需要后缀名」——空后缀在白名单内、自动补 .dll。
    try {
        let p = PackageInfo.load(path)
        return "OK:${p.name}|${p.qualifiedName}"
    } catch (e: Exception) {
        return e.message
    }
}

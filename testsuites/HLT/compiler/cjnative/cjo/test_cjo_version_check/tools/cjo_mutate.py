# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
# See https://cangjie-lang.cn/pages/LICENSE for license information.

# cjo_mutate.py — CJO 版本检查 fixture 变异工具:flatc JSON 往返改写 cjoVersion/version 串,
#   外加字节级破坏操作;fixture 运行时现场生成,套件不预存 .cjo。
#
# 用法:
#   --patch-cjo <file> --set-cjo-version M.m.p|next-minor   改写 cjoVersion 三元组
#   --patch-cjo <file> --set-version-string S    改写 version 字符串
#   --patch-cjo <file> --clear-version-string    删除 version 字符串
#   --patch-cjo <file> --truncate [N]            截断至前 N 字节(缺省减半)
#   --patch-cjo <file> --corrupt-identifier      头 4 字节改 XXXX
#   --patch-cjo <file> --random-fill [SEED]      等长随机字节替换(固定种子可复现)
#   --dump-version <file>                        印 "M.m.p <version-string>"
#   --generate <base.cjo> <out.cjo> --set-cjo-version M.m.p [--set-version-string S]
#
# 资源定位:flatc 与 CjoFormat.fbs 只在本脚本所在目录(tools/)查找,其他路径一律不搜;
#   各平台 flatc 以 zip 入库(linux 分架构),首次使用解压到本目录。
# 门禁语义:接受 minor<=cur 且 major<=cur(含 (0,0,0)=缺版本形态),任一超出即拒绝。
import argparse
import os
import platform
import random
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile


# 各平台 flatc 以 zip 入库(包内单个二进制),首次使用解压到本脚本所在目录后直接复用;
# linux 按机器架构细分(x64 包以 ubuntu18 为基线发行版构建,glibc 兼容面最广),win/mac 不分架构。
_FLATC_LINUX_ARCH = {  # platform.machine() → flatc 二进制专属名
    'x86_64': 'flatc-linux-x64-ubuntu18',
    'amd64': 'flatc-linux-x64-ubuntu18',
    'aarch64': 'flatc-linux-aarch64',
    'arm64': 'flatc-linux-aarch64',
}
_FLATC_GENERIC = {'win': 'flatc.exe', 'mac': 'flatc', 'linux': 'flatc'}


def _flatc_specific_name(key):
    """本平台 flatc 二进制专属名(linux 再按机器架构细分,未收录架构退回平台通名)。"""
    if key == 'linux':
        return _FLATC_LINUX_ARCH.get(platform.machine().lower(), 'flatc-linux')
    return 'flatc-win.exe' if key == 'win' else 'flatc-mac'


def _flatc_zip_candidates(key):
    """本平台 zip 候选名(专属架构名优先,linux 旧平台名/通名兜底)。"""
    if key == 'linux':
        return (_flatc_specific_name(key) + '.zip', 'flatc-linux.zip', 'flatc.zip')
    return ('flatc-%s.zip' % key,)


def _platform_key():
    if os.name == 'nt':
        return 'win'
    return 'mac' if sys.platform == 'darwin' else 'linux'


def _tools_dir():
    """资源唯一探测目录:本脚本所在目录(tools/),其他路径一律不搜。"""
    return os.path.dirname(os.path.abspath(__file__))


def locate_tool(name):
    """找 CjoFormat.fbs 等资源:仅本脚本所在目录(tools/),不做其他任何路径搜索。"""
    cand = os.path.join(_tools_dir(), name)
    if os.path.isfile(cand):
        return cand
    raise SystemExit('cjo_mutate.py: cannot locate %s (searched only %s; '
                     '请确认资源与本脚本同目录)' % (name, _tools_dir()))


def locate_flatc():
    """找本平台 flatc:仅脚本所在目录内 专属名 → 本平台 zip(首次解压) → 通名。

    专属名优先于通名,避免同目录内他平台/他架构 flatc 被误用;linux 再按机器架构细分。
    """
    key = _platform_key()
    d = _tools_dir()
    specific = _flatc_specific_name(key)
    cand = os.path.join(d, specific)
    if os.path.isfile(cand):
        return cand
    for zname in _flatc_zip_candidates(key):
        zcand = os.path.join(d, zname)
        if os.path.isfile(zcand):
            return _extract_flatc_zip(zcand, specific)
    cand = os.path.join(d, _FLATC_GENERIC[key])
    if os.path.isfile(cand):
        return cand
    arch = platform.machine().lower() if key == 'linux' else '-'
    raise SystemExit('cjo_mutate.py: cannot locate flatc for %s (%s) (searched only %s; '
                     '请确认本平台/本架构 flatc 二进制或 zip 与本脚本同目录)'
                     % (key, arch, d))


def _extract_flatc_zip(zip_path, specific):
    """解包 flatc zip 到 zip 同级目录(即脚本所在目录),返回本平台二进制路径。

    并发解压按"已存在且等长则跳过 + 临时名原子替换"防撕裂。
    """
    bases = (specific, _FLATC_GENERIC[_platform_key()])
    outdir = os.path.dirname(os.path.abspath(zip_path))
    try:
        with zipfile.ZipFile(zip_path) as zf:
            for info in zf.infolist():
                if info.is_dir():
                    continue
                base = os.path.basename(info.filename.replace('\\', '/'))
                if not base:
                    continue
                dst = os.path.join(outdir, base)
                if not (os.path.isfile(dst) and os.path.getsize(dst) == info.file_size):
                    tmp_dst = '%s.tmp%d' % (dst, os.getpid())
                    with zf.open(info) as src, open(tmp_dst, 'wb') as fh:
                        shutil.copyfileobj(src, fh)
                    os.replace(tmp_dst, dst)
                if os.name != 'nt' and base in bases:
                    os.chmod(dst, 0o755)  # zip 外部属性不保证保留可执行位
    except (OSError, zipfile.BadZipFile) as exc:
        raise SystemExit('cjo_mutate.py: cannot extract flatc from %s into %s: %s'
                         % (zip_path, outdir, exc))
    for base in bases:  # 解压成功:按候选名认领本平台二进制
        cand = os.path.join(outdir, base)
        if os.path.isfile(cand):
            return cand
    for base in sorted(os.listdir(outdir)):  # 兜底:命名不在候选表(如带架构后缀)
        if not base.startswith('flatc'):
            continue
        if os.name == 'nt':
            if not base.endswith('.exe'):
                continue
        elif '.' in base:
            continue
        cand = os.path.join(outdir, base)
        if os.path.isfile(cand):
            if os.name != 'nt':
                os.chmod(cand, 0o755)
            return cand
    raise SystemExit('cjo_mutate.py: no flatc binary for this platform in %s' % zip_path)


def relaxed_json_to_strict(txt):
    """flatc 的 relaxed JSON → 严格 JSON:键名加引号、去尾逗号。"""
    txt = re.sub(r'([,{\[]\s*)([A-Za-z_][A-Za-z0-9_]*)\s*:', r'\1"\2":', txt)
    txt = re.sub(r',(\s*[}\]])', r'\1', txt)
    return txt


def flatc_roundtrip(cjo_path, mutate):
    """cjo → json → mutate(json 文本) → bin → 覆写回 cjo。"""
    flatc = locate_flatc()
    fbs = locate_tool('CjoFormat.fbs')
    tmp = tempfile.mkdtemp(prefix='cjo_mutate_')
    try:
        stem = 'probe_%d' % os.getpid()
        probe = os.path.join(tmp, stem + '.cjo')
        shutil.copy(cjo_path, probe)
        r = subprocess.run([flatc, '-t', fbs, '--', probe], cwd=tmp,
                           capture_output=True, text=True, errors='replace')
        if r.returncode != 0:
            raise SystemExit('cjo_mutate.py: flatc -t failed on %s:\n%s'
                             % (cjo_path, (r.stderr or '')[-400:]))
        json_path = os.path.join(tmp, stem + '.json')
        if not os.path.isfile(json_path):
            raise SystemExit('cjo_mutate.py: flatc -t produced no json for %s' % cjo_path)
        txt = open(json_path, encoding='utf-8').read()
        txt = mutate(txt)
        open(json_path, 'w', encoding='utf-8').write(txt)
        r = subprocess.run([flatc, '-b', fbs, stem + '.json'], cwd=tmp,
                           capture_output=True, text=True, errors='replace')
        if r.returncode != 0:
            raise SystemExit('cjo_mutate.py: flatc -b failed:\n%s' % (r.stderr or '')[-400:])
        bin_path = os.path.join(tmp, stem + '.bin')
        if not os.path.isfile(bin_path):
            raise SystemExit('cjo_mutate.py: flatc -b produced no bin')
        shutil.move(bin_path, cjo_path)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


TRIPLE_RE = re.compile(
    r'cjoVersion: \{\s*major_num: (\d+),\s*minor_num: (\d+),\s*patch_num: (\d+)')
VERSION_STR_RE = re.compile(r'version: "([^"]*)"')


def set_triple(txt, m, mi, p):
    def repl(match):
        return ('cjoVersion: {\n    major_num: %d,\n    minor_num: %d,\n'
                '    patch_num: %d' % (m, mi, p))
    new, n = TRIPLE_RE.subn(repl, txt, count=1)
    if n == 0:
        raise SystemExit('cjo_mutate.py: cjoVersion triple not found in json')
    return new


def read_triple(txt):
    m = TRIPLE_RE.search(txt)
    if not m:
        raise SystemExit('cjo_mutate.py: cjoVersion triple not found in json')
    return (int(m.group(1)), int(m.group(2)), int(m.group(3)))


def byte_ops(path, op, arg=None):
    """字节级破坏操作(Verifier 组):截断/坏 identifier/随机填充。直接改写文件。"""
    raw = open(path, 'rb').read()
    if op == 'truncate':
        n = int(arg) if arg is not None else len(raw) - len(raw) // 2
        raw = raw[:n]
    elif op == 'corrupt-identifier':
        raw = b'XXXX' + raw[4:]
    elif op == 'random-fill':
        rng = random.Random(int(arg) if arg is not None else 42)
        raw = bytes(rng.randrange(256) for _ in range(len(raw)))
    else:
        raise SystemExit('cjo_mutate.py: unknown byte op %s' % op)
    open(path, 'wb').write(raw)
    print('cjo_mutate.py: %s applied to %s' % (op, path))


def main():
    ap = argparse.ArgumentParser(description='CJO version fixture surgery tool')
    ap.add_argument('--patch-cjo', metavar='FILE')
    ap.add_argument('--generate', nargs=2, metavar=('BASE', 'OUT'))
    ap.add_argument('--set-cjo-version', metavar='M.m.p|next-minor',
                    help='Use a fixed triple or increment the input file minor version')
    ap.add_argument('--set-version-string', metavar='S')
    ap.add_argument('--clear-version-string', action='store_true')
    ap.add_argument('--truncate', nargs='?', const='', default=None, metavar='N')
    ap.add_argument('--corrupt-identifier', action='store_true')
    ap.add_argument('--random-fill', nargs='?', const='', default=None, metavar='SEED')
    ap.add_argument('--dump-version', metavar='FILE')
    ap.add_argument('--patch-cache', action='store_true',
                    help='已废弃:缓存 cjo 不参与版本门禁,传入即报错退出')
    args = ap.parse_args()

    if args.patch_cache:
        raise SystemExit('cjo_mutate.py: --patch-cache 已废弃(缓存 cjo 不参与版本门禁)')

    # 字节级破坏:不经过 flatc(输入本来就允许是坏结构),直接改文件
    byte_op = None
    if args.truncate is not None:
        byte_op = ('truncate', args.truncate or None)
    elif args.corrupt_identifier:
        byte_op = ('corrupt-identifier', None)
    elif args.random_fill is not None:
        byte_op = ('random-fill', args.random_fill or None)
    if byte_op is not None:
        if not args.patch_cjo:
            ap.error('--truncate/--corrupt-identifier/--random-fill need --patch-cjo FILE')
        byte_ops(args.patch_cjo, byte_op[0], byte_op[1])
        return

    if args.dump_version:
        flatc = locate_flatc()
        fbs = locate_tool('CjoFormat.fbs')
        tmp = tempfile.mkdtemp(prefix='cjo_dump_')
        try:
            probe = os.path.join(tmp, 'dump.cjo')
            shutil.copy(args.dump_version, probe)
            r = subprocess.run([flatc, '-t', fbs, '--', probe], cwd=tmp,
                               capture_output=True, text=True, errors='replace')
            if r.returncode != 0:
                raise SystemExit('cjo_mutate.py: flatc -t failed:\n%s' % (r.stderr or '')[-300:])
            txt = open(os.path.join(tmp, 'dump.json'), encoding='utf-8').read()
        finally:
            shutil.rmtree(tmp, ignore_errors=True)
        tri = read_triple(txt)
        vs = VERSION_STR_RE.search(txt)
        print('%d.%d.%d %s' % (tri[0], tri[1], tri[2], vs.group(1) if vs else '(none)'))
        return

    targets = []
    if args.patch_cjo:
        targets.append(args.patch_cjo)
    if args.generate:
        base, out = args.generate
        shutil.copy(base, out)
        targets.append(out)

    if not targets:
        ap.error('nothing to do: need --patch-cjo FILE or --generate BASE OUT')

    triple = None
    if args.set_cjo_version and args.set_cjo_version != 'next-minor':
        parts = args.set_cjo_version.split('.')
        if len(parts) != 3:
            ap.error('--set-cjo-version expects M.m.p')
        triple = tuple(int(x) for x in parts)

    for path in targets:
        def mutate(txt):
            txt2 = txt
            if args.set_cjo_version == 'next-minor':
                major, minor, _ = read_triple(txt2)
                if minor == 255:
                    raise SystemExit('cjo_mutate.py: cannot increment minor 255')
                txt2 = set_triple(txt2, major, minor + 1, 0)
            elif triple is not None:
                txt2 = set_triple(txt2, *triple)
            if args.set_version_string is not None:
                new, n = VERSION_STR_RE.subn('version: "%s"' % args.set_version_string,
                                             txt2, count=1)
                if n == 0:
                    raise SystemExit('cjo_mutate.py: version string not found in json')
                txt2 = new
            if args.clear_version_string:
                new, n = re.subn(r'version: "[^"]*",\s*', '', txt2, count=1)
                if n == 0:
                    raise SystemExit('cjo_mutate.py: version string not found in json')
                txt2 = new
            if txt2 == txt and triple is None and args.set_version_string is None \
                    and not args.clear_version_string:
                raise SystemExit('cjo_mutate.py: no mutation applied to %s' % path)
            return txt2
        flatc_roundtrip(path, mutate)
        print('cjo_mutate.py: patched %s' % path)


if __name__ == '__main__':
    main()

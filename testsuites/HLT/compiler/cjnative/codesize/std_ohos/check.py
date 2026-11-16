# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

import argparse
import glob
import os

BASELINE = 10991
REDUCE_RATIO = 0.05

script_dir = os.path.dirname(os.path.abspath(__file__))

arg_parser = argparse.ArgumentParser()
arg_parser.add_argument('--list', help='path to the checked-in rom_runtime_so.list (baseline manifest).',
                        default=os.path.join(script_dir, 'rom_runtime_so.list'))
arg_parser.add_argument('--lib-dir', help='path to the SDK runtime lib dir, '
                                          'defaults to $CANGJIE_HOME/runtime/lib/*ohos*cjnative')
arg_parser.add_argument('--baseline', type=int, default=BASELINE,
                        help='reference baseline sum in KB to compare against (default: BASELINE constant).')
arg_parser.add_argument('--report', action='store_true',
                        help='print current sum only and exit 0, skip assertion (use to measure the baseline).')
args = arg_parser.parse_args()

list_file = args.list
if not os.path.isfile(list_file):
    print(f'FAIL: manifest {list_file} not found')
    exit(1)

if args.lib_dir:
    lib_dir = args.lib_dir
else:
    runtime_lib = os.path.join(os.environ['CANGJIE_HOME'], 'runtime', 'lib')
    candidates = glob.glob(os.path.join(runtime_lib, '*ohos*cjnative'))
    if not candidates:
        print(f'FAIL: no ohos cjnative lib dir found under {runtime_lib}')
        exit(1)
    lib_dir = candidates[0]

names = []
with open(list_file, 'r', encoding='utf-8', errors='replace') as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        names.append(line.split()[0])

total_bytes = 0
missing = []
for name in names:
    path = os.path.join(lib_dir, name)
    if not os.path.isfile(path):
        missing.append(name)
        continue
    total_bytes += os.path.getsize(path)

if missing:
    print(f'FAIL: files missing in {lib_dir}: {missing}')
    exit(1)

total_kb = total_bytes // 1024
print(f'manifest: {list_file}')
print(f'lib dir: {lib_dir}')
print(f'parsed entries: {len(names)}')
print(f'sum of sizes: {total_bytes} bytes ({total_kb} KB)')
if args.report:
    print(f'measured baseline: {total_kb} KB (use --baseline {total_kb} or set BASELINE = {total_kb} in check.py)')
    exit(0)
limit_kb = args.baseline * (1 - REDUCE_RATIO)
print(f'reference baseline: {args.baseline} KB, limit {limit_kb:.2f} KB')
if total_kb > limit_kb:
    print(f'FAIL: sum {total_kb} KB exceeds limit {limit_kb:.2f} KB, '
          f'rom runtime size not reduced by {REDUCE_RATIO * 100:.0f}% vs baseline {args.baseline} KB')
    exit(1)

print('check.py PASS')

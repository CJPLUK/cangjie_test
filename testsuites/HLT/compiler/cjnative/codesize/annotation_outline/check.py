# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

import argparse
import os
import shutil
import subprocess

arg_parser = argparse.ArgumentParser()
arg_parser.add_argument('--file', help='file to be checked.')
arg_parser.add_argument('--expected-copyto', type=int,
                        help='expected count of llvm.cj.array.copyto in the file.')
arg_parser.add_argument('--has', action='append', default=[],
                        help='pattern that must appear in the file.')
arg_parser.add_argument('--has-not', action='append', default=[],
                        help='pattern that must not appear in the file.')
arg_parser.add_argument('--max-size', type=int,
                        help='max file size in bytes.')
arg_parser.add_argument('--nm-has', action='append', default=[],
                        help='symbol pattern that must appear in llvm-nm output of the file.')
arg_parser.add_argument('--nm-has-not', action='append', default=[],
                        help='symbol pattern that must not appear in llvm-nm output of the file.')

def find_nm():
    home = os.environ.get('CANGJIE_HOME', '')
    candidates = [
        os.path.join(home, 'third_party', 'llvm', 'bin', 'llvm-nm'),
        os.path.join(home, 'third_party', 'llvm', 'bin', 'nm'),
        os.path.join(home, 'bin', 'llvm-nm'),
    ]
    for c in candidates:
        if c and os.path.isfile(c):
            return c
    return shutil.which('llvm-nm') or shutil.which('nm')


def dump_nm_hits(symbols, keys):
    lines = [line for line in symbols.splitlines() if any(k in line for k in keys)]
    for line in lines[:30]:
        print('  nm:', line)


args = arg_parser.parse_args()

if args.max_size is not None:
    size = os.path.getsize(args.file)
    print(f'file size: {size} (limit {args.max_size})')
    if size > args.max_size:
        print(f'FAIL: {args.file} size {size} exceeds limit {args.max_size}')
        exit(1)

with open(args.file, 'r', encoding='utf-8', errors='replace') as f:
    text = f.read()

if args.expected_copyto is not None:
    count = text.count('llvm.cj.array.copyto')
    print(f'copyto count: {count} (expected {args.expected_copyto})')
    if count != args.expected_copyto:
        print(f'FAIL: copyto count {count} != expected {args.expected_copyto}')
        exit(1)

for pattern in args.has:
    if pattern not in text:
        print(f'FAIL: pattern \'{pattern}\' not found in {args.file}')
        exit(1)

for pattern in args.has_not:
    if pattern in text:
        print(f'FAIL: pattern \'{pattern}\' should not appear in {args.file}')
        exit(1)

if args.nm_has or args.nm_has_not:
    nm_path = find_nm()
    if nm_path is None:
        print('FAIL: cannot find llvm-nm / nm (searched CANGJIE_HOME and PATH)')
        exit(1)
    print(f'using nm tool: {nm_path}')
    result = subprocess.run([nm_path, args.file], capture_output=True, text=True)
    symbols = result.stdout + result.stderr
    for pattern in args.nm_has:
        if pattern not in symbols:
            print(f'FAIL: symbol pattern \'{pattern}\' not found in llvm-nm of {args.file}')
            dump_nm_hits(symbols, ('helper', 'exception', '_imp'))
            exit(1)
        print(f'nm-has: \'{pattern}\' found')
    for pattern in args.nm_has_not:
        if pattern in symbols:
            print(f'FAIL: symbol pattern \'{pattern}\' should not appear in llvm-nm of {args.file}')
            dump_nm_hits(symbols, (pattern,))
            exit(1)
        print(f'nm-has-not: \'{pattern}\' absent')

print('check.py PASS')

#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.
#
# Common utility functions for the iOS simulator direct-executable route.
# Sourced by each run script to avoid duplicated code.
# Depends on the environment variable: CANGJIE_HOME

 
# Check CANGJIE_HOME
require_cangjie_home() {
    if [ -z "${CANGJIE_HOME}" ]; then
        echo "Error: CANGJIE_HOME is not set" >&2
        return 255
    fi
    return 0
}
 
# Return the simulator runtime library directory (selected by architecture)
ios_runtime_lib_dir() {
    local arch="${1:-arm64}"
    if [ "$arch" = "x86_64" ]; then
        echo "${CANGJIE_HOME}/runtime/lib/ios_simulator_x86_64_cjnative"
    else
        echo "${CANGJIE_HOME}/runtime/lib/ios_simulator_aarch64_cjnative"
    fi
}
 
# Ad-hoc sign the executable, otherwise simctl spawn reports Security policy issue (163)
sign_executable() {
    local exe="$1"
    [ -z "$exe" ] && return 255
    codesign -f -s - "$exe"
}
 
# Ad-hoc sign a single file if it is a Mach-O dynamic library.
# Detect by file type (not extension), so actual dylibs named *.a are also handled.
sign_macho_dylib() {
    local f="$1"
    [ -e "$f" ] || return 0
    if file -b "$f" | grep -qE "Mach-O.*(dylib|dynamically linked shared library)"; then
        codesign -f -s - "$f"
    fi
}
 
# Ad-hoc sign all Mach-O dynamic libraries under the given directory,
# otherwise the simulator reports "Trying to load an unsigned library".
sign_dylibs_in_dir() {
    local dir="$1"
    if [ -n "$dir" ] && [ -d "$dir" ]; then
        for d in "$dir"/*; do
            sign_macho_dylib "$d"
        done
    fi
}
 

 
# Detect the CPU architecture of a Mach-O file (arm64 or x86_64).
# Used to pick the matching simulator runtime library directory when the
# architecture is not known otherwise (the [run] script line carries no target
# argument; the compiled executable in the work_dir is the source of truth).
macho_arch() {
    local exe="$1"
    [ -e "$exe" ] || { echo "arm64"; return; }
    if file -b "$exe" | grep -q "x86_64"; then
        echo "x86_64"
    else
        echo "arm64"
    fi
}

# Output a usable simulator udid: prefer the environment variable, otherwise the currently booted simulator
get_simulator_udid() {
    local udid="${XCODE_DEVICE_UDID_OF_CANGJIE_IOS_TEST}"
    if [ -z "$udid" ]; then
        udid=$(xcrun simctl list devices booted -j 2>/dev/null |
            python3 -c "import sys,json;d=json.load(sys.stdin);print(next((dev['udid'] for rt in d['devices'].values() for dev in rt if dev.get('state')=='Booted'),''))" 2>/dev/null)
                fi
    if [ -z "$udid" ]; then
        echo "Error: no booted simulator, set XCODE_DEVICE_UDID_OF_CANGJIE_IOS_TEST or boot a simulator" >&2
        return 255
    fi
    echo "$udid"
}
 
# Build (once, cached in TMPDIR) the SIGILL context-capture dylib for the
# given architecture and print its path. Enabled by setting CJ_TRACE_STACK.
# See sigill_catch.c for the capture mechanism and its design constraints.
ensure_sigill_dylib() {
    local arch="$1"
    local self="${BASH_SOURCE[0]:-${funcsourcetrace[1]%:*}}"
    local script_dir
    script_dir="$(cd "$(dirname "$self")" && pwd)"
    bash "$script_dir/build_sigill_dylib.sh" "$arch"
}

# Run an executable on the simulator, injecting the runtime library directory for dynamic linking.
# The architecture is detected from the executable itself, so x64 builds pick the
# x86_64 runtime directory automatically. The current working directory is appended
# to SIMCTL_CHILD_DYLD_LIBRARY_PATH so case-local glue dylibs (e.g. libcjworld.dylib
# produced in the work_dir) are also loadable at spawn time.
# When CJ_TRACE_STACK is set, the SIGILL context-capture dylib is injected too:
# on SIGILL the process logs pc/base/frame chain to stderr before dying with SIGILL.
# Usage: run_on_simulator <udid> <exe> [args...]
run_on_simulator() {
    local udid="$1"
    local exe="$2"
    shift 2
    local lib_dir arch dylib
    arch=$(macho_arch "$exe")
    lib_dir=$(ios_runtime_lib_dir "$arch")
    echo "running './$exe' on simulator $udid (runtime: $lib_dir)"
    if [ -n "$CJ_TRACE_STACK" ]; then
        dylib=$(ensure_sigill_dylib "$arch") || {
            echo "Error: failed to build sigill capture dylib" >&2
            return 255
        }
        if [ -n "${SIMCTL_CHILD_DYLD_INSERT_LIBRARIES:-}" ]; then
            export SIMCTL_CHILD_DYLD_INSERT_LIBRARIES="$dylib:${SIMCTL_CHILD_DYLD_INSERT_LIBRARIES}"
        else
            export SIMCTL_CHILD_DYLD_INSERT_LIBRARIES="$dylib"
        fi
    fi
    SIMCTL_CHILD_DYLD_LIBRARY_PATH="$lib_dir:$(pwd)" xcrun simctl spawn "$udid" "./$exe" "$@"
    return $?
}
 

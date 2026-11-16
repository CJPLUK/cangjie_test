#!/usr/bin/env bash
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

case25_configure_platform() {
    local host_os="$1"
    local host_arch="$2"

    case "$host_os:$host_arch" in
    Darwin:arm64|Darwin:aarch64|darwin:arm64|darwin:aarch64)
        CASE25_PLATFORM_DIR="darwin_aarch64_cjnative"
        CASE25_SHARED_LIBRARY_EXT="dylib"
        CASE25_LIBRARY_PATH_VAR="DYLD_LIBRARY_PATH"
        CASE25_FALLBACK_LIBRARY_PATH_VAR="DYLD_FALLBACK_LIBRARY_PATH"
        ;;
    Darwin:x86_64|Darwin:amd64|darwin:x86_64|darwin:amd64)
        CASE25_PLATFORM_DIR="darwin_x86_64_cjnative"
        CASE25_SHARED_LIBRARY_EXT="dylib"
        CASE25_LIBRARY_PATH_VAR="DYLD_LIBRARY_PATH"
        CASE25_FALLBACK_LIBRARY_PATH_VAR="DYLD_FALLBACK_LIBRARY_PATH"
        ;;
    Linux:x86_64|Linux:amd64|linux:x86_64|linux:amd64)
        CASE25_PLATFORM_DIR="linux_x86_64_cjnative"
        CASE25_SHARED_LIBRARY_EXT="so"
        CASE25_LIBRARY_PATH_VAR="LD_LIBRARY_PATH"
        CASE25_FALLBACK_LIBRARY_PATH_VAR=""
        ;;
    Linux:aarch64|Linux:arm64|linux:aarch64|linux:arm64)
        CASE25_PLATFORM_DIR="linux_aarch64_cjnative"
        CASE25_SHARED_LIBRARY_EXT="so"
        CASE25_LIBRARY_PATH_VAR="LD_LIBRARY_PATH"
        CASE25_FALLBACK_LIBRARY_PATH_VAR=""
        ;;
    *)
        echo "[ERROR] unsupported host platform: $host_os $host_arch" >&2
        return 1
        ;;
    esac

    CASE25_HOST_OS="$host_os"
    CASE25_HOST_ARCH="$host_arch"
}

case25_configure_sdk_paths() {
    local opt_root="${1%/}"

    CASE25_SDK_ROOT="$opt_root"
    CASE25_STDX_DIR="${CANGJIE_STDX_PATH:-$opt_root/$CASE25_PLATFORM_DIR/dynamic/stdx}"
    CASE25_RUNTIME_LIB_DIR="${CANGJIE_RUNTIME_LIB_DIR:-$CASE25_SDK_ROOT/runtime/lib/$CASE25_PLATFORM_DIR}"
    CASE25_RUNTIME_LIBRARY="${CANGJIE_RUNTIME_LIBRARY:-$CASE25_RUNTIME_LIB_DIR/libcangjie-runtime.$CASE25_SHARED_LIBRARY_EXT}"
    CASE25_STDX_HTTP_LIBRARY="$CASE25_STDX_DIR/libstdx.net.http.$CASE25_SHARED_LIBRARY_EXT"
    CASE25_STDX_JSON_LIBRARY="$CASE25_STDX_DIR/libstdx.encoding.json.$CASE25_SHARED_LIBRARY_EXT"
    CASE25_STDX_STREAM_LIBRARY="$CASE25_STDX_DIR/libstdx.encoding.json.stream.$CASE25_SHARED_LIBRARY_EXT"
}

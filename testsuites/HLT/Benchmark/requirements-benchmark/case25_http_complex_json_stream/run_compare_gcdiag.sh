#!/usr/bin/env bash
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.
#
# Case25: use one cangjie-opt SDK and compare only cjEnableGC=1 vs cjEnableGC=2.
# Set CANGJIE_HOME when cangjie-opt is not under the default workspace path.
# Individual paths can be overridden with CANGJIE_HOME, CANGJIE_STDX_PATH,
# CANGJIE_RUNTIME_LIB_DIR, and CANGJIE_RUNTIME_LIBRARY.
set -euo pipefail

CASE_DIR="$(cd "$(dirname "$0")" && pwd -P)"
SCRIPT_DIR="$CASE_DIR/script"
RESULT_ROOT="$CASE_DIR/result"
source "$SCRIPT_DIR/platform_config.sh"

HOST_OS="${CASE25_HOST_OS:-$(uname -s)}"
HOST_ARCH="${CASE25_HOST_ARCH:-$(uname -m)}"
case25_configure_platform "$HOST_OS" "$HOST_ARCH"

DEFAULT_WORKSPACE_ROOT="$(cd "$CASE_DIR/../../../../.." && pwd -P)"
OPT_ROOT="${CANGJIE_HOME:-$DEFAULT_WORKSPACE_ROOT/cangjie_compiler/output/cangjie-opt}"
case25_configure_sdk_paths "$OPT_ROOT"

SDK_ROOT="$CASE25_SDK_ROOT"
STDX_DIR="$CASE25_STDX_DIR"
RUNTIME_LIB_DIR="$CASE25_RUNTIME_LIB_DIR"
RUNTIME_LIBRARY="$CASE25_RUNTIME_LIBRARY"
STDX_HTTP_LIBRARY="$CASE25_STDX_HTTP_LIBRARY"
STDX_JSON_LIBRARY="$CASE25_STDX_JSON_LIBRARY"
STDX_STREAM_LIBRARY="$CASE25_STDX_STREAM_LIBRARY"
PYTHON_BIN="${PYTHON_BIN:-python3}"

HEAP_SIZE="${HEAP_SIZE:-4gb}"
PERSISTENT_BYTES_INPUT="${CASE25_PERSISTENT_BYTES:-1gb}"
PERSISTENT_WORKERS="${CASE25_PERSISTENT_WORKERS:-8}"
CONCURRENCY="${CASE25_CONCURRENCY:-100}"
PAYLOAD="${CASE25_PAYLOAD:-100K}"
DURATION_MS="${CASE25_DURATION_MS:-60000}"
CLIENT_TIMEOUT_MS="${CASE25_CLIENT_TIMEOUT_MS:-5000}"
CLIENT_MODE="${CASE25_CLIENT_MODE:-sync}"
SEND_INTERVAL_MS="${CASE25_SEND_INTERVAL_MS:-1}"
MAX_INFLIGHT="${CASE25_MAX_INFLIGHT:-32}"
PROCS="${PROCS:-}"
GC_INTERVAL="${CASE25_GC_INTERVAL:-}"
HEAP_GROWTH="${CASE25_HEAP_GROWTH:-}"
SCAVENGE_GROWTH="${CASE25_SCAVENGE_GROWTH:-}"

ACTIVE_SERVER_PID=""
ACTIVE_CLIENT_PID=""
ACTIVE_SAMPLER_PID=""

cleanup_active_processes() {
    local pid
    for pid in \
        "${ACTIVE_SAMPLER_PID:-}" \
        "${ACTIVE_CLIENT_PID:-}" \
        "${ACTIVE_SERVER_PID:-}"; do
        if [[ -n "$pid" ]]; then
            kill "$pid" 2>/dev/null || true
            wait "$pid" 2>/dev/null || true
        fi
    done
    ACTIVE_SERVER_PID=""
    ACTIVE_CLIENT_PID=""
    ACTIVE_SAMPLER_PID=""
}
trap cleanup_active_processes EXIT INT TERM

for required_file in \
    "$SDK_ROOT/envsetup.sh" \
    "$RUNTIME_LIBRARY" \
    "$STDX_HTTP_LIBRARY" \
    "$STDX_JSON_LIBRARY" \
    "$STDX_STREAM_LIBRARY" \
    "$CASE_DIR/benchmark.cj" \
    "$CASE_DIR/copygc/stream_transform.cj" \
    "$CASE_DIR/persistent_baseline.cj" \
    "$CASE_DIR/payloads/${PAYLOAD}.json" \
    "$SCRIPT_DIR/normalize_byte_size.sh" \
    "$SCRIPT_DIR/compare_results.py"; do
    if [[ ! -f "$required_file" ]]; then
        echo "[ERROR] required file not found: $required_file" >&2
        exit 1
    fi
done

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
    echo "[ERROR] Python executable not found: $PYTHON_BIN" >&2
    exit 1
fi

for numeric_name in PERSISTENT_WORKERS CONCURRENCY DURATION_MS CLIENT_TIMEOUT_MS SEND_INTERVAL_MS MAX_INFLIGHT; do
    numeric_value="${!numeric_name}"
    if [[ ! "$numeric_value" =~ ^[0-9]+$ ]] || [[ "$numeric_value" -le 0 ]]; then
        echo "[ERROR] $numeric_name must be a positive integer, got '$numeric_value'" >&2
        exit 2
    fi
done

PERSISTENT_BYTES="$(bash "$SCRIPT_DIR/normalize_byte_size.sh" "$PERSISTENT_BYTES_INPUT")"
PERSISTENT_MIB=$((PERSISTENT_BYTES / 1024 / 1024))
PAYLOAD_TAG="$(printf '%s' "$PAYLOAD" | tr '[:upper:]' '[:lower:]')"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
COMPARE_DIR_BASE="$RESULT_ROOT/${TIMESTAMP}_opt_gc1_vs_gc2_${PERSISTENT_MIB}M_c${CONCURRENCY}_${PAYLOAD_TAG}_${HEAP_SIZE}"
COMPARE_DIR="$COMPARE_DIR_BASE"
suffix=1
while [[ -e "$COMPARE_DIR" ]]; do
    COMPARE_DIR="${COMPARE_DIR_BASE}_${suffix}"
    suffix=$((suffix + 1))
done

WGC_DIR="$COMPARE_DIR/wgc"
GENERATIONAL_DIR="$COMPARE_DIR/generational"
MPLCONFIG_DIR="$RESULT_ROOT/.mplconfig"
mkdir -p "$WGC_DIR" "$GENERATIONAL_DIR" "$MPLCONFIG_DIR"

compile_benchmark() {
    echo "[INFO] compiling benchmark once with $SDK_ROOT"
    env -i \
        HOME="$HOME" \
        TERM="${TERM:-xterm}" \
        PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin" \
        SDK_ROOT="$SDK_ROOT" \
        STDX_DIR="$STDX_DIR" \
        RUNTIME_LIB_DIR="$RUNTIME_LIB_DIR" \
        LIBRARY_PATH_VAR="$CASE25_LIBRARY_PATH_VAR" \
        FALLBACK_LIBRARY_PATH_VAR="$CASE25_FALLBACK_LIBRARY_PATH_VAR" \
        STDX_HTTP_LIBRARY="$STDX_HTTP_LIBRARY" \
        STDX_JSON_LIBRARY="$STDX_JSON_LIBRARY" \
        STDX_STREAM_LIBRARY="$STDX_STREAM_LIBRARY" \
        CASE_DIR="$CASE_DIR" \
        COMPARE_DIR="$COMPARE_DIR" \
        bash -c '
            set -euo pipefail
            set +u
            source "$SDK_ROOT/envsetup.sh" >/dev/null 2>&1
            set -u
            if ! command -v cjc >/dev/null 2>&1; then
                export PATH="$SDK_ROOT/bin:$SDK_ROOT/tools/bin:$PATH:$HOME/.cjpm/bin"
            fi
            export "$LIBRARY_PATH_VAR=$STDX_DIR:$RUNTIME_LIB_DIR:$SDK_ROOT/tools/lib"
            if [[ -n "$FALLBACK_LIBRARY_PATH_VAR" ]]; then
                export "$FALLBACK_LIBRARY_PATH_VAR=$RUNTIME_LIB_DIR:$SDK_ROOT/tools/lib"
            fi
            cjc -O2 \
                "$CASE_DIR/benchmark.cj" \
                "$CASE_DIR/copygc/stream_transform.cj" \
                "$CASE_DIR/persistent_baseline.cj" \
                --import-path "$STDX_DIR" \
                -L "$STDX_DIR" \
                --link-option "$STDX_HTTP_LIBRARY" \
                --link-option "$STDX_JSON_LIBRARY" \
                --link-option "$STDX_STREAM_LIBRARY" \
                -o "$COMPARE_DIR/benchmark"
        ' >"$COMPARE_DIR/compile.log" 2>&1
    test -x "$COMPARE_DIR/benchmark"
}

port_is_free() {
    "$PYTHON_BIN" - "$1" <<'PY'
import socket
import sys

port = int(sys.argv[1])
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
    sock.settimeout(0.05)
    try:
        sock.connect(("127.0.0.1", port))
    except OSError:
        raise SystemExit(0)
raise SystemExit(1)
PY
}

find_free_port() {
    local port="$1"
    local attempt
    for ((attempt = 0; attempt < 50; ++attempt)); do
        if port_is_free "$port"; then
            printf '%s\n' "$port"
            return 0
        fi
        port=$((port + 1))
    done
    echo "[ERROR] no free port found from $1" >&2
    return 1
}

file_md5() {
    "$PYTHON_BIN" - "$1" <<'PY'
import hashlib
import sys

digest = hashlib.md5()
with open(sys.argv[1], "rb") as source:
    for chunk in iter(lambda: source.read(1024 * 1024), b""):
        digest.update(chunk)
print(digest.hexdigest())
PY
}

compile_benchmark
BENCHMARK_MD5="$(file_md5 "$COMPARE_DIR/benchmark")"
RUNTIME_MD5="$(file_md5 "$RUNTIME_LIBRARY")"
cp "$CASE_DIR/benchmark.cj" "$COMPARE_DIR/benchmark.cj.snapshot"
cp "$CASE_DIR/copygc/stream_transform.cj" "$COMPARE_DIR/stream_transform.cj.snapshot"
cp "$CASE_DIR/persistent_baseline.cj" "$COMPARE_DIR/persistent_baseline.cj.snapshot"
cp "$CASE_DIR/payloads/${PAYLOAD}.json" "$COMPARE_DIR/payload.snapshot.json"

run_side() {
    local label="$1"
    local side_name="$2"
    local gc_mode="$3"
    local requested_port="$4"
    local out_dir="$COMPARE_DIR/$side_name"
    local port
    port="$(find_free_port "$requested_port")"

    {
        echo "case=case25_http_complex_json_stream"
        echo "label=$label"
        echo "host_os=$HOST_OS"
        echo "host_arch=$HOST_ARCH"
        echo "platform_dir=$CASE25_PLATFORM_DIR"
        echo "sdk_root=$SDK_ROOT"
        echo "stdx_dir=$STDX_DIR"
        echo "runtime_library=$RUNTIME_LIBRARY"
        echo "runtime_library_md5=$RUNTIME_MD5"
        echo "runtime_dylib_md5=$RUNTIME_MD5"
        echo "binary_md5=$BENCHMARK_MD5"
        echo "cjc_gc_mode="
        echo "cj_enable_gc=$gc_mode"
        echo "heap_size=$HEAP_SIZE"
        echo "persistent_bytes=$PERSISTENT_BYTES"
        echo "persistent_workers=$PERSISTENT_WORKERS"
        echo "concurrency=$CONCURRENCY"
        echo "payload=$PAYLOAD"
        echo "duration_ms=$DURATION_MS"
        echo "client_timeout_ms=$CLIENT_TIMEOUT_MS"
        echo "client_mode=$CLIENT_MODE"
        echo "send_interval_ms=$SEND_INTERVAL_MS"
        echo "max_inflight=$MAX_INFLIGHT"
        echo "procs=$PROCS"
        echo "cj_gc_interval=$GC_INTERVAL"
        echo "cj_heap_growth=$HEAP_GROWTH"
        echo "cj_scavenge_growth=$SCAVENGE_GROWTH"
        echo "mrt_report=enabled"
        echo "server_port=$port"
        echo "timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    } >"$out_dir/run_metadata.env"

    local -a common_env=(
        "HOME=$HOME"
        "TERM=${TERM:-xterm}"
        "PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin"
        "cjHeapSize=$HEAP_SIZE"
        CASE25_PAYLOAD="$PAYLOAD"
        CASE25_CONCURRENCY="$CONCURRENCY"
        CASE25_DURATION_MS="$DURATION_MS"
        CASE25_PERSISTENT_WORKERS="$PERSISTENT_WORKERS"
        "CASE25_SERVER_PORT=$port"
        CASE25_CLIENT_TIMEOUT_MS="$CLIENT_TIMEOUT_MS"
        "CASE25_PAYLOAD_DIR=$CASE_DIR/payloads"
        "CASE25_CLIENT_MODE=$CLIENT_MODE"
        "CASE25_SEND_INTERVAL_MS=$SEND_INTERVAL_MS"
        "CASE25_MAX_INFLIGHT=$MAX_INFLIGHT"
    )
    common_env+=("$CASE25_LIBRARY_PATH_VAR=$STDX_DIR:$RUNTIME_LIB_DIR:$SDK_ROOT/tools/lib")
    if [[ -n "$CASE25_FALLBACK_LIBRARY_PATH_VAR" ]]; then
        common_env+=("$CASE25_FALLBACK_LIBRARY_PATH_VAR=$RUNTIME_LIB_DIR:$SDK_ROOT/tools/lib")
    fi
    if [[ -n "$PROCS" ]]; then
        common_env+=("cjProcessorNum=$PROCS")
    fi
    if [[ -n "$GC_INTERVAL" ]]; then
        common_env+=("cjGCInterval=$GC_INTERVAL")
    fi
    if [[ -n "$HEAP_GROWTH" ]]; then
        common_env+=("cjHeapGrowth=$HEAP_GROWTH")
    fi
    if [[ -n "$SCAVENGE_GROWTH" ]]; then
        common_env+=("cjScavengeGrowth=$SCAVENGE_GROWTH")
    fi

    echo "[INFO] ===== $label ====="
    echo "[INFO] port=$port heap=$HEAP_SIZE persistent=$PERSISTENT_BYTES payload=$PAYLOAD concurrency=$CONCURRENCY duration=${DURATION_MS}ms timeout=${CLIENT_TIMEOUT_MS}ms"

    env -i "${common_env[@]}" \
        cjEnableGC="$gc_mode" \
        MRT_REPORT="$out_dir/server.gc.log" \
        CASE25_ROLE=server \
        CASE25_PERSISTENT_BYTES="$PERSISTENT_BYTES" \
        "$COMPARE_DIR/benchmark" >"$out_dir/server.stdout.txt" 2>"$out_dir/server.stderr.txt" &
    ACTIVE_SERVER_PID=$!

    local ready=0
    local attempt
    for ((attempt = 0; attempt < 900; ++attempt)); do
        if (echo >"/dev/tcp/127.0.0.1/$port") 2>/dev/null; then
            ready=1
            break
        fi
        local server_state
        server_state="$(ps -o stat= -p "$ACTIVE_SERVER_PID" 2>/dev/null | tr -d '[:space:]')"
        case "$server_state" in
        ""|*E*|*Z*)
            wait "$ACTIVE_SERVER_PID" 2>/dev/null || true
            ACTIVE_SERVER_PID=""
            echo "[ERROR] $label server exited before readiness" >&2
            return 1
            ;;
        esac
        sleep 0.1
    done
    if [[ "$ready" != 1 ]]; then
        echo "[ERROR] $label server readiness timeout" >&2
        return 1
    fi

    env -i "${common_env[@]}" \
        cjEnableGC="$gc_mode" \
        MRT_REPORT="$out_dir/client.gc.log" \
        CASE25_ROLE=client \
        CASE25_PERSISTENT_BYTES=0 \
        "$COMPARE_DIR/benchmark" >"$out_dir/stdout.txt" 2>"$out_dir/stderr.txt" &
    ACTIVE_CLIENT_PID=$!

    perl -MTime::HiRes=sleep,time -e '
        my ($client_pid, $server_pid) = @ARGV;
        while (kill 0, $client_pid) {
            my $line = `ps -o rss=,%cpu= -p $server_pid 2>/dev/null`;
            $line =~ s/^\s+|\s+$//g;
            if ($line ne "") {
                my ($rss, $cpu) = split /\s+/, $line;
                my $t = time();
                my @lt = localtime(int($t));
                my $frac = sprintf("%.3f", $t - int($t));
                $frac =~ s/^0//;
                printf "%04d-%02d-%02dT%02d:%02d:%02d%s,%s,%s\n",
                    $lt[5]+1900, $lt[4]+1, $lt[3], $lt[2], $lt[1], $lt[0], $frac, $rss, $cpu;
            }
            sleep(0.2);
        }
    ' "$ACTIVE_CLIENT_PID" "$ACTIVE_SERVER_PID" > "$out_dir/rss.csv" 2>"$out_dir/sampler.stderr.txt" &
    ACTIVE_SAMPLER_PID=$!

    local client_status
    if wait "$ACTIVE_CLIENT_PID"; then
        client_status=0
    else
        client_status=$?
    fi
    ACTIVE_CLIENT_PID=""
    kill "$ACTIVE_SAMPLER_PID" 2>/dev/null || true
    wait "$ACTIVE_SAMPLER_PID" 2>/dev/null || true
    ACTIVE_SAMPLER_PID=""
    kill "$ACTIVE_SERVER_PID" 2>/dev/null || true
    wait "$ACTIVE_SERVER_PID" 2>/dev/null || true
    ACTIVE_SERVER_PID=""

    echo "$client_status" >"$out_dir/run.exitcode"
    if [[ "$client_status" -ne 0 ]] || \
        ! grep -q '^\[DONE\]$' "$out_dir/stdout.txt" || \
        ! grep -q '^\[RESULT\] total=' "$out_dir/stdout.txt"; then
        echo "[ERROR] $label client failed or did not emit a complete result (exit=$client_status)" >&2
        return 1
    fi
    grep '^\[RESULT\]' "$out_dir/stdout.txt"
    awk -F, '{rss += $2; cpu += $3; if ($2 > peak) peak = $2; n++}
        END {if (n) printf "[SERVER] samples=%d avg_cpu=%.2f%% avg_rss=%.2fMiB peak_rss=%.2fMiB\n", n, cpu / n, rss / n / 1024, peak / 1024}' \
        "$out_dir/rss.csv"
}

run_side "WGC(cjEnableGC=1)" "wgc" 1 18600
run_side "GenerationalGC(cjEnableGC=2)" "generational" 2 18610

MPLCONFIGDIR="$MPLCONFIG_DIR" "$PYTHON_BIN" "$SCRIPT_DIR/compare_results.py" \
    --run "WGC(cjEnableGC=1)=$WGC_DIR" \
    --run "GenerationalGC(cjEnableGC=2)=$GENERATIONAL_DIR" \
    --output "$COMPARE_DIR/compare_report.md"

echo "[DONE] compare_dir=$COMPARE_DIR"

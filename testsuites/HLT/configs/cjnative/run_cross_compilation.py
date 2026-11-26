#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
# 
# See https://cangjie-lang.cn/pages/LICENSE for license information.

import argparse
import logging
import os
import platform
import time
import subprocess
import sys
from collections import OrderedDict
from pathlib import Path
from textwrap import indent
import uuid
import re
import shlex

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

PREPARE_STAGE = ["copy_file_to_remote"]
RUN_STAGE = ["run_case"]
DOWNLOAD_STAGE = ["download_file_from_remote"]
REMOVE_STAGE = ["remove_file_on_remote"]

STAGES = (PREPARE_STAGE, RUN_STAGE, DOWNLOAD_STAGE, REMOVE_STAGE)

EXIT_CODE = 0
# ENCODING = locale.getpreferredencoding(False)
ENCODING = "utf-8"

IS_WINDOWS = platform.system() == "Windows"

# ssh/scp options shared by every board connection. The board host key is
# ephemeral (reflashed/reimaged boards regenerate it) and the framework runs
# with stdin closed, so an interactive "accept host key?" prompt would make
# the connection fail instead of waiting for input. Accept any key and keep
# known_hosts untouched.
SSH_COMMON_OPTS = "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

tool = "hdc"
# scp/ssh connection target, populated in main() from --host/--user/--port
# (or RTOS_HOST/RTOS_USER/RTOS_PORT). Empty when tool is hdc/adb.
scp_target = {}


class RunError(Exception):
    pass


def complete_path(path):
    """Returns the canonical path of a path"""
    path = Path(path)
    if not path.exists():
        return Path(os.path.realpath(str(path)))
    return path.expanduser().resolve()


def add_run_path(new_path):
    """Add path to PATH"""
    run_env = os.environ.copy()
    old_path = run_env.get("PATH")
    if old_path:
        if sys.platform == 'linux' or sys.platform == 'darwin':
            run_env["PATH"] = old_path + ":" + new_path
        else:
            run_env["PATH"] = old_path + ";" + new_path
    else:
        run_env["PATH"] = new_path
    return run_env


def run(cmd, work_dir, timeout):
    process = subprocess.Popen(
        cmd,
        shell=True,
        close_fds=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd=str(work_dir),
        env=add_run_path(str(work_dir)),
    )
    try:
        comout, comerr = process.communicate(timeout=timeout)
    except subprocess.CalledProcessError as e:
        raise e
    else:
        returncode = process.returncode
        comout = comout.decode(ENCODING, errors="ignore")
        comerr = comerr.decode(ENCODING, errors="ignore")
        return returncode, comout, comerr
    finally:
        process.terminate()


def convert_windows_path_separators(cmd):
    """Convert Windows path separators in cmd to '/', keeping shell escapes.

    The command is executed by the POSIX shell on the remote device, where a
    backslash can be either a Windows path separator (e.g. "C:\\dir\\file")
    that has to become '/', or an escape sequence used by the shell or by a
    tool (e.g. the "\\-" inside "grep '\\-\\-\\-'", or the "\\\"" inside
    'grep "tests=\\"4\\""') that must be kept intact.
    """
    path_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789._:"
    result = []
    i = 0
    length = len(cmd)
    while i < length:
        ch = cmd[i]
        if ch == "'":
            # Inside single quotes every backslash is literal text for the
            # remote shell, copy the quoted fragment unchanged.
            end = cmd.find("'", i + 1)
            if end == -1:
                result.append(cmd[i:])
                break
            result.append(cmd[i:end + 1])
            i = end + 1
            continue
        if ch == '"':
            # Inside double quotes a backslash only escapes " \ $ ` for the
            # remote shell, any other backslash is a Windows path separator.
            result.append(ch)
            i += 1
            while i < length and cmd[i] != '"':
                if cmd[i] == '\\' and i + 1 < length and cmd[i + 1] in ('"', '\\', '$', '`'):
                    result.append(cmd[i:i + 2])
                    i += 2
                    continue
                result.append('/' if cmd[i] == '\\' else cmd[i])
                i += 1
            if i < length:
                result.append('"')
                i += 1
            continue
        if ch == '\\':
            prev = cmd[i - 1] if i > 0 else ''
            nxt = cmd[i + 1] if i + 1 < length else ''
            if prev in path_chars and (nxt == '' or nxt in path_chars):
                result.append('/')
            else:
                result.append('\\')
            i += 1
            continue
        result.append(ch)
        i += 1
    return ''.join(result)


def construct_tool_shell_cmd(cmd: str):
    # Where to stash the stdout/stderr/exit-code capture files on the device.
    # RTOS boards may not have /data/local/tmp; scp_target carries the
    # remote temp dir chosen in main() (defaults to /data/local/tmp for
    # hdc/adb, /tmp for scp unless overridden by --remote-root's parent).
    remote_temp_dir = scp_target.get('remote_capture_dir', '/data/local/tmp')
    h = '{}/{}'.format(remote_temp_dir, uuid.uuid4())
    shell_cmd = f'{cmd} 1> {h}_stdout.txt 2> {h}_stderr.txt ; echo exit_code_start$?exit_code_end > {h}_exit_code.txt ; cat {h}_stdout.txt ; cat {h}_exit_code.txt ; cat {h}_stderr.txt ; rm {h}_stdout.txt ; rm {h}_exit_code.txt ; rm {h}_stderr.txt'
    if IS_WINDOWS:
        # cmd.exe keeps single quotes and backslashes inside double quotes
        # literally, so a double quoted argument is passed through unchanged.
        shell_cmd = '"{}"'.format(shell_cmd)
    else:
        # Quote the whole command for the host shell without breaking any
        # quoting that the command itself uses on the device.
        shell_cmd = shlex.quote(shell_cmd)
    if tool == "scp":
        # Run on the board over ssh. scp_target holds user/host/port set in
        # main(); the whole remote script is a single quoted argument so the
        # remote shell expands it verbatim.
        port_opt = "-p {} ".format(scp_target['port']) if scp_target.get('port') else ""
        cmd = "ssh {common_opts} {port_opt}{user}@{host} {shell_cmd}".format(
            common_opts=SSH_COMMON_OPTS,
            port_opt=port_opt,
            user=scp_target['user'],
            host=scp_target['host'],
            shell_cmd=shell_cmd,
        )
    else:
        cmd = f"{tool} shell {shell_cmd}"
    return cmd


def construct_tool_send_cmd(src, dest):
    if "hdc" in tool:
        cmd = "{tool} file send {src} {dest}".format(
            tool=tool,
            src=str(src).strip(),
            dest=str(dest).strip(),
        )
    elif "adb" in tool:
        for root_dir_path, _, file_name_list in os.walk(src):
            for file_name in file_name_list:
                if file_name.endswith('.c') or file_name.endswith('.cpp') or file_name.endswith('.java'):
                    file_path = os.path.join(root_dir_path, file_name)
                    print(f'removing {file_path}')
                    os.remove(file_path)
        cmd = "{tool} push {src} {dest}".format(
            tool=tool,
            src=str(src).strip(),
            dest=str(dest).strip(),
        )
    elif tool == "scp":
        # Push the local work dir to the board. dest must be the remote root
        # (e.g. /tmp/run) — the board's scp only accepts the existing root as
        # target. scp -r copies the local dir INTO dest as a subdirectory
        # named after it, so the case dir ends up at dest/<local-dir-basename>
        # (the hash-named dir used by run_case/cleanup).
        port_opt = "-P {} ".format(scp_target['port']) if scp_target.get('port') else ""
        target = "{user}@{host}:{dest}".format(
            user=scp_target['user'], host=scp_target['host'], dest=str(dest).strip(),
        )
        cmd = "scp {common_opts} -r {port_opt}{src} {target}".format(
            common_opts=SSH_COMMON_OPTS,
            port_opt=port_opt, src=str(src).strip(), target=target,
        )
    else:
        cmd = ""
    return cmd


def construct_tool_recv_cmd(src, dest):
    """Pull a file/dir from the remote device back to the local host."""
    if "hdc" in tool:
        cmd = "{tool} file recv {src} {dest}".format(
            tool=tool, src=str(src).strip(), dest=str(dest).strip(),
        )
    elif "adb" in tool:
        cmd = "{tool} pull {src} {dest}".format(
            tool=tool, src=str(src).strip(), dest=str(dest).strip(),
        )
    elif tool == "scp":
        port_opt = "-B -P {} ".format(scp_target['port']) if scp_target.get('port') else "-B "
        target = "{user}@{host}:{src}".format(
            user=scp_target['user'], host=scp_target['host'], src=str(src).strip(),
        )
        cmd = "scp {common_opts} -r {port_opt}{target} {dest}".format(
            common_opts=SSH_COMMON_OPTS,
            port_opt=port_opt, target=target, dest=str(dest).strip(),
        )
    else:
        cmd = ""
    return cmd


def construct_remote_cmd(execute_cmd, execute_case_cmd, upload_file, remote_case_dir, remote_root):
    """Build the run/copy/remove remote commands.

    remote_case_dir is the absolute directory on the device where the case
    runs: remote_root/<case-dir-basename>. Each case gets its own directory
    (the work-dir basename carries a unique hash), so parallel cases never
    share a remote dir and cleanup only removes the current case's dir.
    """
    # remote_capture_dir is pinned in main() before this is called; if a caller
    # invokes construct_remote_cmd directly (older code path), default it.
    if 'remote_capture_dir' not in scp_target:
        scp_target['remote_capture_dir'] = '/tmp' if tool == "scp" else '/data/local/tmp'
    cmd_temp = execute_case_cmd.split(" ")
    execute_case_cmd = " ".join(cmd_temp)
    run_case_cmd = (
        "cd {path}; chmod -R +x {path}; export PATH=$(pwd):$PATH; export LD_LIBRARY_PATH=$(pwd):$LD_LIBRARY_PATH && "
        "{execute_case_cmd}".format(path=remote_case_dir, execute_case_cmd=execute_case_cmd)
    )
    execute_cmd["run_case"] = construct_tool_shell_cmd(run_case_cmd)

    if tool == "scp":
        # 板卡上的 scp 目标只能写到 remote root（如 /tmp/run），不能直接写
        # /tmp/run/<hash-dir>。先确保 remote root 存在（干净板卡首跑时可能没有），
        # 再 scp -r <work_dir> user@host:<root>：scp 会把本地目录作为子目录拷入，
        # 远端即得到 <root>/<hash-dir>，与 run/cleanup 用的 remote_case_dir 一致。
        execute_cmd["copy_file_to_remote"] = [
            construct_tool_shell_cmd("mkdir -p {}".format(remote_root.rstrip('/'))),
            construct_tool_send_cmd(upload_file, remote_root),
        ]
    else:
        execute_cmd["copy_file_to_remote"] = [
            construct_tool_send_cmd(upload_file, remote_case_dir)
        ]
    remove_case_cmd = (
        "rm -rf {}".format(remote_case_dir)
    )
    execute_cmd["remove_file_on_remote"] = construct_tool_shell_cmd(remove_case_cmd)


def parse_cli():
    parser = argparse.ArgumentParser(prog="run")

    parser.add_argument(
        "--timeout",
        type=float,
        default=None,
        help="run test case timeout",
    )
    parser.add_argument(
        "-d",
        "--device",
        type=str,
        default=None,
        help="the target device for hdc/adb commands",
    )
    parser.add_argument(
        "-t",
        "--tool",
        type=str,
        default="hdc",
        help="the tool for commands (hdc/adb/scp)",
    )
    # execute_cmd is optional so that --cleanup can be invoked alone (the
    # framework re-runs the script with only --cleanup to remove the remote
    # case dir after a passing case). ONE_OR_MORE would reject a bare --cleanup.
    parser.add_argument(
        "execute_cmd",
        nargs=argparse.ZERO_OR_MORE,
        metavar="command",
        help="execute command",
    )

    connection_options = parser.add_argument_group("Script options")
    connection_options.add_argument(
        "--verbose",
        action="store_true",
        dest="verbose",
        help="enable verbose output",
    )
    # scp/ssh connection parameters. Each may also be supplied via the
    # matching environment variable (RTOS_HOST / RTOS_USER / RTOS_PORT), so a
    # cfg can write --host=%%RTOS_HOST%% and let the host shell expand it,
    # mirroring the existing --device=%%DEVICE_ID%% pattern.
    connection_options.add_argument(
        "--host",
        type=str,
        default=None,
        help="scp/ssh target host (e.g. 192.168.1.50); falls back to $RTOS_HOST",
    )
    connection_options.add_argument(
        "--user",
        type=str,
        default=None,
        help="scp/ssh target user (e.g. root); falls back to $RTOS_USER",
    )
    connection_options.add_argument(
        "--port",
        type=str,
        default=None,
        help="scp/ssh port; falls back to $RTOS_PORT",
    )
    connection_options.add_argument(
        "--remote-root",
        type=str,
        default="/data/local/tmp/run",
        dest="remote_root",
        help="remote root dir under which the per-case dir is created "
             "(default /data/local/tmp/run; use /tmp/run for RTOS)",
    )
    connection_options.add_argument(
        "--cleanup",
        action="store_true",
        default=False,
        help="cleanup mode: remove the remote case dir and exit. Invoked by "
             "the test framework after a case finishes, so the device does not "
             "accumulate per-case run directories. This is the default end-of-case "
             "behavior unless --keep-temp is given.",
    )
    connection_options.add_argument(
        "--keep-temp",
        action="store_true",
        default=False,
        dest="keep_temp",
        help="keep the remote case dir after the case finishes (mirror of the "
             "framework's --keep_temp). When set, --cleanup is a no-op so the "
             "device keeps the run directory for inspection.",
    )

    opts = parser.parse_args()
    return opts


def run_case(execute_cmd, work_dir, timeout):
    global EXIT_CODE
    try:
        for stage, value in execute_cmd.items():
            if stage == "remove_file_on_remote":
                continue
            if isinstance(value, str):
                run_cmd(stage, value, work_dir, timeout)
            elif isinstance(value, list):
                for cmd in value:
                    run_cmd(stage, cmd, work_dir, timeout)
    except Exception as e:
        # Only clean up the remote dir when the case failed, so that a retry
        # starts from a fresh upload. On success the dir must survive: this
        # script is invoked once per RUN-EXEC line of a case, and everything
        # created on the device by earlier lines (e.g. a directory made by a
        # mkdir in one line) has to stay available for the later lines.
        cleanup_cmd = execute_cmd.get("remove_file_on_remote")
        if cleanup_cmd:
            try:
                run_cmd("remove_file_on_remote", cleanup_cmd, work_dir, timeout)
            except Exception:
                pass
        raise RunError(str(e))


def run_cmd(stage, cmd, work_dir, timeout):
    return_code, com_out, com_err = run(cmd, work_dir, timeout)
    time.sleep(2)

    if 'exit_code_start' in com_out and 'exit_code_end' in com_out:
        com_out = com_out.replace('\r\n', '\n')
        exit_code_start = com_out.find('exit_code_start')
        exit_code_end = com_out.find('exit_code_end')
        stdout_content = '{}'.format(com_out[:exit_code_start])
        return_code = '{}'.format(com_out[exit_code_start + len('exit_code_start'):exit_code_end])
        stderr_content = '{}'.format(com_out[exit_code_end + len('exit_code_end'):])
        com_out = stdout_content
        com_err = stderr_content

    return_code = str(return_code)
    log_output = logging.debug
    if return_code != "0":
        log_output = logging.error
    if stage == "run_case":
        sys.stdout.write(com_out)
        sys.stderr.write(com_err)
    log_output("execute stage: %s", stage)
    log_output("execute command: %s", cmd)
    log_output("execute exit code: %s", return_code)
    logging.debug("execute stdout: \n%s", indent(com_out, "\t", lambda line: True))
    logging.debug("execute stderr: \n%s", indent(com_err, "\t", lambda line: True))
    global EXIT_CODE
    if stage != "remove_file_on_remote":
        EXIT_CODE = int(return_code)
    else:
        # remove is best-effort cleanup invoked after a passing case. It must
        # NOT raise (that would flip an already-passing case to FAIL), but a
        # failed rm leaves a stale dir on the device. Surface it via EXIT_CODE
        # + an error log so the framework's --cleanup call returns non-zero and
        # prints a visible WARNING instead of silently leaving the dir behind.
        if return_code != "0":
            try:
                EXIT_CODE = int(return_code)
            except (TypeError, ValueError):
                EXIT_CODE = 1
            logging.error(
                "cleanup/remove stage failed (exit %s): %s", return_code, com_err,
            )
    if return_code != "0" and stage != "remove_file_on_remote":
        reason = "Run stage: {} failed at command: {}, reason: {}".format(
            stage.upper(), cmd, com_err
        )
        raise RunError(reason)


def main():
    global tool
    global scp_target
    opts = parse_cli()
    timeout = opts.timeout
    tool = opts.tool

    # Resolve scp/ssh connection info: CLI flag takes precedence, then the
    # matching environment variable (RTOS_HOST / RTOS_USER / RTOS_PORT). This
    # mirrors the existing --device=%%DEVICE_ID%% pattern where the cfg writes
    # an env-var placeholder and the host shell expands it.
    host = opts.host or os.environ.get("RTOS_HOST")
    user = opts.user or os.environ.get("RTOS_USER")
    port = opts.port or os.environ.get("RTOS_PORT")

    if tool == "scp":
        if not host or not user:
            raise RunError(
                "scp tool requires a host and user: pass --host/--user or set "
                "RTOS_HOST/RTOS_USER".format()
            )
        scp_target = {"host": host, "user": user, "port": port}

    if opts.device is not None:
        if tool == "hdc":
            tool += " -t {}".format(opts.device)
        elif tool == "adb":
            tool += " -s {}".format(opts.device)
        elif tool == "scp":
            # For scp, --device (if given) is treated as user@host, overriding
            # the separate --host/--user flags. Convenient for ad-hoc runs.
            scp_target = {"host": opts.device, "user": user or "root", "port": port}

    logging.basicConfig(
        format="\t%(asctime)s %(message)s",
        datefmt="%H:%M:%S",
        level=logging.DEBUG if opts.verbose else logging.INFO,
        stream=sys.stderr,
    )

    remote_root = opts.remote_root
    local_path = os.getcwd()
    # Each case runs in its own remote dir remote_root/<case-dir-basename>.
    # The work-dir basename carries a unique hash, so cases in a batch run
    # never share a remote dir, and --cleanup removes only this case's dir —
    # never the whole remote root, which other cases may still be using.
    remote_case_dir = "{}/{}".format(remote_root.rstrip('/'), os.path.basename(local_path))

    # Pick where construct_tool_shell_cmd stashes its stdout/stderr/exit-code
    # capture files on the device. hdc/adb boards have /data/local/tmp; an
    # sshd-bearing RTOS board is more likely to expose /tmp. Set it once here
    # so both the cleanup path and construct_remote_cmd see the same value.
    if 'remote_capture_dir' not in scp_target:
        scp_target['remote_capture_dir'] = '/tmp' if tool == "scp" else '/data/local/tmp'

    # ---- cleanup mode: remove the remote case dir and exit ----
    # Invoked by the test framework (cangjie_test_framework/run.py) after a
    # case passes, as the default end-of-case behavior (unless the framework
    # was started with --keep_temp, in which case it does not invoke cleanup
    # at all). The framework re-runs this script with the same --remote-root,
    # so rm -rf hits exactly the dir used during the run. A non-zero
    # EXIT_CODE here propagates to the framework, which logs a visible
    # WARNING so a silently-failing rm no longer leaves stale dirs.
    if opts.cleanup:
        if opts.keep_temp:
            # Mirror of the framework's --keep_temp: keep everything, do nothing.
            return
        remove_cmd = "rm -rf {}".format(remote_case_dir)
        cleanup_cmd = construct_tool_shell_cmd(remove_cmd)
        cleanup_timeout = timeout if timeout else 60
        run_cmd("remove_file_on_remote", cleanup_cmd, ".", cleanup_timeout)
        if tool == "scp":
            # rm -rf 对不存在的路径同样返回 0，无法区分"已删除"与"删错了
            # 路径"。rm 之后再用 ls 确认目标目录是否还在：若还在，说明这次
            # 清理没删到真正的用例目录，以非零退出让框架打出可见的 WARNING。
            verify_cmd = construct_tool_shell_cmd("ls -d {}".format(remote_case_dir))
            _, verify_out, verify_err = run(verify_cmd, ".", cleanup_timeout)
            if ("No such file or directory" not in verify_out
                    and "No such file or directory" not in verify_err):
                logging.error(
                    "cleanup verify FAILED: %s still exists after rm -rf (ls output: %s)",
                    remote_case_dir, (verify_out or verify_err).strip()[:200],
                )
                sys.exit(1)
        sys.exit(EXIT_CODE)

    # ---- normal execution mode ----
    execute_cmd = " ".join(opts.execute_cmd)
    if not execute_cmd:
        raise RunError("no execute command given (and --cleanup not set)")
    # Only Windows-host case commands carry Windows path separators that must
    # be turned into POSIX paths for the remote shell. On a POSIX host
    # (linux/mac) backslashes in the command are shell escapes (e.g. "\\n",
    # "\\\"") and converting them would corrupt the command.
    if IS_WINDOWS:
        execute_cmd = convert_windows_path_separators(execute_cmd)

    execute_stages = OrderedDict()
    for stage in STAGES:
        for cmd in stage:
            execute_stages[cmd] = None

    construct_remote_cmd(
        execute_stages,
        execute_cmd,
        local_path,
        remote_case_dir,
        remote_root,
    )
    # If the remote case dir already exists (left over from an earlier failed
    # run that did not clean up), skip the copy step and reuse it.
    check_case = construct_tool_shell_cmd("ls {}".format(remote_case_dir))
    return_code, com_out, com_err = run(check_case, ".", 10)
    if "No such file or directory" not in com_out and "No such file or directory" not in com_err:
        execute_stages["copy_file_to_remote"] = None
    run_case(execute_stages, ".", timeout)


if __name__ == "__main__":
    try:
        main()
    except RunError as e:
        # EXIT_CODE reflects the last run stage's exit code, but a RunError can
        # be raised before any stage runs (e.g. missing scp connection info), in
        # which case EXIT_CODE is still 0. Surface the message and exit non-zero
        # so the framework treats the invocation as failed rather than silent.
        sys.stderr.write("RunError: {}\n".format(e))
        sys.exit(EXIT_CODE if EXIT_CODE != 0 else 1)

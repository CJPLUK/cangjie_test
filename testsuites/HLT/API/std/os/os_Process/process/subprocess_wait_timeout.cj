/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// (not Windows) EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// (not OHOS and not Windows)RUN-EXEC-PIPE: %run %run_opt %output %run_utest_opt %run_args | compare %f
// (not Windows) ASSERT: scan Summary: TOTAL: 12
// (not Windows) ASSERT: scan ERROR: 0
import std.posix.*
import std.process.*

// Regression tests for SubProcess.wait(timeout:):
//  - a timed-out wait must not leave a background reaper thread behind,
//    otherwise the child is reaped by that stray thread and every later
//    wait() fails with ECHILD and returns -1;
//  - wait() must be idempotent: the exit status is cached on the instance so
//    repeated calls return the same result instead of -1;
//  - the polling (WNOHANG) wait path must return the real exit status for a
//    normal exit and the terminating signal number for a signal exit, and must
//    still work for waitOutput() after an earlier timeout expired.
@Test
class Test_subprocess_wait_timeout {
    @TestCase
    func test_timeout_then_rewait_same_instance(): Unit {
        // wait(timeout:) times out cleanly without spawning a residual reaper,
        // so a later wait() on the same instance reaps the child itself and
        // returns the real exit status (0) instead of -1.
        let sub = Process.start("sleep", "2")
        try {
            sub.wait(timeout: Duration.millisecond * 500)
            @Expect(false)
        } catch (_: TimeoutException) {
        }
        // Give the child enough time to exit. With the old implementation the
        // stray reaper thread reaps it here, making the wait() below return -1.
        sleep(Duration.second * 3)
        @Expect(sub.wait(), 0)
    }

    @TestCase
    func test_idempotent_rewait(): Unit {
        // Once reaped, repeated wait() calls must return the cached exit
        // status instead of failing with ECHILD.
        let sub = Process.start("sleep", "1")
        @Expect(sub.wait(), 0)
        @Expect(sub.wait(), 0)
        @Expect(sub.wait(), 0)
    }

    @TestCase
    func test_multiple_timeouts_then_rewait(): Unit {
        // Several timed-out waits must not poison later waits either.
        let sub = Process.start("sleep", "2")
        var timeoutCnt = 0
        try {
            sub.wait(timeout: Duration.millisecond * 300)
            @Expect(false)
        } catch (_: TimeoutException) {
            timeoutCnt++
        }
        try {
            sub.wait(timeout: Duration.millisecond * 300)
            @Expect(false)
        } catch (_: TimeoutException) {
            timeoutCnt++
        }
        try {
            sub.wait(timeout: Duration.millisecond * 300)
            @Expect(false)
        } catch (_: TimeoutException) {
            timeoutCnt++
        }
        @Expect(timeoutCnt, 3)
        sleep(Duration.second * 3)
        @Expect(sub.wait(), 0)
    }

    @TestCase
    func test_exit_within_timeout_returns_exit_code(): Unit {
        // A child that exits before the deadline must be reaped by the polling
        // wait and return its real exit code instead of throwing.
        let sub = Process.start("/bin/sh", "-c", "exit 7")
        @Expect(sub.wait(timeout: Duration.second * 5), 7)
    }

    @TestCase
    func test_timeout_then_second_timed_wait(): Unit {
        // A second *timed* wait (not only a blocking one) must recover the real
        // exit status after an earlier timeout expired.
        let sub = Process.start("sleep", "1")
        try {
            sub.wait(timeout: Duration.millisecond * 200)
            @Expect(false)
        } catch (_: TimeoutException) {
        }
        @Expect(sub.wait(timeout: Duration.second * 5), 0)
    }

    @TestCase
    func test_signal_exit_code_via_timed_wait(): Unit {
        // A child killed by a signal must surface the terminating signal number
        // (9 for SIGKILL) through the polling (WNOHANG) wait path.
        let sub = Process.start("sleep", "5")
        kill(Int32(sub.pid), SIGKILL)
        @Expect(sub.wait(timeout: Duration.second * 5), 9)
    }

    @TestCase
    func test_wait_output_after_timeout(): Unit {
        // waitOutput() must still read the pipes and reap the child.
        let sub = Process.start("/bin/sh", "-c", "sleep 1; printf timeout-output", stdOut: Pipe, stdErr: Pipe)
        try {
            sub.wait(timeout: Duration.millisecond * 200)
            @Expect(false)
        } catch (_: TimeoutException) {
        }
        sleep(Duration.second * 2)
        let (exitCode, out, err) = sub.waitOutput()
        @Expect(exitCode, 0)
        @Expect(String.fromUtf8(out), "timeout-output")
        @Expect(String.fromUtf8(err), "")
    }

    @TestCase
    func test_already_exited_child_with_tiny_timeout(): Unit {
        let sub = Process.start("/bin/sh", "-c", "exit 7")
        sleep(Duration.second)
        @Expect(sub.wait(timeout: Duration.nanosecond), 7)
        @Expect(sub.wait(), 7)
    }

    @TestCase
    func test_deadline_expires_before_late_exit(): Unit {
        let sub = Process.start("sleep", "1")
        try {
            sub.wait(timeout: Duration.nanosecond * 500000)
            @Expect(false)
        } catch (e: TimeoutException) {
            @Expect(e.message, "")
        }
        @Expect(sub.wait(), 0)
    }

    @TestCase
    func test_negative_timeout_blocks_until_exit(): Unit {
        // A non-positive timeout keeps the documented blocking semantics: the
        // wait stays in the calling thread until the child exits and returns its
        // real exit code (no timeout is armed, no background reaper is spawned).
        let sub = Process.start("/bin/sh", "-c", "exit 4")
        @Expect(sub.wait(timeout: Duration.millisecond * -1), 4)
    }

    @TestCase
    func test_rewait_after_blocking_wait_with_timeout(): Unit {
        // Once a blocking wait has reaped the child, a later *timed* wait must
        // hit the cached fast path and return the same exit code instead of
        // polling waitpid again (which would fail with ECHILD and return -1).
        let sub = Process.start("/bin/sh", "-c", "exit 7")
        @Expect(sub.wait(), 7)
        @Expect(sub.wait(timeout: Duration.second * 5), 7)
    }

    @TestCase
    func test_rewait_after_signal_exit_is_idempotent(): Unit {
        // A signal exit must be cached too: after the terminating signal number
        // is observed once, both a blocking and a timed re-wait return it.
        let sub = Process.start("sleep", "5")
        kill(Int32(sub.pid), SIGKILL)
        @Expect(sub.wait(timeout: Duration.second * 5), 9)
        @Expect(sub.wait(), 9)
        @Expect(sub.wait(timeout: Duration.second * 5), 9)
    }
}

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// (Windows) EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// (Windows) RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args
import std.process.*

foreign func CJ_OS_WaitSubProcessExitTimeout(handle: IntNative, timeoutMilliseconds: UInt32,
    exitCode: CPointer<Int64>): Int32

// Windows regression coverage for SubProcess.wait(timeout:). The native timed
// wait uses WaitForSingleObject and must not leave a background waiter behind.
@Test
class Test_subprocess_wait_timeout {
    @TestCase
    func test_timeout_then_rewait_same_instance(): Unit {
        let sub = Process.start("sleep", "2s")
        try {
            sub.wait(timeout: Duration.millisecond * 500)
            @Expect(false)
        } catch (_: TimeoutException) {
        }
        sleep(Duration.second * 3)
        @Expect(sub.wait(), 0)
    }

    @TestCase
    func test_idempotent_rewait(): Unit {
        let sub = Process.start("sleep", "1s")
        @Expect(sub.wait(), 0)
        @Expect(sub.wait(), 0)
        @Expect(sub.wait(), 0)
    }

    @TestCase
    func test_timeout_then_second_timed_wait(): Unit {
        let sub = Process.start("sleep", "1s")
        try {
            sub.wait(timeout: Duration.millisecond * 200)
            @Expect(false)
        } catch (_: TimeoutException) {
        }
        @Expect(sub.wait(timeout: Duration.second * 5), 0)
    }

    @TestCase
    func test_exit_within_timeout_returns_exit_code(): Unit {
        let sub = Process.start("sleep", "1s")
        @Expect(sub.wait(timeout: Duration.second * 5), 0)
    }

    @TestCase
    func test_wait_output_after_timeout(): Unit {
        let sub = Process.start("sleep", "1s")
        try {
            sub.wait(timeout: Duration.millisecond * 200)
            @Expect(false)
        } catch (_: TimeoutException) {
        }
        sleep(Duration.second * 2)
        let (exitCode, out, err) = sub.waitOutput()
        @Expect(exitCode, 0)
        @Expect(String.fromUtf8(out), "")
        @Expect(String.fromUtf8(err), "")
    }

    @TestCase
    func test_already_exited_child_with_tiny_timeout(): Unit {
        let sub = Process.start("sleep", "1s")
        sleep(Duration.second * 2)
        @Expect(sub.wait(timeout: Duration.nanosecond), 0)
        @Expect(sub.wait(), 0)
    }

    @TestCase
    func test_deadline_expires_before_late_exit(): Unit {
        let sub = Process.start("sleep", "1s")
        try {
            sub.wait(timeout: Duration.nanosecond * 500000)
            @Expect(false)
        } catch (e: TimeoutException) {
            @Expect(e.message, "")
        }
        @Expect(sub.wait(), 0)
    }

    @TestCase
    func test_native_wait_rejects_null_handle(): Unit {
        var exitCode: Int64 = 73
        let ret = unsafe { CJ_OS_WaitSubProcessExitTimeout(IntNative(0), 1, inout exitCode) }
        @Expect(ret, -1)
        @Expect(exitCode, 73)
    }
}

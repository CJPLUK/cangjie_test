// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package javasample;

public final class Main {
    private Main() {}

    public static void main(String[] args) {
        TestImpl test = new TestImpl();

        // 1. Normal JNI call: no pending exception should be detected.
        int result = test.testCheckExceptionNoPending();
        if (result != 42) {
            throw new AssertionError(
                "Unexpected result: " + result + ", expected 42"
            );
        }
        System.out.println("PASS: no pending exception");

        // 2. Java method throws an exception.
        // checkException should detect the pending JNI exception.
        boolean exceptionCaught = false;

        try {
            test.testCheckExceptionPending();
        } catch (Throwable expected) {
            exceptionCaught = true;
            System.out.println(
                "PASS: pending exception detected: "
                + expected.getClass().getName()
                + ": "
                + expected.getMessage()
            );
        }

        if (!exceptionCaught) {
            throw new AssertionError(
                "Expected an exception from testCheckExceptionPending"
            );
        }

        // 3. Check that JNI calls still work after the exception.
        result = test.testCheckExceptionNoPending();
        if (result != 42) {
            throw new AssertionError(
                "Unexpected result after exception: " + result
            );
        }
        System.out.println("PASS: JNI works after pending exception");

        System.out.println("All checkException tests passed");
    }
}

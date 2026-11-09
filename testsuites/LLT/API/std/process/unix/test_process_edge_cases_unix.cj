/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// (Unix) EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// (Unix) EXEC: %run %run_opt %output %run_utest_opt

import std.collection.*
import std.fs.*
import std.process.*
import std.time.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
class ProcessEdgeCasesTest {
    let baseDir: String = "./cov_tmp_process_coverage"

    @BeforeAll
    func setupAll(): Unit {
        removeIfExists(baseDir, recursive: true)
        Directory.create(baseDir)
    }

    @AfterAll
    func tearDownAll(): Unit {
        removeIfExists(baseDir, recursive: true)
    }

    func path(name: String): String {
        "${baseDir}/${name}"
    }

    @TestCase
    func testCurrentProcessMetadataEnvironmentAndTimes(): Unit {
        let current = Process.current
        @Expect(current.pid > 0, true)
        @Expect(current.isAlive(), true)
        @Expect(current.name.size > 0, true)
        @Expect(current.command.size > 0, true)
        @Expect(current.commandLine.size > 0, true)
        @Expect(current.arguments.size, current.commandLine.size - 1)
        @Expect(FileInfo(current.workingDirectory).isDirectory(), true)
        @Expect(FileInfo(current.homeDirectory).isDirectory(), true)
        @Expect(FileInfo(current.tempDirectory).isDirectory(), true)
        @Expect(current.startTime != DateTime.UnixEpoch, true)
        @Expect(current.systemTime >= Duration.Zero, true)
        @Expect(current.userTime >= Duration.Zero, true)
        @Expect(Process.of(current.pid).pid, current.pid)
        @Expect(findProcess(current.pid).pid, current.pid)

        let key = "CANGJIE_PROCESS_COVERAGE_ENV"
        let previous = current.getEnv(key)
        try {
            current.removeEnv(key)
            @Expect(current.getEnv(key), None)
            current.setEnv(key, "")
            @Expect(current.getEnv(key), Some(""))
            @Expect(current.environment.get(key), Some(""))
            current.setEnv(key, "coverage-value")
            @Expect(current.getEnv(key), Some("coverage-value"))
            @Expect(current.environment.get(key), Some("coverage-value"))
            @ExpectThrows[IllegalArgumentException](current.getEnv("COV\0"))
            @ExpectThrows[IllegalArgumentException](current.setEnv("COV\0", "value"))
            @ExpectThrows[IllegalArgumentException](current.setEnv("COV_BAD_VALUE", "bad\0value"))
            @ExpectThrows[IllegalArgumentException](current.removeEnv("COV\0"))
            @ExpectThrows[ProcessException](current.setEnv("", "coverage-value"))
            @ExpectThrows[ProcessException](current.removeEnv(""))
        } finally {
            match (previous) {
                case Some(value) => current.setEnv(key, value)
                case None => current.removeEnv(key)
            }
        }
    }

    @TestCase
    func testTempDirectoryFallbackAndPrecedence(): Unit {
        let current = Process.current
        let previousTmpDir = current.getEnv("TMPDIR")
        let previousTmp = current.getEnv("TMP")
        let previousTemp = current.getEnv("TEMP")
        let previousTempDir = current.getEnv("TEMPDIR")
        try {
            current.removeEnv("TMPDIR")
            current.removeEnv("TMP")
            current.removeEnv("TEMP")
            current.removeEnv("TEMPDIR")
            @Expect(current.tempDirectory.toString(), "/tmp")

            current.setEnv("TEMP", "/tmp/cangjie-coverage-temp")
            @Expect(current.tempDirectory.toString(), "/tmp/cangjie-coverage-temp")
            current.setEnv("TMP", "/tmp/cangjie-coverage-tmp")
            @Expect(current.tempDirectory.toString(), "/tmp/cangjie-coverage-tmp")
            current.setEnv("TMPDIR", "/tmp/cangjie-coverage-tmpdir")
            @Expect(current.tempDirectory.toString(), "/tmp/cangjie-coverage-tmpdir")
        } finally {
            match (previousTmpDir) {
                case Some(value) => current.setEnv("TMPDIR", value)
                case None => current.removeEnv("TMPDIR")
            }
            match (previousTmp) {
                case Some(value) => current.setEnv("TMP", value)
                case None => current.removeEnv("TMP")
            }
            match (previousTemp) {
                case Some(value) => current.setEnv("TEMP", value)
                case None => current.removeEnv("TEMP")
            }
            match (previousTempDir) {
                case Some(value) => current.setEnv("TEMPDIR", value)
                case None => current.removeEnv("TEMPDIR")
            }
        }
    }

    @TestCase
    func testPipedChildMetadataAndStreamLifecycle(): Unit {
        let key = "CANGJIE_PROCESS_CHILD_ENV"
        let childEnv = HashMap<String, String>()
        childEnv.add(key, "child-value")
        let script = "read line; printf '%s' \"$line\""
        let child = launch(
            "/bin/sh",
            ["-c", script, "coverage-child", "argument with spaces"],
            workingDirectory: Some(Path(baseDir)),
            environment: Some(childEnv),
            stdIn: Pipe,
            stdOut: Pipe,
            stdErr: Pipe
        )
        var waited = false
        try {
            let info = findProcess(child.pid)
            @Expect(info.name, "sh")
            @Expect(info.command, "/bin/sh")
            @Expect(info.arguments, ["-c", script, "coverage-child", "argument with spaces"])
            @Expect(info.commandLine[0], "/bin/sh")
            @Expect(info.workingDirectory, canonicalize(Path(baseDir)))
            @Expect(info.environment.get(key), Some("child-value"))
            @Expect(info.startTime != DateTime.UnixEpoch, true)
            @Expect(info.systemTime >= Duration.Zero, true)
            @Expect(info.userTime >= Duration.Zero, true)
            @Expect(info.isAlive(), true)
            @ExpectThrows[IllegalArgumentException](child.stdOutPipe.read(Array<Byte>()))

            child.stdInPipe.write("pipe-value\n".toArray())
            let (status, output, error) = child.waitOutput()
            waited = true
            @Expect(status, 0)
            @Expect(String.fromUtf8(output), "pipe-value")
            @Expect(error.size, 0)
            @Expect(child.stdOutPipe.read(Array<Byte>(1, repeat: 0)), -1)
            @ExpectThrows[ProcessException](child.stdInPipe.write("after-exit".toArray()))
        } finally {
            if (!waited) {
                if (child.isAlive()) {
                    child.terminate(force: true)
                }
                child.wait()
            }
        }
    }

    @TestCase
    func testExecutionOutputAndCompatibilityWrappers(): Unit {
        let (status, output, error) = executeWithOutput(
            "/bin/sh",
            ["-c", "printf stdout-data; printf stderr-data >&2"]
        )
        @Expect(status, 0)
        @Expect(String.fromUtf8(output), "stdout-data")
        @Expect(String.fromUtf8(error), "stderr-data")
        @Expect(execute("/bin/sh", ["-c", "exit 7"]), 7)

        let (legacyStatus, legacyOutput, legacyError) = Process.runOutput(
            "/bin/sh",
            ["-c", "printf legacy-output; printf legacy-error >&2"]
        )
        @Expect(legacyStatus, 0)
        @Expect(String.fromUtf8(legacyOutput), "legacy-output")
        @Expect(String.fromUtf8(legacyError), "legacy-error")
        @Expect(Process.run("/bin/sh", ["-c", "exit 3"]), 3)

        let emptyEnvironment = HashMap<String, String>()
        let (emptyStatus, emptyOutput, emptyError) = executeWithOutput(
            "/usr/bin/env",
            [],
            environment: Some(emptyEnvironment)
        )
        @Expect(emptyStatus, 0)
        @Expect(emptyOutput.size, 0)
        @Expect(emptyError.size, 0)

        let pathEnvironment = HashMap<String, String>()
        pathEnvironment.add("PATH", "/bin:/usr/bin")
        let pathResolved = launch("true", [], environment: Some(pathEnvironment))
        @Expect(pathResolved.wait(), 0)

        let emptyEnvironmentChild = launch("/bin/sleep", ["5"], environment: Some(emptyEnvironment))
        var emptyEnvironmentWaited = false
        try {
            let emptyEnvironmentInfo = findProcess(emptyEnvironmentChild.pid)
            @Expect(emptyEnvironmentInfo.environment.size, 0)
            let emptyEnvironmentExitCode = emptyEnvironmentChild.wait(timeout: Duration.second * 5)
            emptyEnvironmentWaited = true
            @Expect(emptyEnvironmentExitCode, 0)
        } finally {
            if (!emptyEnvironmentWaited) {
                if (emptyEnvironmentChild.isAlive()) {
                    emptyEnvironmentChild.terminate(force: true)
                }
                emptyEnvironmentChild.wait()
            }
        }
        let legacyChild = Process.start("/bin/sh", ["-c", "exit 4"])
        @Expect(legacyChild.wait(), 4)
    }

    @TestCase
    func testChunkedOutputTimedWaitAndTermination(): Unit {
        let (status, output, error) = executeWithOutput("/usr/bin/head", ["-c", "16384", "/dev/zero"])
        @Expect(status, 0)
        @Expect(output.size, 16384)
        @Expect(output[0] == 0, true)
        @Expect(error.size, 0)

        let timed = launch("/bin/sleep", ["0.02"])
        @Expect(timed.wait(timeout: Duration.second * 5), 0)
        let maximumTimeout = launch("/bin/true", [])
        @Expect(maximumTimeout.wait(timeout: Duration.nanosecond * 0x7FFF_FFFF_FFFF_FFFF), 0)
        let timeoutChild = launch("/bin/sleep", ["5"])
        @ExpectThrows[TimeoutException](timeoutChild.wait(timeout: Duration.nanosecond))
        timeoutChild.terminate(force: true)
        timeoutChild.wait()

        let graceful = launch("/bin/sleep", ["5"])
        var gracefullyWaited = false
        try {
            graceful.terminate()
            let gracefulExitCode = graceful.wait()
            gracefullyWaited = true
            @Expect(gracefulExitCode != 0, true)
        } finally {
            if (!gracefullyWaited) {
                if (graceful.isAlive()) {
                    graceful.terminate(force: true)
                }
                graceful.wait()
            }
        }

        let target = launch("/bin/sleep", ["10"])
        let targetInfo = findProcess(target.pid)
        @Expect(targetInfo.isAlive(), true)
        targetInfo.terminate(force: true)
        @Expect(target.wait(), 9)
        @Expect(targetInfo.isAlive(), false)
        @ExpectThrows[ProcessException](targetInfo.terminate())
    }

    @TestCase
    func testFileAndDiscardRedirections(): Unit {
        let inputPath = path("stdin.txt")
        File.writeTo(inputPath, "from-file".toArray())
        try (input = File(inputPath, Read)) {
            let (status, output, error) = executeWithOutput("/bin/cat", [], stdIn: FromFile(input))
            @Expect(status, 0)
            @Expect(String.fromUtf8(output), "from-file")
            @Expect(error.size, 0)
        }

        let outputPath = path("stdout.txt")
        try (outputFile = File(outputPath, Write)) {
            let redirected = launch(
                "/bin/sh",
                ["-c", "printf redirected"],
                stdOut: FromFile(outputFile),
                stdErr: Discard
            )
            @Expect(redirected.wait(), 0)
        }
        @Expect(String.fromUtf8(File.readFrom(outputPath)), "redirected")
        let unlinkedPath = path("unlinked-redirect.txt")
        File.writeTo(unlinkedPath, "unlinked".toArray())
        try (unlinked = File(unlinkedPath, Read)) {
            remove(unlinkedPath)
            @ExpectThrows[ProcessException](launch("/bin/true", [], stdIn: FromFile(unlinked)))
        }

        let discarded = launch("/bin/sh", ["-c", "printf hidden"], stdOut: Discard, stdErr: Discard)
        @Expect(discarded.wait(), 0)
        @Expect(discarded.stdOutPipe.read(Array<Byte>(1, repeat: 0)), -1)

        let inherited = launch("/bin/sleep", ["0.05"], stdOut: Inherit, stdErr: Inherit)
        @Expect(inherited.stdOutPipe.read(Array<Byte>(1, repeat: 0)), -1)
        @Expect(inherited.wait(timeout: Duration.second * 5), 0)

        let closedFile = File(outputPath, Write)
        closedFile.close()
        @ExpectThrows[ProcessException](launch("/bin/true", [], stdOut: FromFile(closedFile)))
    }

    @TestCase
    func testLaunchAndPidValidationErrors(): Unit {
        @ExpectThrows[IllegalArgumentException](launch("/bin/sh\0", []))
        @ExpectThrows[IllegalArgumentException](launch("/bin/sh", ["\0"]))
        @ExpectThrows[ProcessException](launch("/__cangjie_process_command_does_not_exist__", []))

        let badEnvironment = HashMap<String, String>()
        badEnvironment.add("BAD=KEY", "value")
        @ExpectThrows[IllegalArgumentException](launch("/bin/true", [], environment: Some(badEnvironment)))

        let badEnvironmentName = HashMap<String, String>()
        badEnvironmentName.add("BAD\0KEY", "value")
        @ExpectThrows[IllegalArgumentException](launch("/bin/true", [], environment: Some(badEnvironmentName)))

        let badEnvironmentValue = HashMap<String, String>()
        badEnvironmentValue.add("BAD_VALUE", "bad\0value")
        @ExpectThrows[IllegalArgumentException](launch("/bin/true", [], environment: Some(badEnvironmentValue)))

        let regularFile = path("not-a-directory")
        File.writeTo(regularFile, "x".toArray())
        @ExpectThrows[IllegalArgumentException](launch(
            "/bin/true",
            [],
            workingDirectory: Some(Path(regularFile))
        ))
        @ExpectThrows[IllegalArgumentException](launch(
            "/bin/true",
            [],
            workingDirectory: Some(Path(path("missing-directory")))
        ))

        @ExpectThrows[IllegalArgumentException](findProcess(-1))
        @ExpectThrows[IllegalArgumentException](findProcess(Int64(Int32.Max) + 1))
        @ExpectThrows[ProcessException](findProcess(Int64(Int32.Max)))
        @ExpectThrows[IllegalArgumentException](Process.of(-1))
    }

    @TestCase
    func testCurrentAndChildProcessStreamAccessors(): Unit {
        let current = Process.current
        @ExpectThrows[IllegalArgumentException](current.stdIn.read(Array<Byte>()))
        current.stdOut.write(Array<Byte>())
        current.stdOut.flush()
        current.stdErr.write(Array<Byte>())
        current.stdErr.flush()

        let child = launch(
            "/bin/sh",
            ["-c", "printf pipe-out; printf pipe-err >&2"],
            stdIn: Pipe,
            stdOut: Pipe,
            stdErr: Pipe
        )
        var waited = false
        try {
            child.stdIn.write(Array<Byte>())
            child.stdIn.flush()
            @ExpectThrows[IllegalArgumentException](child.stdOut.read(Array<Byte>()))
            @ExpectThrows[IllegalArgumentException](child.stdErrPipe.read(Array<Byte>()))
            @ExpectThrows[IllegalArgumentException](child.stdErr.read(Array<Byte>()))

            let (status, output, error) = child.waitOutput()
            waited = true
            @Expect(status, 0)
            @Expect(String.fromUtf8(output), "pipe-out")
            @Expect(String.fromUtf8(error), "pipe-err")
            @Expect(child.stdOutPipe.read(Array<Byte>(1, repeat: 0)), -1)
            @Expect(child.stdErrPipe.read(Array<Byte>(1, repeat: 0)), -1)
        } finally {
            if (!waited) {
                if (child.isAlive()) {
                    child.terminate(force: true)
                }
                child.wait()
            }
        }
    }

    @TestCase
    func testLargeProcessMetadataAndExitedProcessErrors(): Unit {
        let longValue = String.fromUtf8(Array<Byte>(5000, repeat: 65))
        let key = "CANGJIE_PROCESS_LONG_ENV"
        let childEnv = HashMap<String, String>()
        childEnv.add("PATH", "/bin:/usr/bin")
        childEnv.add(key, longValue)

        let child = launch(
            "/bin/sh",
            ["-c", "sleep 1; :", "coverage-child", longValue],
            environment: Some(childEnv),
            stdIn: Discard,
            stdOut: Discard,
            stdErr: Discard
        )
        var waited = false
        try {
            let info = findProcess(child.pid)
            @ExpectThrows[ProcessException](child.stdInPipe.write(Array<Byte>(1, repeat: 0)))
            @Expect(info.arguments.size, 4)
            @Expect(info.arguments[3], longValue)
            @Expect(info.environment.get(key), Some(longValue))
            @Expect(child.wait(timeout: Duration.second * 10), 0)
            waited = true
            @ExpectThrows[ProcessException](findProcess(child.pid))
            @ExpectThrows[ProcessException](info.environment)
        } finally {
            if (!waited) {
                if (child.isAlive()) {
                    child.terminate(force: true)
                }
                child.wait()
            }
        }
    }

}

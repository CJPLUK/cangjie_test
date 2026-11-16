/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// (Unix) EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// (Unix) EXEC: %run %run_opt %output %run_utest_opt

import std.fs.*
import std.io.SeekPosition
import std.unittest.*
import std.unittest.testmacro.*

@Test
class FsEdgeCasesTest {
    let baseDir: String = "./cov_tmp_fs_additional"

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
    func testRecursiveDirectorySizeCopyAndRemoval(): Unit {
        let source = path("source")
        let target = path("copy")
        Directory.create("${source}/nested/deeper", recursive: true)
        File.writeTo("${source}/root.txt", "root-data".toArray())
        File.writeTo("${source}/nested/deeper/leaf.txt", "leaf-data".toArray())

        @Expect(FileInfo(source).isDirectory(), true)
        @Expect(FileInfo(source).size > 0, true)
        copy(source, to: target)
        @Expect(FileInfo("${target}/nested/deeper").isDirectory(), true)
        @Expect(String.fromUtf8(File.readFrom("${target}/root.txt")), "root-data")
        @Expect(String.fromUtf8(File.readFrom("${target}/nested/deeper/leaf.txt")), "leaf-data")

        remove(target, recursive: true)
        @Expect(exists(target), false)
        remove(source, recursive: true)
        @Expect(exists(source), false)
    }

    @TestCase
    func testFileInfoAfterRemovalAndRootHiddenError(): Unit {
        let filePath = path("stale-info.txt")
        File.writeTo(filePath, "stale".toArray())
        let staleInfo = FileInfo(filePath)
        @Expect(FileInfo(filePath).isHidden(), false)
        let hiddenPath = path(".hidden-info")
        File.writeTo(hiddenPath, "hidden".toArray())
        @Expect(FileInfo(hiddenPath).isHidden(), true)
        remove(hiddenPath)
        remove(filePath)
        @ExpectThrows[FSException](staleInfo.size)
        @ExpectThrows[FSException](staleInfo.isRegular())
        @ExpectThrows[FSException](staleInfo.creationTime)
        @ExpectThrows[FSException](staleInfo.lastAccessTime)
        @ExpectThrows[FSException](staleInfo.lastModificationTime)
        @ExpectThrows[FSException](staleInfo.isSymbolicLink())
        @ExpectThrows[FSException](staleInfo.isDirectory())
        @ExpectThrows[FSException](staleInfo.isReadOnly())
        @ExpectThrows[FSException](staleInfo.canExecute())
        @ExpectThrows[FSException](staleInfo.canRead())
        @ExpectThrows[FSException](staleInfo.canWrite())
        @ExpectThrows[FSException](staleInfo.setExecutable(true))
        @ExpectThrows[FSException](staleInfo.setReadable(true))
        @ExpectThrows[FSException](staleInfo.setWritable(true))
        @ExpectThrows[FSException](FileInfo("/").isHidden())
        @Expect(FileInfo("/").parentDirectory, None)
    }

    @TestCase
    func testReadAndWriteModeFailures(): Unit {
        let filePath = path("mode-check.txt")
        @Expect(Read == Read, true)
        @Expect(Write == Write, true)
        @Expect(Append == Append, true)
        @Expect(ReadWrite == ReadWrite, true)
        @Expect(Read != Write, true)
        @Expect(Read.toString(), "Read")
        @Expect(Write.toString(), "Write")
        @Expect(Append.toString(), "Append")
        @Expect(ReadWrite.toString(), "ReadWrite")
        File.writeTo(filePath, "mode-data".toArray())
        let originalContent = String.fromUtf8(File.readFrom(filePath))

        try (readOnly = File(filePath, Read)) {
            @ExpectThrows[FSException](readOnly.write("not-writable".toArray()))
            @ExpectThrows[IllegalArgumentException](readOnly.read(Array<Byte>()))
        }
        try (writeOnly = File(filePath, Write)) {
            @ExpectThrows[FSException](writeOnly.read(Array<Byte>(1, repeat: 0)))
        }

        File.writeTo(filePath, originalContent.toArray())
        try (appendOnly = File(filePath, Append)) {
            appendOnly.write(Array<Byte>())
        }
        @Expect(String.fromUtf8(File.readFrom(filePath)), originalContent)

        let closedRead = File(filePath, Read)
        closedRead.close()
        @Expect(closedRead.isClosed(), true)
        @Expect(closedRead.canRead(), false)
        closedRead.close()
        @Expect(closedRead.isClosed(), true)
        @ExpectThrows[FSException](closedRead.read(Array<Byte>(1, repeat: 0)))
        let closedWrite = File(filePath, Write)
        closedWrite.close()
        @Expect(closedWrite.isClosed(), true)
        @Expect(closedWrite.canWrite(), false)
        @ExpectThrows[FSException](closedWrite.write("after-close".toArray()))
    }

    @TestCase
    func testDirectoryCopyWalkAndValidationBoundaries(): Unit {
        let source = path("copy-boundary-source")
        let target = path("copy-boundary-target")
        let childPath = "${source}/child.txt"
        Directory.create(source)
        Directory.create("${source}/nested")
        File.writeTo(childPath, "copy-data".toArray())
        File.writeTo("${source}/nested/nested.txt", "nested-data".toArray())
        let childLink = "${source}/child-link.txt"
        let childTarget = canonicalize(Path(childPath)).toString()
        SymbolicLink.create(childLink, to: childTarget)
        Directory.create(target)
        Directory.create("${target}/nested")

        @ExpectThrows[FSException](copy(Path(source), to: Path(source)))
        @ExpectThrows[FSException](copy(Path(source), to: Path(target)))
        @ExpectThrows[FSException](copy(Path(path("missing-source")), to: Path(path("missing-copy"))))
        copy(Path(source), to: Path(target), overwrite: true)
        @Expect(String.fromUtf8(File.readFrom("${target}/child.txt")), "copy-data")
        @Expect(String.fromUtf8(File.readFrom("${target}/nested/nested.txt")), "nested-data")
        @Expect(FileInfo("${target}/child-link.txt").isSymbolicLink(), true)
        @Expect(SymbolicLink.readFrom("${target}/child-link.txt").toString(), childTarget)
        @ExpectThrows[FSException](copy(Path(source), to: Path("${source}/nested-copy"), overwrite: true))
        let fileCopySource = path("file-copy-failure-source")
        Directory.create(fileCopySource)
        File.writeTo("${fileCopySource}/child.txt", "copy-data".toArray())
        let fileCopyTarget = path("file-copy-failure-target")
        File.writeTo(fileCopyTarget, "target-data".toArray())
        @ExpectThrows[FSException](copy(Path(fileCopySource), to: Path(fileCopyTarget), overwrite: true))

        let visited = Box<Int64>(0)
        Directory.walk(Path(source)) {
            info =>
                visited.value++
                @Expect(info.isRegular() || info.isDirectory() || info.isSymbolicLink(), true)
                false
        }
        @Expect(visited.value, 1)
        @ExpectThrows[FSException](Directory.isEmpty(Path(childPath)))
        @ExpectThrows[FSException](Directory.walk(Path(childPath)) { _ => true })
    }

    @TestCase
    func testDirectoryStateAndFailurePaths(): Unit {
        let emptyDirectory = path("empty-check")
        Directory.create(emptyDirectory)
        @Expect(Directory.isEmpty(emptyDirectory), true)

        let child = "${emptyDirectory}/child.txt"
        File.writeTo(child, "child".toArray())
        @Expect(Directory.isEmpty(emptyDirectory), false)
        @ExpectThrows[FSException](remove(emptyDirectory))
        @Expect(exists(child), true)

        let regularParent = path("regular-parent")
        File.writeTo(regularParent, "x".toArray())
        @ExpectThrows[FSException](Directory.create("${regularParent}/child", recursive: true))
        @ExpectThrows[IllegalArgumentException](Directory.create(""))

        let seekPath = path("seek-boundary.txt")
        File.writeTo(seekPath, "seek-data".toArray())
        try (seekFile = File(seekPath, ReadWrite)) {
            @ExpectThrows[FSException](seekFile.seek(Begin(-1)))
        }

        @ExpectThrows[FSException](canonicalize(Path(path("missing-canonicalize"))))
        @ExpectThrows[FSException](rename(path("missing-rename-source"), to: path("missing-rename-target")))
    }

    @TestCase
    func testHardAndSymbolicLinkOperationsAndFailures(): Unit {
        let target = path("link-target.txt")
        let hardLink = path("hard-link.txt")
        let symbolicLink = path("symbolic-link.txt")
        File.writeTo(target, "link-data".toArray())
        @Expect(FileInfo(target) == FileInfo(target), true)
        let normalizedTarget = Path("${baseDir}/./link-target.txt")
        @Expect(normalizedTarget == Path(target), true)
        @Expect(normalizedTarget.hashCode(), Path(target).hashCode())

        HardLink.create(Path(hardLink), to: Path(target))
        @Expect(String.fromUtf8(File.readFrom(hardLink)), "link-data")
        @ExpectThrows[FSException](HardLink.create(hardLink, to: target))

        let symbolicTarget = canonicalize(Path(target)).toString()
        SymbolicLink.create(symbolicLink, to: symbolicTarget)
        @Expect(FileInfo(symbolicLink).isSymbolicLink(), true)
        @Expect(SymbolicLink.readFrom(symbolicLink).toString(), symbolicTarget)
        let copiedSymbolicLink = path("symbolic-link-copy.txt")
        copy(symbolicLink, to: copiedSymbolicLink)
        @Expect(SymbolicLink.readFrom(copiedSymbolicLink).toString(), symbolicTarget)
        @Expect(String.fromUtf8(File.readFrom(copiedSymbolicLink)), "link-data")
        @ExpectThrows[FSException](copy(symbolicLink, to: copiedSymbolicLink))
        copy(symbolicLink, to: copiedSymbolicLink, overwrite: true)
        @Expect(FileInfo(copiedSymbolicLink).isSymbolicLink(), true)
        @ExpectThrows[FSException](SymbolicLink.create(Path(symbolicLink), to: Path(target)))
        @ExpectThrows[IllegalArgumentException](SymbolicLink.readFrom(Path(target)))
    }

}

// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package fs

foreign {
    // Path
    func CJ_FS_NormalizePath(path: CPointer<Byte>, pathLen: Int64,
        realPath: CPointer<UInt8>): Int64 // (<= 0): error, (> 0): real path size

    // FileInfo
    func CJ_FS_PathSize(path: CPointer<Byte>, pathLen: Int64): Int64 // -1: failed, (>= 0): file size

    func CJ_FS_GetCreationTime(path: CPointer<Byte>, pathLen: Int64): Int64 // -1: failed, (>= 0): time data

    func CJ_FS_GetLastAccessTime(path: CPointer<Byte>, pathLen: Int64): Int64 // -1: failed, (>= 0): time data

    func CJ_FS_GetLastModificationTime(path: CPointer<Byte>, pathLen: Int64): Int64 // -1: failed, (>= 0): time data

    func CJ_FS_GetSymbolicLinkTarget(path: CPointer<Byte>, pathLen: Int64, buf: CPointer<UInt8>,
        bufSize: Int64): Int64 // -1: failed, (>= 0): the size of buf be read

    func CJ_FS_GetLinkFileSize(path: CPointer<Byte>, pathLen: Int64): Int64 // -1: failed, (>= 0): link file size

    func CJ_FS_IsReadOnly(path: CPointer<Byte>, pathLen: Int64): Int8 // -1: error, 0: false, 1: true

    func CJ_FS_CanRead(path: CPointer<Byte>, pathLen: Int64): Int8 // -1: error, 0: false, 1: true

    func CJ_FS_CanWrite(path: CPointer<Byte>, pathLen: Int64): Int8 // -1: error, 0: false, 1: true

    func CJ_FS_CanExecute(path: CPointer<Byte>, pathLen: Int64): Int8 // -1: error, 0: false, 1: true

    func CJ_FS_SetExecutable(path: CPointer<Byte>, pathLen: Int64,
        executable: Bool): Int8 // -2: Operation not permitted, -1: Other Errors, 0: false, 1: true

    func CJ_FS_SetReadable(path: CPointer<Byte>, pathLen: Int64,
        readable: Bool): Int8 // -2: Operation not permitted, -1: Other Errors, 0: false, 1: true

    func CJ_FS_SetWritable(path: CPointer<Byte>, pathLen: Int64,
        writable: Bool): Int8 // -2: Operation not permitted, -1: Other Errors, 0: false, 1: true

    // Directory
    func CJ_FS_DirGetNumber(path: CPointer<Byte>, pathLen: Int64): Int64 // -1: failed, (>= 0): file number in dir

    func CJ_FS_ISDirEmpty(path: CPointer<Byte>, pathLen: Int64): Int8 // -1: error, 0: false, 1: true

    func CJ_FS_DirGetData(path: CPointer<Byte>, pathLen: Int64, buffer: CPointer<Byte>,
        bufferLen: Int64): Int64 // -1: failed, (>= 0): data length of buffer

    func CJ_FS_DirCreate(path: CPointer<Byte>, pathLen: Int64): Bool // false: Failed, true: Success

    func CJ_FS_DirCreateRecursive(path: CPointer<Byte>, pathLen: Int64): Bool // false: Failed, true: Success

    func CJ_FS_DirDeleteRecursive(path: CPointer<Byte>, pathLen: Int64): Bool // false: Failed, true: Success

    func CJ_FS_CreateTempDir(path: CPointer<Byte>): Bool // false: Failed, true: Success

    func CJ_FS_CopyREF(srcPath: CString, srcPathLen: Int64, destPath: CString,
        destPathLen: Int64): Int8 // -1: failed, 0: success

    func CJ_FS_CopyLink(srcPath: CString, srcPathLen: Int64, destPath: CString,
        destPathLen: Int64): Int8 // -1: failed, 0: success

    // File
    func CJ_FS_OpenFile(path: CPointer<Byte>, pathLen: Int64,
        oflag: Int32): FileHandle // -1: failed, (>= 0): fileHandle

    func CJ_FS_Seek(fd: FileHandle, whence: Int32,
        offset: Int64): Int64 // -1: failed, (>= 0): distance from the start position

    func CJ_FS_CloseFile(fd: FileHandle): Int64 // -1: failed, (>= 0): success

    func CJ_FS_GetFileSize(fd: FileHandle): Int64 // -1: failed, (>= 0): file size

    func CJ_FS_FileRead(fd: FileHandle, buffer: CPointer<Byte>,
        maxLen: UIntNative): Int64 // -1: failed, 0: end, (>0): the size of buffer be read

    func CJ_FS_FileWrite(fd: FileHandle, buffer: CPointer<Byte>,
        maxLen: UIntNative): Bool // -1: failed, (>=0): the size of buffer be written

    func CJ_FS_CreateTempFile(path: CPointer<Byte>): FileHandle // false: Failed, true: Success

    // Util
    func CJ_FS_IsLink(path: CPointer<Byte>, pathLen: Int64): Int8 // -1: error, 0: false, 1: true

    func CJ_FS_IsFile(path: CPointer<Byte>, pathLen: Int64): Int8 // -1: error, 0: false, 1: true

    func CJ_FS_IsDir(path: CPointer<Byte>, pathLen: Int64): Int8 // -1: error, 0: false, 1: true

    func CJ_FS_IsFileORLinkToFile(path: CPointer<Byte>, pathLen: Int64): Int8 // -1: error, 0: false, 1: true

    func CJ_FS_IsDirORLinkToFDir(path: CPointer<Byte>, pathLen: Int64): Int8 // -1: error, 0: false, 1: true

    func CJ_FS_Exists(path: CPointer<Byte>, pathLen: Int64): Int8 // -1: error, 0: false, 1: true

    func CJ_FS_Remove(path: CPointer<Byte>, pathLen: Int64): Bool // false: Failed, true: Success

    func CJ_FS_Rmdir(path: CPointer<Byte>, pathLen: Int64): Bool // false: Failed, true: Success

    func CJ_FS_MoveTo(sourcePath: CPointer<Byte>, sourceLen: Int64, destinationPath: CPointer<Byte>,
        destinationLen: Int64): Bool // false: Failed, true: Success

    func CJ_FS_ErrnoGet(): Int32 // get errno

    func CJ_FS_ErrmesGet(errnoValue: Int32): CString // get message for the current errno

}

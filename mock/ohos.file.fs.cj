/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ohos.file.fs

import ohos.labels.APILevel
import ohos.business_exception.BusinessException
import ohos.ffi.*
import ohos.hilog.HilogChannel

let FS_LOG = HilogChannel(0, FILEIO_DOMAIN_ID, "CJ-fs")

@C
struct CFilter {
    CFilter(
        var suffix: CArrString,
        var displayName: CArrString,
        var mimeType: CArrString,
        var fileSizeOver: Int64,
        var lastModifiedAfter: Float64,
        var excludeMedia: Bool
    ) {}

    func free(): Unit {
        unsafe {
            freeArrCString(suffix)
            freeArrCString(displayName)
            freeArrCString(mimeType)
        }
    }
}

@C
struct CConflictFiles {
    CConflictFiles(
        let srcFile: CString,
        let destFile: CString
    ) {}
}

@C
struct RetDataCArrConflictFiles {
    RetDataCArrConflictFiles(
        let code: Int32,
        let data: CArrConflictFiles
    ) {}
}

@C
struct RetDataCArrStringN {
    RetDataCArrStringN(
        let code: Int32,
        let data: CArrString
    ) {}
}

@C
struct CArrConflictFiles {
    CArrConflictFiles(
        let head: CPointer<CConflictFiles>,
        let size: Int64
    ) {}
}

@C
struct CListFileOptions {
    CListFileOptions(
        let recursion: Bool,
        let listNum: Int32,
        let filter: CFilter
    ) {}
}

@C
struct RetReaderIteratorResult {
    private RetReaderIteratorResult(
        let code: Int32,
        let done: Bool,
        let value: CString
    ) {}
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class RandomAccessFileOptions {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var start: Option<Int64>

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var end: Option<Int64>

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public init(
        start!: Option<Int64> = None,
        end!: Option<Int64> = None
    ) {
        super()
        this.start = None
        this.end = None
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class OpenMode {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public static const READ_ONLY: Int64 = 0o0

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public static const WRITE_ONLY: Int64 = 0o1

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public static const READ_WRITE: Int64 = 0o2

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public static const CREATE: Int64 = 0o100

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public static const TRUNC: Int64 = 0o1000

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public static const APPEND: Int64 = 0o2000

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public static const NONBLOCK: Int64 = 0o4000

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public static const DIR: Int64 = 0o200000

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public static const NOFOLLOW: Int64 = 0o400000

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public static const SYNC: Int64 = 0o4010000
    
    public init() {
        super()
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public open class Options {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var encoding: String

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public init(encoding!: String = "utf-8") {
        super()
        this.encoding = String()
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class ReaderIterator {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true]
    public func next(): ReaderIteratorResult {
        return ReaderIteratorResult()
    }
    
    public init() {
        super()
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class ReaderIteratorResult {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var done: Bool

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var value: String
    
    public init() {
        super()
        this.done = true
        this.value = String()
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class WriteOptions <: Options {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var length: Option<UIntNative>

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var offset: Option<Int64>

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public init(
        length!: Option<UIntNative> = None,
        offset!: Option<Int64> = None,
        encoding!: String = "utf-8"
    ) {
        super(encoding: String())
        this.length = None
        this.offset = None
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public open class ReadOptions {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var offset: Option<Int64>

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var length: Option<UIntNative>

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public init(
        offset!: Option<Int64> = None,
        length!: Option<UIntNative> = None
    ) {
        super()
        this.offset = None
        this.length = None
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class ReadTextOptions <: ReadOptions {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var encoding: String

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public init(
        offset!: Option<Int64> = None,
        length!: Option<UIntNative> = None,
        encoding!: String = "utf-8"
    ) {
        super(
            offset: None,
            length: None
        )
        this.encoding = String()
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public enum AccessModeType {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    Exist
    | @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    Write
    | @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    Read
    | @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    ReadWrite
    | ...
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public enum AccessFlagType {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    Local | ...
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public enum WhenceType {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    SeekSet
    | @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    SeekCur
    | @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    SeekEnd
    | ...
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class ConflictFiles {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var srcFile: String

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var destFile: String
    
    public init() {
        super()
        this.srcFile = String()
        this.destFile = String()
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class Filter {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var suffix: Array<String>

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var displayName: Array<String>

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var mimeType: Array<String>

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var fileSizeOver: ?Int64

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var lastModifiedAfter: ?Float64

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var excludeMedia: Bool

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true]
    public init(
        suffix!: Array<String> = Array<String>(),
        displayName!: Array<String> = Array<String>(),
        mimeType!: Array<String> = Array<String>(),
        fileSizeOver!: ?Int64 = None,
        lastModifiedAfter!: ?Float64 = None,
        excludeMedia!: Bool = false
    ) {
        super()
        this.suffix = Array()
        this.displayName = Array()
        this.mimeType = Array()
        this.fileSizeOver = None
        this.lastModifiedAfter = None
        this.excludeMedia = true
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class ListFileOptions {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var recursion: Bool

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var listNum: Int32

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public var filter: Filter

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public init(
        recursion!: Bool = false,
        listNum!: Int32 = 0,
        filter!: Filter = Filter()
    ) {
        super()
        this.recursion = true
        this.listNum = 0
        this.filter = Filter(
            suffix: Array(),
            displayName: Array(),
            mimeType: Array(),
            fileSizeOver: None,
            lastModifiedAfter: None,
            excludeMedia: true
        )
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class FileIo {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func access(path: String, mode!: AccessModeType = AccessModeType.Exist,
        flag!: AccessFlagType = AccessFlagType.Local): Bool {
        return true
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func close(file: Int32): Unit {
        let code = unsafe { FfiOHOSFileFsCloseByFd(file) }
        if (code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(code))
            throw BusinessException(code, getErrorInfo(code))
        }
        return
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func close(file: File): Unit {
        try {
            let code = unsafe { FfiOHOSFileFsClose(file.getID()) }
            if (code != SUCCESS_CODE) {
                // The ffi interface returns an incorrect error code, which is temporarily avoided.
                if (code == -1) {
                    FS_LOG.error(getErrorInfo(FILEIO_INVALID_ARGUMENT))
                    throw BusinessException(FILEIO_INVALID_ARGUMENT, getErrorInfo(FILEIO_INVALID_ARGUMENT))
                }
                FS_LOG.error(getErrorInfo(code))
                throw BusinessException(code, getErrorInfo(code))
            }
        } catch (e: NoneValueException) {
            FS_LOG.error(getErrorInfo(FILEIO_INVALID_ARGUMENT))
            throw BusinessException(FILEIO_INVALID_ARGUMENT, getErrorInfo(FILEIO_INVALID_ARGUMENT))
        }
        return
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func copyDir(src: String, dest: String, mode!: Int32 = 0): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func copyFile(src: String, dest: String, mode!: Int32 = 0): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func copyFile(src: String, dest: Int32, mode!: Int32 = 0): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func copyFile(src: Int32, dest: String, mode!: Int32 = 0): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func copyFile(src: Int32, dest: Int32, mode!: Int32 = 0): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func createStream(path: String, mode: String): Stream {
        return Stream()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func createRandomAccessFile(file: String, mode!: Int64 = OpenMode.READ_ONLY,
        options!: RandomAccessFileOptions = RandomAccessFileOptions()): RandomAccessFile {
        return RandomAccessFile()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func createRandomAccessFile(file: File, mode!: Int64 = OpenMode.READ_ONLY,
        options!: RandomAccessFileOptions = RandomAccessFileOptions()): RandomAccessFile {
        return RandomAccessFile()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true]
    public static func dup(fd: Int32): File {
        return File()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func fdatasync(fd: Int32): Unit {
        let ret: Int32
        unsafe {
            ret = FfiOHOSFileFsFdatasync(fd)
        }
        if (ret != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(ret))
            throw BusinessException(ret, getErrorInfo(ret))
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func fdopenStream(fd: Int32, mode: String): Stream {
        return Stream()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func fsync(fd: Int32): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func listFile(path: String, options!: ListFileOptions = ListFileOptions()): Array<String> {
        return Array()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true]
    public static func lseek(fd: Int32, offset: Int64, whence!: WhenceType = SeekSet): Int64 {
        return 0
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func lstat(path: String): Stat {
        return Stat()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func mkdir(path: String): Unit {
        let pathString = unsafe { LibC.mallocCString(path) }
        let code = unsafe { FfiOHOSFileFsMkdir(pathString, false, false) }
        unsafe { LibC.free(pathString) }
        if (code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(code))
            throw BusinessException(code, getErrorInfo(code))
        }
        return
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func mkdir(path: String, recursion: Bool): Unit {
        let pathString = unsafe { LibC.mallocCString(path) }
        let code = unsafe { FfiOHOSFileFsMkdir(pathString, recursion, true) }
        unsafe { LibC.free(pathString) }
        if (code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(code))
            throw BusinessException(code, getErrorInfo(code))
        }
        return
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func mkdtemp(prefix: String): String {
        let cValue: RetDataCString
        unsafe {
            let cStringPrefix = LibC.mallocCString(prefix)
            cValue = FfiOHOSFileFsMkdtemp(cStringPrefix)
            LibC.free(cStringPrefix)
        }
        if (cValue.code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(cValue.code))
            throw BusinessException(cValue.code, getErrorInfo(cValue.code))
        }
        let ret = cValue.data.toString()
        unsafe { FfiOHOSFileFsReleaseCString(cValue.data) }
        return ret
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func moveDir(src: String, dest: String, mode!: Int32 = 0): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func moveFile(src: String, dest: String, mode!: Int32 = 0): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func open(path: String, mode!: Int64 = OpenMode.READ_ONLY): File {
        let pathCString = unsafe { LibC.mallocCString(path) }
        let cValue = unsafe { FfiOHOSFileFsOpen(pathCString, mode) }
        unsafe {
            LibC.free(pathCString)
        }
        if (cValue.code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(cValue.code))
            throw BusinessException(cValue.code, getErrorInfo(cValue.code))
        }
        return File(cValue.data)
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func read(fd: Int32, buffer: Array<Byte>, options!: ReadOptions = ReadOptions()): Int64 {
        if (buffer.size == 0) {
            return 0
        }
        let cBuffer = safeMalloc<Byte>(count: buffer.size)
        let cValue = if (options.offset.isNone()) {
            unsafe { FfiOHOSFileFsReadCur(fd, cBuffer, buffer.size, options.length ?? UIntNative(buffer.size)) }
        } else {
            unsafe {
                FfiOHOSFileFsRead(fd, cBuffer, buffer.size, options.length ?? UIntNative(buffer.size),
                    options.offset ?? 0)
            }
        }
        for (index in 0..cValue.data) {
            let ch = unsafe { cBuffer.read(index) }
            buffer[index] = ch
        }
        unsafe { LibC.free(cBuffer) }
        if (cValue.code == SUCCESS_CODE) {
            return cValue.data
        } else {
            FS_LOG.error(getErrorInfo(cValue.code))
            throw BusinessException(cValue.code, getErrorInfo(cValue.code))
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func readLines(filePath: String, options!: Options = Options()): ReaderIterator {
        return ReaderIterator()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func readText(filePath: String, options!: ReadTextOptions = ReadTextOptions()): String {
        return String()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func rename(oldPath: String, newPath: String): Unit {
        unsafe {
            try (
                oldString = LibC.mallocCString(oldPath).asResource(),
                newString = LibC.mallocCString(newPath).asResource()
            ) {
                let code = FfiOHOSFileFsRename(oldString.value, newString.value)
                if (code != SUCCESS_CODE) {
                    FS_LOG.error(getErrorInfo(code))
                    throw BusinessException(code, getErrorInfo(code))
                }
            }
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func rmdir(path: String): Unit {
        let pathString = unsafe { LibC.mallocCString(path) }
        let code = unsafe { FfiOHOSFileFsRmdir(pathString) }
        unsafe { LibC.free(pathString) }
        if (code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(code))
            throw BusinessException(code, getErrorInfo(code))
        }
        return
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func stat(file: String): Stat {
        let cString = unsafe { LibC.mallocCString(file) }
        let cValue = unsafe { FfiOHOSFileFsStatByString(cString) }
        unsafe { LibC.free(cString) }
        if (cValue.code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(cValue.code))
            throw BusinessException(cValue.code, getErrorInfo(cValue.code))
        }
        return Stat(cValue.data)
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func stat(file: Int32): Stat {
        let cValue = unsafe { FfiOHOSFileFsStatByID(file) }
        match {
            case cValue.code == SUCCESS_CODE =>
                let id = cValue.data
                return Stat(id)
            case _ =>
                FS_LOG.error(getErrorInfo(cValue.code))
                throw BusinessException(cValue.code, getErrorInfo(cValue.code))
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func truncate(file: String, len!: Int64 = 0): Unit {
        let code: Int32
        unsafe {
            let cString = LibC.mallocCString(file)
            code = FfiOHOSFileFsTruncateByString(cString, len)
            LibC.free(cString)
        }
        if (code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(code))
            throw BusinessException(code, getErrorInfo(code))
        }
        return
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func truncate(file: Int32, len!: Int64 = 0): Unit {
        let code = unsafe { FfiOHOSFileFsTruncateByFd(file, len) }
        if (code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(code))
            throw BusinessException(code, getErrorInfo(code))
        }
        return
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func unlink(path: String): Unit {
        let str = unsafe { LibC.mallocCString(path) }
        let code = unsafe { FfiOHOSFileFsUnlink(str) }
        unsafe { LibC.free(str) }
        if (code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(code))
            throw BusinessException(code, getErrorInfo(code))
        }
        return
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true]
    public static func utimes(path: String, mtime: Float64): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func write(fd: Int32, buffer: Array<Byte>, options!: WriteOptions = WriteOptions()): Int64 {
        var writeBytes = 0
        let len = options.length ?? UIntNative(buffer.size)
        if (len > UIntNative(buffer.size)) {
            throw BusinessException(INVALID_ARGS_CODE, "Invalid argument")
        }
        unsafe {
            try (encodingCString = LibC.mallocCString(options.encoding).asResource()) {
                let data = acquireArrayRawData(buffer)
                let cValue = if (options.offset.isNone()) {
                    FfiOHOSFileFsWriteCur(fd, data.pointer, len, encodingCString.value)
                } else {
                    FfiOHOSFileFsWrite(fd, data.pointer, len, options.offset ?? 0, encodingCString.value)
                }
                releaseArrayRawData(data)
                if (cValue.code == SUCCESS_CODE) {
                    writeBytes = cValue.data
                } else {
                    FS_LOG.error(getErrorInfo(cValue.code))
                    throw BusinessException(cValue.code, getErrorInfo(cValue.code))
                }
            }
        }
        return writeBytes
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public static func write(fd: Int32, buffer: String, options!: WriteOptions = WriteOptions()): Int64 {
        var writeBytes = 0
        let len = options.length ?? UIntNative(buffer.size)
        if (len > UIntNative(buffer.size)) {
            throw BusinessException(INVALID_ARGS_CODE, "Invalid argument")
        }
        unsafe {
            try (
                cBuffer = LibC.mallocCString(buffer).asResource(),
                encodingCString = LibC.mallocCString(options.encoding).asResource()
            ) {
                let cValue = if (options.offset.isNone()) {
                    FfiOHOSFileFsWriteCur(fd, cBuffer.value.getChars(), len, encodingCString.value)
                } else {
                    FfiOHOSFileFsWrite(fd, cBuffer.value.getChars(), len, options.offset ?? 0, encodingCString.value)
                }
                if (cValue.code == SUCCESS_CODE) {
                    writeBytes = cValue.data
                } else {
                    FS_LOG.error(getErrorInfo(cValue.code))
                    throw BusinessException(cValue.code, getErrorInfo(cValue.code))
                }
            }
        }
        return writeBytes
    }
    
    public init() {
        super()
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class File <: RemoteDataLite {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public prop fd: Int32 {
        get() {
            unsafe { FfiOHOSFILEFsGetFD(getID()) }
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public prop path: String {
        
        get() {
            return String()
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public prop name: String {
        
        get() {
            return String()
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true]
    public func getParent(): String {
        return String()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true]
    public func unlock(): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true]
    public func tryLock(exclusive!: Bool = false): Unit {
        return ()
    }
    
    init(instanceId: Int64) {
        super(instanceId)
    }

    init() {
        super(0)
    }
    
    ~init() {
        releaseFFIData(myDataId)
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class RandomAccessFile {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public prop fd: Int32 {
        
        get() {
            return 0
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public prop filePointer: Int64 {
        
        get() {
            return 0
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public func setFilePointer(filePointer: Int64): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", workerthread: true]
    public func close(): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public func write(buffer: String, options!: WriteOptions = WriteOptions()): Int64 {
        return 0
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public func write(buffer: Array<Byte>, options!: WriteOptions = WriteOptions()): Int64 {
        return 0
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public func read(buffer: Array<Byte>, options!: ReadOptions = ReadOptions()): Int64 {
        return 0
    }
    
    public init() {
        super()
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class Stat <: RemoteDataLite {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public prop ino: Int64 {
        get() {
            unsafe { Int64(FfiOHOSStatGetIno(getID())) }
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public prop mode: Int64 {
        get() {
            unsafe { Int64(FfiOHOSStatGetMode(getID())) }
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public prop uid: Int64 {
        get() {
            unsafe { Int64(FfiOHOSStatGetUid(getID())) }
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public prop gid: Int64 {
        get() {
            unsafe { Int64(FfiOHOSStatGetGid(getID())) }
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public prop size: Int64 {
        get() {
            unsafe { Int64(FfiOHOSStatGetSize(getID())) }
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public prop atime: Int64 {
        get() {
            unsafe { Int64(FfiOHOSStatGetAtime(getID())) }
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public prop mtime: Int64 {
        get() {
            unsafe { Int64(FfiOHOSStatGetMtime(getID())) }
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public prop ctime: Int64 {
        get() {
            unsafe { Int64(FfiOHOSStatGetCtime(getID())) }
        }
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public func isBlockDevice(): Bool {
        let ret = unsafe { FfiOHOSStatIsBlockDeviceV2(getID()) }
        if (ret.code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(ret.code))
            return false
        }
        return ret.data
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public func isCharacterDevice(): Bool {
        let ret = unsafe { FfiOHOSStatIsCharacterDeviceV2(getID()) }
        if (ret.code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(ret.code))
            return false
        }
        return ret.data
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public func isDirectory(): Bool {
        let ret = unsafe { FfiOHOSStatIsDirectoryV2(getID()) }
        if (ret.code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(ret.code))
            return false
        }
        return ret.data
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public func isFifo(): Bool {
        let ret = unsafe { FfiOHOSStatIsFIFOV2(getID()) }
        if (ret.code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(ret.code))
            return false
        }
        return ret.data
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public func isFile(): Bool {
        let ret = unsafe { FfiOHOSStatIsFileV2(getID()) }
        if (ret.code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(ret.code))
            return false
        }
        return ret.data
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public func isSocket(): Bool {
        let ret = unsafe { FfiOHOSStatIsSocketV2(getID()) }
        if (ret.code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(ret.code))
            return false
        }
        return ret.data
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
    public func isSymbolicLink(): Bool {
        let ret = unsafe { FfiOHOSStatIsSymbolicLinkV2(getID()) }
        if (ret.code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(ret.code))
            return false
        }
        return ret.data
    }
    
    public init() {
        super()
    }

    init(instanceId: Int64) {
        super(instanceId)
    }

    ~init() {
        releaseFFIData(myDataId)
    }
}

@!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO"]
public class Stream {
    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public func close(): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public func flush(): Unit {
        return ()
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public func write(buffer: String, options!: WriteOptions = WriteOptions()): Int64 {
        return 0
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public func write(buffer: Array<Byte>, options!: WriteOptions = WriteOptions()): Int64 {
        return 0
    }

    @!APILevel[since: "22", syscap: "SystemCapability.FileManagement.File.FileIO", throwexception: true, workerthread: true]
    public func read(buffer: Array<Byte>, options!: ReadOptions = ReadOptions()): Int64 {
        return 0
    }
    
    public init() {
        super()
    }
}
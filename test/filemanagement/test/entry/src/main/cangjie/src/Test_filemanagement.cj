/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

/**
 * Created on 2024/1/29
 */
package ohos_app_cangjie_entry

internal import ohos.base.*
internal import BasicServicesKit.SystemDateTime
internal import std.sync.*
internal import std.time.*
import std.unittest.testmacro.*
import CoreFileKit.*
import std.runtime.GC
import std.unittest.testmacro.*
import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import ohos.hilog.Hilog
import ohos.business_exception.BusinessException

@Test
class Test_filemanagement {
    @BeforeAll
    public func waitForDirCreation(): Unit {
        sleepFor(5.second)
    }

    override func afterAll(): Unit {
        GC()
        sleep(Duration.second * 2)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_stat() {
        let dirPath = "/data/storage/el2/base/haps/entry/files"
        @Assert(FileIo.access(dirPath))
        let dirStat = FileIo.stat(dirPath)
        @Expect(dirStat.mode, 504)
        @Expect(dirStat.isBlockDevice(), false)
        @Expect(dirStat.isCharacterDevice(), false)
        @Expect(dirStat.isDirectory(), true)
        @Expect(dirStat.isFIFO(), false)
        @Expect(dirStat.isFile(), false)
        @Expect(dirStat.isSocket(), false)
        @Expect(dirStat.isSymbolicLink(), false)
        // for coverage
        let ino = dirStat.ino
        let uid = dirStat.uid
        let gid = dirStat.gid
        let filePath = "/data/storage/el2/base/haps/entry/files/test_times.txt"
        let res = FileIo.access(filePath)
        if (res) {
            FileIo.unlink(filePath)
        }

        let file = FileIo.open(
            filePath,
            mode: (OpenMode.READ_WRITE | OpenMode.CREATE)
        )
        let fileStat0 = FileIo.stat(file.fd)
        let timeStampBeforeSleep = SystemDateTime.getTime(isNanoseconds: false) / 1000
        Hilog.info(0, "Test_filemanagement",
            "before: timestamp = ${timeStampBeforeSleep} \n atime = ${fileStat0.atime} \n mtime = ${fileStat0.mtime} \n ctime = ${fileStat0.ctime}"
        )
        @Expect(timeStampBeforeSleep, fileStat0.atime)
        @Expect(timeStampBeforeSleep, fileStat0.mtime)
        @Expect(timeStampBeforeSleep, fileStat0.ctime)
        sleep(Duration.second * 10)
        FileIo.write(file.fd, "my content")

        let timeStampAfterSleep = SystemDateTime.getTime(isNanoseconds: false) / 1000
        let fileStat1 = FileIo.stat(file.fd)
        Hilog.info(0, "Test_filemanagement", 
            "before: timestamp = ${timeStampAfterSleep} \n atime = ${fileStat1.atime} \n mtime = ${fileStat1.mtime} \n ctime = ${fileStat1.ctime}"
        )

        @Expect(timeStampBeforeSleep, fileStat1.atime)
        @Expect(timeStampAfterSleep, fileStat1.mtime)
        @Expect(timeStampAfterSleep, fileStat1.ctime)
        FileIo.close(file.fd)

        try {
            let exceptionStat = FileIo.stat("")
        } catch (_: Exception) {
        }
        try {
            let exceptionStat = FileIo.stat(-1)
        } catch (_: Exception) {
        }
        try {
            FileIo.close(-1)
            @Expect(false)
        } catch (_: Exception) {
            Hilog.error(0, "Test_filemanagement", "Invalide fd.")
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_lstat() {
        let dirPath = "/data/storage/el2/base/haps/entry/files"
        let dirStat = FileIo.lstat(dirPath)
        @Expect(dirStat.mode, 504)
        @Expect(dirStat.isBlockDevice(), false)
        @Expect(dirStat.isCharacterDevice(), false)
        @Expect(dirStat.isDirectory(), true)
        @Expect(dirStat.isFIFO(), false)
        @Expect(dirStat.isFile(), false)
        @Expect(dirStat.isSocket(), false)
        @Expect(dirStat.isSymbolicLink(), false)

        try {
            let exceptionStat = FileIo.lstat("")
        } catch (_: Exception) {
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_access() {
        let filePath = "/data/storage/el2/base/test_access.txt"
        try {
            FileIo.unlink(filePath)
        } catch (_) {
        }
        try {
            FileIo.unlink("")
        } catch (_: Exception) {
        }

        let status1 = FileIo.access(filePath)
        @Expect(!status1)
        let file = FileIo.open(
            filePath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        let status2 = FileIo.access(filePath)
        @Expect(status2)
        try {
            let exceptionRes = FileIo.access("1212")
        } catch (_: Exception) {
        }
        let status3 = FileIo.access(filePath, mode: AccessModeType.ReadWrite)
        @Expect(status3)
        let status4 = FileIo.access(filePath, mode: AccessModeType.Write, flag: AccessFlagType.Local)
        @Expect(status4)
        let status5 = FileIo.access(filePath, mode: AccessModeType.Exist)
        let status6 = FileIo.access(filePath, mode: AccessModeType.Read)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_open() {
        let filePath = "/data/storage/el2/base/test_access.txt"
        try {
            FileIo.unlink(filePath)
        } catch (_) {
        }
        let status1 = FileIo.access(filePath)
        @Expect(!status1)
        let file = FileIo.open(
            filePath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        let status2 = FileIo.access(filePath)
        @Expect(status2)
        try {
            let file1 = FileIo.open(
                "123",
                mode: OpenMode.READ_WRITE
            )
        } catch (_: Exception) {
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_copyFile() {
        try {
            FileIo.copyFile("", "")
        } catch (_: Exception) {
        }
        try {
            FileIo.copyFile(-1, "")
        } catch (_: Exception) {
        }
        try {
            FileIo.copyFile("", -1)
        } catch (_: Exception) {
        }
        try {
            FileIo.copyFile(-1, -1)
        } catch (_: Exception) {
        }

        let src = "/data/storage/el2/base/haps/entry/files/test_copyFile"
        let dest = src + "tgt"
        if (FileIo.access(src)) {
            FileIo.unlink(src)
        }
        let file = FileIo.open(
            src,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        if (FileIo.access(dest)) {
            FileIo.unlink(dest)
        }

        FileIo.copyFile(src, dest)
        let size1 = FileIo
            .stat(src)
            .size
        let size2 = FileIo
            .stat(dest)
            .size
        @Expect(size1, size2)

        FileIo.close(file)
        FileIo.unlink(src)
        FileIo.unlink(dest)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_copyDir_01() {
        // exception branch
        try {
            FileIo.copyDir("", "", mode: 1)
        } catch (e: Exception) {
        }

        let dpath = "/data/storage/el2/base/haps/entry/files/test_copyDir_01"
        let ddpath = dpath + "/srcDir_first"
        let ffpath = ddpath + "/srcFile_first_01"
        let ffpath2 = ddpath + "/srcFile_first_02"
        let dddpath = ddpath + "/srcDir_second"
        let fffpath = dddpath + "/srcFile_second_01"
        let ddpath2 = dpath + "/destDir_first"
        let ffpath3 = ddpath2 + "/destFile_first_01"
        if (FileIo.access(dpath)) {
            FileIo.rmdir(dpath)
        }
        if (FileIo.access(ddpath)) {
            FileIo.rmdir(ddpath)
        }
        if (FileIo.access(ddpath2)) {
            FileIo.rmdir(ddpath2)
        }
        if (FileIo.access(dddpath)) {
            FileIo.rmdir(dddpath)
        }
        FileIo.mkdir(dpath)
        FileIo.mkdir(ddpath)
        FileIo.mkdir(ddpath2)
        FileIo.mkdir(dddpath)
        if (FileIo.access(ffpath)) {
            FileIo.unlink(ffpath)
        }
        if (FileIo.access(ffpath2)) {
            FileIo.unlink(ffpath2)
        }
        if (FileIo.access(fffpath)) {
            FileIo.unlink(fffpath)
        }
        if (FileIo.access(ffpath3)) {
            FileIo.unlink(ffpath3)
        }
        let srcFile_first_01 = FileIo.open(
            ffpath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        let srcFile_first_02 = FileIo.open(
            ffpath2,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        let srcFile_second_01 = FileIo.open(
            fffpath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        let destFile_first_01 = FileIo.open(
            ffpath3,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )

        FileIo.copyDir(ddpath + "/", ddpath2 + "/", mode: 1)
        let size1 = FileIo
            .stat(ddpath2 + "/srcDir_first/srcFile_first_02")
            .size
        let size2 = FileIo
            .stat(ffpath2)
            .size
        @Expect(size1, size2)

        let size3 = FileIo
            .stat(ddpath2 + "/srcDir_first/srcFile_first_01")
            .size
        let size4 = FileIo
            .stat(ffpath)
            .size
        @Expect(size3, size4)

        let r1 = FileIo.access(ddpath)
        @Expect(r1, true)
        let r2 = FileIo.access(ddpath2 + "/srcDir_first/srcDir_second")
        @Expect(r2, true)

        let size5 = FileIo
            .stat(ddpath2 + "/srcDir_first/srcDir_second/srcFile_second_01")
            .size
        let size6 = FileIo
            .stat(fffpath)
            .size
        @Expect(size5, size6)

        FileIo.close(srcFile_first_01)
        FileIo.close(srcFile_first_02)
        FileIo.close(srcFile_second_01)
        FileIo.close(destFile_first_01)
        FileIo.rmdir(dpath)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_copyDirConflict() {
        let src1Path = "/data/storage/el2/base/haps/cpsrc1"
        let filePath = "/data/storage/el2/base/haps/cpsrc1/testcpConflict"
        let dest1Path = "/data/storage/el2/base/haps/cpdest1"
        let conflictDirPath = "/data/storage/el2/base/haps/cpdest1/cpsrc1"
        let conflictFilePath = "/data/storage/el2/base/haps/cpdest1/cpsrc1/testcpConflict"

        if (!FileIo.access(src1Path)) {
            FileIo.mkdir(src1Path)
        }
        if (!FileIo.access(dest1Path)) {
            FileIo.mkdir(dest1Path)
        }
        if (!FileIo.access(conflictDirPath)) {
            FileIo.mkdir(conflictDirPath)
        }
        if (!FileIo.access(filePath)) {
            let file1 = FileIo.open(
                filePath,
                mode: (OpenMode.CREATE | OpenMode.READ_ONLY)
            )
            FileIo.close(file1)
        }
        if (!FileIo.access(conflictFilePath)) {
            let file2 = FileIo.open(
                conflictFilePath,
                mode: (OpenMode.CREATE | OpenMode.READ_ONLY)
            )
            FileIo.close(file2)
        }
        try {
            FileIo.copyDir(src1Path, dest1Path, mode: 1)
        } catch (e: Exception) {
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_dup() {
        try {
            let readTextOption = ReadTextOptions(length: 2)
            let content1 = FileIo.readText("", options: readTextOption)
        } catch (e: Exception) {
        }
        let fpath = "/data/storage/el2/base/haps/entry/files/test_dup"
        if (FileIo.access(fpath)) {
            FileIo.unlink(fpath)
        }
        let file = FileIo.open(
            fpath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        let fd = file.fd

        let dupFile = FileIo.dup(file.fd)
        FileIo.close(file)
        let newPath = dupFile.path
        @Expect(newPath, fpath)
        let dupFd = dupFile.fd

        let str = "hello, world"
        let bytesWritten = FileIo.write(dupFd, str)
        let content = FileIo.readText(fpath)
        @Expect(content, str)

        // Exception branch
        try {
            let exceptionDupFile = FileIo.dup(-1)
        } catch (_: Exception) {
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_read() {
        let fpath = "/data/storage/el2/base/haps/entry/files/test_read"
        let f = FileIo.open(
            fpath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        let res = FileIo.access(fpath)
        let str = "hello, world"
        FileIo.write(f.fd, str)
        FileIo.close(f)

        let file = FileIo.open(fpath, mode: OpenMode.READ_ONLY)
        let arr = Array<Byte>(16, repeat: 0)
        let readlen1 = FileIo.read(file.fd, arr)
        let content = String.fromUtf8(arr[..readlen1])
        @Expect(content, str)

        let arr2 = Array<Byte>(0, repeat: 0)
        let readLen3 = FileIo.read(file.fd, arr2)
        @Expect(readLen3, 0)

        FileIo.close(file)
        FileIo.unlink(fpath)

        // Exception branch
        try {
            let arr1 = Array<Byte>(16, repeat: 0)
            let readlen2 = FileIo.read(-1, arr1)
        } catch (_: Exception) {
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_readLines() {
        let fpath = "/data/storage/el2/base/haps/entry/files/test_readLines"
        let f = FileIo.open(
            fpath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        let res = FileIo.access(fpath)
        let str = "hello, world"
        FileIo.write(f.fd, str)
        FileIo.close(f)

        let file = FileIo.open(fpath, mode: OpenMode.READ_ONLY)
        let readerIterator = FileIo.readLines(fpath)
        let readerIteratorResult = readerIterator.next()
        try {
            let exceptionResult = readerIterator.next()
        } catch (e: Exception) {
        }
        let content = readerIteratorResult.value
        @Expect(content, str)

        FileIo.close(file)
        FileIo.unlink(fpath)

        // Exception branch
        try {
            let readerIterator1 = FileIo.readLines("")
        } catch (_: Exception) {
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_write() {
        let str = "hello, world"
        let arr = str.toArray()
        // exception branch
        try {
            FileIo.write(-1, str)
        } catch (_: Exception) {
        }
        try {
            FileIo.write(-1, arr)
        } catch (_: Exception) {
        }
        try {
            FileIo.write(-1, Array<Byte>(0, repeat: 0))
        } catch (_: Exception) {
        }

        let fpath = "/data/storage/el2/base/haps/entry/files/test_write"
        let f = FileIo.open(
            fpath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        let res = FileIo.access(fpath)
        let writeBuffer = Array<UInt8>(100, repeat: 0)
        for (i in 0..writeBuffer.size) {
            writeBuffer[i] = UInt8(i)
        }
        let writeOption = WriteOptions(offset: 0)
        FileIo.write(f.fd, str, options: writeOption)
        FileIo.write(f.fd, writeBuffer, options: WriteOptions(offset: str.size))
        FileIo.close(f)
        FileIo.unlink(fpath)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_truncate() {
        try {
            FileIo.truncate("", len: 0)
        } catch (_: Exception) {
        }
        try {
            FileIo.truncate(-1, len: 0)
        } catch (_: Exception) {
        }

        let fpath = "/data/storage/el2/base/haps/entry/files/test_truncate"
        let f = FileIo.open(
            fpath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        let res = FileIo.access(fpath)
        FileIo.write(f.fd, "hello, world")
        FileIo.close(f)
        FileIo.truncate(fpath, len: 5)
        let file = FileIo.open(fpath, mode: OpenMode.READ_ONLY)
        let arr = Array<Byte>(1024, repeat: 0)
        let readlen1 = FileIo.read(file.fd, arr)
        let content = String.fromUtf8(arr[..readlen1])
        @Expect(content, "hello")
        FileIo.close(file)
        FileIo.unlink(fpath)

        let fpath1 = "/data/storage/el2/base/haps/entry/files/test_truncate1"
        let f1 = FileIo.open(
            fpath1,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        let res1 = FileIo.access(fpath1)
        FileIo.write(f1.fd, "hello, world")
        FileIo.truncate(f1.fd, len: 5)
        FileIo.close(f1)
        let file1 = FileIo.open(fpath1, mode: OpenMode.READ_ONLY)
        let arr1 = Array<Byte>(1024, repeat: 0)
        let readlen2 = FileIo.read(file1.fd, arr1)
        let content1 = String.fromUtf8(arr1[..readlen2])
        @Expect(content1, "hello")
        FileIo.close(file1)
        FileIo.unlink(fpath1)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_fsync() {
        try {
            FileIo.fsync(-1)
        } catch (e: Exception) {
        }
        let fpath = "/data/storage/el2/base/haps/entry/files/test_fsync"
        let file = FileIo.open(
            fpath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        FileIo.write(file.fd, "hello, world")
        FileIo.fsync(file.fd)
        let readlen = FileIo.read(file.fd, Array<Byte>(4096, repeat: 0), options: ReadOptions(offset: 0))
        Hilog.info(0, "Test_filemanagement", "read length is ${readlen}")
        FileIo.close(file)
        FileIo.unlink(fpath)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_listFile() {
        try {
            FileIo.listFile("")
        } catch (e: Exception) {
        }

        let root = "/data/storage/el2/base/haps/entry/files/test_fileList"
        if (!FileIo.access(root)) {
            FileIo.mkdir(root)
        }

        let subDir0 = root + "/subDir0"
        let subFile0 = root + "/subFile0.png"

        if (!FileIo.access(subDir0)) {
            FileIo.mkdir(subDir0)
        }

        if (!FileIo.access(subFile0)) {
            FileIo.open(
                subFile0,
                mode: (OpenMode.CREATE | OpenMode.READ_ONLY)
            )
        }

        let options = ListFileOptions()
        let result = FileIo
            .listFile(root)
            .toString()
        @Expect(result.contains("subDir0"))
        @Expect(result.contains("subFile0.png"))
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_lseek() {
        try {
            FileIo.lseek(-1, 7, whence: WhenceType.SeekCur)
        } catch (e: Exception) {
        }
        try {
            FileIo.lseek(-1, 2, whence: WhenceType.SeekEnd)
        } catch (e: Exception) {
        }
        let filePath = "/data/storage/el2/base/test_lseek.txt"
        let file = FileIo.open(
            filePath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        let file_fd = file.fd
        FileIo.write(file_fd, "hello, world")
        let offset = FileIo.lseek(file_fd, 7, whence: WhenceType.SeekSet)
        FileIo.write(file_fd, "cangjie")
        let arr = Array<Byte>(1024, repeat: 0)
        let readlen = FileIo.read(file_fd, arr, options: ReadOptions(offset: 0))
        let content = String.fromUtf8(arr[..readlen])
        @Expect(content, "hello, cangjie")
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_moveDir() {
        let srcPath = "/data/storage/el2/base/haps/src"
        let destPath = "/data/storage/el2/base/haps/dest"

        if (!FileIo.access(srcPath)) {
            FileIo.mkdir(srcPath)
        }
        if (!FileIo.access(destPath)) {
            FileIo.mkdir(destPath)
        }
        FileIo.moveDir(srcPath, destPath)
        @Expect(FileIo.access(destPath + "/src"))

        let src1Path = "/data/storage/el2/base/haps/src1"
        let filePath = "/data/storage/el2/base/haps/src1/testConflict"
        let dest1Path = "/data/storage/el2/base/haps/dest1"
        let conflictDirPath = "/data/storage/el2/base/haps/dest1/src1"
        let conflictFilePath = "/data/storage/el2/base/haps/dest1/src1/testConflict"

        if (!FileIo.access(src1Path)) {
            FileIo.mkdir(src1Path)
        }
        if (!FileIo.access(dest1Path)) {
            FileIo.mkdir(dest1Path)
        }
        if (!FileIo.access(conflictDirPath)) {
            FileIo.mkdir(conflictDirPath)
        }
        if (!FileIo.access(filePath)) {
            let file1 = FileIo.open(
                filePath,
                mode: (OpenMode.CREATE | OpenMode.READ_ONLY)
            )
            FileIo.close(file1)
        }
        if (!FileIo.access(conflictFilePath)) {
            let file2 = FileIo.open(
                conflictFilePath,
                mode: (OpenMode.CREATE | OpenMode.READ_ONLY)
            )
            FileIo.close(file2)
        }
        try {
            FileIo.moveDir(src1Path, dest1Path, mode: 1)
        } catch (e: Exception) {
        }

        try {
            FileIo.moveDir("", "")
        } catch (_: Exception) {
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_moveFile() {
        try {
            FileIo.moveFile("", "", mode: 0)
        } catch (_: Exception) {
        }
        let srcPath = "/data/storage/el2/base/haps/src.txt"
        let destPath = "/data/storage/el2/base/haps/dest"

        if (!FileIo.access(srcPath)) {
            FileIo.open(
                srcPath,
                mode: (OpenMode.CREATE | OpenMode.READ_ONLY)
            )
        }
        if (!FileIo.access(destPath)) {
            FileIo.mkdir(destPath)
        }
        let destFile = destPath + "dest.txt"
        FileIo.moveFile(srcPath + "/", destFile + "/", mode: 0)
        @Expect(FileIo.access(destFile))
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_mkdtemp() {
        try {
            FileIo.mkdtemp("")
        } catch (_: Exception) {
        }
        try {
            FileIo.mkdtemp("/data/storage/el2/base/haps/XXXXXX")
        } catch (_) {
            @Expect(false)
        }
        @Expect(true)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_utimes() {
        try {
            FileIo.utimes("", 0.0)
        } catch (e: Exception) {
        }

        let srcPath = "/data/storage/el2/base/haps/test_utimes.txt"

        if (!FileIo.access(srcPath)) {
            FileIo.open(
                srcPath,
                mode: (OpenMode.CREATE | OpenMode.READ_ONLY)
            )
        }
        FileIo.utimes(srcPath, 0.0)
        let stat = FileIo.stat(srcPath)
        @Expect(stat.mtime, 0)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_randomAccessFile() {
        try {
            FileIo.fdatasync(-1)
        } catch (e: Exception) {
        }
        let filePath = "/data/storage/el2/base/haps/entry/files/test.txt"
        let file = FileIo.open(
            filePath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        FileIo.write(file.fd, "hello world")
        FileIo.fdatasync(file.fd)
        let randomAccessFile = FileIo.createRandomAccessFile(filePath, mode: OpenMode.READ_WRITE)

        try {
            let randomAccessFile1 = FileIo.createRandomAccessFile("", mode: OpenMode.READ_WRITE)
        } catch (_: Exception) {
        }

        let filePath1 = "/data/storage/el2/base/haps/entry/files/test1.txt"
        let file1 = FileIo.open(
            filePath1,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        FileIo.write(file1.fd, "hello world")
        FileIo.fdatasync(file1.fd)
        let randomAccessFile1 = FileIo.createRandomAccessFile(file1, mode: OpenMode.READ_WRITE)

        @Expect(randomAccessFile.fd > 3)
        @Expect(randomAccessFile1.fd > 3)
        @Expect(randomAccessFile.filePointer , 0)
        @Expect(randomAccessFile1.filePointer, 0)

        randomAccessFile.setFilePointer(6)
        randomAccessFile1.setFilePointer(6)

        let writeOption = WriteOptions(length: 5)
        let str = "hello cangjie"
        Hilog.info(0, "fs_test", "start test writeRandomAccessFile")
        let writeLen = randomAccessFile.write(str, options: writeOption)
        let writeLen1 = randomAccessFile1.write(str, options: writeOption)
        @Expect(writeLen, 5)
        @Expect(writeLen1, 5)

        let exceptionWriteOption = WriteOptions(length: 0)
        try {
            let exceptionWriteLen = randomAccessFile.write("", options: exceptionWriteOption)
        } catch (e: Exception) {
        }
        try {
            let exceptionWriteLen1 = randomAccessFile.write("")
        } catch (e: Exception) {
        }

        randomAccessFile.setFilePointer(0)

        let readOption = ReadOptions(length: 5)
        let readArr = Array<Byte>(1024, repeat: 0)
        let len = randomAccessFile.read(readArr, options: readOption)
        let readContent = String.fromUtf8(readArr[..len])
        @Expect(readContent, "hello")
        let readArr1 = Array<Byte>(1, repeat: 0)
        let len1 = randomAccessFile.read(readArr1)
        @Expect(len1, 1)
        let readContent2 = String.fromUtf8(readArr1[..len1])
        @Expect(readContent2, " ")
        let readArr2 = Array<Byte>(0, repeat: 0)
        let len2 = randomAccessFile.read(readArr2)
        @Expect(len2, 0)
        try {
            let exceptionLen = randomAccessFile.read(readArr1, options: ReadOptions(length: 1000000))
        } catch (e: Exception) {
        }

        randomAccessFile.close()
        randomAccessFile1.close()

        let arr = Array<Byte>(1024, repeat: 0)
        let arr1 = Array<Byte>(1024, repeat: 0)
        FileIo.lseek(file.fd, 0)
        FileIo.lseek(file1.fd, 0)
        let readLen = FileIo.read(file.fd, arr)
        let readLen1 = FileIo.read(file1.fd, arr1)
        let content = String.fromUtf8(arr[..readLen])
        let content1 = String.fromUtf8(arr1[..readLen1])
        @Expect(content, "hello hello")
        @Expect(content1, "hello hello")
        FileIo.close(file)
        FileIo.close(file1)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_file() {
        let filePath = "/data/storage/el2/base/test_file.txt"
        let file = FileIo.open(
            filePath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        @Expect(file.fd > 2)
        @Expect(file.path, filePath)
        @Expect(file.name, "test_file.txt")
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_createStreamException() {
        try {
            let stream = FileIo.createStream("1212", "w+")
            @Expect(false)
        } catch (_: Exception) {
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_fdopenStream() {
        let filePath = "/data/storage/el2/base/test_fdopenStream.txt"
        try {
            let file = FileIo.open(
                filePath,
                mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
            )
            let stream = FileIo.fdopenStream(file.fd, "w+")
            stream.close()
            let stream1 = FileIo.fdopenStream(-1, "w+")
        } catch (_: Exception) {
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_tryLock() {
        let filePath = "/data/storage/el2/base/test_tryLock.txt"
        try {
            let stream = FileIo.createStream(filePath, "w+")
            var testString = "Lorem ipsum dolor sit amet. Rem dolores amet qui dolores magnam eum nihil quaerat ea quisquam minima. "
            let writeLen = stream.write(testString.toArray())
            stream.flush()
            stream.close()
            let file = FileIo.open(
                filePath,
                mode: OpenMode.READ_WRITE
            )
            let lock1 = file.tryLock(exclusive: true)
            let file2 = FileIo.open(
                filePath,
                mode: OpenMode.READ_ONLY
            )
            let lock2 = file2.tryLock();
            @Expect(false)
        } catch (e: BusinessException) {
            @Expect(e.code, 13900023)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_unLock() {
        let filePath = "/data/storage/el2/base/haps/entry/files/text_unLock.txt"
        try {
            let stream = FileIo.createStream(filePath, "w+")
            var testString = "Lorem ipsum dolor sit amet. Rem dolores amet qui dolores magnam eum nihil quaerat ea quisquam minima. "
            let writeOption = WriteOptions(offset: 0)
            let writeLen = stream.write(testString, options: writeOption)
            stream.close()
            let file = FileIo.open(
                filePath,
                mode: OpenMode.READ_WRITE
            )
            let lock1 = file.tryLock(exclusive: true)
            file.unlock()
            let file2 = FileIo.open(
                filePath,
                mode: OpenMode.READ_ONLY
            )
            file2.unlock()
        } catch (e: Exception) {
            Hilog.info(0, "fs_test", "error: ${e.toString()}")
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getParent() {
        let filePath = "/data/storage/el2/base/haps/entry/files/text_unLock.txt"
        try {
            let stream = FileIo.createStream(filePath, "w+")
            var testString = "Lorem ipsum dolor sit amet. Rem dolores amet qui dolores magnam eum nihil quaerat ea quisquam minima. "
            let writeLen = stream.write(testString)
            stream.close()
            let file = FileIo.open(
                filePath,
                mode: OpenMode.READ_WRITE
            )
            let parentPath = file.getParent()
        } catch (e: Exception) {
            Hilog.info(0, "fs_test", "error: ${e.toString()}")
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_mkdir() {
        let dirPath = "/data/storage/el2/base/mkdirtest"
        let dirPath2 = "/data/storage/el2/base/test_mkdir"
        try {
            FileIo.rmdir(dirPath)
        } catch (_) {
        }
        try {
            FileIo.rmdir(dirPath2)
        } catch (_) {
        }
        let status1 = FileIo.access(dirPath)
        @Expect(!status1)
        FileIo.mkdir("/data/storage/el2/base/mkdirtest")
        let status2 = FileIo.access(dirPath)
        @Expect(status2)
        let status3 = FileIo.access(dirPath2)
        @Expect(!status3)
        FileIo.mkdir(dirPath2, false)
        let status4 = FileIo.access(dirPath2)
        @Expect(status4)

        try {
            FileIo.mkdir("")
        } catch (_: Exception) {
        }
        try {
            FileIo.mkdir("", false)
        } catch (_: Exception) {
        }
        try {
            FileIo.rmdir("")
        } catch (_: Exception) {
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_rename() {
        let dirPath = "/data/storage/el2/base/renameTest"
        let srcPath = dirPath + "src.txt"
        FileIo.open(
            srcPath,
            mode: (OpenMode.CREATE | OpenMode.READ_WRITE)
        )
        let destPath = dirPath + "dest.txt"
        FileIo.rename(srcPath, destPath)
        let status = FileIo.access(destPath)
        @Expect(status)

        try {
            FileIo.rename("", "")
        } catch (_: Exception) {
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_stream_write_read() {
        let path = "/data/storage/el2/base/haps/entry/files/text.txt"
        let writeStream = FileIo.createStream("/data/storage/el2/base/haps/entry/files/text.txt", "w+")
        let testString = "Lorem ipsum dolor sit amet. Rem dolores amet qui dolores magnam eum nihil quaerat ea quisquam minima."
        let strLen = testString.size
        let writeLen = writeStream.write(testString)
        @Expect(strLen, writeLen)
        writeStream.close()

        let readStream = FileIo.createStream("/data/storage/el2/base/haps/entry/files/text.txt", "r+")
        let x: UInt8 = 0
        var buffer = Array<Byte>(2048, repeat: x)
        var buffer1 = Array<Byte>(2048, repeat: x)
        var buffer2 = Array<Byte>(0, repeat: 0)
        let readLen = readStream.read(buffer)
        let readLen1 = readStream.read(buffer1, options: ReadOptions(offset: 0))
        let readLen2 = readStream.read(buffer2)
        @Expect(readLen2, 0)

        Hilog.info(0, "fs_test", "readLen: ${readLen.toString()}")
        @Expect(readLen, 101)
        @Expect(readLen1, 101)
        Hilog.info(0, "fs_test", "buffer: ${String.fromUtf8(buffer)}")
        @Expect(String.fromUtf8(buffer[..readLen]), testString)
        @Expect(String.fromUtf8(buffer1[..readLen1]), testString)
        readStream.close()
        try {
            readStream.close()
        } catch (_: Exception) {
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_OpenMode() {
        @Expect(OpenMode.READ_ONLY, 0o0)
        @Expect(OpenMode.WRITE_ONLY, 0o1)
        @Expect(OpenMode.READ_WRITE, 0o2)
        @Expect(OpenMode.CREATE, 0o100)
        @Expect(OpenMode.TRUNC, 0o1000)
        @Expect(OpenMode.APPEND, 0o2000)
        @Expect(OpenMode.NONBLOCK, 0o4000)
        @Expect(OpenMode.DIR, 0o200000)
        @Expect(OpenMode.NOFOLLOW, 0o400000)
        @Expect(OpenMode.SYNC, 0o4010000)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_Filter() {
        try {
            Filter(fileSizeOver: -1)
            @Expect(false)
        } catch (e: BusinessException) {
            @Expect(e.code, 13900020)
        }
    }
}

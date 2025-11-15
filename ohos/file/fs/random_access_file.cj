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

// The Cangjie API is in Beta. For details on its capabilities and limitations, please refer to the README file.

package ohos.file.fs

import ohos.ffi.{RemoteDataLite, releaseFFIData, RetDataI64, SUCCESS_CODE, safeMalloc}
import ohos.business_exception.BusinessException
import ohos.labels.APILevel

/**
 * Provides APIs for randomly reading and writing a stream. Before invoking any API of RandomAccessFile,
 * you need to use createRandomAccessFile() to create a RandomAccessFile instance.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.FileManagement.File.FileIO"
]
public class RandomAccessFile <: RemoteDataLite {
    init(instanceId: Int64) {
        super(instanceId)
    }

    ~init() {
        releaseFFIData(myDataId)
    }

    /**
     * FD of the file.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.File.FileIO"
    ]
    public prop fd: Int32 {
        get() {
            unsafe { FfiOHOSRandomAccessFileGetFd(getID()) }
        }
    }

    /**
     * Offset pointer to the RandomAccessFile instance.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.File.FileIO"
    ]
    public prop filePointer: Int64 {
        get() {
            unsafe { FfiOHOSRandomAccessFileGetFPointer(getID()) }
        }
    }

    /**
     * Sets the file offset pointer.
     *
     * @param { Int64 } filePointer - Offset pointer to the RandomAccessFile instance.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.File.FileIO"
    ]
    public func setFilePointer(filePointer: Int64): Unit {
        unsafe { FfiOHOSRandomAccessFileSetFilePointerSync(getID(), filePointer) }
        return
    }

    /**
     * Closes this RandomAccessFile instance.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.File.FileIO",
        workerthread: true
    ]
    public func close(): Unit {
        unsafe { FfiOHOSRandomAccessFileClose(getID()) }
        return
    }

    /**
     * Writes data to a file.
     *
     * @param { String } buffer - The data to write.
     * @param { WriteOptions } [options] - The options are as follows:
     * length (UIntNative): length of the data to write. The default value is the buffer length.
     * offset (Int64): start position to write the data (it is determined by filePointer plus offset).
     * By default, data is written from the filePointer.
     * encoding (String): format of the data to be encoded when the data is a string.
     * The default value is 'utf-8', which is the only value supported.
     * @returns { Int64 } Returns the number of bytes written to the file.
     * @throws { BusinessException } 13900001 - Operation not permitted
     * @throws { BusinessException } 13900004 - Interrupted system call
     * @throws { BusinessException } 13900005 - I/O error
     * @throws { BusinessException } 13900008 - Bad file descriptor
     * @throws { BusinessException } 13900010 - Try again
     * @throws { BusinessException } 13900013 - Bad address
     * @throws { BusinessException } 13900020 - Invalid argument
     * @throws { BusinessException } 13900024 - File too large
     * @throws { BusinessException } 13900025 - No space left on device
     * @throws { BusinessException } 13900034 - Operation would block
     * @throws { BusinessException } 13900041 - Quota exceeded
     * @throws { BusinessException } 13900042 - Unknown error
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.File.FileIO",
        throwexception: true,
        workerthread: true
    ]
    public func write(buffer: String, options!: WriteOptions = WriteOptions()): Int64 {
        let arr = unsafe { buffer.rawData() }
        write(arr, options: options)
    }

    /**
     * Writes data to a file.
     *
     * @param { Array<Byte> } buffer - The data to write.
     * @param { WriteOptions } [options] - The options are as follows:
     * length (UIntNative): length of the data to write. The default value is the buffer length.
     * offset (Int64): start position to write the data (it is determined by filePointer plus offset).
     * By default, data is written from the filePointer.
     * encoding (String): format of the data to be encoded when the data is a string.
     * The default value is 'utf-8', which is the only value supported.
     * @returns { Int64 } Returns the number of bytes written to the file.
     * @throws { BusinessException } 13900001 - Operation not permitted
     * @throws { BusinessException } 13900004 - Interrupted system call
     * @throws { BusinessException } 13900005 - I/O error
     * @throws { BusinessException } 13900008 - Bad file descriptor
     * @throws { BusinessException } 13900010 - Try again
     * @throws { BusinessException } 13900013 - Bad address
     * @throws { BusinessException } 13900020 - Invalid argument
     * @throws { BusinessException } 13900024 - File too large
     * @throws { BusinessException } 13900025 - No space left on device
     * @throws { BusinessException } 13900034 - Operation would block
     * @throws { BusinessException } 13900041 - Quota exceeded
     * @throws { BusinessException } 13900042 - Unknown error
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.File.FileIO",
        throwexception: true,
        workerthread: true
    ]
    public func write(buffer: Array<Byte>, options!: WriteOptions = WriteOptions()): Int64 {
        let writeLen: UIntNative = options.length ?? UIntNative(buffer.size)
        if (writeLen > UIntNative(buffer.size)) {
            throw BusinessException(INVALID_ARGS_CODE, "Invalid argument")
        }
        var writeBytes: Int64 = 0
        unsafe {
            let cBuffer = acquireArrayRawData(buffer)
            let cValue = FfiOHOSRandomAccessFileWrite(getID(), cBuffer.pointer, writeLen, options.offset ?? 0)
            releaseArrayRawData(cBuffer)
            if (cValue.code != SUCCESS_CODE) {
                FS_LOG.error(getErrorInfo(cValue.code))
                throw BusinessException(cValue.code, getErrorInfo(cValue.code))
            }
            writeBytes = cValue.data
        }
        return writeBytes
    }

    /**
     * Reads data from a file.
     *
     * @param { Array<Byte> } buffer - Buffer used to store the file read.
     * @param { ReadOptions } [options] - The options are as follows:
     * length (UIntNative): length of the data to read. The default value is the buffer length.
     * offset (Int64): start position to read the data (it is determined by filePointer plus offset).
     * By default, data is read from the filePointer.
     * @returns { Int64 } Used to return the data read.
     * @throws { BusinessException } 13900004 - Interrupted system call
     * @throws { BusinessException } 13900005 - I/O error
     * @throws { BusinessException } 13900008 - Bad file descriptor
     * @throws { BusinessException } 13900010 - Try again
     * @throws { BusinessException } 13900013 - Bad address
     * @throws { BusinessException } 13900019 - Is a directory
     * @throws { BusinessException } 13900020 - Invalid argument
     * @throws { BusinessException } 13900034 - Operation would block
     * @throws { BusinessException } 13900042 - Unknown error
     * @throws { BusinessException } 13900044 - Network is unreachable
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.File.FileIO",
        throwexception: true,
        workerthread: true
    ]
    public func read(buffer: Array<Byte>, options!: ReadOptions = ReadOptions()): Int64 {
        let cValue: RetDataI64
        if (buffer.size == 0) {
            return 0
        }
        let cBuffer = safeMalloc<Byte>(count: buffer.size)
        if (options.length.isNone()) {
            cValue = unsafe {
                FfiOHOSRandomAccessFileRead(getID(), cBuffer, UIntNative(buffer.size), options.offset ?? 0)
            }
        } else {
            cValue = unsafe {
                FfiOHOSRandomAccessFileRead(getID(), cBuffer, options.length.getOrThrow(), options.offset ?? 0)
            }
        }
        for (index in 0..cValue.data) {
            let ch = unsafe { cBuffer.read(index) }
            buffer[index] = ch
        }
        unsafe { LibC.free(cBuffer) }
        if (cValue.code != SUCCESS_CODE) {
            FS_LOG.error(getErrorInfo(cValue.code))
            throw BusinessException(cValue.code, getErrorInfo(cValue.code))
        }
        return cValue.data
    }
}

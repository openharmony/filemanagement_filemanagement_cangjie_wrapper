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

package ohos.file.fileuri

import ohos.ffi.{RemoteDataLite, releaseFFIData}
import ohos.hilog.Hilog
import ohos.business_exception.BusinessException
import ohos.labels.APILevel

foreign func FfiOHOSFILEUriCreateUri(uriOrPath: CString): Int64

foreign func FfiOHOSFILEUriGetPath(id: Int64): CString

foreign func FfiOHOSFILEUriGetName(id: Int64): CString

foreign func FfiOHOSFILEUriToString(id: Int64): CString

foreign func FfiOHOSFILEUriGetUriFromPath(cPath: CString): CString

class UriImpl {
    init() {}
}

/**
 * URI Represents a Uniform Resource Identifier (URI) reference.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.FileManagement.AppFileService"
]
protected abstract class Uri <: RemoteDataLite & ToString {
    private let impl_: UriImpl = UriImpl()
    init(id: Int64) {
        super(id)
    }

    /**
     * Gets/Sets the path portion of the URI.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.AppFileService"
    ]
    public open prop path: String {
        get() {
            throw BusinessException(13900031, "The prop is not supported.")
        }
    }

    /**
     * Converts this URI into an encoded string.
     *
     * @returns { String } URI in a serialized string.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.AppFileService"
    ]
    public open func toString(): String {
        throw BusinessException(13900031, "The function is not supported.")
    }
}

/**
 * FileUri represents the uri of the file.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.FileManagement.AppFileService"
]
public class FileUri <: Uri {

    /**
     * Constructor for obtaining the instance of the FileUri class.
     *
     * @param { String } uriOrPath - Uri or Path.
     * @throws { BusinessException } 13900005 - I/O error
     * @throws { BusinessException } 13900011 - Out of memory
     * @throws { BusinessException } 13900020 - Invalid argument
     * @throws { BusinessException } 13900042 - Unknown error
     * @throws { BusinessException } 14300002 - Invalid uri
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.AppFileService",
        throwexception: true
    ]
    public init(uriOrPath: String) {
        super(
            unsafe {
                if (uriOrPath == "") {
                    Hilog.error(0xD003900, "File-FileUir", "Invalid argument")
                    throw BusinessException(13900020, "Invalid argument")
                }
                let uriCString = LibC.mallocCString(uriOrPath)
                let id = FfiOHOSFILEUriCreateUri(uriCString)
                LibC.free(uriCString)
                if (id < 0) {
                    Hilog.error(0xD003900, "File-FileUir", "Out of memory")
                    throw BusinessException(13900011, "Out of memory")
                }
                id
            })
    }

    ~init() {
        releaseFFIData(myDataId)
    }

    /**
     * Gets/Sets the path portion of the URI.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.AppFileService"
    ]
    public override prop path: String {
        get() {
            unsafe {
                let cPath = FfiOHOSFILEUriGetPath(getID())
                let resultPath = cPath.toString()
                LibC.free(cPath)
                return resultPath
            }
        }
    }

    /**
     * Obtains the file name of uri.
     *
     * @throws { BusinessException } 13900005 - I/O error
     * @throws { BusinessException } 13900042 - Unknown error
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.AppFileService",
        throwexception: true
    ]
    public prop name: String {
        get() {
            unsafe {
                let cName = FfiOHOSFILEUriGetName(getID())
                let resultName = cName.toString()
                LibC.free(cName)
                return resultName
            }
        }
    }

    /**
     * Converts this URI into an encoded string.
     *
     * @returns { String } Return the file uri string
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.AppFileService"
    ]
    public override func toString(): String {
        unsafe {
            let cStr = FfiOHOSFILEUriToString(getID())
            let str = cStr.toString()
            LibC.free(cStr)
            return str
        }
    }
}

/**
 * Get the uri from the path of file in app sandbox
 *
 * @param { String } path - the path of file in app sandbox
 * @returns { String } Return the file uri
 * @throws { BusinessException } 13900020 - Invalid argument.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.FileManagement.AppFileService",
    throwexception: true
]
public func getUriFromPath(path: String): String {
    if (path == "") {
        Hilog.error(0xD003900, "File-FileUir", "The input parameter is invalid")
        throw BusinessException(13900020, "Invalid argument")
    }
    unsafe {
        let cPath = LibC.mallocCString(path)
        let cUri = FfiOHOSFILEUriGetUriFromPath(cPath)
        LibC.free(cPath)
        let str = cUri.toString()
        LibC.free(cUri)
        return str
    }
}

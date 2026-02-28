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

package ohos.file.fileuri

import ohos.labels.APILevel
import ohos.business_exception.BusinessException
import ohos.ffi.RemoteDataLite

@!APILevel[
    since: "22",
    syscap: "SystemCapability.FileManagement.AppFileService"
]
public open class Uri <: RemoteDataLite & ToString {

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

@!APILevel[
    since: "22",
    syscap: "SystemCapability.FileManagement.AppFileService"
]
public class FileUri <: Uri {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.AppFileService",
        throwexception: true
    ]
    public init(uriOrPath: String) {
        super()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.AppFileService"
    ]
    public override prop path: String {
        
        get() {
            return String()
        }
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.AppFileService",
        throwexception: true
    ]
    public prop name: String {
        
        get() {
            return String()
        }
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.FileManagement.AppFileService"
    ]
    public override func toString(): String {
        return String()
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.FileManagement.AppFileService",
    throwexception: true
]
public func getUriFromPath(path: String): String {
    return String()
}

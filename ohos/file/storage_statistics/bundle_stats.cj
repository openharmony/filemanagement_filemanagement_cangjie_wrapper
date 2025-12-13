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

package ohos.file.storage_statistics

import ohos.labels.APILevel

/**
 * Get the bundle statistics.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.StorageService.SpatialStatistics"
]
public class BundleStats {
    /**
     * The size of application installation data.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.StorageService.SpatialStatistics"
    ]
    public var appSize: Int64
    /**
     * The size of application cache data.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.StorageService.SpatialStatistics"
    ]
    public var cacheSize: Int64
    /**
     * The size of application local data, distributed data and database data.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.StorageService.SpatialStatistics"
    ]
    public var dataSize: Int64

    init(appSize: Int64, cacheSize: Int64, dataSize: Int64) {
        this.appSize = appSize
        this.cacheSize = cacheSize
        this.dataSize = dataSize
    }
}

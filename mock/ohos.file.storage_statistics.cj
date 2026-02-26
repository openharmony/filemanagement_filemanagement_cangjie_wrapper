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

package ohos.file.storage_statistics

import ohos.labels.APILevel

@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.StorageService.SpatialStatistics",
    throwexception: true
]
public func getCurrentBundleStats(): BundleStats {
    return BundleStats(0, 0, 0)
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.StorageService.SpatialStatistics"
]
public class BundleStats {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.StorageService.SpatialStatistics"
    ]
    public var appSize: Int64
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.StorageService.SpatialStatistics"
    ]
    public var cacheSize: Int64
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.StorageService.SpatialStatistics"
    ]
    public var dataSize: Int64

    init(appSize: Int64, cacheSize: Int64, dataSize: Int64) {
        this.appSize = 0
        this.cacheSize = 0
        this.dataSize = 0
    }
}
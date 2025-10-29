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

package ohos_app_cangjie_entry

internal import ohos.base.*
import kit.CoreFileKit.*
import std.runtime.GC
import std.unittest.testmacro.*
import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import ohos.hilog.Hilog
import ohos.business_exception.BusinessException

@Test
class Test_fileUri {
    override func afterAll(): Unit {
        GC()
        sleep(Duration.second)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_fileUri() {
        let fPath = "/data/storage/el1/base/test_fileUri.txt"
        let file = FileIo.open(fPath, mode: OpenMode.CREATE)
        FileIo.close(file)
        let fUri = FileUri(fPath)
        let name = fUri.name
        @Expect(name, "test_fileUri.txt")
        let path = fUri.path
        @Expect(path, fPath)

        // exception branch
        try {
            let fUri_exception = FileUri("")
            @Expect(false)
        } catch (e: BusinessException) {
            @Expect(e.code, 13900020)
        }

        let uri = getUriFromPath(fPath)
        @Expect(uri.startsWith("file://"))
        @Expect(uri.endsWith(fPath))

        // exception branch
        try {
            let uri_exception = getUriFromPath("")
            @Expect(false)
        } catch (e: BusinessException) {
            @Expect(e.code, 13900020)
        }
        Hilog.info(0, "test_fileUri", "${fUri.toString()}")
    }
}

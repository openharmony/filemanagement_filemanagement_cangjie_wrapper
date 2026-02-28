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

package ohos.file.picker

import ohos.app.ability.ui_ability.UIAbilityContext
import ohos.labels.APILevel

@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService"
]
public class DocumentViewPicker {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public init(abilityContext: UIAbilityContext) {
        super()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService",
        workerthread: true
    ]
    public func select(option!: DocumentSelectOptions = DocumentSelectOptions()): Array<String> {
        return Array<String>()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService",
        throwexception: true,
        workerthread: true
    ]
    public func save(option!: DocumentSaveOptions = DocumentSaveOptions()): Array<String> {
        return Array<String>()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService.FolderSelection"
    ]
    public func getSelectedIndex(): Int32 {
        return 0i32
    }
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService"
]
public class AudioViewPicker {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public init(abilityContext: UIAbilityContext) {
        super()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService",
        workerthread: true
    ]
    public func select(option!: AudioSelectOptions = AudioSelectOptions()): Array<String> {
        return Array<String>()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService",
        throwexception: true,
        workerthread: true
    ]
    public func save(option!: AudioSaveOptions = AudioSaveOptions()): Array<String> {
        return Array<String>()
    }
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService.FolderSelection"
]
public enum DocumentSelectMode {
    /**
     * FileMode (default).
     * Indicates that only files are allowed to be selected.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService.FolderSelection"
    ]
    FileMode
    |
    /**
     * Folder.
     * Indicates that only folders are allowed to be selected.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService.FolderSelection"
    ]
    Folder
    |
    /**
     * Mixed type of files and folders.
     * Indicates that files and folders are allowed to be selected.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService.FolderSelection"
    ]
    Mixed
    | ...
}

/**
 * Enumerates the modes for saving documents.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService"
]
public enum DocumentPickerMode {
    /**
     * Standard mode.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    PickerDefault
    |
    /**
     * Download mode.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    Download
    | ...
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService"
]
public class DocumentSelectOptions {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var defaultFilePathUri: ?String

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var fileSuffixFilters: Array<String>

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var maxSelectNumber: Int64

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService.FolderSelection"
    ]
    public var selectMode: DocumentSelectMode

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService.FolderSelection"
    ]
    public var authMode: Bool

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService",
        throwexception: true
    ]
    public init(
        defaultFilePathUri!: ?String = None,
        fileSuffixFilters!: Array<String> = Array<String>(),
        maxSelectNumber!: Int64 = 500,
        selectMode!: DocumentSelectMode = FileMode,
        authMode!: Bool = false
    ) {
        super()
        this.defaultFilePathUri = None
        this.fileSuffixFilters = Array<String>()
        this.maxSelectNumber = 500
        this.selectMode = FileMode
        this.authMode = false
    }
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService"
]
public class DocumentSaveOptions {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var newFileNames: Array<String>

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var defaultFilePathUri: ?String

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var fileSuffixChoices: Array<String>

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var pickerMode: DocumentPickerMode

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public init(
        newFileNames!: Array<String> = Array<String>(),
        defaultFilePathUri!: ?String = None,
        fileSuffixChoices!: Array<String> = Array<String>(),
        pickerMode!: DocumentPickerMode = DocumentPickerMode.PickerDefault
    ) {
        super()
        this.newFileNames = Array<String>()
        this.defaultFilePathUri = None
        this.fileSuffixChoices = Array<String>()
        this.pickerMode = DocumentPickerMode.PickerDefault
    }
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService"
]
public class AudioSelectOptions {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var maxSelectNumber: Int64

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public init(maxSelectNumber!: Int64 = 1) {
        super()
        this.maxSelectNumber = 1
    }
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService"
]
public class AudioSaveOptions {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var newFileNames: Array<String>

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public init(newFileNames!: Array<String> = Array<String>()) {
        super()
        this.newFileNames = Array<String>()
    }
}
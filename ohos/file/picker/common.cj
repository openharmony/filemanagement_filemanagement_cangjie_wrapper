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

package ohos.file.picker

import ohos.business_exception.BusinessException
import ohos.labels.{APILevel, Hide}

const CREATE_FILE_NAME_LENGTH_LIMIT = 256
const INVALID_ARGS_CODE: Int32 = 13900020
const SELECT_ACTION = "ohos.want.action.OPEN_FILE"
const SAVE_ACTION = "ohos.want.action.CREATE_FILE"

@!Hide
protected enum MergeTypeMode {
    @!Hide
    Default
    |
    @!Hide
    Audio
    |
    @!Hide
    Video
    |
    @!Hide
    Document
    |
    @!Hide
    Picture
    | ...
}

/**
 * Enumerates the types of documents selected.
 * Only 2-in-1 devices are supported.
 */
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

    prop mode: Int64 {
        get() {
            match (this) {
                case FileMode => 0
                case Folder => 1
                case Mixed => 2
                case _ => throw IllegalArgumentException("The type is not supported yet.")
            }
        }
    }
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

    func getValue(): Int64 {
        match (this) {
            case PickerDefault => 0
            case Download => 1
            case _ => throw IllegalArgumentException("The type is not supported yet.")
        }
    }
}

/**
 * Defines the options for selecting documents.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService"
]
public class DocumentSelectOptions {
    /**
     * Path of the document or directory to select.
     * It is empty by default (the recently opened page is displayed).
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var defaultFilePathUri: ?String

    /**
     * Document suffix of the document to select. The value is a string array. 
     * Each element specifies an option, which includes at most two parts with a vertical bar (|) in between.
     * The first part is the description, and the second part is the document suffix.
     * If there is no "|", the option does not have the description.
     * Multiple document suffixes separated by a comma (,) are allowed in an option.
     * The number of elements in a string array cannot exceed 100.
     * This parameter is available only to the devices that have the required system capability.
     * By default, no filtering is performed, that is, all documents are selected.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var fileSuffixFilters: Array<String>

    /**
     * Maximum number of documents that can be selected.
     * Value range: 1 to 500.
     * Only the devices with the required system capability can select directories,
     * and only one directory can be selected at a time.
     * Default value: 1.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var maxSelectNumber: Int64

    /**
     * Selection mode. Only 2-in-1 devices are supported. The default value is FileMode.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var selectMode: DocumentSelectMode

    /**
     * Whether to start Picker.
     * Default value: false.
     * If authMode is true, defaultFilePathUri is mandatory, which specifies the URI of the file allowed to access.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var authMode: Bool

    @!Hide
    protected var multiAuthMode: Bool = false

    @!Hide
    protected var multiUriArray: Array<String> = Array<String>()

    @!Hide
    protected var mergeMode: MergeTypeMode = MergeTypeMode.Default

    @!Hide
    protected var isEncryptionSupported: Bool = false

    /**
     * Create DocumentSelectOptions instance.
     *
     * @param {?String} [ defaultFilePathUri ] - Path of the document or directory to select.
     * @param {Array<String>} [ fileSuffixFilters ] - Document suffix of the document to select.
     * @param {Int64} [ maxSelectNumber ] - Maximum number of documents that can be selected.
     * @param {DocumentSelectMode} [ selectMode ] - Selection mode.
     * @param {Bool} [ authMode ] - Whether to start Picker.
     * @throws { BusinessException } 13900020 - Invalid arguments.
     */
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
        this.defaultFilePathUri = defaultFilePathUri
        this.fileSuffixFilters = fileSuffixFilters
        this.maxSelectNumber = maxSelectNumber
        this.selectMode = selectMode
        this.authMode = authMode
        if (maxSelectNumber < 1 || maxSelectNumber > 500) {
            PICKER_LOG.error("The maxSelectNumber must range from 1 to 500.")
            throw BusinessException(INVALID_ARGS_CODE, "Invalid arguments.")
        }
        if (fileSuffixFilters.size > 100) {
            PICKER_LOG.error("The fileSuffixFilters size can not exceed 100.")
            throw BusinessException(INVALID_ARGS_CODE, "Invalid arguments.")
        }
        if (authMode && defaultFilePathUri.isNone()) {
            PICKER_LOG.error("When authMode is true, must pass defaultFilePathUri.")
            throw BusinessException(INVALID_ARGS_CODE, "Invalid arguments.")
        }
    }
}

/**
 * Defines the options for saving documents.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService"
]
public class DocumentSaveOptions {
    /**
     * Name of the document to save.
     * If this parameter is not specified, the user needs to enter the the document name.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var newFileNames: Array<String>

    /**
     * Path of the document or directory to save.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var defaultFilePathUri: ?String

    /**
     * Document suffix of the document to save. The value is a string array.
     * Each element specifies an option, which includes at most two parts with a vertical bar (|) in between.
     * The first part is the description, and the second part is the document suffix.
     * If there is no "|", the option does not have the description. By default, all documents are saved.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var fileSuffixChoices: Array<String>

    /**
     * Mode for starting Picker. Default value: PickerDefault.
     * If pickerMode is Download,
     * the settings of newFileNames, defaultFilePathUri, and fileSuffixChoices do not take effect.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var pickerMode: DocumentPickerMode

    /**
     * Create DocumentSaveOptions instance.
     *
     * @param { Array<String> } [ newFileNames ] - Name of the document to save.
     * @param { ?String } [ defaultFilePathUri ] - Path of the document or directory to save.
     * @param { Array<String> } [ fileSuffixChoices ] - Document suffix of the document to save.
     * @param { DocumentPickerMode } [ pickerMode ] - Mode for starting Picker. Default value: PickerDefault.
     */
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
        this.newFileNames = newFileNames
        this.defaultFilePathUri = defaultFilePathUri
        this.fileSuffixChoices = fileSuffixChoices
        this.pickerMode = pickerMode
    }
}

/**
 * Defines the options for selecting audio clips.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService"
]
public class AudioSelectOptions {
    /**
     * Maximum number of audio clips that can be selected.
     * Default value: 1. Value range: 1 to 500
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var maxSelectNumber: Int64

    /**
     * Create AudioSelectOptions instance.
     *
     * @param { Int64 } [ maxSelectNumber ] - Maximum number of audio clips that can be selected.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public init(maxSelectNumber!: Int64 = 1) {
        if (maxSelectNumber < 1 || maxSelectNumber > 500) {
            PICKER_LOG.error("The maxSelectNumber must range from 1 to 500.")
            throw BusinessException(INVALID_ARGS_CODE, "Invalid arguments.")
        }
        this.maxSelectNumber = maxSelectNumber
    }
}

/**
 * Defines the options for saving audio clips.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService"
]
public class AudioSaveOptions {
    /**
     * File names of the audio clips to save.
     * If this parameter is not specified, the user needs to enter the file names.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public var newFileNames: Array<String>

    /**
     * Create AudioSaveOptions instance.
     *
     * @param { Array<String> } [ newFileNames ] - File names of the audio clips to save.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public init(newFileNames!: Array<String> = Array<String>()) {
        this.newFileNames = newFileNames
    }
}

class ExtTypes {
    static const DOWNLOAD_TYPE: String = 'filePicker'
    static const AUDIO_PICKER_TYPE: String = 'audioPicker'
    static const PHOTO_PICKER_TYPE: String = 'photoPicker'
}

class PickerDetailType {
    static const FILE_MGR_AUTH = 'downloadAuth'
    static const FILE_MGR_SELECT = 'select'
    static const FILE_MGR_SAVE = 'save'
}

class PickerResult {
    PickerResult(
        let resultCode: Int32,
        let userSuffixIndex: Int32,
        let isOriginal: Bool,
        let ability_params_stream: Array<String>,
        let uriArr: Array<String>,
        let photoUris: Array<String>
    ) {}
}

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

import std.sync.SyncCounter
import std.collection.HashMap
import ohos.app.ability.want.{Want, WantValueType}
import ohos.app.ability.ui_ability.UIAbilityContext
import ohos.business_exception.BusinessException
import ohos.labels.APILevel
import ohos.ffi.SUCCESS_CODE

/**
 * Provides APIs for selecting and saving documents in different formats.
 * Before using the APIs of DocumentViewPicker, you need to create a DocumentViewPicker instance.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService"
]
public class DocumentViewPicker {
    var suffixIndex = -1i32
    let abilityContext: UIAbilityContext

    /**
     * A constructor used to create a DocumentViewPicker instance.
     * This constructor is recommended. For details about how to obtain the context, see getHostContext.
     *
     * @param { UIAbilityContext } abilityContext - Application context.
     * For details about the application context of the stage model, see Context.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public init(abilityContext: UIAbilityContext) {
        this.abilityContext = abilityContext
    }

    /**
     * Starts a documentPicker page for the user to select one or more documents.
     * You can pass in DocumentSelectOptions to specify the URIs of the documents to select.
     *
     * @param { DocumentSelectOptions } [ option ] - Options for selecting documents.
     * If this parameter is not specified, the documentPicker page is displayed by default.
     * @return { Array<String> } - Returns the URIs of the documents selected.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService",
        workerthread: true
    ]
    public func select(option!: DocumentSelectOptions = DocumentSelectOptions()): Array<String> {
        let count = SyncCounter(1)
        let result = Box<?Array<String>>(None)
        let error = Box<?BusinessException>(None)

        let paramMap = HashMap<String, WantValueType>()
        paramMap.add("startMode", StringValue("choose"))
        paramMap.add("extType", StringValue(ExtTypes.DOWNLOAD_TYPE))
        paramMap.add("pickerType", StringValue(PickerDetailType.FILE_MGR_SELECT))

        paramMap.add("key_select_mode", Int64Value(option.selectMode.mode))
        paramMap.add("key_pick_num", Int64Value(option.maxSelectNumber))
        if (let Some(uri) <- option.defaultFilePathUri) {
            paramMap.add("key_pick_dir_path", StringValue(uri))
        }
        if (option.fileSuffixFilters.size > 0) {
            paramMap.add("key_file_suffix_filter",
                ArrayValue(option.fileSuffixFilters.map({value => StringValue(value)})))
        }
        paramMap.add("key_auth_mode", BoolValue(option.authMode))

        let want = Want(
            action: SELECT_ACTION,
            parameters: paramMap
        )

        modalPicker(abilityContext, want, None) {
            ret => if (ret.resultCode != SUCCESS_CODE) {
                error.value = BusinessException(ret.resultCode,
                    ERROR_CODE_MAP.get(ret.resultCode) ?? ERROR_CODE_MAP[ErrCode.RESULT_ERROR])
                count.dec()
            } else {
                result.value = ret.ability_params_stream
                count.dec()
            }
        }
        count.waitUntilZero()
        if (error.value.isSome()) {
            throw error.value.getOrThrow()
        }
        return result.value.getOrThrow()
    }

    /**
     * Starts a documentPicker page for the user to save one or more documents.
     * You can pass in DocumentSaveOptions to specify the URIs of the documents to save.
     *
     * @param { DocumentSaveOptions } [ option ] - Options for saving the documents. If this parameter is not specified,
     * a documentPicker page will be displayed for the user to enter the names of the documents to save.
     * @return { Array<String> } - Returns the URIs of the documents saved.
     * @throws { BusinessException } 13900030 - File name too long.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService",
        throwexception: true,
        workerthread: true
    ]
    public func save(option!: DocumentSaveOptions = DocumentSaveOptions()): Array<String> {
        for (i in 0..option.newFileNames.size) {
            if (option.newFileNames[i].size >= CREATE_FILE_NAME_LENGTH_LIMIT) {
                throw BusinessException(ErrCode.NAME_TOO_LONG, ERROR_CODE_MAP[ErrCode.NAME_TOO_LONG])
            }
        }
        let count = SyncCounter(1)
        let result = Box<?Array<String>>(None)
        let error = Box<?BusinessException>(None)

        let paramMap = HashMap<String, WantValueType>()
        paramMap.add("startMode", StringValue("save"))
        paramMap.add("pickerMode", Int64Value(DocumentPickerMode.PickerDefault.getValue()))
        paramMap.add("extType", StringValue(ExtTypes.DOWNLOAD_TYPE))
        paramMap.add("pickerType", StringValue(PickerDetailType.FILE_MGR_SAVE))
        if (option.newFileNames.size > 0) {
            paramMap.add("key_pick_file_name", ArrayValue(option.newFileNames.map({value => StringValue(value)})))
            paramMap.add("saveFile", StringValue(option.newFileNames[0]))
        }
        if (let Some(uri) <- option.defaultFilePathUri) {
            paramMap.add("key_pick_dir_path", StringValue(uri))
        }
        if (option.fileSuffixChoices.size > 0) {
            paramMap.add("key_file_suffix_choices", ArrayValue(option.fileSuffixChoices.map({value => StringValue(value)})))
        }
        if (option.pickerMode.getValue() == Download.getValue()) {
            paramMap.add("pickerMode", Int64Value(option.pickerMode.getValue()))
            paramMap.add("pickerType", StringValue(PickerDetailType.FILE_MGR_AUTH))
        }

        let abilityWant = Want(
            action: SAVE_ACTION,
            parameters: paramMap
        )
        // currently not support window
        modalPicker(abilityContext, abilityWant, None) {
            ret => if (ret.resultCode != SUCCESS_CODE) {
                error.value = BusinessException(ret.resultCode,
                    ERROR_CODE_MAP.get(ret.resultCode) ?? ERROR_CODE_MAP[ErrCode.RESULT_ERROR])
                count.dec()
            } else {
                if (ret.userSuffixIndex >= 0) {
                    this.suffixIndex = ret.userSuffixIndex
                }
                result.value = ret.ability_params_stream
                count.dec()
            }
        }
        count.waitUntilZero()
        if (error.value.isSome()) {
            throw error.value.getOrThrow()
        }
        return result.value.getOrThrow()
    }

    /**
     * Obtains the index of the file suffix type of the file saved.
     * Only 2-in-1 devices are supported.
     * This method takes effect only when used with save().
     * This method can be used only after DocumentSaveOptions.
     * fileSuffixChoices is configured.
     * The index (Int32) returned by this method indicates the location of
     * the file suffix specified in DocumentSaveOptions.fileSuffixChoices.
     * If no file suffix is specified, getSelectedIndex() returns -1.
     *
     * @return { Int32 } - Returns the index of the suffix array fileSuffixChoices
     * configured by the user in DocumentSaveOptions.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService.FolderSelection"
    ]
    public func getSelectedIndex(): Int32 {
        let idx = suffixIndex
        suffixIndex = -1i32
        idx
    }
}

/**
 * Provides APIs for selecting and saving audio clips.
 * Before using the APIs of AudioViewPicker, you need to create an AudioViewPicker instance.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.FileManagement.UserFileService"
]
public class AudioViewPicker {
    let abilityContext: UIAbilityContext

    /**
     * A constructor used to create an AudioViewPicker instance.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService"
    ]
    public init(abilityContext: UIAbilityContext) {
        this.abilityContext = abilityContext
    }

    /**
     * Starts an audioPicker page for the user to select one or more audio clips.
     * You can pass in AudioSelectOptions to specify the URIs of the audio clips to select.
     *
     * @param { AudioSelectOptions } [ option ] - Options for selecting audio clips.
     * @return { Array<String> } - Returns the URIs of the audio clips selected.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService",
        workerthread: true
    ]
    public func select(option!: AudioSelectOptions = AudioSelectOptions()): Array<String> {
        let count = SyncCounter(1)
        let result = Box<?Array<String>>(None)
        let error = Box<?BusinessException>(None)

        let paramMap = HashMap<String, WantValueType>()
        paramMap.add("extType", StringValue(ExtTypes.AUDIO_PICKER_TYPE))
        paramMap.add("key_pick_num", Int64Value(option.maxSelectNumber))

        let want = Want(
            action: SELECT_ACTION,
            parameters: paramMap
        )

        modalPicker(abilityContext, want, None) {
            ret => if (ret.resultCode != SUCCESS_CODE) {
                error.value = BusinessException(ret.resultCode,
                    ERROR_CODE_MAP.get(ret.resultCode) ?? ERROR_CODE_MAP[ErrCode.RESULT_ERROR])
                count.dec()
            } else {
                result.value = ret.uriArr
                count.dec()
            }
        }
        count.waitUntilZero()
        if (error.value.isSome()) {
            throw error.value.getOrThrow()
        }
        return result.value.getOrThrow()
    }

    /**
     * Starts an audioPicker page (currently, a documentPicker page is displayed)
     * for the user to save one or more audio clips.
     * You can pass in AudioSaveOptions to specify the URIs of the audio clips to save.
     *
     * @param { AudioSaveOptions } [ option ] - Options for saving audio clips.If this parameter is not specified,
     * an audioPicker page will be displayed for the user to enter the names of the files to save.
     * @return { Array<String> } - Returns the URIs of the audio clips saved.
     * @throws { BusinessException } 13900030 - File name too long.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.FileManagement.UserFileService",
        throwexception: true,
        workerthread: true
    ]
    public func save(option!: AudioSaveOptions = AudioSaveOptions()): Array<String> {
        let documentOption = DocumentSaveOptions(newFileNames: option.newFileNames)
        let documentPicker = DocumentViewPicker(abilityContext)
        documentPicker.save(option: documentOption)
    }
}

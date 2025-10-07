# filemanagement_cangjie_wrapper(beta feature)

## Introduction

The filemanagement_cangjie_wrapper is a Cangjie API encapsulated on OpenHarmony for application developers to provide a complete file data management solution. It provides secure and easy-to-use file access capabilities and comprehensive file storage management capabilities. The currently open file management Cangjie api only supports standard devices.

## System Architecture

**Figure 1** Architecture of the file management subsystem
![filemanagement_cangjie_wrapper architecture](figures/filemanagement_cangjie_wrapper_architecture_en.png)

As shown in the architecture diagram:

Interface layer description:

- Basic File Management API: Cangjie public interfaces based on basic file management encapsulation exposed to developers.
- File URI API: Cangjie public interfaces based on file URI encapsulation exposed to developers.

Framework layer description:

- Basic File Management Wrapper: Basic file management provides file access capabilities, such as creating files, deleting files, modifying files, obtaining file information, and retrieving file lists. This encapsulation layer is a Cangjie encapsulation implementation of file management functionality based on the file access interface.
- File URI Wrapper: File URI provides the ability to obtain the application's own URI. This encapsulation layer is a Cangjie encapsulation implementation of the file URI functionality based on the public file access service.

Cangjie File Management Service Dependencies:

- File Access Interface: Provides capabilities for managing basic files, managing basic directories, and streaming file reading that can be called by the file management Cangjie interface.
- Public File Access Service: Provides file sharing and management service capabilities that can be called by the file management Cangjie interface.
- cangjie_ark_interop: Encapsulates public interfaces for C language interoperation, and provides Cangjie tag class implementation for annotating Cangjie APIs, as well as providing BusinessException exception class definitions thrown to users.
- Cangjie DFX: Responsible for providing log interfaces, providing Cangjie interfaces that can be called by the file management Cangjie interface to print logs at critical paths.

## Directory Structure

```
foundation/filemanagement/filemanagement_cangjie_wrapper
├── figures                           # architecture pictures
├── kit                               # Cangjie File Management kit code
│   └── CoreFileKit                   # Cangjie CoreFileKit implementation
├── ohos                              # Cangjie File Management code
│   └── file                          # Cangjie File implementation
│       ├── fileuri                   # File URI module
│       └── fs                        # Basic file management module
└── test                              # Cangjie test code
    ├── filemanagement                # File management tests
    └── file_uri                      # File URI tests
```

## Usage

The current file management Cangjie interface provides the following functions:

- Basic file access capability, including basic file operations such as creating, deleting, and moving files, file information acquisition, and file information setting functions. For details, please refer to [Basic File Management API](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_en/apis/CoreFileKit/cj-apis-file_fs.md)
- File access capability. For details on file access capability, please refer to [File URI API](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_en/apis/CoreFileKit/cj-apis-file_fileuri.md).

For relevant guidance, please refer to [File Management Usage Guide](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/Dev_Guide/source_en/file-management/cj-core-file-kit-intro.md).

## Constraints

-   Basic file management interface currently only supports UTF-8/16 encoding.
-   File URI currently does not support external storage directories.

Compared with the API capabilities provided by ArkTS, the following functions are not supported:

- Storage management functions.
- Common file function.
- Distributed file management capabilities.
- Application file sharing capabilities.

## Code Contribution

Developers are welcome to contribute code, documentation, etc. For specific contribution processes and methods, please refer to [Code Contribution](https://gitcode.com/openharmony/docs/blob/master/en/contribute/code-contribution.md).

## Repositories Involved

[filemanagement_app_file_service](https://gitcode.com/openharmony/filemanagement_app_file_service/blob/master/README.md)

[filemanagement_file_api](https://gitcode.com/openharmony/filemanagement_file_api/blob/master/README.md)

[arkcompiler_cangjie_ark_interop](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/README.md)

[hiviewdfx_hiviewdfx_cangjie_wrapper](https://gitcode.com/openharmony-sig/hiviewdfx_hiviewdfx_cangjie_wrapper/blob/master/README.md)
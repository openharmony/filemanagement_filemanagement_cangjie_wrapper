# filemanagement_cangjie_wrapper

## Introduction

The filemanagement_cangjie_wrapper is a Cangjie API encapsulated on OpenHarmony based on file access interfaces and public file access framework capabilities. The file management subsystem provides a complete file management solution for OpenHarmony. It provides secure and easy-to-use file access and comprehensive file management capabilities. The currently open file management Cangjie api only supports standard devices.

## System Architecture

**Figure 1** Architecture of the file management subsystem
![filemanagement_cangjie_wrapper architecture](figures/filemanagement_cangjie_wrapper_architecture_en.png)

As shown in the architecture diagram:

Interface layer description:

- Basic File Management API: Cangjie public interfaces based on basic file management encapsulation exposed to users.
- File URI API: Cangjie public interfaces based on file URI encapsulation exposed to users.

Framework layer description:

- Basic File Management Wrapper: Provides file access capabilities, such as creating files, deleting files, modifying files, obtaining file information, and retrieving file lists.
- File URI Wrapper: Provides an interface for obtaining the application's own URI.
- Cangjie File Management FFI Interface Definition: Responsible for defining the C language interoperation interface with Cangjie, which is used to implement Cangjie's file management capabilities.

Cangjie File Management Service Dependencies:

- Cangjie ark interop: Encapsulates public interfaces for C language interoperation, and provides Cangjie tag class implementation for annotating Cangjie APIs, as well as providing BusinessException exception class definitions thrown to users.
- File Api: Provides C language interfaces that can be called by the file management Cangjie interface for basic files for managing files, basic files for managing directories, and streaming file reading capabilities.
- User File Service: Provides C language interfaces that can be called by the file management Cangjie interface for file sharing and management service capabilities.
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
    │   └── test                      # File management test project
    └── file_uri                      # File URI tests
        └── test                      # File URI test project
```

## Usage

The current file management Cangjie interface provides the following functions:

- Basic file access capability.
- File information acquisition capability.

For filemanagement-related APIs, please refer to:

-   [File Management](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_en/apis/CoreFileKit/cj-apis-file_fs.md)
-   [File URI](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_en/apis/CoreFileKit/cj-apis-file_fileuri.md)

For relevant guidance, please refer to [File Management Usage Guide](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/Dev_Guide/source_en/file-management/cj-core-file-kit-intro.md).

## Constraints

Constraints on local I/O APIs:

-   Only UTF-8/16 encoding is supported.
-   The URIs cannot include external storage directories.

Compared with the API capabilities provided by ArkTS, the following functions are not supported at the moment:

- Storage management functions.
- Common file function.
- Distributed capabilities.
- Application file sharing capabilities.

## Code Contribution

Developers are welcome to contribute code, documentation, etc. For specific contribution processes and methods, please refer to [Code Contribution](https://gitcode.com/openharmony/docs/blob/master/en/contribute/code-contribution.md).

## Repositories Involved

[filemanagement_app_file_service](https://gitcode.com/openharmony/filemanagement_app_file_service/blob/master/README.md)

[filemanagement_file_api](https://gitcode.com/openharmony/filemanagement_file_api/blob/master/README.md)

[arkcompiler_cangjie_ark_interop](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/README.md)

[hiviewdfx_hiviewdfx_cangjie_wrapper](https://gitcode.com/openharmony-sig/hiviewdfx_hiviewdfx_cangjie_wrapper/blob/master/README.md)
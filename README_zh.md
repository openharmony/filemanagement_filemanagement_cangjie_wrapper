# 文件管理仓颉接口

## 简介

文件管理仓颉接口是在OpenHarmony上基于文件管理子系统能力之上封装的仓颉API。文件管理子系统为OpenHarmony提供一套完整的文件数据管理解决方案，提供安全、易用的文件访问能力和完善的文件存储管理能力。当前开放的文件管理仓颉接口仅支持standard设备。

## 系统架构

**图 1**  文件管理仓颉架构图
![文件管理仓颉架构图](figures/filemanagement_cangjie_wrapper_architecture_zh.png)

- 基本文件管理封装：提供文件访问能力，如创建文件、删除文件、修改文件、获取文件信息、获取文件列表等。
- 文件URI封装：提供获取应用自己的URI接口。
- 仓颉文件管理FFI接口定义：负责定义被Cangjie语言调用的C语言互操作接口，用于实现仓颉文件管理能力。
- 仓颉互操作：封装C语言互操作公共接口，并提供仓颉标签类实现用于对仓颉API进行标注，以及提供抛向用户的BusinessException异常类定义。
- 文件访问：提供用于管理文件的基本文件，管理目录的基本文件，流式读取文件能力的C语言接口。
- 公共文件访问服务：提供文件分享和管理服务能力的C语言接口。
- 仓颉DFX：负责提供日志接口，用于在关键路径处打印日志。

## 目录

```
foundation/filemanagement/filemanagement_cangjie_wrapper
├── figures                           # 存放README中的架构图
├── kit                               # 仓颉文件管理kit化代码
│   └── CoreFileKit                   # 仓颉CoreFileKit实现
├── ohos                              # 仓颉文件管理接口实现
│   └── file                          # 仓颉文件接口实现
│       ├── fileuri                   # 文件URI模块
│       └── fs                        # 基本文件管理模块
└── test                              # 仓颉测试代码
    ├── filemanagement                # 文件管理测试
    │   └── test                      # 文件管理测试工程
    └── file_uri                      # 文件URI测试
        └── test                      # 文件URI测试工程
```

## 约束

本地IO接口

-   目前仅支持UTF-8/16编码。
-   目前URI暂不支持外部存储目录。

## 使用说明

当前文件管理仓颉接口提供了以下功能：

- 基础文件访问能力。
- 文件信息获取能力。

与ArkTS提供的API能力相比，暂不支持以下功能：

- 存储管理功能。
- 公共文件功能。
- 分布式能力。
- 应用文件分享能力。

文件管理相关API请参见：

-   [文件管理](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_zh_cn/apis/CoreFileKit/cj-apis-file_fs.md)
-   [文件URI](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_zh_cn/apis/CoreFileKit/cj-apis-file_fileuri.md)

相关指导请参见[文件管理使用指导](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/Dev_Guide/source_zh_cn/file-management/cj-core-file-kit-intro.md)。

## 参与贡献

欢迎广大开发者贡献代码、文档等，具体的贡献流程和方式请参见[参与贡献](https://gitcode.com/openharmony/docs/blob/master/zh-cn/contribute/%E5%8F%82%E4%B8%8E%E8%B4%A1%E7%8C%AE.md)。

## 相关仓

[filemanagement_app_file_service](https://gitcode.com/openharmony/filemanagement_app_file_service/blob/master/README_ZH.md)

[filemanagement_file_api](https://gitcode.com/openharmony/filemanagement_file_api/blob/master/README_zh.md)

[arkcompiler_cangjie_ark_interop](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/README_zh.md)

[hiviewdfx_hiviewdfx_cangjie_wrapper](https://gitcode.com/openharmony-sig/hiviewdfx_hiviewdfx_cangjie_wrapper/blob/master/README_zh.md)
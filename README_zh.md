# 文件管理仓颉接口

## 简介

文件管理仓颉接口是在OpenHarmony上基于文件管理子系统能力之上封装的仓颉API。文件管理子系统为OpenHarmony提供一套完整的文件数据管理解决方案，提供安全、易用的文件访问能力和完善的文件存储管理能力。当前开放的文件管理仓颉接口仅支持standard设备。

## 系统架构

**图 1**  文件管理仓颉架构图
![文件管理仓颉架构图](figures/filemanagement_cangjie_wrapper_architecture_zh.png)

- 文件IO接口：提供文件创建、访问和随机读写接口；
- 文件流接口：提供流式读写文件的能力接口；
- 文件锁接口：提供文件阻塞式、非阻塞式施加共享锁或独占锁，及解锁的能力接口；
- 文件信息接口：提供包括文件大小、访问权限、修改时间在内的基本统计信息接口；
- 应用文件URI接口：提供获取应用自己的URI接口；
- 仓颉文件管理FFI接口定义：负责定义C互操作仓颉接口，用于实现仓颉文件管理能力；
- 应用文件：为应用提供安全的沙箱隔离技术，保证应用数据安全基础上权限最小化；
- 基础文件：提供创建、修改及访问文件的能力。

## 目录

```
foundation/filemanagement/filemanagement_cangjie_wrapper
├── figures               # 存放README中的架构图
├── kit                   # 仓颉文件管理kit化代码
│   └── CoreFileKit       # 仓颉CoreFileKit实现
├── ohos                  # 仓颉文件管理接口实现
│   └── file              # 仓颉文件接口实现
└── test                  # 仓颉测试代码
```

## 约束

本地IO接口

-   目前仅支持UTF-8/16编码；
-   目前URI暂不支持外部存储目录。

## 使用说明

当前文件管理仓颉接口提供了以下功能：

- 基础文件访问能力；
- 文件信息获取能力；

与ArkTS相比，暂不支持以下功能：

- 存储管理功能；
- 公共文件功能；
- 分布式能力；
- 应用文件分享能力。

文件管理相关API请参见：

-   [ohos.file.fs（文件管理）](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_zh_cn/apis/CoreFileKit/cj-apis-file_fs.md)
-   [ohos.file.fileuri](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_zh_cn/apis/CoreFileKit/cj-apis-file_fileuri.md)

相关指导请参见[Core File Kit简介](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/Dev_Guide/source_zh_cn/file-management/cj-core-file-kit-intro.md)。

## 参与贡献

欢迎广大开发者贡献代码、文档等，具体的贡献流程和方式请参见[参与贡献](https://gitcode.com/openharmony/docs/blob/master/zh-cn/contribute/%E5%8F%82%E4%B8%8E%E8%B4%A1%E7%8C%AE.md)。

## 相关仓

[filemanagement_app_file_service](https://gitee.com/openharmony/filemanagement_app_file_service/blob/master/README_ZH.md)

[filemanagement_file_api](https://gitee.com/openharmony/filemanagement_file_api/blob/master/README_zh.md)

[cangjie_ark_interop](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/README_zh.md)

[hiviewdfx_cangjie_wrapper](https://gitcode.com/openharmony-sig/hiviewdfx_hiviewdfx_cangjie_wrapper/blob/master/README_zh.md)

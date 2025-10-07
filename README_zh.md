# 文件管理仓颉封装（beta特性）

## 简介

文件管理仓颉封装为OpenHarmony应用开发者提供了一套文件数据管理解决方案，提供安全、易用的文件访问能力和完善的文件存储管理能力的仓颉API。当前开放的文件管理仓颉接口仅支持standard设备。

## 系统架构

**图 1**  文件管理仓颉封装架构图
![文件管理仓颉封装架构图](figures/filemanagement_cangjie_wrapper_architecture_zh.png)

如架构图所示：

接口层说明：

- 文件管理API：提供基础文件操作能力，包括文件基本管理、文件目录管理、文件信息统计、文件流式读写等常用文件功能的仓颉公开接口声明。
- 文件URI API：提供通过PATH获取文件统一资源标志符（Uniform Resource Identifier，URI）的仓颉公开接口声明。

框架层说明：

- 文件管理封装：提供文件访问能力，如创建文件、删除文件、修改文件、获取文件信息、获取文件列表等。该封装层是基于文件访问接口对文件管理功能进行仓颉封装实现。
- 文件URI封装：提供获取应用自己的URI能力。该封装层是基于公共文件访问服务对文件URI功能进行仓颉封装实现。

仓颉文件管理服务依赖部件引入说明：

- 文件访问接口：提供可被文件管理仓颉接口调用的用于管理基本文件，管理基本目录，流式读取文件native能力实现。
- 公共文件访问服务：提供可被文件管理仓颉接口调用的文件分享和管理服务能力的native功能实现。
- cangjie_ark_interop：封装C语言互操作公共接口，并提供仓颉标签类实现用于对仓颉API进行标注，以及提供抛向用户的BusinessException异常类定义。
- hiviewdfx_cangjie_wrapper：负责提供日志接口，提供可被文件管理仓颉接口调用的在关键路径处打印日志能力的仓颉接口。

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
    └── file_uri                      # 文件URI测试
```

## 使用说明

当前文件管理仓颉封装提供了以下功能：

- 文件管理, 提供包含创建、删除、移动等文件基础操作、文件信息获取、文件信息设置功能，相关API详情请参考[文件管理 API](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_zh_cn/apis/CoreFileKit/cj-apis-file_fs.md)
- 文件URI，提供通过PATH获取文件统一标识符的能力，后续可通过使用文件管理对应接口进行相关open、read、write等操作。详情请参考[文件URI API](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_zh_cn/apis/CoreFileKit/cj-apis-file_fileuri.md)。

相关指导请参见[文件管理使用指导](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/Dev_Guide/source_zh_cn/file-management/cj-core-file-kit-intro.md)。

## 约束

-   文件管理接口目前仅支持UTF-8/16编码。
-   文件URI目前URI暂不支持外部存储目录。

与ArkTS提供的API能力相比，暂不支持以下功能：

- [端云同步管理功能](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-cloudsyncmanager.md)： 包括使能/去使能端云协同能力、修改应用同步开关，云端数据变化通知以及账号退出清理/保留云相关文件等。
- [目录环境功能](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-environment.md)：提供环境目录能力，获取内存存储根目录、公共文件根目录。
- [文件哈希处理功能](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-hash.md)：对文件内容进行哈希处理。
- [选择器功能](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-picker.md)：文件的选择和保存的功能。
- [数据标签功能](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-securityLabel.md)：提供文件数据安全等级的相关功能。
- [文件系统空间统计功能](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-statvfs.md)：提供文件系统相关存储信息的功能。
- [应用空间统计功能](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-file-storage-statistics.md)：对内外卡的空间查询、对应用分类数据统计的查询、对应用数据的查询等。
- [文件分享功能](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-core-file-kit/js-apis-fileShare.md)：提供文件分享能力。

## 参与贡献

欢迎广大开发者贡献代码、文档等，具体的贡献流程和方式请参见[参与贡献](https://gitcode.com/openharmony/docs/blob/master/zh-cn/contribute/%E5%8F%82%E4%B8%8E%E8%B4%A1%E7%8C%AE.md)。

## 相关仓

[filemanagement_app_file_service](https://gitcode.com/openharmony/filemanagement_app_file_service/blob/master/README_ZH.md)

[filemanagement_file_api](https://gitcode.com/openharmony/filemanagement_file_api/blob/master/README_zh.md)

[arkcompiler_cangjie_ark_interop](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/README_zh.md)

[hiviewdfx_hiviewdfx_cangjie_wrapper](https://gitcode.com/openharmony-sig/hiviewdfx_hiviewdfx_cangjie_wrapper/blob/master/README_zh.md)
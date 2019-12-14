# TreeEdit

Qml实现的树结构编辑器。

|功能|进度|
|--|--|
|树结构的缩进|完成|
|展开、折叠|完成|
|添加|完成|
|删除|完成|
|重命名|完成|
|搜索|完成|
|导入|计划中|
|导出|计划中|
|节点属性编辑|计划中|

## 原理

View 使用qml中的 Controls2 ListView

Model使用C++中的 QAbstractListModel子类

## 效果预览

![](preview.png)

## Qt版本

5.12.x

## CI

| [Windows][win-link]| [Ubuntu][ubuntu-link]|[MacOS][macos-link]|[Android][android-link]|[IOS][ios-link]|
|---------------|---------------|-----------------|-----------------|----------------|
| ![win-badge]  | ![ubuntu-badge]      | ![macos-badge] |![android-badge]   |![ios-badge]   |


[win-link]: https://github.com/JaredTao/TreeEdit/actions?query=workflow%3AWindows "WindowsAction"
[win-badge]: https://github.com/JaredTao/TreeEdit/workflows/Windows/badge.svg  "Windows"

[ubuntu-link]: https://github.com/JaredTao/TreeEdit/actions?query=workflow%3AUbuntu "UbuntuAction"
[ubuntu-badge]: https://github.com/JaredTao/TreeEdit/workflows/Ubuntu/badge.svg "Ubuntu"

[macos-link]: https://github.com/JaredTao/TreeEdit/actions?query=workflow%3AMacOS "MacOSAction"
[macos-badge]: https://github.com/JaredTao/TreeEdit/workflows/MacOS/badge.svg "MacOS"

[android-link]: https://github.com/JaredTao/TreeEdit/actions?query=workflow%3AAndroid "AndroidAction"
[android-badge]: https://github.com/JaredTao/TreeEdit/workflows/Android/badge.svg "Android"

[ios-link]: https://github.com/JaredTao/TreeEdit/actions?query=workflow%3AIOS "IOSAction"
[ios-badge]: https://github.com/JaredTao/TreeEdit/workflows/IOS/badge.svg "IOS"

## Reop

|[许可][license-link]||[已发布][release-link]|[下载][download-link]|下载次数|
|:--:|:--:|:--:|:--:|
|![license-badge]|![release-badge] |![download-badge]|![download-latest]|


[license-link]: https://github.com/jaredtao/TreeEdit/blob/master/LICENSE "LICENSE"
[license-badge]: https://img.shields.io/badge/license-MIT-blue.svg "MIT"
[release-link]: https://github.com/jaredtao/TreeEdit/releases "Release status"
[release-badge]: https://img.shields.io/github/release/jaredtao/TreeEdit.svg?style=flat-square "Release status"
[download-link]: https://github.com/jaredtao/TreeEdit/releases/latest "Download status"
[download-badge]: https://img.shields.io/github/downloads/jaredtao/TreeEdit/total.svg "Download status"
[download-latest]: https://img.shields.io/github/downloads/jaredtao/TreeEdit/latest/total.svg "latest status"

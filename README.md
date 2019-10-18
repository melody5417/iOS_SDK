# iOS SDK 从开发到发布

最近在做封装 SDK（Framework） 的工作，本篇文章将记录 iOS SDK 从开发到发布的具体流程，注意事项和经验总结。代码可在 [github链接](https://github.com/melody5417/iOS_SDK) 下载。

首先介绍下创建 SDK 工程以及对应 Demo 工程的具体流程。

## 创建 SDK 工程

### 创建 workspace，用以管理 SDK 和 Demo project

![创建workspace](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/1创建workspace.png)

### 创建 Cocoa Touch Framework，并加入到之前创建的 workspace 里

![创建 MFramework project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_2创建动态库.png)

![创建 MFramework project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_3创建framework project_1.png)

![创建 MFramework project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_4创建framework project_2.png)

### 更改工程设置

* 更改 Info -> development target 到目标系统版本
![创建 MFramework project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_5创建framewok project_3.png)

* 确认 Target -> Build Settings -> Mach-O Type 为 Dynamic
![配置工程信息](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_6framework 确认mac-o type.png)

* 更改 Target -> Build Settings -> Build Active Architchture Only 为 NO
![配置工程信息](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_7_1framework build active architecture.png)

* 更改 Target -> Build Settings -> Bitcode 为 NO
![配置工程信息](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_7_2framework bitcode.png "")

* 更改 Edit scheme -> Run -> Build Configuration 为 Release
![公开头文件](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-3_2 修改framework configuration.png)


### 配置公共头文件

* 添加测试代码
![公开头文件](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_8framework添加测试代码.png)

* 设置测试类的头文件 .h 为 public
![公开头文件](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_9framework添加public header_1.png)

* 在 MFramework.h 文件中引入所有公开的头文件
![公开头文件](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_10framework添加public header_2.png

## 创建 Demo 工程

### 创建 MDemo project，加入之前创建的 workspace。
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/3_1创建demo project_0.png)
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/3_2创建demo project_1.png)
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/3_3创建demo project_2.png)

### 更改 MDemo 工程设置
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/3_4创建demo project_3.png)
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/3_4创建demo project_4.png)
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/4工程全部创建完预览.png)

### 集成 SDK 测试
* 在 Target -> General 配置 Linked Framework 和 Embeded Binaries 为 MFramework
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/5_1demo添加embeded和link.png)

* 调用 MFramework 的测试代码，console 打印如预期
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/5_2demo调用sdk.png)


## 本地打包 手动发布

![创建target](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-1创建target.png)
![创建aggregate](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-2 创建 aggregate.png)
![6-3 创建aggregate 预览](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-3 创建aggregate 预览.png)
![6-3 创建aggregate 预览](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-3_2 创建aggregate 预览.png)
![6-3 创建aggregate 预览](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-3_3 创建aggregate 预览.png)
![6-4 设置 target dependencies](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-4 设置 target dependencies.png)
![6-5 创建build 脚本](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-5 创建build 脚本.png)
![6-5_2 创建build 脚本](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-5_2 创建build 脚本.png)
![6-6 build 模拟器版本的framework](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-6 build 模拟器版本的framework.png)
![6-6 build build镇机的framework](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-6 build build镇机的framework.png)
![6-7 build aggregate](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-7 build aggregate.png)
![6-8 适用真机及模拟器的framework](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-8 适用真机及模拟器的framework.png)
![6-9 framework集成到demo](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-9 framework集成到demo.png)
![](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/.png)
![](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/.png)

脚本代码

```
TARGET_NAME=${PROJECT_NAME}
OUTPUT_DIR=${SRCROOT}/Products/${TARGET_NAME}.framework
DEVICE_DIR=${BUILD_ROOT}/${CONFIGURATION}-iphoneos/${TARGET_NAME}.framework
SIMULATOR_DIR=${BUILD_ROOT}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework

if [ -d "${OUTPUT_DIR}" ]
then
rm -rf "${OUTPUT_DIR}"
fi

mkdir -p "${OUTPUT_DIR}"
cp -R "${DEVICE_DIR}/" "${OUTPUT_DIR}/"

lipo -create "${DEVICE_DIR}/${TARGET_NAME}" "${SIMULATOR_DIR}/${TARGET_NAME}" -output "${OUTPUT_DIR}/${TARGET_NAME}"

open "${SRCROOT}/Products"
```


## 持续构建 自动发布




## 版本号设置

## 文档 历史版本

## 归档哪些文件



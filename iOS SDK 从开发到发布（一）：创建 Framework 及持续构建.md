# iOS SDK 从开发到发布（一）：创建 Framework 及持续构建

本篇文章将记录 iOS SDK 从开发到发布的具体流程和经验总结。本文主要以图片形式展示，代码可在 [github链接](https://github.com/melody5417/iOS_SDK) 下载，本篇文章代码对应 **Tag 0.0.1**。

## 创建 SDK 工程

### 创建 Cocoa Touch Framework: MFramework
![创建 MFramework project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/1_1%E5%88%9B%E5%BB%BAframework%20project.png)

### 更改工程设置

* 更改 Info -> development target 到目标系统版本
* 确认 Target -> Build Settings -> Mach-O Type 为 Dynamic
* 更改 Target -> Build Settings -> Build Active Architchture Only 为 NO
* 更改 Target -> Build Settings -> Bitcode 为 NO
	
	![配置工程信息](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/1_2修改framework工程设置.png)


### 配置公共头文件

* 添加测试代码
![公开头文件](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_8framework添加测试代码.png)

* 设置测试类的头文件 .h 为 public
![公开头文件](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_9framework添加public%20header_1.png)

* 在 MFramework.h 文件中引入所有公开的头文件
![公开头文件](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_10framework添加public%20header_2.png)

## 创建 Demo 工程

### 创建 Demo 工程 并集成 MFramework

* 如图创建 Demo 工程。
* 配置 Demo 工程，关闭 bitcode。
* 将 MFramework 的 .project 拖入 Demo 工程中。
* 在 Target -> Build Phases 配置 Dependencies 添加 MFramework。
* 在 Target -> Build Phases 配置 Linked Framework 和 Embeded Binaries 添加 MFramework。


	![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/3_1创建Demo并集成Framework.png)

### 验证

* 调用 MFramework 的测试代码，console 打印如预期。

![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/5_2demo调用sdk.png)


## 本地打包 手动发布

* 更改 Edit scheme -> Run -> Build Configuration 为 Release
![公开头文件](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-3_2%20修改framework%20configuration.png)

创建 Cross-platform 的 Aggregate，执行 build 脚本，通过 lipo 命令将之前构建好的 **模拟器架构的 SDK 产物** 和 **真机架构的 SDK 产物** 合成 **适用于真机和模拟器的 SDK 产物**

* 创建 Cross-platform 的 Aggregate
![创建target](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-1创建target.png)
![创建aggregate](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-2%20创建%20aggregate.png)
![6-3 创建aggregate 预览](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-3%20创建aggregate%20预览.png)

* 修改 Configuration, 添加 Dependency 和 Build Script 
![6-3 创建aggregate 预览](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-3_3%20修改common%20configuration.png)
![6-4 设置 target dependencies](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-4%20设置%20target%20dependencies.png)
![6-5 创建build 脚本](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-5%20创建build%20脚本.png)
![6-5_2 创建build 脚本](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-5_2%20创建build%20脚本.png)

* 脚本代码

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
* 构建 MFramework 的模拟器产物
![6-6 build 模拟器版本的framework](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-6%20build%20模拟器版本的framework.png)

* 构建 MFramework 的真机产物
![6-6 build build镇机的framework](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-6%20build%20build镇机的framework.png)

* 构建 MFrameworkCommon，通过 Build Script 会产生 **支持模拟器和真机的 SDK 产物**。
![6-7 build aggregate](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-7%20build%20aggregate.png)
![6-8 适用真机及模拟器的framework](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-8%20适用真机及模拟器的framework.png)

* MDemo 工程集成 SDK 产物 MFramework.framework，添加 Embedded Binaries 和 Linked Frameworks.
![6-9 framework集成到demo](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/6-9%20framework集成到demo.png)

## 持续构建 自动发布

每次发布都手动打包，不仅繁琐，耗人工，而且容易出现遗漏甚至错误。下面介绍下如何达到持续构建和自动发布。在 workspace 根目录创建构建脚本 build.sh，命令行运行脚本 sudo ./build.sh, 则会在 workspace 根目录下创建 result 文件夹并生成目标产物。借助 **蓝盾** 等持续构建平台，则可以达到持续构建，自动发布，自动归档的完美操作。

* 目标产物预览
![7-1framework自动构建预览](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/7-1framework自动构建预览.png)

* 脚本代码

```
# 环境变量
#version=$MajorVersion"."$MinorVersion"."$FixVersion"."$BuildNo
#shortVersion=$MajorVersion"."$MinorVersion"."$FixVersion
version=2.3.4.5
shortVersion=2.3.4

xcworkspace="DevFramework"
scheme="MFramework"
configuration="Release"

WORKSPACE=`pwd`
RESULT_DIR=$WORKSPACE/result

# 清理工作区
rm -r ~/Library/Developer/Xcode/Archives/`date +%Y-%m-%d`/$scheme\ *.xcarchive
xcodebuild clean -workspace $xcworkspace.xcworkspace -scheme $scheme -configuration $configuration

# 更新版本号
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $version" $scheme/$scheme/Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $shortVersion" $scheme/$scheme/Info.plist

# 分别编译真机和模拟器的 framework
xcodebuild -workspace $xcworkspace.xcworkspace -scheme $scheme -configuration $configuration ONLY_ACTIVE_ARCH=NO -sdk iphoneos BUILD_DIR="$RESULT_DIR" BUILD_ROOT="${BUILD_ROOT}" clean build
if ! [ $? = 0 ] ;then
    echo "xcodebuild iphoneos fail"
    exit 1
fi

xcodebuild -workspace $xcworkspace.xcworkspace -scheme $scheme -configuration $configuration ONLY_ACTIVE_ARCH=NO -sdk iphonesimulator BUILD_DIR="$RESULT_DIR" BUILD_ROOT="${BUILD_ROOT}" clean build
if ! [ $? = 0 ] ;then
    echo "xcodebuild iphonesimulator fail"
    exit 1
fi

# 合并 framework，输出适用真机和模拟器的 framework 到 result 目录
cp -R "$RESULT_DIR/${configuration}-iphoneos/${scheme}.framework/" "$RESULT_DIR/${scheme}_${version}.framework/"
lipo -create "$RESULT_DIR/$configuration-iphonesimulator/${scheme}.framework/${scheme}" "$RESULT_DIR/${configuration}-iphoneos/${scheme}.framework/${scheme}" -output "$RESULT_DIR/${scheme}_${version}.framework/${scheme}"
if ! [ $? = 0 ] ;then
    echo "lipo create framework fail"
    exit 1
fi

```

## 版本号设置
Framework 一定要配置版本号的，这样方便用户（SDK使用者）接入合适目标版本，也有利于后期的定位问题和开发维护。
版本号格式推荐是 **主版本.特性版本.修正版本.持续构建build号**，具体如何配置可以参考上面的【持续构建 自动发布】。

## 上架 App Store
为了让用户（SDK使用者）可以进行模拟器和真机的开发调试，上述步骤生成的 SDK 包含了4个架构: **i386**  **x86_64**  **armv7** **arm64**。其中 **i386**  **x86_64** 是Mac处理器的指令集，运行模拟器的架构，在提交 App Store 时需要移除。

![8-1开发版本](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/8-1开发版本.png)

![8-2appstore版本](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/8-2appstore版本.png)


```
# TARGET 代表framework的名字

cd TARGET.framework # 跳转到 framework 目录

lipo -archs TARGET   # 查看framework支持的架构

lipo TARGET -thin armv7 -output TARGET_armv7 # 输出 armv7 架构

lipo TARGET -thin arm64 -output TARGET_arm64 # 输出 arm64 架构

lipo -create TARGET_armv7 TARGET_arm64 -output TARGET # 合并 armv7 和 arm64 架构
```

这个脚本也可以放到 build.sh 中，这样可以一次构建同时出 开发版 和 发布版，避免了手动操作可能引入的问题，同时达到持续构建 自动归档的目标。

## 交付 List

这是在实际交付时后补的章节，因为 **交付 List** 真的非常重要。 在我实际开发 SDK 交付给用户（SDK调用方）时，由于交付流程**手动操作比较多，很容易引入遗漏甚至错误**。比如说 具体交付哪些文件，文件是否为最新版本，怎么接入SDK等。

基于此，最后我**将 SDK 的开发，测试和交付都集中到蓝盾统一管理**。
主要的操作是将上述几个步骤的操作统一到 build.sh 脚本构建，产物具体包括：

	* SDK 的 Dev 版本
	* SDK 的 Store 版本
	* Demo 工程源码
	* 接入手册文档
	* 版本历史文档

这样能确保 开发，测试和交付三方 代码功能的一致性，交付文档的完整性以及持续构建和自动归档。
## 结语
看到这里，iOS SDK 开发到发布的基本流程都已走通。当然 SDK 的开发工作远不止这些，更多的坑和经验还要靠各位大佬总结和分享，hhhh，就先到这里啦～

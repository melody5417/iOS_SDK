# iOS SDK 从开发到发布（二）：Framework 部署到 CocoaPods

在 **[iOS SDK 从开发到发布系列一]()** 中介绍了如何创建 Framework， 打包支持模拟器架构，支持真机架构的版本，以及持续构建。

然而系列一文章的产物是 Framework，iOS更常用的依赖管理工具是CocoaPods。 本文系列一基础之上介绍如何将 Framwork 部署到 CocoaPods。代码可在 [github链接](https://github.com/melody5417/iOS_SDK) 下载，本篇文章代码对应：

* **Tag 0.0.2** pod发布采用 source code 方式
* **Tag 0.0.3** pod发布采用 framework 方式
* **Tag 0.0.4** pod source 拉取 zip，不依赖 github

## 创建 podspec 文件
在 git repo 的根目录下创建 **podspec** 文件。

```
$ pod spec create MFramwork

Specification created at MFramwork.podspec

``` 

这里附上 MFramework 的 podspec 供参考，podspec的具体语法可以参考[官方](https://guides.cocoapods.org/syntax/podspec.html)。

这里如果开源代码则可以把源代码文件上传到公有repo，然后配置 spec.source_files。

如果因为某种限制不想开源代码，可以先打包成 Framwork 然后配置 spec.vendored_frameworks。

MFramwork 实现了 **开源代码** 和 **framework** 两种出包方式。

```
Pod::Spec.new do |spec|
  spec.name         = "MFramework"
  spec.version      = "0.0.3"
  spec.summary      = "Demo of Deploy MFramework."
  spec.description  = <<-DESC
                        Deploy MFramework to Cocoapods
                      DESC
  spec.homepage     = "https://github.com/melody5417/iOS_SDK"
  spec.license  		= 'MIT'
  spec.author       = { "melody5417" => "lengningshang@126.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/melody5417/iOS_SDK.git", :tag => "#{spec.version}" }
#  spec.source       = { :http => 'https://dldir1.qq.com/invc/tt/translator/HistoryData/MFramework.framework.zip' }
  spec.source_files = "source/MFramework/MFramework/*.{h,m}"
  spec.vendored_frameworks = "MFramework.framework"
end
```
这里需要注意几点：

* podspec 的路径建议是 repo 的根目录
* license 文件建议和 podspec 同路径，默认名 LICENSE
* source 方式支持 git， http等。 
* source_files 的路径是相对于 podspec 文件的相对路径
* vendored_frameworks 的路径建议和 podspec 同级
* vendored_frameworks 必须同时支持模拟器和真机，确认方法：

	```
	$ lipo -archs MFramework.framework/MFramework
	i386 x86_64 armv7 arm64
	```

## 校验 podspec 文件

### pob lib lint 检查
编写完 podspec 后执行 ```pod lib lint``` 检查文件的正确性。如果以上几点错误，本地 ```pod lib lint```检查语法时可能不会报错，但在最后发布到 CocoaPods 时可能会收到如下报错，别问我怎么知道的。。。。

```
pod trunk push MFramework.podspec
Updating spec repo `trunk`
Validating podspec
 -> MFramework (0.0.2)
    - ERROR | [iOS] file patterns: The `source_files` pattern did not match any file.
    - ERROR | [iOS] file patterns: The `vendored_frameworks` pattern did not match any file.
    - WARN  | [iOS] license: Unable to find a license file

[!] The spec did not pass validation, due to 2 errors and 1 warning.
```

### 本地 MDemo 集成 MFramework.podspec
podspec本地校验成功后就可以集成到 demo 工程中，进一步验证。
进入MDemo路径，创建 **podfile** 文件:

```
# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!


target 'MDemo' do
    pod 'MFramework', :path => '../../'
end
```
执行 ```$pod install```, 运行 MDemo 确认 MFramework 成功集成。

## 发布 podspect 文件

### 注册 pod trunk 用户
```
$ pod trunk register email@mail.com 'Author' --description='desc' --verbose


opening connection to trunk.cocoapods.org:443...
opened
starting SSL for trunk.cocoapods.org:443...
SSL established, protocol: TLSv1.2, cipher: ECDHE-RSA-AES128-GCM-SHA256
......
Conn keep-alive
[!] Please verify the session by clicking the link in the verification email that has been sent to email@mail.com

```
注册后如命令行提示的，会发送验证邮件，点击确认即注册成功。

```$ pod trunk me ``` 可以查看自己的注册信息。
### 发布 pod
```
$ pod trunk push MFramework.podspec
Updating spec repo `trunk`
Validating podspec
 -> MFramework (0.0.2)
    - NOTE  | xcodebuild:  note: Using new build system
    - NOTE  | [iOS] xcodebuild:  note: Planning build
    - NOTE  | [iOS] xcodebuild:  note: Constructing build description
    - NOTE  | [iOS] xcodebuild:  warning: Skipping code signing because the target does not have an Info.plist file and one is not being generated automatically. (in target 'App' from project 'App')
    - NOTE  | [iOS] xcodebuild:  note: Execution policy exception registration failed and was skipped: Error Domain=NSPOSIXErrorDomain Code=1 "Operation not permitted" (in target 'MFramework' from project 'Pods')
    - NOTE  | [iOS] xcodebuild:  note: Execution policy exception registration failed and was skipped: Error Domain=NSPOSIXErrorDomain Code=1 "Operation not permitted" (in target 'Pods-App' from project 'Pods')
    - NOTE  | [iOS] xcodebuild:  note: Execution policy exception registration failed and was skipped: Error Domain=NSPOSIXErrorDomain Code=1 "Operation not permitted" (in target 'App' from project 'App')

Updating spec repo `trunk`

--------------------------------------------------------------------------------
 🎉  Congrats

 🚀  MFramework (0.0.2) successfully published
 📅  April 7th, 00:49
 🌎  https://cocoapods.org/pods/MFramework
 👍  Tell your friends!
--------------------------------------------------------------------------------
```
这里需要注意的几点：

* 提交时需要先建立有效的 pod session，即注册 pod trunk 用户。
* 可以用 ```$ pod search MFramwork```搜索发布的pod
* 如果搜索不到，执行 rm ~/Library/Caches/CocoaPods/search_index.json删除缓存索引再次尝试。

## 进阶：配置 podspec 支持 source 和 framework 灵活切换
开发或者调试时，为了查看源代码，可以配置环境变量来区分两种编译效果

```
Pod::Spec.new do |spec|
  spec.name         = "MFramework"
  spec.version      = "0.0.3"
  spec.summary      = "Demo of Deploy MFramework."
  spec.description  = <<-DESC
                        Deploy MFramework to Cocoapods
                      DESC
  spec.homepage     = "https://github.com/melody5417/iOS_SDK"
  spec.license          = 'MIT'
  spec.author       = { "melody5417" => "lengningshang@126.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/melody5417/iOS_SDK.git", :tag => "#{spec.version}" }

  // 没有设置环境变量，默认采用 framework 集成
  if ENV['USE_SOURCE'] == "1"
    puts 'Pod Install MFramework Source'
    spec.source_files = "source/MFramework/MFramework/*.{h,m}"
  else
    puts 'Pod Install MFramework Framework'
    spec.vendored_frameworks = "MFramework.framework"
  end
end
```

## 清理和重置 pod 

```
// 清空 pod 本地缓存
$ pod cache clean --all 		# will clean all pods
$ pod cache clean ‘XXX' --all 	# will remove all installed 'XXX' pods


// 重置 pod
$ rm -rf ~/Library/Caches/CocoaPods
$ rm -rf Pods
$ rm -rf ~/Library/Developer/Xcode/DerivedData/*
$ pod deintegrate
$ pod setup
$ pod install
```




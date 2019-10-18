# iOS SDK 从零到发布
本篇文章将记录开发iOS SDK 从零到发布的具体流程，注意事项和经验总结。

首先介绍下如何创建sdk以及对应的demo应用。
## sdk创建
1. 创建workspace，取名DevFramework
![创建workspace](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/1创建workspace.png)

2. 创建动态链接库，并加入到之前创建的DevFramework workspace里
![创建 MFramework project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_3创建framework project_1.png "创建 MFramework project")
![创建 MFramework project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_4创建framework project_2.png "修改addto及group信息")
![创建 MFramework project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_5创建framewok project_3.png "MFramework project预览")

3. 配置工程信息
![配置工程信息](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_6framework 确认mac-o type.png "确认Mach-o Type")
![配置工程信息](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_7_1framework build active architecture.png "")
![配置工程信息](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_7_2framework bitcode.png "")

4. 公开头文件
![公开头文件](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_8framework添加测试代码.png "")
![公开头文件](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_9framework添加public header_1.png "")
![公开头文件](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/2_10framework添加public header_2.png "")

## demo创建
1. 创建MDemo project
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/3_1创建demo project_0.png "")
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/3_2创建demo project_1.png "")
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/3_3创建demo project_2.png "")
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/3_4创建demo project_3.png "")
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/4工程全部创建完预览.png "")

2. 链接SDK并调用
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/5_1demo添加embeded和link.png "")
![创建MDemo project](https://raw.githubusercontent.com/melody5417/iOS_SDK/master/resource/5_2demo调用sdk.png "")

以上代码可在 [github链接](https://github.com/melody5417/iOS_SDK) 下载。

## 本地打包 手动发布

## 持续构建 自动发布
1. 蓝盾证书管理
2. 脚本修改
## 版本号设置
## 文档 历史版本
## 归档哪些文件



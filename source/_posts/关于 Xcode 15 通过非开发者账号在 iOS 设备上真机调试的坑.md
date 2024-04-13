---
title: 关于 Xcode 15 在 iOS 设备上真机调试的坑
date: 2024-03-05 19:20:01
author: Zhonjc
tags:
---
## 结论

首先，给出结论：至今（2024.3.5）为止，Xcode 仍然允许非开发者账号（免费账号）在真机上运行你开发好的 App。

## 坑 0：选择了 CloudKit 和 Mac

- 起初无法签署，以为是


## 坑 1：免费账号签署的限制

- Xcode 可以通过免费账号让你的 App 被签署，并安装在你的 iOS 设备上来进行调试。但是这是有限制的。
- Xcode 会在你使用免费账号签署时，自动创建一个名叫 Xcode Managed Profile 的 Provision Profile。它有 7 天的有效期。毕竟只是调试。
- 如果你使用免费账号部署你的 App 到你的真机上，一般可能会出现 2 条错误，即![](/images/截屏2024-03-05%2019.33.12.png)
- 免费的 Provision Profile 有以下 3 个不允许 App 调用的功能，或者说服务：
	- In-App Purchase(IAP) 即应用内购
	- iCloud 相关的云存储
	- Push Notifications 通知推送
- 以上这三个服务，似乎默认都是关闭的。坑就坑在两点：
	1. 我在创建项目时，选择了 CloudKit 来存储数据
	2. 我在创建项目时，选择了 3 个平台：Mac、iPhone、iPad
- 也就是说，如果你想用免费的证书让你的 App 运行在真机上，你必须砍掉以上三个功能。
- 砍掉的方法很简单，只需要在 TARGETS -> 你的应用 -> Signing & Capability 页面中，在对应功能栏最右侧点击 删除 图标即可
- ![](/images/截屏2024-03-05%2019.30.56.png)

## 坑 2：删不掉的 Push Notifications

- iCloud
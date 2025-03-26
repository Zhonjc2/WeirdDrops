---
title: 关于 IPv6 实现公网访问的探索与应用
date: 2025-03-26 13:19:42
author: Zhonjc
tags: 
description: 既然有了公网地址，那岂不是……
---
<span style="color: red; font-size: 1.5rem; font-weight: 900; ">来自作者：文件可能有错误，请注意甄别</span>

猛然发现现在 IPv6 已经成为了可靠的公网访问内网的方案。运营商为每一个家庭网络分配了高达 64 位的地址号，可以有 $2^{64}$ 个主机同时以公网地址的身份连接到互联网。

## 工具

- 使用 tail -f 来事实跟踪更新的文件内容
- 使用 mkdir -p 来直接创建整条路径文件夹
- 使用 apachectl -t 来检查配置文件语法
- 使用 cd - 回到上一个工作目录
- 原来  Obsidian 可以按块缩进，然后代码块就可以完美的放在列表内了
- 如果服务通过 restart 来重启，发现一些更改没有生效，那就尝试先 stop 再 start。在 apachectl 中 restart 后，DAV 配置不知为何不会生效，需要 stop 再 start。
- 要注意，macOS 默认不允许三方软件访问外部磁盘，因此如果要通过 Apache WebDAV 等实现对外部磁盘的访问，需要在 macOS 的设置-隐私中，在完全磁盘访问权限中，增加 /usr/sbin/httpd 来实现外部磁盘访问。
- 对于其他用户（例如用于运行 Apache 服务器的 \_www 用户），lsof 可能检测不出其端口。此时只需要 sudo 即可。
- vim 
	- 删除当前字符 x 
	- 回到行首 0
## 疑问与解答

- 一般家庭网络的 IPv6 地址的网络号为前 64 位。同时，运营商并**不会**为家庭网络分配真正静态的 IPv6 地址，也就是说，其地址中的网络前缀是动态的。何时动的？事实上，我曾经固定了我笔记本的 IPv6 地址，并绑定到了域名，因为不会也懒得弄 DDNS，所以就暂时不折腾了。之后，由于有些事情笔记本带了出去，持续了几天，回来之后发现，域名解析还是正常的，但是之前固定的 IPv6 地址已经不可达了。后来才发现并意识到，在这几天期间，**光猫与路由器**被重启过。在这个时候，ISP 会为我的家庭网络重新分配 IPv6 地址，此时网络号已经发生了变化，原先固定的 IPv6 地址已经不可用了，或者成了别人家的了。
- 你当然可以将自己的设备的 IPv6 地址设置为固定的，然后配合 DNS 实现公网便捷访问。但是重启网络设备会重新分配网络号，会导致之前固定的不可用。因此配合 DDNS 是最优解。

## 实现 HTTP 服务器

- 实际上，这似乎是做不到的，因为 ISP 不让家用宽带监听 80/443 端口。
## 在家用电脑上实现 WebDAV 服务器

> 参考自 https://blog.csdn.net/weixin_34258078/article/details/93450486 与  ChatGPT

- 才发现，经常在镜像源看到的简陋文件页面竟然就是 Apache 提供的 WebDAV 服务器。
- 买了个 Apple TV，但是没有资源，也没有订阅钱，更没有 NAS 钱，所以吃灰了。打算卖掉，但是在卖之前，突然想到既然 Apple TV 插不了存储盘，为什么不用本地服务器呢？
- 在 Mac 上实现 Apache WebDAV 服务器
	- macOS 已经预装了 Apache 服务器，只需要开启和配置 WebDAV 模块即可
	1. 进入 /etc/apache2
	2. 编辑 httpd.conf 配置文件，将 WebDAV 启用 
		1. `sudo vim httpd.conf`
		2. 查找 httpd-dav.conf ，命令模式下输入`/httpd-dav`
		3. 将 `#Include /private/etc/apache2/extra/httpd-dav.conf` 注释移除
		4. 分别查找 `dav_module`、`dav_fs_module`、`auth_digest_module`，然后将其 LoadModule 前的注释移除
			- `LoadModule dav_module libexec/apache2/mod_dav.so`
			- `LoadModule dav_fs_module libexec/apache2/mod_dav_fs.so`
			- `LoadModule auth_digest_module libexec/apache2/mod_auth_digest.so`
		5. 保存并退出（:wq）
	3. 创建自己的 WebDAV 资源目录
		1. `sudo mkdir -p 你想创建的 WebDAV 目录`
		2. `sudo chown -R 你的用户名:_www 你想创建的 WebDAV 目录`
		3. `sudo chmod -R 755 你想创建的 WebDAV 目录`
	4. 创建专用于 WebDAV 的用户与密码
		- `sudo htpasswd -c /etc/apache2/webdav.passwd zhonjc`
	5. 进入 /etc/apache2/extra
	6. 编辑 httpd-dav.conf，配置 WebDAV
		1. sudo vim httpd-dav.conf
		2. 在配置文件中给出的默认的 uploads 目录后，新增自己的目录
			```xml
			Alias /webdav "/Users/zhonjc/WebDAV"
			# /webdav 就是之后访问 WebDAV 的路径
			
			<Directory "/Users/zhonjc/WebDAV">
			        Dav On
			        AuthType Basic
			        AuthName WebDAV-Security
			        AuthUserFile "/etc/apache2/webdav.passwd"
			        # 输入刚刚创建的用户密码文件
			        AuthDigestProvider file
			        AllowOverride None
			        Options Indexes FollowSymLinks
			        Require valid-user
			</Directory>
			```

	7. 重启 Apache
		- `sudo apachectl stop`
		- `sudo apachectl start`
	8. 然后就可以访问 localhost/webdav 了

<!-- ## 实现文件服务器 -->


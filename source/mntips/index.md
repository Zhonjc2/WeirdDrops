---
title: mntips
date: 2023-07-17 23:47:17
layout: wiki
menu_id: mntips
---
hexo generate 前，记得在本地安装 Pandoc。

### load 监听器是专为 img 等资源元素准备的，不适用于背景图像的加载完成。

### 为什么我设定的不蒜子访客总数和访问总数一样？？？？

### DNS解析只对应IP，不对应端口。

### 进行更新：使用 Nginx 反向代理

- 为了让三级及以上域名能够映射到同一个服务器的不同端口上，使用 Nginx 监听不同端口的请求，并将请求反向代理到服务器上的不同端口的服务上。
- Nginx 监听 80 端口。这是必须的，因为 HTTP 协议默认为 80 端口，没有人会在域名后面跟个指定端口来访问站点的。对于 HTTPS ，本站点使用 Cloudflare 的 HTTPS 加密，在 Nginx 配置内直接当做非 HTTPS 配置即可。
- Nginx 可以为不同的 服务器名称（server_name）来反向代理到不同的 目标地址 。
- 之前的 Hexo 博客是在 80 端口监听的，我们通过二级域名 zhos.tech 进行访问（我配置了Cloudflare 页面规则，会将其转到三级域名 \www.zhos.tech）。现在将其更改为 4000 。并在 Nginx 配置监听 80 端口的 zhos.tech ，并反向代理到 \http://localhost:4000 。这样就处理好了二级域名的目标地址，Nginx 会将 服务器 4000 端口 的服务呈现到浏览器上。
- 接下来，就可以随心所欲配置 三四五六七八甚至九级域名了（应该没有这么高的）。
- 现在配置三级域名 gvp.zhos.tech 映射到 Nginx 的 Web 静态目录。
```
server {
	listen 80;
	server_name gvp.zhos.tech;
	location / {
		root html;
		index index.html;
	}
}
```

- Nginx 的原理到底是什么呢？为什么它能做到在 DNS 解析域名，指向服务器之后，Nginx 将其他服务器的服务提供给浏览器呢？
- 使用 Nginx 便可以做到将各种各样的三级及以上域名分配到同一服务器的各种端口中的服务。
- 我发现 Nginx 最核心的地方，就是配置文件的写法……
- Nginx 配置文件的常规写法：

```nginx
http {

	# 一个 server 就代表一个独立的服务

	server{
		listen xxx;
		server_name xxx.cn www.xxx.cn xxx.com
		location / {
			# 反向代理到其他链接
			proxy_pass http://localhost:4000
		}
	}

	server{
		listen xxx;
		server_name xxx.xxx.cn xxx.xxx.com
		location / {
			# 将 Nginx 的 html 目录作为 Web 服务器根目录
			root html
			index index.html
		}
	}

	server{
		listen xxx;
		server_name xxx.xxx.xxx.cn xxxx.xxx.com
		location / {
			# 将 Nginx 的 html 目录下的 libm 作为 Web 服务器根目录
			root html/libm
			index index.html
		}

		location /static/ {
			# 配置 该 Web 服务需要的资源文件夹
			root html
			# 似乎 Nginx 匹配到 location 后，会将 匹配的部分 也作为目标路径的一部分，例如在这里，Nginx 找的就是 html/static/ ，这不是配置路由。也就是说，root 指的是 匹配的路径 的根目录位置。与之相对的可能是 alias 。
			# 注意：location 可以嵌套
		}
	}
}
```

- https://www.wpdaxue.com/too-many-redirects.html
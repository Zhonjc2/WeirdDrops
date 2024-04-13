---
title: 图片负载测试
date: 2023-08-18 15:24:41
author: Zhonjc
categories: 
- 测试
tags: []
description: 使用了 Cloudflare CDN 对本博客进行加速，对媒体加载速度做一个测试。
---

- 一直不太理解 CDN 的原理。按照网上的解释，CDN 会将服务器内容自动缓存到世界各地，那也太费资源了。而且，如果离我最近的服务器就是我服务器本身，那 CDN 是不会缓存到离我最近的其他服务器的吗？好像并不是。我服务器是小水管，经过 CDN 加速后，即使是离源服务器很近的用户进行访问，图片加载速度也会大幅提升。
- 突然知道了 Cloudflare CDN 服务器在国外，加上以后，网站可能会更慢......

![经过 ESRGAN 4 倍放大的插画，大小 33.3MB](/images/IMG_6746_esrgan_anime_4x.png)

![插画（6.8MB）](/images/ysz-12.jpeg)

![](/images/ysz-13.jpeg)

![](/images/ysz-14.jpeg)

![](/images/ysz-15.jpeg)

![](/images/ysz-16.jpeg)

![](/images/ysz-17.jpeg)

![](/images/97801492_p0.jpg)

![](/images/85765309_p0.jpg)
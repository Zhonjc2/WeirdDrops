title: 欢迎来到 怪奇语录
date: 2023-07-13 21:35:50
top: true
tags:
---
## 你好！
<!--more-->

我是 Zhonjc 。
欢迎来到我的博客，这里记录一些灵感、笔记、认知、想法等等。

### 怪奇语录，为什么是怪奇？

实际上，我在为网站做 ICP 备案之前，网站的名字就是简单的一个 Zho's Blog 。网站备案对名字要求很高，必须包含中文。最好不要包含英文、名称、博客字样等等。为此，我就想到了一个在高中就想到的名字，叫做 “怪奇法则” ，实际上里面的内容就是一些不常见的、需要用特别解法的 怪数学题 。但是这个名字没有过华为云到初审，因为有 法则 字样，具有权威的意向。这才改成 “怪奇语录” 。

### 怪奇语录使用了什么框架和主题？

博客使用了 [Hexo 静态博客框架](https://hexo.io/zh-cn/)。之前尝试过 WordPress ，但是，怎么说呢，有点臃肿，而且服务器是最低配运行起来卡卡的，内存常年 100% ，CPU 也差不多。

主题使用了 [Stellar](https://github.com/xaoxuu/hexo-theme-stellar) ，并在其基础上做了一些个性化，因为我想有插画背景，但是这个主题没有做这个设计。直接加上背景非常丑，为此我在背景上加了 blur 效果和 saturate 效果，又在之上加了一层半透明。做完了之后发现在夜间模式还好，正常模式下有点廉价感。之后将背景的透明度降低到 0.2 。这个时候背p景呈现出类似 Windows 11 的窗体的 Mica 效果，可以看到插画背景的色彩过渡。

插画背景来自一个随机二次元插画 API ：[二次元随机图片API](https://t.mwm.moe) ，这个 API 经过备案，且为 HTTPS  。注意，即使你网站本身是 HTTPS 协议，网站内容包含来自非 HTTPS 协议的响应，也会导致网站被认为不安全。![Safari 在控制台的不安全警告](/images/截屏2023-08-18%2015.47.37.png)



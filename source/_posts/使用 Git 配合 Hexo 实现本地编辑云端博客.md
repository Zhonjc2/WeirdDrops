---
title: 使用 Git 配合 Hexo 实现本地编辑云端博客
date: 2023-08-09 16:50:23
author: Zhonjc
tags: []
description: 使用 Git 云端仓库 配合 Hexo 实现本地编辑云端博客。
---

**注意：该文章内容可能存在错误。**

- 本博客尚未配置 CDN ，图片可能加载较慢。

使用 Git 云端仓库 配合 Hexo 实现本地编辑云端博客。

起初，使用自己的云服务器，配置了 Hexo 博客。然而 Hexo 有一个很不好的点，就是新增和编辑博客非常麻烦。一开始想通过 SSH 来实现实时同步，同时使用 Obsidian 来对博客目录进行操作。然而，Obsidian 并不支持使用自己的 SSH 服务器，也没有支持的插件。VSCode 可以，但是并不想用 VSCode 来编写 MarkDown 文件，因为其没有实时预览。后面又想到使用 macOS 的访达连接 FTP 服务器，但是不知道为什么 macOS 抽风，FTP 一直连不上，SMB 也连不上，实际上，我从来没成功用访达连接成功过任何云服务器。

后来没有办法，只能使用 Hexo Admin 凑活用。

后来想到了 Git 。Git 是一种版本控制工具，它本不是用来进行文件同步的，而是进行分布式开发的。但是，我们可以利用 Git 的远程仓库，以及 Crontab 自动执行命令，自动拉取更新，来实现客户端编辑好后 push ，云端工作目录自动 pull ，从而更新博客。

## Git 部分

- 注意区分 Git 仓库和 Obsidian 仓库。该章节下所有仓库指的都是 Git 远程仓库，Obsidian 仓库在此章节下说明为 Obsidian Vault 。
### 创建裸远程仓库

- 对于远程仓库，一般创建的都是裸仓库。因为我们没有必要在远程仓库内部对仓库内容进行更新，这是专用于客户端工作目录进行操作的仓库。
- 关于裸远程仓库，可以看看我的关于 Git 的博客：[Git 使用提醒](/_posts/Git%20使用提醒.md)
- 创建仓库的位置最好放在博客目录外，仓库名设置为 source.git ，这是为了在 Hexo 中 clone 名字为 source 的仓库，source 即 Hexo 博客的内容。其他名称无法将博客内容 add 到仓库中。

`git init --bare source.git`

### 移出 Hexo 博客内容（source 目录）

- 之前已经在 Hexo 中发布过一些内容。因为我们要将这些内容添加到新仓库中，唯一的做法就是先把原先内容（整个 source 目录）移出到其他目录下，然后在 Hexo 目录下 clone 一个名叫 source 的仓库，再将原博客内容移入。

`mv hexo/source hexo/backup_source`

### 在云端的 Hexo 博客根目录下通过 clone 创建新的 source 目录

- 将刚刚创建的云端仓库，在云端服务器的 Hexo 博客目录下，进行 clone ，创建新的 source 目录。

`git clone source.git`

### 将原先的 source 目录内容移入新 source 目录

`mv hexo/backup_source/* hexo/source/`

### 使 source 下的文件被 Git 追溯

`git add .`

### 提交并推送

`git commit -m 'init'`
`git push`

### 配置服务端自动拉取更新

- 这里采用的方法是 Crontab ，实际上这个方法个人觉得不是太适合。

`crontab -e`
然后编写：
`*/1 * * * * cd 你的source工作目录;git pull`
保存并退出

## Obsidian 部分

### 在客户端 clone 云端仓库

`git clone 用户@IP地址:source.git远程仓库位置`

- 注：需要提前配置好 SSH 及其免密登陆，以及专用于更新博客的 Git 用户。

### 用 Obsidian 打开 clone 好的工作目录

![ File - Open Vault ](/images/截屏2023-08-09%2017.05.27.png)
![选择打开，选择刚刚 clone 好的工作目录](/images/截屏2023-08-09%2017.05.49.png)
![进入 Obsidian](/images/截屏2023-08-09%2017.07.28.png)


### Obsidian 安装 Obsidian Git 插件 简化客户端博客推送流程

- Obsidian 有一个第三方插件，叫 Obsidian Git，该插件在 Obsidian 内置了 Git 命令。
- 只需要打开的 Obsidian Vault 为一个正常的 Git 工作目录（包含 .git 文件夹），就可以直接使用这个插件执行 git 命令。
- 似乎这个插件没有 git add，而直接 git commit 便可以。

![](/images/截屏2023-08-09%2017.15.26.png)

- 当博客内容有新变化时，便可以按下 Command + P 打开 Obsidian 命令面板，输入 git commit 查找到该插件的操作，回车即可。![](/images/截屏2023-08-09%2017.16.42.png)
- 推送时和 commit 一样。![](/images/截屏2023-08-09%2017.17.49.png)

### 创建笔记模版

- 来自 https://segmentfault.com/a/1190000042111566?sort=newest
- 为了在 Obsidian 创建笔记时，方便添加 Hexo 的 Front-matter，可以在 Obsidian 中创建模版。
- 在本地工作目录下，创建 \_obsidian 目录，并在目录下新建 Post Template 文件，格式为 md 。最好在 Obsidian 内新建该文件。在文件内添加内容：
```
---
title: {{title}}
date: {{date}}
author: 你的作者名称
tags: []
---
```
- 然后进入 Obsidian 设置 - 核心插件 - 模版 将其打开，然后点击切换按钮旁的设置按钮，进入模版设置。
- 在模版设置下，将相关设置改为：
	- 模版文件夹位置内容为 \_obsidian
	- 日期格式为 YYYY-MM-DD HH:mm:ss
	- ![](/images/截屏2023-08-09%2017.25.14.png)

- 之后新建新博客时，只需要点击 Obsidian 侧边栏的 插入模版 按钮即可。![](/images/截屏2023-08-09%2017.27.16.png)

### 修改 Obsidian 媒体链接格式

- Obsidian 默认拖入的媒体文件，在笔记内的链接格式是 Wiki 链接。
- 为了 Hexo 主题进行正确识别媒体链接，需要将 Obsidian 设置中的 使用 Wiki 链接 关闭。![](/images/截屏2023-08-09%2017.38.16.png)

### 修改 Obsidian 的附件默认存放路径

- Obsidian 默认新添加的附件存储在 Obsidian Vault 的根目录，我们需要将附件文件夹路径修改为 Hexo 的附件位置。
- 除此之外，还需要将 内部链接类型修改为 基于仓库根目录的绝对路径。![](/images/截屏2023-08-09%2017.38.16.png)
- 现在，你可以直接将本地的附件，粘贴到 Obsidian 笔记中，Obsidian 会自动将附件复制到附录文件夹下，并在笔记中给出正确的链接路径。
- 但是，Obsidian 给出的链接路径，在 Hexo 中无法找到，需要在链接头部多加一个 '/' 才能在 Hexo 中正确找到。
- ![](/images/截屏2023-08-09%2017.51.13.png)


## 目前状态

- 目前的体验还不错，但是还有一些问题：
	- Crontab 每隔一分钟拉取，每次推送完得等一等才更新，在未来或许可以使用 Git 远程仓库自带的 Hooks 来实现即时 pull ；
	- Obsidian 新添加的附件，在经过相关设置后，笔记内的附件链接几乎完美，但是有一个缺点就是需要在链接头部加一个 '/'，要不然 Hexo 找不到，这个经常忘记 😓。
	-  ![](/images/截屏2023-08-09%2017.53.34.png)
title: MySQL 8 配置指南
author: Zhonjc
description: 之前安装 MySQL 8 时遇到的坑太多了。但实际上，正规的安装流程很简单，关键就在于找到 MySQL 自动生成的密码。
tags:
  - MySQL
  - MySQL 8
  - Linux
  - 运维
date: 2023-07-14 17:27:24
cover: /images/back.jpeg
banner: coding
categories:
- 笔记
poster:
  headline: MySQL 8 配置指南
  caption: MySQL 5 和 8 装起来到底有什么区别？
  color: white
---

### 通过mysqld命令开启mysqld服务：
1. ps -ef |grep mysqld 查看进程，先 kill 掉所有的 mysql 相关进程
2. 先使用 mysqld —user=root 命令，此时该命令窗口被 mysqld 占用，无法使用
3. 新建 SSH 连接，用新的窗口使用 mysql 命令。

### 通过service mysqld start命令启动mysqld服务：
1. 先kill掉所有mysqld服务
2. 注意要看日志
3. 可能出现没有权限的情况，

注意：如果在 root 用户下，使用 mysqld 命令启用 MySQL 服务，则会导致产生一些所有者为 root 的文件，这就会导致以后若通过 service mysqld start 来启动 MySQL 服务时，会爆出 Permission Denied 的错误（MySQL 以用户 mysql 的身份来执行任务）。解决方法也很简单，只需要找到 MySQL 的日志文件，找到报错的位置，即找到没有权限的文件，将该文件的所有者修改为 mysql 用户即可。

解释：
我们通过yum方式安装mysql,会生成mysql:mysql用户组和用户，启动mysql默认是使用mysql用户。如果我们开启了慢log日志，而且我们使用service mysqld start启动mysql,会报如题所示的错误，根据提示我们知道在my.cnf默认配置指定的/var/lib/mysql这个目录下，存放着数据文件，/var/lib/mysql权限虽然是归mysql:mysql用户组和用户拥有，但是这个目录下的大多数文件，权限都是700,也就是说通过mysql用户来启动，却少权限，我们可以改变这些文件的权限，从而通过使用service mysqld start命令来启动mysql,但是也可以有另外一种方法来启动mysql,而不用改变/var/lib/mysql目录下的文件权限，这个命令就是mysqld --user=root,如果需要让这个命令在后台执行，可以使用mysqld --user=root &.
可以使用
chown -R mysql /var/run/mysqld chgrp -R mysql /var/run/mysqld
赋予mysql用户/var/run/mysqld的权限
除此之外还有/var/lib/mysql


### 修改密码：

	skip-grant-tables #跳过mysql登入密码
	desc #表名 查询

	update user set authentication_string=SHA1('Your Password') where user='root' and host='localhost';
	flush privileges

参考：https://blog.csdn.net/m0_46278037/article/details/113923726  
mysqld -console --skip-grant-tables --shared-memory --user=root

### 远程连接授权
grant all privileges on *.* to 'root'@'%';

https://stackoverflow.com/questions/50691977/how-to-reset-the-root-password-in-mysql-8-0-11

https://stackoverflow.com/questions/9979134/how-can-i-change-mysql-port-from-0-to-3306

### 解决端口 0

edit your my.cnf file and add the line skip-networking = Off to the [mysqld] section, then restart the server.

### 赋予连接权限：

#### 授权所有权限 开启远程连接
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'；
	flush privileges;
但是出现另一个错误  
	
    ERROR 1410 (42000): You are not allowed to create a user with GRANT
查询后解决：

	update user set host='%' where user='root';
再执行两次

	Grant all privileges on test.* to 'test'@'%';
成功

### 总的步骤

1. 查看临时密码  
在 log_error 参数(可以通过my.cnf配置文件查看)指定的错误日志中找到类似于如下的信息:
A temporary password is generated for root@localhost: AdOoGBs!k84f
2. 登录MySQL  
`mysql -uroot -p
	Enter password: #输入步骤1中获取的密码，进入数据库。`
3. 修改root密码  
执行命令：   
`alter user root@"localhost" identified by "your_new_passwd";`  
完成修改，便可以正常使用数据库。

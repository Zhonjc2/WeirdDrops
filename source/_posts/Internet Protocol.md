---
title: Internet Protocol
date: 2024-04-19 14:08:57
author: Zhonjc
tags:
  - 计算机网络
---
## 网际协议 IP

### 概述
1. 网际协议 IP 是 TCP/IP 体系最主要的两个协议之一，也是最重要的互联网标准协议之一。
2. 与IP协议配套的使用的还有三个协议：
	1. 地址解析协议 ARP
	2. 网际控制报文协议 ICMP
	3. 网际组管理协议 IGMP
	4. 如图：
		. ![](/images/截屏2022-05-05%2020.52.17.png)
	5. 将ARP置于网络层最下面，因为IP经常要使用这个协议（ARP置于网络层和数据链路层之间）。ICMP和IGMP置于网络层最上面，因为它们要使用协议IP（作为IP层的SDU的一部分，使用IP层提供的服务）。

### 虚拟互联网络
1. 为了实现网络互联，互通时需要解决许多问题。对于不同的网络，它们有不同的：
	1. 寻址方案
	2. 最大分组长度
	3. 网络接入机制
	4. 超时控制
	5. 差错恢复方法
	6. 状态报告方法
	7. 路由选择技术（部分网络有自己的路由转发，例如广域网）
	8. 用户接入控制
	9. 服务
	10. 管理与控制方式
2. 解决不同网络之间的互联问题，有两种方案：
	1. 所有主机都使用相同的网络。这是不可能的，它不能满足不同用户的需要，没有一种单一的网络能够适应所有用户的需求。而且这也不适应技术发展。
	2. 使用中间设备。这才是正确的方案，可以满足不同需求。
3. 中间设备有哪些种类呢？
	1. 物理层使用的中间设备叫做 转发器（例如集线器） 。
	2. 数据链路层使用的中间设备有 以太网交换机、网桥、桥接器等
	3. 在网络层使用的中间设备叫做 路由器 。
	4. 在网络层以上使用的中间设备叫 网关 。用网关连接两个不兼容的系统，在高层进行协议转换。
4. 注意，当中间设备是网桥或转发器等类似设备时，这仅仅是把一个单一的网络给扩大了，从网络层的角度看，这还是一个网络。
5. 由于参加互联的计算机网络都使用相同的IP协议，因此可以把互联后的计算机网络看成一个虚拟互联网络，即逻辑互联网络。互联起来的各种物理网络的异构性是真实存在的，但是利用IP协议就可以使这些性能各异的网络在网络层上看起来像是一个统一的网络。利用IP协议形成的虚拟互联网络可简称为IP网，IP网是虚拟的。在覆盖全球的IP网之上使用TCP协议簇，就是现在的因特网。![[截屏2022-05-05 21.16.31.png]]
6. *!UNIMPORTANT* 直接交付与间接交付。![[截屏2022-05-05 21.17.47.png]]

### IP 地址
***!IMPORTANT***
###### IP 地址及其表示方法
1. 整个互联网就是一个单一的、抽象的网络。而IP地址，就是给连接到互联网上的 **每一台主机（或路由器）的 每一个接口** ，分配一个 **在全世界范围内是唯一** 的 **32位** 的标识符。IP地址的结构可以使我们很方便的在互联网上进行寻址。IP地址现在由互联网名字和数字分配机构ICANN分配，而且是分级分配。
2. IP地址都是32位的二进制代码。它的表示形式常常由等效的10进制数字表示，每8位二进制为一段，并且在每段数字之间加一个小数点，即 **点分十进制记法** 。
3. IP地址不仅标志了某个主机（或路由器），还标志了某个网络（子网）。因此IP地址采用两级结构， **由两个字段构成** ：
	1. 网络号。标志主机（或路由器）所连接到的网络。一个网络号在整个互联网范围内必须是唯一的。
	2. 主机号。标志该主机（或路由器）。一个主机号在所连接的网络内必须是唯一的。
4. IP 地址指明了 **连接到某个网络上的一个主机或路由器**。
5. IP地址的前n位为网络号，后32-n位为主机号。n取决于IP地址的编址方式。![[截屏2022-05-05 21.54.11.png]]

###### 分类的 IP地址
1. 分类的IP地址应用在早期的互联网。分类分为ABCDE类。
2. A类（n=8），B类（n=16），C类（n=24）。这些地址都是单播地址（一对一通信），是最常用的。D类是多播地址（一对多通信）。E类是保留地址。![[截屏2022-05-05 21.56.52.png]]
3. 如果给出一个二进制数表示的IP单播地址，则很容易就可以看出该地址属于哪一类，同时也能分辨网络号和地址号部分。
4. A类地址的网络号占1B，并且只有7位可以使用，第一位已经固定为0。注意特殊情况：网络号全为0的IP地址表示本网络；网络号为01111111即127的IP地址作为本地软件回环测试之用。因此A类地址的网络号是126个。
5. 全0和全1的主机号一般不指派。全0的主机号表示该IP地址是本主机所连接到的单个网络的 **网络地址** （应该可用作标识网络）。全1表示所有的，即表示该网络下所有的主机。因此各个类网络下的最大主机数应该在总数-2。
6. 一般不使用的特殊IP地址：![[截屏2022-05-05 22.09.34.png]]
	1. 网络号为0，主机号为X，则可以表示在本网络上主机号为X的主机。
	2. 全1，在本网络广播。
7. 分类的IP地址，管理简单、使用方便、转发分组迅速。但是互联网发展迅速，IP快没了，分类的IP地址显现出了巨大的弊端：向组织或学校等分配IP地址网络号时，A类地址太多，而B类又太少不够，因此只能分配A类，造成了巨大的浪费。因此出现了一种新的无分类编址方法 CIDR 。

###### 无分类编址 CIDR
1.  **CIDR 无分类域间路由选择** 。
2. CIDR 有三个要点：
	1. **网络前缀**
		1. CIDR 把网络号改称为 **网络前缀** ，用来指明网络，剩下的后面部分仍然是主机号，用来指明主机。
		2. 网络前缀的 **位数n不是固定的数** ，而是 **可以在0-32之间任意选取** 的值。
		3.  **斜线记法(CIDR 记法)** ：在IP地址后面加上斜线'/'，斜线后是网络前缀所占的位数。
	2. **地址块**
		1. CIDR 把网络前缀都相同的所有连续的IP地址组成一个 **CIDR 地址块** 。
		2. 一个 CIDR 地址块包含的IP地址数目，取决于网络前缀的位数。
		3. 只要知道 CIDR 地址块中的任何一个地址，就可以知道这个地址块的起始地址和最大地址，以及地址块中有几个地址（可指派的地址数记得要减2）。
		4. 我们常使用地址块的最小地址（主机号为0）和网络前缀的位数指明一个地址块。
		5. 也可以用二进制代码简要地表示地址块：网络前缀的二进制数*。例如 10000000 00001110 0010\* 就代表了128.14.32.0/20。这里的星号表示了主机号字段的所有0。在不需要指明网络地址时，也可把这样的地址块简称为/20地址块。
		6. 几种表示法的注意：
			1. 128.14.32.7 是单一的IP地址，但是没有指明网络前缀位数，无法获取网络地址。
			2. 128.14.32.7/20 也是单一的IP地址，因为主机号并不是全0。指明了网络前缀位数，因此可以获取网络地址。
			3. 128.14.32.0/20 才是包含多个IP地址的地址块或网络前缀，同时也是这个地址块中主机号全为0的地址。可以省略十进制表示法中的最后的0，简写为128.14.32/20。
			4. 要想指明网络地址，就必须在IP地址中指明网络前缀的位数。
	3. **地址掩码（子网掩码）**
		1. 32位的 地址掩码 能够使计算机从IP地址快速算出网络地址。
		2. 地址掩码（可简称为掩码）由一连串1和接着的一连串0构成，而1的个数就是网络前缀的长度。在CIDR记法中，斜线后面的数字就是地址掩码中1的个数。
		3. 把二进制的IP地址和地址掩码进行按位与计算，即可得出网络地址。
		4. 常用的CIDR地址块![[截屏2022-05-06 15.34.28.png]]
3. 每一个CIDR地址块中的地址数一定是2的整数次幂。当网络前缀位数大于24时，CIDR地址块都包含了多个C类地址，因此有时称CIDR编址为构造超网。
4. CIDR 有3个特殊的地址块：
	1. 前缀n=32。没有主机号，就是一个特殊的IP地址，用于主机路由。
	2. 前缀n=31。这个地址块中只有两个IP地址，其主机号分别为0和1。这个地址块用于点对点链路。
	3. 前缀n=0。同时IP地址也全是0，即0.0.0.0/0。者用于默认路由。
5. 使用CIDR，可以更加灵活有效地分配IP地址空间，可根据客户需要分配适当大小的CIDR地址块。
6. **路由聚合** ：一个大的CIDR地址块包含许多小CIDR地址块，所以在<u>路由器的转发表中就利用较大的一个CIDR地址块来代替许多小的CIDR地址块</u>(找网络，而不是找具体的主机)。这种方法称为路由聚合，它使得转发表中只用一个项目就可以表示原来传统分类地址的很多个路由项目，因而大大压缩了转发表所占的空间，减少了查找转发表所需的时间。

###### IP地址的特点
1. 每一个IP地址都由网络前缀和主机号两部分组成。也就是说， **IP地址是分等级的** 。分两个等级的好处是：
	1. IP地址管理结构在分配IP地址时只分配网络前缀，而剩下的主机号则由得到该网络前缀的单位自行分配。方便了IP地址的管理。
	2. 路由器根据目的主机所连接的网络前缀来转发分组， **不考虑目的主机号** ，这样可以使转发表中的项目数大幅减少。减少存储占用，缩短查找时间。
2. 实际上， **IP 地址是标志一台主机（或路由器）和一条链路的接口** 。
	1. 多归属主机：当一台主机同时连接到两个网络上时，该主机就必须同时具有两个相应的IP地址，其网络号必然是不同的。这种主机称为多归属主机。
3. 一个网络是指具有相同网络前缀的主机的集合，因此，用转发器或交换机连接起来的若干个局域网仍为一个网络，它们都具有相同的网络前缀。
4. 互联网同等对待每一个IP地址。
5. 路由器总是具有两个或两个以上的IP地址。即 **路由器每个接口的IP地址的网络前缀都不同** 。同一个网络的主机或路由器端口的IP地址中的网络号必须一样。
6. 当两个路由器直接相连，在连线两端的接口处，可以分配也可以不分配IP地址。如果分配了IP地址，则这一段连线就构成了一种只包含一段线路的特殊网络（叫网络是因为有IP地址）。这种网络仅需两个IP地址，因此这里就使用了/31地址块。这种地址块专门为点对点链路的两端使用，主机号只有2种可能，0和1。但为了节省IP地址资源，对于这种网络，常常不分配IP地址。

### IP 地址与 MAC 地址
1. MAC地址常称为物理地址/硬件地址，对应的，IP地址也被称为虚拟地址/软件地址/逻辑地址，IP地址是用软件实现的。
2. 从层次的角度看，MAC地址是数据链路层使用的地址，IP地址是网络层和以上各层使用的地址，是一种逻辑地址。
3. 在发送地址时，数据从高层向低层，然后在链路上传输。使用IP地址的IP分组交给数据链路层之后，就被封装成MAC帧。MAC帧在传送时使用的源地址和目的地址都是MAC地址，这两个MAC地址都写在MAC帧的首部中。
4. 连接在通信链路上的设备在收到MAC帧时，根据MAC帧首部中的MAC地址决定收下或丢弃。只有在剥去MAC帧首部和尾部后，把MAC层的数据上交给网络层后，网络层才能在IP数据报的首部中找到源IP地址和目的IP地址。
5. 交换机是数据链路层设备，只有MAC地址，没有IP地址，最高只有链路层，没有网络层。因此在网络层看时，交换机可以当做不存在。
6. 注意：
	1. 在IP层抽象的互联网上只能看到IP数据报。在IP分组传输的过程中，虽然要经过多个路由器的转发，但是在IP分组的首部中， **源IP和目标IP永远不变** 。经过的路由器并不会出现在IP分组中。
	2. 对于路由器来说，源IP地址是没用的。 **路由器只根据目的站的IP地址进行转发** 。
	3. 在局域网的链路层，只能看到MAC帧。MAC帧在不同网络上传送时，其MAC帧首部中的源地址和目标地址要发生变化。当一台局域网内的主机向别的网络内的主机发送数据时，MAC帧首部中源地址就是自己，而目标地址是该局域网的路由器的MAC地址（MAC帧到达交换机后，会根据MAC地址，决定转发到接路由器的端口）。到达路由器后，在网络层抽出IP分组，获得目标IP地址，查询转发表，获取下一跳的目的地和对应的转发端口，（光查询，并不更改IP分组内的IP头）然后下到链路层，再加上链路层的首部，此时源MAC地址是路由器的MAC地址，目标地址是下一跳的MAC地址。
	4. 尽管互连在一起的网络的 MAC 地址体系各不相同，但 IP 层抽象的互联网却屏蔽了下层这些很复杂的细节。只要我们在网络层上讨论问题，就能够使用统一的、抽象的 IP 地址研究主机和主机或路由器之间的通信。
	5. 在网络层下到数据链路层时，为了根据目标IP地址获取数据链路层传输所需要的目标MAC地址，需要运行ARP协议。

### 地址解析协议 ARP
实现IP通信时使用了两个地址：IP地址和MAC地址。而实际上用于链路传输的是MAC地址。在传输时，必须将目标IP地址转换为在当前网络内通往该目标IP方向的MAC地址。这就用到了ARP协议。（注意ARP运行在每一台主机或路由器，每一台主机或路由器都有自己的ARP高速缓存；而以太网交换机的自学习算法是处在中心的。）
1.  **ARP 运行步骤**
	1. 每一台主机都设有一个 **ARP高速缓存** ，里面存有 **本局域网（注意映射只在本局域网有效）** 上的各主机和路由器的IP地址到MAC地址的映射表，这些都是该主机目前知道的一些MAC地址。
	2. 当主机A要向<u style="border-bottom:5px solid black;text-decoration:none;font-weight:900;">本局域网</u>上的某台主机B发送IP数据报时，就先在其ARP高速缓存中查看有无主机B的IP地址。
		1. 若有，就在ARP高速缓存中查出其对应的MAC地址，再把这个MAC地址写入MAC帧，然后通过局域网把该MAC帧发往此MAC地址。
		2. 若没有，（有可能是B才入网，也有可能是A才加电）主机A就自动运行ARP，然后按以下步骤找出主机B的MAC地址：
			1. ARP进程在本局域网上广播发送一个ARP请求分组。该分组的主要内容包含 发送方的硬件地址、发送方的IP地址、目标方的硬件地址（此时未知，填0）、目标方的IP地址。意思就是：我的IP地址是XXX，MAC地址是YYY，我想知道IP地址为ZZZ的主机的MAC地址。
			2. 在本局域网上的所有主机上运行的ARP进程都收到此ARP请求分组。路由器不会转发ARP请求。
			3. 主机B的IP地址与ARP请求分组中要查询的IP地址一致，就收下这个ARP请求分组，并向主机A发送ARP响应分组，同时在这个ARP响应分组中写入自己的MAC地址。其他主机发现ARP请求分组内要查的IP不是自己就都不理会。（ARP响应分组是单播的，从一个源地址发送到一个目的地址。它包含 发送方的硬件地址、发送方的IP地址、目标方的硬件地址、目标方的IP地址。意思就是：我的IP地址是MMM，我的MAC地址是CCC。）
			4. 主机A在发送ARP请求分组时，会把自己的MAC和IP地址写入ARP请求分组。当主机B收到A的ARP请求分组时，就把主机A的这一地址映射写入主机B自己的ARP高速缓存中。这样B在以后向A发送数据报时就很方便了。
			5. 主机A收到ARP响应分组后，就在其ARP高速缓存中写入主机B的IP地址到MAC地址的映射。
	3. ARP对保存在高速缓存中的每一个映射地址项目 **都设置生存时间** 。凡超过生存时间的项目就从高速缓存中删除掉，以保证映射的正确。
	4. **注意：** ARP用来解决 **同一局域网上** 的主机或路由器的IP地址和MAC地址的映射问题。
		1. 如果所要找的主机H<sub>2</sub>和源主机H<sub>1</sub>不再同一个局域网上，源主机就无法解析出另一个局域网上的目标主机的MAC地址。但实际上， **源主机也不需要知道异构网络的目标主机的MAC地址。**
		2. 主机H1发送给主机H2的IP分组，首先需要通过H1连接在同一个局域网上的路由器R1进行转发，主机是知道路由器的IP地址的，<u>因此主机H1需要知道的是路由器R1的IP地址对MAC的映射。</u>
		3. H1使用ARP把路由器R1的IP地址解析为路由器的MAC地址，然后把IP分组发出，这时链路会把分组发送到路由器R1。以后<u>R1在网络层通过转发表知道应该把IP分组转发到哪个网络结点，再使用ARP解析出该结点的MAC地址，然后到达链路层加到MAC帧头部然后发出，以此类推，最后一跳由目标主机的路由器解析出目标主机的MAC地址。</u>也就是说，**ARP只会把IP地址解析到当前网络的某个设备的MAC地址，而不会把地址解析到最终目的的MAC地址**，这是没必要的，也是没可能的，MAC地址是运用在同一个网络内的，只要在同一网络内知道下一跳的地址即可（路由器端口也属于网络内），<u>要传往不在同一个网络的主机只需要转发给路由器，一切交给网络层就行。</u>
	5. ARP协议是自动运行的，主机的用户对这种地址解析过程是不知情的。
2. ARP的四种典型情况
	1. 发送方是主机，要把 IP 数据报发送到本网络上的另一个主机。这时用 ARP 找到目的主机的硬件地址。
	2. 发送方是主机，要把 IP 数据报发送到另一个网络上的一个主机。这时用 ARP 找到本网络上的一个路由器的硬件地址。剩下的工作由这个路由器来完成。
	3. 发送方是路由器，要把 IP 数据报转发到本网络上的一个主机。这时用 ARP 找到目的主机的硬件地址。
	4. 发送方是路由器，要把 IP 数据报转发到另一个网络上的一个主机。这时用 ARP 找到本网络上另一个路由器的硬件地址。剩下的工作由这个路由器来完成。
3. 有了MAC地址还要IP干啥
	1. 全世界存在着各式各样的网络，它们使用不同的MAC地址。要使它们能够互相通信就必须进行非常复杂的MAC地址转换工作，因此由用户或用户主机来完成这项工作几乎是不可能的事。即使是对分布在全世界的以太网MAC地址进行寻址，也是极其困难的。然而IP编址把这个问题解决了。~~路由器可以转换不同网络类型的MAC帧？~~ 即使必须多次调用ARP来找到下一跳MAC地址，但这个过程对用户来说是无感的。

### IP 数据报的格式
1. 一个IP数据报由首部和数据两部分组成。
	1. 首部的一部分长度是固定的，**共20字节**，是所有IP数据报所必须具有的。在首部的固定部分的后面是一些可选字段，其长度是可变的。
	2. IP分组的首部长度 **必须是4B的整数倍。** 如果不是4B的 整数倍，必须有填充字段加以填充。
	3. 整个首部的 **最长长度为60Byte。**
	4. 一般情况下首部就20B，即不使用可变首部。
	5. 具体格式：![[截屏2022-05-12 19.23.17.png]]
2. ***!!IMPORTANT 各个字段：***
	1. 4b 版本字段：协议IP的版本。通信双方所使用的IP协议的版本必须相同。
	2. 4b 首部长度字段：表示首部的长度。注意，首部长度字段所表示数的<u>单位是32b</u>。首部长度字段最小为0101，代表只有固定首部部分，没有可变首部，总长度为5\*32b=20B；最大为1111，代表首部总长15\*32b=60B。
	3. 8b 区分服务字段：用于获取更好地服务。只有在区分服务时这个字段才起作用。
	4. 16b 总长度字段：首部和数据之和的长度，**字段单位为字节**。可得出IPv4数据报最大长度为2<sup>16</sup> -1= **65535字节。** 
		* 注意，IP数据报的长度要遵守低层的MTU限制。如果超了，则需要把过长的数据报进行**分片处理。**
		* IP协议规定，所有主机和路由必须能够接受长度≤576B的数据报。
		* 分片过后，总长度字段的值是分片后<u>每一个IP分片的长度。</u>
	5. 16b 标识字段：IP软件在存储器中维持一个计数器，每产生一个数据报，计数器就加 1 ，并将此值赋给标识字段。注意<u>这并不是序号</u>，IP是无连接的，不存在按序接收的问题。标识字段的作用体现在当IP数据报需要被分片时，其标识字段会被复制到所有的数据报片的标识字段中。<u>相同的标识字段使得分片后的各数据报片能够正确重组。</u> 
	6. 3b 标志字段：目前只有两位有意义。
		1. 低位为MF(More Fragment)。MF=1代表后面还有分片的数据报。MF=0表示这已经是若干数据报片的最后一个。
		2. 中位为DF(Do not Fragment)。DF=1时不允许该数据报被分片，DF=0时允许分片。
	7. 13b 片偏移字段：数据报被分片后，各个分片在原数据报中的相对位置。片偏移以8B为偏移单位，这也就是说，除最后一个数据报片外，其他每个分片的长度一定是8B的整数倍。例如：![[截屏2022-05-12 19.56.38.png]]
		* 其中，<u>每个分片的标识字段都相同</u>，就是原先未分片的数据报的标识字段。
		* 如果分片后还要再分，那么<u>新分片的片偏移依旧是相对于最原先的数据报。</u>
		* 各个分片字段的变化：![[截屏2022-05-12 20.06.02.png]]
	8. 8b 生存时间字段 TTL ：数据报在网络中的寿命。目的是防止IP数据报兜圈子。以前的单位是时间，而现在的单位是 **跳数** ，TTL字段的功能也就变成了 跳数限制 。路由器在每次转发之前就把TTL减1。若TTL减小到0还没有到达目标则丢弃该数据报。TTL长8位，因此最大跳数为255。
	9. 8b 协议字段：指出此数据报携带的数据使用何种协议，让目的主机知道应该将数据部分上交给哪个协议。![[截屏2022-05-12 20.16.11.png]]
	10. 16b 首部校验和：只检验数据报的首部，不包括数据部分。数据报每经过一个路由器都会重新计算一下首部校验和（一些字段会发生变化）。使用网际校验和算法。
	11. 32b 源地址
	12. 32b 目的地址
	13. 可变首部：就是一个选项字段，用于支持排错、测量以及安全等措施。<u>长度可变，最短1B，最长40B，</u><u style="text-decoration:none;border-bottom:3px solid black">最后用全0来填充以保证4B的整数倍。</u> 
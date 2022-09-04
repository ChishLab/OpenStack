<div align="center">

# 私有云平台基础架构
#### **注：全部基于VMware虚拟机试搭建，仅用于学习交流**
</div>

## 1. 虚拟机创建（物理机可忽略）
> 演示软件：VMware Warkstations Pro 16 <br>
> *请提前设置虚拟网络编辑器，设置后尽量不要再去设置，如遇内网设备无法连入虚拟机，请尝试重启所有网卡*

- ### 1.1. 安装 CentOS7
    - 版本选择 1804 ：`CentOS-7-x86_64-DVD-1804.iso`

- ### 1.2. 虚拟网络编辑
    - VMnet8 改为 `NAT` 模式，子网 IP 设置为 `192.168.100.0`
    - VMnet1 改为 `仅主机` 模式，子网 IP 设置为 `192.168.200.0`

- ### 1.3. 安装 `controller` 节点系统
    - 选择 `CentOS-7-x86_64-DVD-1804.iso` & `chinaskills_cloud_iaas.iso` 镜像文件
    - 网络适配器 : VMnat8 (NAT) & VMnat1 (仅主机)
    - 自动建立分区，删除 `/home` 分区
    > 安装系统前，请不要勾选启动 `chinaskills_cloud_iaas.iso` 镜像

- ### 1.4. 安装 `compute` 节点系统
    - 选择 `CentOS-7-x86_64-DVD-1804.iso` 镜像文件
    - 网络适配器 : VMnat8 (NAT) & VMnat1 (仅主机)
    - 硬盘容量须比 `controller` 大，自动建立分区，删除 `/home` 分区，如容量 200GiB 应分配 `/` 分区 100GiB ，剩余容量备用

## 2. 配置网卡、主机名
> 添加或修改 `/etc/sysconfig/network-scripts/ifcfg-ens*` (具体网卡) 文件
- ### 2.1. `controller` 节点
    - 配置网络
        * ens33: 192.168.100.10
        ```conf
        # 仅更改以下内容
        BOOTPROTO=static
        ONBOOT=yes
        # 尾行添加
        IPADDR=192.168.100.10
        NETMASK=255.255.255.0
        GATEWAY=192.168.100.1
        ```

        * ens34: 192.168.200.10
        ```conf
        # 仅更改以下内容
        BOOTPROTO=static
        ONBOOT=yes
        # 尾行添加
        IPADDR=192.168.200.10
        ```
        * 重启网卡 : `systemctl restart network`

    - 配置主机名
        ```sh
        hostnamectl set-hostname controller
        # Ctrl + D Log out and log in again.
        ```

- ### 2.2. `compute` 节点
    - 配置网络
        * ens33: 192.168.100.20
        ```conf
        # 仅更改以下内容
        BOOTPROTO=static
        ONBOOT=yes
        # 尾行添加
        IPADDR=192.168.100.20
        NETMASK=255.255.255.0
        GATEWAY=192.168.100.1
        ```

        * ens34: 192.168.200.20
        ```conf
        # 仅更改以下内容
        BOOTPROTO=static
        ONBOOT=yes
        # 尾行添加
        IPADDR=192.168.200.20
        ```
        * 重启网卡 : `systemctl restart network`

    - 配置主机名
        ```sh
        hostnamectl set-hostname compute
        # Ctrl + D Log out and log in again.
        ```

## 3. 编辑 SELinux 并关闭防火墙
- ### 3.1. 修改 `SELinux` 为可通过状态 : `vi /etc/selinux/config`
    ```conf
    # 仅更改以下内容
    SELINUX=permissive
    ```
    > 执行 `setenforce 0` 使selinux立即生效

- ### 3.2. 关闭防火墙并设置开机不自启
    ```sh
    # 关闭防火墙服务进程
    systemctl stop firewalld
    # 关闭防火墙自启
    systemctl disable firewalld
    ```

- ##### 3.3. 连接 CRT 或任意支持连接 SSH 软件，进行下面操作

## 4. 添加主机映射
> 修改 `hosts` 添加主机关系 : `vi /etc/hosts` 
- ### 4.1. `controller` 节点
    ```yaml
    192.168.100.10 controller
    192.168.100.20 compute
    ```
- ### 4.2. `compute` 节点
    ```yaml
    192.168.100.10 controller
    192.168.100.20 compute
    ```

## 5. 挂载 ISO 文件 (controller 节点)
> 打开 `controller` 节点虚拟机设置将 `chinaskills_cloud_iaas.iso` CD/DVD的 `已连接` 打开
- ### 5.1. 挂载 `CentOS-7-x86_64-DVD-1804.iso`
    ```sh
    # 查看镜像位置，其为 4.2G 左右
    lsblk
    # 挂载 CentOS 镜像，如 sr1 大小为 4.2G 左右，则挂载此目录，否则是 sr0
    mount /dev/sr1 /mnt/
    # 创建需要传入数据的目录
    mkdir /opt/centos
    # 镜像数据文件传入
    cp -rvf /mnt/* /opt/centos
    # 完成后取消挂载
    umount /mnt/
    ```
- ### 5.2. 挂载 `chinaskills_cloud_iaas.iso`
    ```sh
    # 查看镜像位置，其为 3.6G 左右
    lsblk
    # 挂载 iaas 镜像，如 sr0 大小为 3.6G 左右，则挂载此目录，否则是 sr1
    mount /dev/sr1 /mnt/
    # 创建需要传入数据的目录
    mkdir /opt/iaas
    # 镜像数据文件传入
    cp -rvf /mnt/* /opt/iaas
    # 完成后取消挂载
    umount /mnt/
    ```

## 6. 配置 yum 源
- ### 6.1. yum 源备份 (controller 和 compute 节点)
    ```sh
    mkdir /opt/repo
    mv /etc/yum.repos.d/* /opt/repo/
    ```

- ### 6.2. 创建 repo 文件
    > 在 `/etc/yum.repos.d` 创建 centos.repo 源文件 : `vi /etc/yum.repos.d/centos.repo`
    - controller 节点
        ```conf
        [centos]
        name=centos
        baseurl=file:///opt/centos
        gpgcheck=0
        enabled=1
        [iaas]
        name=iaas
        baseurl=file:///opt/iaas/iaas-repo
        gpgcheck=0
        enabled=1
        ```
    - compute 节点
        ```conf
        [centos]
        name=centos
        baseurl=ftp://192.168.100.10/centos
        gpgcheck=0
        enabled=1
        [iaas]
        name=iaas
        baseurl=ftp://192.168.100.10/iaas/iaas-repo
        gpgcheck=0
        enabled=1
        ```
    - 清除缓存并验证 yum 源
        > 请完成 [**ftp 服务器**](#63-搭建-ftp-服务器开启并设置自启controller-节点) 的搭建，再去 compute 节点执行以下命令，否则 yum 源的验证不会通过
        ```sh
        yum clean all
        yum repolist
        ```

- ### 6.3. 搭建 ftp 服务器，开启并设置自启（controller 节点）
    - 安装 vsftpd 包
        ```sh
        yum install -y vsftpd
        ```

    - 编辑 vsftpd 配置文件 : `vi /etc/vsftpd/vsftpd.conf`
        ```conf
        # 添加
        anon_root=/opt/
        ```
    
    - 开启服务并开启自启
        ```sh
        systemctl start vsftpd
        systemctl enable vsftpd
        ```

## 7. 编辑配置环境变量
- ### 7.1. 在 `controller` 和 `compute` 节点安装 `iaas-xiandian` 包
    ```sh
    yum install -y iaas-xiandian
    ```

- ### 7.2. 编辑文件 `/etc/xiandian/openrc.sh` ，此文件是安装过程中的各项参数，根据每项参数上一行的说明及服务器实际情况进行配置 : `vi /etc/xiandian/openrc.sh`
    - 使用正则表达式删除配置文件前的第一个 `#` : `:1,$s/^#//g`

    - 使用正则表达式在 `PASS=` 尾后添加密码 : `:1,$s/PASS=/PASS=000000/g` ，按 `gg` 返回第一行

    - `controller` 节点编辑变量 -> [点击这里查看详情](https://github.com/ChishFoxcat/OpenStack/blob/master/openrc.sh)
        ```conf
        HOST_IP=192.168.100.10
        HOST_NAME=controller
        HOST_IP_NODE=192.168.100.20
        HOST_PASS_NODE=000000
        HOST_NAME_NODE=compute
        network_segment_IP=192.168.100.0/24
        RABBIT_USER=openstack
        DOMAIN_NAME=demo
        METADATA_SECRET=000000
        INTERFACE_IP=192.168.100.10
        INTERFACE_NAME=ens33
        Physical_NAME=provider
        minvlan=101
        maxvlan=200
        STORAGE_LOCAL_NET_IP=192.168.100.20
        ```

    - `compute` 节点编辑变量，因为上面已经修改大半直接在 `controller` 节点使用 `scp /etc/xiandian/openrc.sh 192.168.100.20:/etc/xiandian/openrc.sh` 传入 `compute` 节点，修改部分即可
        ```conf
        INTERFACE_IP=192.168.100.20
        ```

## 8. 通过脚本安装服务
- `controller` 和 `compute` 节点执行脚本 `iaas-pre-host.sh` 进行安装
- 安装完成后同时重启

## 9. 安装所需相关服务
- ### 9.1. 安装 Mysql 数据库服务
    - 在 `controller` 执行脚本 `iaas-install-mysql.sh` 进行安装

- ### 9.2. 安装 Keystone 服务
    - 在 `controller` 执行脚本 `iaas-install-keystone.sh` 进行安装

- ### 9.3. 安装 Glance 服务
    - 在 `controller` 执行脚本 `iaas-install-glance.sh` 进行安装

- ### 9.4. 安装 Nova 服务
    - 在 `controller` 执行脚本 `iaas-install-nova-controller.sh` 进行安装
    - 在 `compute` 执行脚本 `iaas-install-nova-compute.sh` 进行安装

- ### 9.5. 安装 Dashboard 服务
    - 在 `controller` 执行脚本 `iaas-install-dashboard.sh` 进行安装
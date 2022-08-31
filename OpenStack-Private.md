<div align="center">

# 私有云平台基础架构
#### **注：全部基于VMware虚拟机试搭建，仅用于学习交流**
</div>

## 1. 虚拟机创建（物理机可忽略）
> 演示软件：VMware Warkstations Pro 16

- ### 1.1. 安装 CentOS7
    - 1.1.1. 版本选择 1804 ：`CentOS-7-x86_64-DVD-1804.iso`

- ### 1.2. 虚拟网络编辑
    - 1.2.1. VMnet8 改为 `NAT` 模式，子网 IP 设置为 `192.168.100.0`
    - 1.2.2. VMnet1 改为 `仅主机` 模式，子网 IP 设置为 `192.168.200.0`

- ### 1.3. 安装 `controller` 节点系统
    - 1.3.1. 选择 `CentOS-7-x86_64-DVD-1804.iso` & `chinaskills_cloud_iaas.iso` 镜像文件
    - 1.3.2. 网络适配器 : VMnat8 (NAT) & VMnat1 (仅主机)
    - 1.3.3. 自动建立分区，删除 `/home` 分区
    > 安装系统前，请不要勾选启动 `chinaskills_cloud_iaas.iso` 镜像

- ### 1.4. 安装 `compute` 节点系统
    - 1.4.1. 选择 `CentOS-7-x86_64-DVD-1804.iso` 镜像文件
    - 1.4.2. 网络适配器 : VMnat8 (NAT) & VMnat1 (仅主机)
    - 1.4.3. 硬盘容量须比 `controller` 大，自动建立分区，删除 `/home` 分区，如容量 200GiB 应分配 `/` 分区 100GiB ，剩余容量备用

## 2. 配置网卡、主机名
> 添加或修改 `/etc/sysconfig/network-scripts/ifcfg-ens*` （具体网卡）文件
- ### 2.1. `controller` 节点
    - 2.1.1. 配置网络
        * ens33: 192.168.100.10
        ```yaml
        # 仅更改以下内容
        BOOTPROTO=static
        ONBOOT=yes
        # 尾行添加
        IPADDR=192.168.100.10
        NETMASK=255.255.255.0
        GATEWAY=192.168.100.1
        ```

        * ens34: 192.168.200.10
        ```yaml
        # 仅更改以下内容
        BOOTPROTO=static
        ONBOOT=yes
        # 尾行添加
        IPADDR=192.168.200.10
        ```
        * 重启网卡
        ```shell
        systemctl restart network
        ```
    - 2.1.2. 配置主机名
        ```shell
        hostnamectl set-hostname controller
        # Ctrl + D Log out and log in again.
        ```
# mido-miui11-kernel
用于红米 Note4X（骁龙625）官方 MIUI11 9.10.10 的内核，解决了传感器超过 40 小时候失灵、系统桌面过于占用内存等问题。

### 适用设备
* 红米 Note 4X 高通骁龙版
* 已刷官方开发版 MIUI11 9.10.10

### 安装方法
* 将手机关机并用 USB 连接电脑
* 安装好驱动程序与 Fastboot
* 关机状态下按音量下+开机键
* 看到 FASTBOOT 字样后在电脑上执行
	```
	fastboot boot mido-kernel_g653a83a-miui11_9.10.10-dfc643_19110501.img
	```
* 如果能开机进入桌面，则重复 1~3 步，不能进入桌面请放弃操作
* 看到 FASTBOOT 字样后在电脑上执行
	```
	fastboot flash boot mido-kernel_g653a83a-miui11_9.10.10-dfc643_19110501.img
	fastboot reboot
	```
* 完成
* 如果需要刷 Magisk 可以在此时刷入
* 如果需要刷 VoLTE 基带可以在此时刷入

-----

### 内核组成部分
* zImage（内核）：取自官方 MIUI10 2.20.0 稳定版
```
Linux version 3.18.31-perf-g653a83a (builder@c3-miui-ota-bd01.bj) (gcc version 4.9 20150123 (prerelease) (GCC) ) #1 SMP PREEMPT Mon Jan 7 15:27:53 CST 2019
```
* ramdisk（根目录）：取自官方 MIUI11 9.10.10 开发版

修改部分均存放在 ```ramdisk/init.dfc643._____.sh``` 中，参数均以 ```dfc643.____.____``` 开头，服务名均以 ```dfc643-_____``` 命名。

-----

### 参数：初始化
```
dfc643.init.ignore_ver [true|false]    
(默认值: false) 不对内核与MIUI兼容性进行检测，不启用遇到不匹配MIUI时，开机会显示警告文字。
```

### 参数：内存优化
```
dfc643.memory.lmkopt [true|false]    
(默认值: true) 启用杀后台优化，减少应用被杀后台几率。

dfc643.memory.swap [true|false]    
(默认值: false) 在数据分区上创建一个虚拟内存文件并启用虚拟内存。

dfc643.memory.swap.size [100+]    
(默认值: 256, 单位: MiB) 虚拟内存大小，最大不要超过DATA分区可用空间。

dfc643.memory.zram [true|false]    
(默认值: true) 启用压缩内存，将物理内存压缩，使得内存更耐用。

dfc643.memory.zram.size [100~2000]    
(默认值: 1280, 单位: MiB) 压缩内存大小，建议使用默认值。
```

### 参数：杂项
```
dfc643.misc.gapps_disable [true|false]    
(默认值: false) 禁用谷歌全家桶以及谷歌服务框架。

dfc643.misc.miad_disable [true|false]    
(默认值: true) 禁用小米系统的广告推送服务组件。

dfc643.misc.mido_enhance [true|false]    
(默认值: true) 启用小米功能增强（如手动相机、实时HDR、录音模式等……）
```

### 参数：网络
```
dfc643.net.wcnss_config [true|false]    
(默认值: true) 优化无线网络参数包括但不限于启用 40MHz 支持。
```

### 参数：安全
```
dfc643.sec.selinux [true|false]    
(默认值: false) 在内核脚本执行完毕后启用 SELinux，但会导致一些问题发生，因此不建议启用。
```


### 免 ROOT 覆盖系统参数
* 创建文本文件 /sdcard/Android/linux/user.prop
* 在文件中写下你想设定的参数
* 重启手机参数自动应用

### 免 ROOT 覆盖主机文件
* 创建文本文件 /sdcard/Android/linux/hosts
* 在文件中写下你想设定的主机映射
* 最后必须留下一行空行
* 重启手机参数自动应用

-----


### 版本信息
mido-kernel_g653a83a-miui11_9.10.10-dfc643_19110501    
Tue Nov  5 12:32:55 DST 2019


### 内核修改日志
* 修复小米桌面内存泄露
* 默认禁用 SELinux
* 默认禁用 DM 校验
* 禁用相机日志（避免 Logcat 刷屏）
* 禁止自动恢复小米官方 Rec
* 禁止执行系统分区的内核优化参数
* 添加内存优化脚本
* 添加 Camera API2 支持
* 替换无线网卡驱动
* 添加无线网卡参数优化
* 添加免 ROOT Hosts

### 作者信息
xRetia Lab
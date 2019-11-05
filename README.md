# mido-miui11-kernel
Xiaomi Redmi Note4/4X (SD625) kernel for official MIUI11 9.10.10, fixed sensor failed, miui launcher memory leak etc.

[中文版点这里](README-zh.md)

### REQUIREMENT
* Xiaomi Redmi Note 4/4X (SD625)
* Flashed official MIUI11 9.10.10-dev

### INSTALLATION
* Turn off phone and connect to PC
* Install fastboot and driver
* Hold-press Vol-down and power button
* When screen shows "FASTBOOT" execute command on PC
	```
	fastboot boot mido-kernel_g653a83a-miui11_9.10.10-dfc643_19110501.img
	```
* If phone boot into desktop, repeat step 1~3, On the other wise the kernel incompitable with your device.
* When screen shows "FASTBOOT" execute command on PC
	```
	fastboot flash boot mido-kernel_g653a83a-miui11_9.10.10-dfc643_19110501.img
	fastboot reboot
	```
* Finished
* Now you can flash magisk

-----

### ABOUT KERNEL
* zImage (kernel): extracted from official MIUI10 2.20.0 stable
```
Linux version 3.18.31-perf-g653a83a (builder@c3-miui-ota-bd01.bj) (gcc version 4.9 20150123 (prerelease) (GCC) ) #1 SMP PREEMPT Mon Jan 7 15:27:53 CST 2019
```
* ramdisk (rootfs): extracted from official MIUI11 9.10.10 dev

All the script added by me storaged at ```ramdisk/init.dfc643._____.sh```, system props all start with ```dfc643.____.____```, service name all start with ```dfc643-_____```.

-----

### PROPS: INIT
```
dfc643.init.ignore_ver [true|false]
(Default: false) ignore kernel and miui version matchability check.
```

### PROPS: MEMORY-OPTIMIZATION
```
dfc643.memory.lmkopt [true|false]
(Default: true) enable Low-Memory-Killer optimization.

dfc643.memory.swap [true|false]
(Default: false) enable swapfile on data partition.

dfc643.memory.swap.size [100+]
(Default: 256, Unit: MiB) size of swapfile will created on data partition.

dfc643.memory.zram [true|false]
(Default: true) enable memory compression (zram).

dfc643.memory.zram.size [100~2000]
(Default: 1280, Unit: MiB) size of memory will zram use.
```

### PROPS: MISC
```
dfc643.misc.gapps_disable [true|false]
(Default: false) disable google apps and gms service.

dfc643.misc.miad_disable [true|false]
(Default: true) override miad folder on sdcard and disable msa apps.

dfc643.misc.mido_enhance [true|false]
(Default: true) override mido device feature to enable manual camerea etc.
```

### PROPS: NETWORK
```
dfc643.net.wcnss_config [true|false]
(Default: true) override system wlan configuration with some optimization.
```

### PROPS: SECURITY
```
dfc643.sec.selinux [true|false]
(Default: false) enable SELinux when kernel fully loaded. enable selinux will cause driver load fail, like wifi, hotspot, etc.
```


### ROOTLESS PROP
* create file at: /sdcard/Android/linux/user.prop
* write down your props in the file
* reboot android to apply it

### ROOTLESS HOSTS
* create file at: /sdcard/Android/linux/hosts
* write down your host in the file
* leave an empty line at the last is required
* reboot android to apply it


### VERSION
mido-kernel_g653a83a-miui11_9.10.10-dfc643_19110501    
Tue Nov  5 12:32:55 DST 2019


### CHANGELOG
* fixed miuihome memory leak
* disable selinux by default
* disable dmverity by default
* disable camera logs
* ignore recovery install script
* ignore post script on system partition
* added memory optimization script
* added camera2 support
* added systemless driver modules
* added wlan optimization override
* added rootless hosts file

### AUTHOR
xRetia Lab
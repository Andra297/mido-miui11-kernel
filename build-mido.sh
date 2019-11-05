#!/bin/bash
if [ "$1" == "" ]; then
    echo "usage: $0 /path/ramdisk /path/kernel /path/newboot.img"
    exit 0
fi

mkbootfs "$1" | gzip > /tmp/ramdisk-mido.gz \
&& mkbootimg --base 0x80000000 \
    --cmdline 'ignore_loglevel console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 androidboot.bootdevice=7824900.sdhci earlycon=msm_hsl_uart,0x78af000 androidboot.selinux=permissive' \
    --kernel "$2" \
    --ramdisk /tmp/ramdisk-mido.gz \
    -o "$3"

rm -f /tmp/ramdisk-mido.gz
echo "success"

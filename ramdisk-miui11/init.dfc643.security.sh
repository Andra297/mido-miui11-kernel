#!/system/bin/sh
LOG="log -p i -t dfc643-security"
$LOG "initizing ..."

selinux_enable=`getprop dfc643.sec.selinux`
if [ "$selinux_enable" == "true" ]; then
    $LOG "SELinux: waiting for 30 secs ..."
    sleep 30
    $LOG "SELinux: set enforcing ..."
    setenforce 1
    $LOG "SELinux: done!"
fi


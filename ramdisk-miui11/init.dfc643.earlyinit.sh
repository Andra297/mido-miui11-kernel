#!/system/bin/sh
export PATH=/system/bin
LOG="log -p i -t dfc643-earlyinit"

# waiting for data partition
while [ ! -d /data/media/0 ]
do
    sleep 0.3
    $LOG "< waiting for data device >"
done

if [ -f /data/media/0/Android/linux/user.prop ]; then
    $LOG "found user's prop file, loading ..."
    while read line
    do
        key=`echo $line | cut -d"=" -f1`
        value=`echo $line | cut -d"=" -f2`
        if [ "$key" != "" ] && [ "$value" != "" ]
        then
            $LOG "loading prop: $line ..."
            setprop $key $value
        fi
    done < /data/media/0/Android/linux/user.prop
    $LOG "user prop loaded!"
fi

#__check_bootimg_miui_version__
if [ "`getprop dfc643.init.ignore_ver`" == "false" ]; then
    if [ "`getprop ro.build.fingerprint`" != "`getprop ro.bootimage.build.fingerprint`" ]
    then
        KLOG="log -p e -t kernel"
        $KLOG "##########################################"
        $KLOG "# WARNING !!                             #"
        $KLOG "#                                        #"
        $KLOG "# Kernel version not matched MIUI version#"
        $KLOG "# make sure flashed matched MIUI?        #"
        $KLOG "##########################################"
        mount --bind /misc/verErr_bootanimation.zip /system/media/bootanimation.zip
        killall -9 bootanimation
        /system/bin/bootanimation &
    fi
fi

$LOG "all done!"

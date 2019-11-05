#!/system/bin/sh
LOG="log -p i -t dfc643-driver"
$LOG "initizing ..."

wcnss_config=`getprop dfc643.net.wcnss_config`
case "$1" in
"core")
    $LOG "preveting load old drivers ..."
    mount --bind /empty /system/lib/modules
    ;;
    
"main")
    if [ "$wcnss_config" == "true" ]; then
        $LOG "configuring wcnss driver ..."
        mount -o remount,rw /
        chown system:wifi /driver/wcnss/WCNSS_qcom_cfg.ini
        mount --bind /driver/wcnss/WCNSS_qcom_cfg.ini /system/etc/wifi/WCNSS_qcom_cfg.ini
        mount -o remount,ro /
        rm -f /data/misc/wifi/WCNSS_qcom_cfg.ini
        ln -s /driver/wcnss/WCNSS_qcom_cfg.ini /data/misc/wifi/WCNSS_qcom_cfg.ini
    else
        rm -f /data/misc/wifi/WCNSS_qcom_cfg.ini
        ln -s /system/etc/wifi/WCNSS_qcom_cfg.ini /data/misc/wifi/WCNSS_qcom_cfg.ini
    fi
    
    $LOG "mounting driver files ..."
    umount /system/lib/modules
    mount --bind /driver/modules /system/lib/modules
    
    $LOG "installing drivers ..."
    #insmod /system/lib/modules/pronto/pronto_wlan.ko
    ;;

esac

$LOG "all done!"

#!/system/bin/sh
LOG="log -p i -t dfc643-misc"

early_load() {
    miad_disable=`getprop dfc643.misc.miad_disable`
    if [ "$miad_disable" == "true" ]; then
        $LOG "overriding miad on sdcard ..."
        rm -rf /storage/self/primary/miad
        echo "DO_NOT_REMOVE" > /storage/self/primary/miad

        $LOG "disabling miad application ..."
        mount --bind /empty /system/app/systemAdSolution
        mount --bind /empty /data/app/com.miui.systemAdSolution-1
        mount --bind /empty /data/app/com.miui.systemAdSolution-2
        mount --bind /empty /data/app/com.miui.systemAdSolution-3
        mount --bind /empty /system/app/MSA-CN-NO_INSTALL_PACKAGE
        mount --bind /empty /system/app/mab
        mount --bind /empty /system/app/MSA
        mount --bind /empty /system/app/MSA-Global
        mount --bind /empty /system/app/AnalyticsCore
        mount --bind /empty /system/app/CarrierDefaultApp
        mount --bind /empty /system/app/WAPPushManager
    fi


    gapps_disable=`getprop dfc643.misc.gapps_disable`
    if [ "$gapps_disable" == "true" ]; then
    $LOG "disabling google application ..."
        mount --bind /empty /system/app/GoogleCalendarSyncAdapter
        mount --bind /empty /system/app/LatinImeGoogle
        mount --bind /empty /system/app/GoogleContactsSyncAdapter
        mount --bind /empty /system/app/Gmail2
        mount --bind /empty /system/app/GoogleKeyboard
        mount --bind /empty /system/app/Hangouts
        mount --bind /empty /system/app/GoogleTTS
        mount --bind /empty /system/app/GooglePrintRecommendationService
        mount --bind /empty /system/app/GoogleKeyboard
        mount --bind /empty /system/priv-app/PrebuiltGmsCore
        mount --bind /empty /system/priv-app/Phonesky
        mount --bind /empty /system/priv-app/GooglePartnerSetup
        mount --bind /empty /system/priv-app/GoogleFeedback
        mount --bind /empty /system/priv-app/GoogleBackupTransport
        mount --bind /empty /system/priv-app/GoogleLoginService
        mount --bind /empty /system/priv-app/GoogleOneTimeInitializer
        mount --bind /empty /system/priv-app/GoogleServicesFramework
        mount --bind /empty /system/priv-app/GoogleOneTimeInitializer
        mount --bind /empty /system/priv-app/GooglePlayServicesUpdater
        mount --bind /empty /system/priv-app/GmsCore
        mount --bind /empty /system/priv-app/Velvet
    fi
    
    
    #__override_system_apps__
    $LOG "patching system apps ..."
    mount --bind /misc/app/MiuiHome /system/priv-app/MiuiHome #MiuiHome-4.1.4,fixed_memory_leak
    

    mido_enhance=`getprop dfc643.misc.mido_enhance`
    if [ "$mido_enhance" == "true" ]; then
    $LOG "overriding mido device_features ..."
        mount --bind /misc/device_features/mido.xml /system/etc/device_features/mido.xml
    fi
    
    if [ -f /data/media/0/Android/linux/hosts ]; then
        $LOG "found user's hosts file, loading ..."
        echo "127.0.0.1 localhost" > /data/local/tmp/hosts
        echo "::1 ip6-localhost" >> /data/local/tmp/hosts
        cat /data/media/0/Android/linux/hosts >> /data/local/tmp/hosts
        chmod 644 /data/local/tmp/hosts
        mount --bind /data/local/tmp/hosts /system/etc/hosts
        $LOG "user hosts loaded!"
    fi
}

later_load() {

}

case "$1" in
"early_load")
    $LOG "initizing early_load ..."
    early_load
    ;;
"later_load")
    $LOG "initizing later_load ..."
    later_load
    ;;
esac

$LOG "all done!"

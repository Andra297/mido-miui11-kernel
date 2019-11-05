#!/system/bin/sh
# Set Memory paremeters.
#
# Set per_process_reclaim tuning parameters
# 2GB 64-bit will have aggressive settings when compared to 1GB 32-bit
# 1GB and less will use vmpressure range 50-70, 2GB will use 10-70
# 1GB and less will use 512 pages swap size, 2GB will use 1024
#
# Set Low memory killer minfree parameters
# 32 bit all memory configurations will use 15K series
# 64 bit up to 2GB with use 14K, and above 2GB will use 18K
#
# Set ALMK parameters (usually above the highest minfree values)
# 32 bit will have 53K & 64 bit will have 81K
#
# Set ZCache parameters
# max_pool_percent is the percentage of memory that the compressed pool
# can occupy.
# clear_percent is the percentage of memory at which zcache starts
# evicting compressed pages. This should be slighlty above adj0 value.
# clear_percent = (adj0 * 100 / avalible memory in pages)+1
#
LOG="log -p i -t dfc643-memory"
$LOG "initizing ..."
arch_type=`uname -m`
MemTotalStr=`cat /proc/meminfo | grep MemTotal`
MemTotal=${MemTotalStr:16:8}
MemTotalPg=$((MemTotal / 4))
adjZeroMinFree=18432

# Read adj series and set adj threshold for PPR and ALMK.
# This is required since adj values change from framework to framework.
adj_series=`cat /sys/module/lowmemorykiller/parameters/adj`
adj_1="${adj_series#*,}"
set_almk_ppr_adj="${adj_1%%,*}"

# PPR and ALMK should not act on HOME adj and below.
# Normalized ADJ for HOME is 6. Hence multiply by 6
# ADJ score represented as INT in LMK params, actual score can be in decimal
# Hence add 6 considering a worst case of 0.9 conversion to INT (0.9*6).
set_almk_ppr_adj=$(((set_almk_ppr_adj * 6) + 6))
echo $set_almk_ppr_adj > /sys/module/lowmemorykiller/parameters/adj_max_shift
echo $set_almk_ppr_adj > /sys/module/process_reclaim/parameters/min_score_adj
#echo 1 > /sys/module/process_reclaim/parameters/enable_process_reclaim
#echo 70 > /sys/module/process_reclaim/parameters/pressure_max
#echo 30 > /sys/module/process_reclaim/parameters/swap_opt_eff
#echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
lmk_opt_mode=`getprop dfc643.memory.lmkopt`
if [ "$lmk_opt_mode" == "true" ]; then
    $LOG "adjusting lowmemorykiller parameters ..."
    #echo 50 > /sys/module/process_reclaim/parameters/pressure_min
    #echo 512 > /sys/module/process_reclaim/parameters/per_swap_size
    echo "5120,7680,10240,12800,19200,25600" > /sys/module/lowmemorykiller/parameters/minfree
    echo 26850 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
    adjZeroMinFree=14746
elif [ "$arch_type" == "aarch64" ] && [ $MemTotal -gt 2097152 ]; then
    #echo 10 > /sys/module/process_reclaim/parameters/pressure_min
    #echo 1024 > /sys/module/process_reclaim/parameters/per_swap_size
    echo "18432,23040,27648,32256,55296,80640" > /sys/module/lowmemorykiller/parameters/minfree
    echo 81250 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
    adjZeroMinFree=18432
elif [ "$arch_type" == "aarch64" ] && [ $MemTotal -gt 1048576 ]; then
    #echo 10 > /sys/module/process_reclaim/parameters/pressure_min
    #echo 1024 > /sys/module/process_reclaim/parameters/per_swap_size
    echo "14746,18432,22118,25805,40000,55000" > /sys/module/lowmemorykiller/parameters/minfree
    echo 56250 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
    adjZeroMinFree=14746
elif [ "$arch_type" == "aarch64" ]; then
    #echo 50 > /sys/module/process_reclaim/parameters/pressure_min
    #echo 512 > /sys/module/process_reclaim/parameters/per_swap_size
    echo "14746,18432,22118,25805,40000,55000" > /sys/module/lowmemorykiller/parameters/minfree
    echo 81250 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
    adjZeroMinFree=14746
else
    #echo 50 > /sys/module/process_reclaim/parameters/pressure_min
    #echo 512 > /sys/module/process_reclaim/parameters/per_swap_size
    echo "15360,19200,23040,26880,34415,43737" > /sys/module/lowmemorykiller/parameters/minfree
    echo 53059 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
    adjZeroMinFree=15360
fi

# zCache
$LOG "configuring and enabling zCache ..."
clearPercent=$((((adjZeroMinFree * 100) / MemTotalPg) + 1))
echo $clearPercent > /sys/module/zcache/parameters/clear_percent
echo 30 >  /sys/module/zcache/parameters/max_pool_percent

# zRAM disk
zram_enable=`getprop dfc643.memory.zram`
zram_size=`getprop dfc643.memory.zram.size`
# Default Zram size is 1.2GB
if [ "$zram_size" == "" ]; then
    zram_size=1288490188
else
    zram_size=$(($zram_size * 1024 * 1024))
fi
if [ "$zram_enable" == "true" ]; then
    $LOG "configuring and enabling zRAM ..."
    swapoff /dev/block/zram0 > /dev/null 2>&1
    echo '1' > /sys/block/zram0/reset
    echo '0' > /sys/block/zram0/disksize
    echo '8' > /sys/block/zram0/max_comp_streams
    #echo 'lz4' > /sys/block/zram0/comp_algorithm
    echo $zram_size > /sys/block/zram0/disksize
    mkswap /dev/block/zram0
    swapon /dev/block/zram0 -p 32758
    echo '100' > /proc/sys/vm/swappiness
else
    $LOG "disabling zRAM ..."
    swapoff /dev/block/zram0 > /dev/null 2>&1
    echo '1' > /sys/block/zram0/reset
    echo '0' > /sys/block/zram0/disksize
fi

# SWAP
swap_enable=`getprop dfc643.memory.swap`
swap_size=`getprop dfc643.memory.swap.size`
# Default Swap size is 256MB
if [ "$swap_size" == "" ]; then
    swap_size=256
fi
if [ "$swap_enable" == "true" ]; then
    $LOG "configuring and enabling swap ..."
    # Static swiftness
    echo 1 > /proc/sys/vm/swap_ratio_enable
    echo 70 > /proc/sys/vm/swap_ratio

    # Swap disk
    if [ ! -f /data/system/swap/swapfile ]; then
        dd if=/dev/zero of=/data/system/swap/swapfile bs=1m count=$swap_size
    fi
    mkswap /data/system/swap/swapfile
    swapon /data/system/swap/swapfile -p 32758
fi

$LOG "all done!"

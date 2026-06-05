#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: eSirPlayground
# Youtube Channel: https://goo.gl/fvkdwm 
#=================================================
#1. Modify default IP
sed -i 's/192.168.1.1/192.168.5.1/g' openwrt/package/base-files/files/bin/config_generate

#2. Clear the login password
sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' openwrt/package/lean/default-settings/files/zzz-default-settings

#3. Replace with JerryKuKu’s Argon
#rm openwrt/package/lean/luci-theme-argon -rf

# 直接重写 99-default_network，将 eth0 设为 WAN，eth1 设为 LAN
cat << 'EOF' > package/base-files/files/etc/board.d/99-default_network
#!/bin/sh
# 强制覆盖默认网络逻辑：eth0 为 WAN，eth1 为 LAN
. /lib/functions/uci-defaults.sh

board_config_update

# 核心修改：明确指定 eth0 为 WAN，eth1 为 LAN
ucidef_set_interfaces_lan_wan "eth1" "eth0"

board_config_flush
exit 0
EOF

# 确保脚本有执行权限
chmod +x package/base-files/files/etc/board.d/99-default_network

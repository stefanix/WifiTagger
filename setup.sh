

# install packages for mod-lua
scp -r packages/*.ipk root@192.168.1.1:/root/
ssh root@192.168.1.1 'opkg install /root/*.ipk"'
ssh root@192.168.1.1 'rm /root/*.ipk"'

# copy wifiTagger web app to router
scp -r www/* root@192.168.1.1:/www/

# setup uhttpd to serve index.lua
# this is a catch-all, all requests go through it
# The config file is "/etc/config/uhttpd"
ssh root@192.168.1.1 'uci set uhttpd.main.lua_prefix=/'
ssh root@192.168.1.1 'uci set uhttpd.main.lua_handler=/www/index.lua'
ssh root@192.168.1.1 'uci commit uhttpd'
ssh root@192.168.1.1 '/etc/init.d/uhttpd restart'

# make router a captive portal by resolving all domains
# to its own IP address (restart of dnsmasq required)
ssh root@192.168.1.1 'echo "address=/#/192.168.1.1" >> /etc/dnsmasq.conf'
ssh root@192.168.1.1 '/etc/init.d/dnsmasq restart'

# enable wifi radio, set default SSID
ssh root@192.168.1.1 'uci set wireless.@wifi-iface[0].ssid="WifiTagger"'
ssh root@192.168.1.1 'uci set wireless.@wifi-device[0].disabled=0'
ssh root@192.168.1.1 'uci commit wireless'
ssh root@192.168.1.1 'uci apply wireless'


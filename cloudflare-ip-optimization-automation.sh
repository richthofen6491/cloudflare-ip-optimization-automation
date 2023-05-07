#!/bin/bash
while true
do



#Get IP Address
###############################
#IPv4
./CloudflareST -n 100 -t 5 -dn 30 -dt 15 -url https://speed.cloudflare.com/__down?bytes=500000000 -f cloudflare_ipv4_list.txt -o ipv4_raw_result.txt
#IPv6
./CloudflareST -n 100 -t 5 -dn 30 -dt 15 -url https://speed.cloudflare.com/__down?bytes=500000000 -f cloudflare_ipv6_list.txt -o ipv6_raw_result.txt
###############################




#Clean IP Address
###############################
#IPv4
cat ipv4_raw_result.txt|grep -oP "([0-9]{1,3}[\.]){3}[0-9]{1,3}">ipv4_result.txt
#IPv6
cat ipv6_raw_result.txt|egrep -o '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]).){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]).){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))'>ipv6_result.txt
###############################




#Generate v2ray subscription from vless list
###############################
#IPv4
for vless in $(cat vless_list.txt)
do
  for ip in $(cat ipv4_result.txt)
  do
    echo $vless >> subscription_raw
    sed -i "s/ADDRESS/$ip/g" subscription_raw
    sed -i "s/IPADDR/$ip/g" subscription_raw
  done
done
#IPv6
for vless in $(cat vless_list.txt)
do
  for ip in $(cat ipv6_result.txt)
  do
    echo $vless >> subscription_raw
    sed -i "s/ADDRESS/[$ip]/g" subscription_raw
    sed -i "s/IPADDR/$ip/g" subscription_raw
  done
done
#Encode raw vless list to subscription file
cat subscription_raw|base64 > vless
#delete raw vless list
rm -rf subscription_raw
###############################



#Generate v2ray subscription from vmess list
###############################
#IPv4
for vmess in $(cat vmess_list.txt)
do
  for ip in $(cat ipv4_result.txt)
  do
    echo $vmess | base64 -d > vmess_tmp.txt
    sed -i "s/ADDRESS/$ip/g" vmess_tmp.txt
    sed -i "s/IPADDR/$ip/g" vmess_tmp.txt
    echo -n "vmess://" >> subscription_raw
    cat vmess_tmp.txt|base64 -w 0 >>subscription_raw
    echo >> subscription_raw
  done
done
#IPv6
for vmess in $(cat vmess_list.txt)
do
  for ip in $(cat ipv6_result.txt)
  do
    echo $vmess | base64 -d > vmess_tmp.txt
    sed -i "s/ADDRESS/$ip/g" vmess_tmp.txt
    sed -i "s/IPADDR/$ip/g" vmess_tmp.txt
    echo -n "vmess://" >> subscription_raw
    cat vmess_tmp.txt|base64 -w 0 >>subscription_raw
    echo >> subscription_raw
  done
done
#Encode raw vless list to subscription file
cat subscription_raw|base64 > vmess
#delete raw vless list
rm -rf subscription_raw
###############################




#Generate clash subscription from vmess list
###############################
#IPv4
for vmess in $(cat clash_etc/vmess_for_clash_list.txt)
do
  touch $vmess\_clash.yml
  echo "mode: global" > $vmess\_clash.yml
  echo "proxies:" >> $vmess\_clash.yml
  for ip in $(cat ipv4_result.txt)
  do
    cat $vmess >> $vmess\_clash.yml
    sed -i "s/ADDRESS/$ip/g" $vmess\_clash.yml
    sed -i "s/IPADDR/$ip/g" $vmess\_clash.yml
    #echo -n "vmess://" >> subscription_raw
    #cat vmess_tmp.txt|base64 -w 0 >>subscription_raw
    #echo >> subscription_raw
  done
  cat clash_etc/clash_yml_proxy_group_configs.txt >> $vmess\_clash.yml
  for ip in $(cat ipv4_result.txt)
  do
    echo "      - Node-ADDRESS" >> $vmess\_clash.yml
    sed -i "s/ADDRESS/$ip/g" $vmess\_clash.yml
  done
done






#auto upload
s3cmd put vmess s3://proxy-subscription --acl-public
s3cmd put vless s3://proxy-subscription --acl-public
s3cmd put clash_etc/*.yml s3://proxy-subscription --acl-public



sleep 604800
done

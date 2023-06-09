# cloudflare-ip-optimization-automation

一个使用 XIU2/CloudflareSpeedTest 来自动选择优化IP并且生成VMESS/VLESS/Clash订阅的脚本

## 主要功能

本脚本适用于使用 VMESS+WS+TLS 或者 VLESS+WS+TLS 方式部署，并结合 CloudFlare CDN 使用的代理服务器，

基于XIU2/CloudflareSpeedTest，添加了一定程度上的自动化和输出v2ray/clash格式订阅文件的功能。

该脚本旨在解决使用 CloudFlare CDN 代理的 VMESS/VLESS 服务器所遇到的如下问题

1. IPv6兼容性不良: 在不支援IPv6的老旧设备上直接使用CloudFlare CDN代理的地址时，偶尔或完全无法连接。

2. CDN 节点延迟高: DNS直接解析出的CloudFlare CDN节点延迟过高，造成不良使用体验。

3. CDN 下载速度慢: DNS直接解析出的CloudFlare CDN节点带宽过低，造成奥里给一般的使用体验。

4. CDN 丢包多: DNS直接解析出的CloudFlare CDN节点在运气不好的时候会丢包很多

5. 只连接单个CDN节点而速度缓慢: 在本地网络质量不佳(比如太过保守的QoS规则)的情况下，使用本脚本输出的Clash配置文件中的负载均衡规则，通过多个CloudFlare CDN节点连接至同一个WS，可能提升使用体验。

借助本脚本，您可以根据自己的设置，轻松输出 V2Ray 订阅文件，包含负载均衡规则的 Clash 订阅文件。

您可以将本脚本部署至您位于本地网络中的 NAS / 服务器 / 软路由等设备上，并设置时间隔以保持服务运行。

## 部署/使用方式

待添加

## 待办事项

添加部署方式、使用方式的说明

添加丢包数量限制

添加Containerfile或者Dockerfile并且提供Docker.io或者Quay.io的容器镜像

## 注意事项

安全问题：如果可以尽量不要使用Clash for Windows这种东西，可能会有潜在的安全风险。


# cloudflare-ip-optimization-automation

一个使用 XIU2/CloudflareSpeedTest 来自动选择优化IP并且生成VMESS/VLESS/Clash订阅的脚本

## 主要功能

本脚本适用于使用 VMESS+WS+TLS 或者 VLESS+WS+TLS 方式部署，并结合 CloudFlare CDN 使用的代理服务器，它提供了优选IP和输出v2ray/clash格式订阅文件的功能。

该脚本旨在解决使用 CloudFlare CDN 代理的 VMESS/VLESS 服务器所遇到的 IPv6 兼容性、CDN 节点延迟高、CDN 下载速度慢、只连接单个 CDN 节点而速度缓慢等问题。

借助本脚本，您可以根据自己的设置，轻松输出 V2Ray 订阅文件，包含负载均衡规则的 Clash 订阅文件。

您可以将本脚本部署至您位于本地网络中的 NAS / 服务器 / 软路由等设备上，并设置时间隔以保持服务运行。

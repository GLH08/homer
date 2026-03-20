# 智能卡片

智能卡片（Smart Cards）为外部服务提供特定的集成功能，在基础服务卡片之上显示额外信息和功能。通过在 YAML 配置的服务项中添加 `type` 键即可启用。

每种服务集成有不同的要求和配置参数（参见下方卡片列表）。

> [!WARNING]
> 您的 `config.yml` 文件通过 HTTP 暴露在 `/assets/config.yml`。文件中的任何敏感信息（如 API 密钥）
> 对任何能访问您 Homer 实例的人都可见。只有在 Homer 实例受身份验证或访问控制保护时，
> 才应在此文件中包含 API 密钥，**或者使用代理（如 [`CORSair`](https://github.com/bastienwirtz/corsair)）
> 在服务端安全地注入凭据**。

可用服务位于 `src/components/services/`：

- [通用选项](#通用选项)
- [AdGuard Home](#adguard-home)
- [CopyToClipboard](#复制到剪贴板)
- [Docuseal](#docuseal)
- [Docker Socket Proxy](#docker-socket-proxy)
- [Emby / Jellyfin](#emby--jellyfin)
- [FreshRSS](#freshrss)
- [Gatus](#gatus)
- [Gitea / Forgejo](#gitea--forgejo)
- [Glances](#glances)
- [Gotify](#gotify)
- [Healthchecks](#healthchecks)
- [Home Assistant](#home-assistant)
- [Immich](#immich)
- [Jellystat](#jellystat)
- [Lidarr, Prowlarr, Sonarr, Readarr, Radarr](#lidarr-prowlarr-sonarr-readarr-radarr)
- [Linkding](#linkding)
- [Matrix](#matrix)
- [Mealie](#mealie)
- [Medusa](#medusa)
- [Miniflux](#miniflux)
- [Nextcloud](#nextcloud)
- [OctoPrint / Moonraker](#octoprintmoonraker)
- [OliveTin](#olivetin)
- [OpenHAB](#openhab)
- [OpenWeatherMap](#openweathermap)
- [Paperless-NGX](#paperless-ngx)
- [PeaNUT](#peanut)
- [PiAlert](#pialert)
- [PiHole](#pihole)
- [Ping](#ping)
- [Plex](#plex)
- [Portainer](#portainer)
- [Prometheus](#prometheus)
- [Proxmox](#proxmox)
- [qBittorrent](#qbittorrent)
- [rTorrent](#rtorrent)
- [SABnzbd](#sabnzbd)
- [Scrutiny](#scrutiny)
- [Speedtest Tracker](#speedtest-tracker)
- [Tautulli](#tautulli)
- [Tdarr](#tdarr)
- [Traefik](#traefik)
- [Transmission](#transmission)
- [TrueNAS Scale](#truenas-scale)
- [Uptime Kuma](#uptime-kuma)
- [Vaultwarden](#vaultwarden)
- [Wallabag](#wallabag)
- [What's Up Docker](#whats-up-docker)

> [!IMPORTANT]
> 与外部服务交互的智能卡片受 CORS 限制，因此需要满足以下条件之一：
>
> - 所有服务与 Homer 托管在**同一域名**（mydomain.tld/pihole, mydomain.tld/proxmox），以完全避免跨域请求。
> - 所有服务配置为**接受跨站请求**，在响应中发送必要的 CORS 头（可以直接在服务配置中设置，或通过代理）。
> - **使用代理**添加必要的 CORS 头（方案很多，部分可参见[这里](https://enable-cors.org/server.html)，也推荐轻量简单的方案 [`CORSair`](https://github.com/bastienwirtz/corsair)）。
>
> 如遇问题，请参阅[故障排除](troubleshooting.md#服务卡片不工作什么都不显示或显示离线状态-pi-hole-sonarr-ping-)页面。

## 通用选项

```yaml
- name: "我的服务"
  type: "<类型>"
  logo: "assets/tools/sample.png" # 可选
  url: https://my-service.url # 可选：不指定 'endpoint' 时作为卡片链接和 API 基础 URL
  endpoint: https://my-service-api.url # 可选：用于获取服务数据的替代基础 URL
  useCredentials: false # 可选：覆盖全局 proxy.useCredentials 配置
  headers: # 可选：覆盖全局 proxy.headers 配置
```

如果提供了副标题（使用 `subtitle` 配置键），**它将覆盖（隐藏）** 自定义集成在副标题行显示的任何自定义信息。

## AdGuard Home

显示 AdGuard Home 防护状态和拦截查询统计。

```yaml
- name: "AdGuard Home"
  type: "AdGuardHome"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
```

> **注意**：如果 AdGuard Home 的 Web 用户受密码保护，必须在所有请求中携带 Authorization HTTP 头。可以通过代理实现，或在服务项配置中添加：
>
> ```yaml
> headers:
>   Authorization: "Basic <base64编码的 username:password>"
> ```

## 复制到剪贴板

显示一个带复制按钮的服务卡片，点击后会将指定文本复制到剪贴板。

```yaml
- name: "复制文本！"
  type: "CopyToClipboard"
  logo: "assets/tools/sample.png"
  subtitle: "点击复制图标复制文本"
  clipboard: "这段文字将被复制到剪贴板"
  url: "https://optional-link.com" # 可选：点击卡片（不是复制按钮）时打开
```

## Docker Socket Proxy

显示 Docker Socket Proxy 的运行中、已停止和错误容器的数量。

```yaml
- name: "Docker"
  type: "DockerSocketProxy"
  logo: "assets/tools/sample.png"
  endpoint: "https://my-service-api.url:port"
```

## Docuseal

显示 Docuseal 版本。

```yaml
- name: Docuseal
  type: Docuseal
  logo: "assets/tools/sample.png"
  url: https://my-service.url
```

## Emby / Jellyfin

显示 Emby 或 Jellyfin 服务器的统计数据。
`libraryType` 配置可选择显示的统计类型。

```yaml
- name: "Emby"
  type: "Emby"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  apikey: "<---在此插入 API 密钥--->"
  libraryType: "music" # 选择显示的统计类型，可选：music、series 或 movies
```

## FreshRSS

显示 FreshRSS 服务器的未读文章数和订阅总数。

```yaml
- name: "FreshRSS"
  type: "FreshRSS"
  url: https://my-service.url
  updateInterval: 5000 # (可选) 更新统计的时间间隔（毫秒）
  username: "<---您的用户名--->"
  password: "<---您的密码--->"
```

## Gatus

Gatus 服务显示来自 Gatus 服务器的已配置服务信息。
在 config.yml 中需要两行配置：

```yaml
  type: "Gatus"
  url: "http://192.168.0.151/gatus"
```

可选地，可以过滤结果，只包含定义组中的任务：
```yaml
  groups: [Services, External]
```

可以定义更新时间间隔（毫秒）来定期检查状态：
```yaml
  updateInterval: 5000
```

可以通过设置以下内容来隐藏平均响应时间（同时节省计算资源）：
```yaml
  hideaverages: true
```

## Gitea / Forgejo

显示 Gitea / Forgejo 版本。

```yaml
- name: Forgejo
  type: Gitea
  logo: "assets/tools/sample.png"
  url: https://my-service.url
```

## Glances

显示 Glances 服务器的系统指标（CPU、内存、Swap、负载）。

```yaml
- name: "系统指标"
  type: "Glances"
  icon: "fa-solid fa-heart-pulse"
  url: https://my-service.url
  stats: [cpu, mem] # 选项：load, cpu, mem, swap
```

如果没有现成的 Glances 服务器，以下是 Docker Compose 示例供参考：

```yml
---
services:
  glances:
    image: nicolargo/glances:latest
    container_name: glances
    environment:
      - TZ=Europe/Rome
      - GLANCES_OPT=-w
    ports:
      - 61208:61208
    restart: unless-stopped
```

## Gotify

显示待处理消息数量和系统健康状态。

```yaml
- name: "Gotify"
  type: "Gotify"
  url: https://my-service.url
  apikey: "<---在此插入客户端令牌--->"
```

**API 令牌**：请使用**客户端令牌**（而非应用令牌）。

## Healthchecks

显示 Healthchecks 监控服务的状态统计（正常/异常/宽限期）。

```yaml
- name: "Healthchecks"
  type: "Healthchecks"
  url: https://my-service.url
  apikey: "<---在此插入 API 密钥--->"
```

**API 密钥**：在 Healthchecks 网页界面的 **Settings > API Access > API key (read-only)** 中查找。

## Home Assistant

显示 Home Assistant 实例状态、版本、位置和实体数量。

```yaml
- name: "Home Assistant"
  type: "HomeAssistant"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  apikey: "<---在此插入长期访问令牌--->"
  items: [] # 可选："name"、"version"、"entities"
  separator: " " # 可选
```

**API 令牌**：在 Home Assistant 中创建长期访问令牌：
1. 进入 **Profile > Security > Long-lived access tokens**
2. 点击 **Create Token**

**CORS 配置**：编辑 Home Assistant 的 `configuration.yml`，添加 Homer 的 IP：
```yaml
http:
  cors_allowed_origins:
    - "http://homer.local:8080"
    - "https://your-homer-domain.com"
```

## Immich

显示 Immich 服务器的用户数量、照片/视频数量和存储使用情况。

```yaml
- name: "Immich"
  type: "Immich"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  apikey: "<---在此插入 API 密钥--->"
```

**要求**：Immich 服务器版本需为 `1.118.0` 或更高
**API 密钥**：在 Immich 网页界面的 **Administration > API Keys** 中创建

## Jellystat

显示 Jellyfin 服务器上的当前并发流数量。

```yaml
- name: "Jellystat"
  type: "Jellystat"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  apikey: "<---在此插入 API 密钥--->"
```

**API 密钥**：可以在 Jellystat 服务器的仪表板中创建：Settings/API Keys -> Add Key

## Lidarr、Prowlarr、Sonarr、Readarr 和 Radarr

显示 Lidarr、Readarr、Radarr 或 Sonarr 应用的活动（蓝色）、缺失（紫色）、警告（橙色）或错误（红色）通知气泡。
在 `config.yml` 中需要两行配置：

```yaml
- name: "Lidarr"
  type: "Lidarr" # "Lidarr"、"Prowlarr"、"Radarr" 或 "Sonarr"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  checkInterval: 5000 # (可选) 更新状态的时间间隔（毫秒）
  apikey: "<---在此插入 API 密钥--->"
```

URL 必须是 Lidarr、Prowlarr、Readarr、Radarr 或 Sonarr 应用的根 URL。

**API 密钥**：Lidarr、Prowlarr、Readarr、Radarr 或 Sonarr 的 API 密钥可在 `Settings` > `General` 中找到，这是访问 API 所必需的。

> [!IMPORTANT]
> **Radarr API V3 支持**：如果您使用的 Radarr 或 Sonarr 版本较旧，不支持新的 V3 API 端点，请在服务配置中添加 `"legacyApi: true"`。

## Linkding

此集成可以查询 Linkding 并列出多个结果。
Linkding 需要启用 CORS，但 Linkding 本身不支持，可以通过前置反向代理解决。
此集成最多返回 15 个结果，可以多次添加到仪表盘并使用不同查询来获取所需内容。

```yaml
- name: "Linkding"
  type: "Linkding"
  url: https://my-service.url
  token: "<---在此插入 API 密钥--->"
  limit: 10 # Linkding 返回的最大条目数，最小 1，最大 15
  query: "#ToDo #Homer" # 在 Linkding 中执行的查询，使用 #标签名 搜索标签
```

## Matrix

显示 Matrix 版本，并显示服务器是否在线。

```yaml
- name: "Matrix - 服务器"
  type: "Matrix"
  logo: "assets/tools/sample.png"
  url: "http://matrix.example.com"
```

## Mealie

显示 Mealie 管理中的食谱数量，或者当天有计划时显示今日餐食计划。

```yaml
- name: "Mealie"
  type: "Mealie"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  apikey: "<---在此插入 API 密钥--->"
```

**API 密钥**：需要在 Mealie 安装中设置的 API 密钥字段中创建。
API 页面位置：点击汉堡菜单 -> 点击您的头像 -> 点击 "Manage your API Tokens"

## Medusa

显示 Medusa 应用的通知气泡：新闻（灰色）、警告（橙色）或错误（红色）。

```yaml
- name: "Medusa"
  type: "Medusa"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  apikey: "<---在此插入 API 密钥--->"
```

URL 必须是 Medusa 应用的根 URL。

**API 密钥**：Medusa API 密钥可在 General 配置 > Interface 中找到，这是访问 Medusa API 所必需的。

## Miniflux

显示 Miniflux RSS 阅读器中的未读文章数量。

```yaml
- name: "Miniflux"
  type: "Miniflux"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  apikey: "<---在此插入 API 密钥--->"
  style: "status" # 可选 "status" 或 "counter"
  checkInterval: 60000 # 可选：更新未读数的时间间隔（毫秒）
```

**API 密钥**：在 Miniflux 网页界面的 **Settings > API Keys > Create a new API key** 中生成

## Nextcloud

显示 Nextcloud 版本，并显示 Nextcloud 是在线、离线还是处于[维护模式](https://docs.nextcloud.com/server/stable/admin_manual/maintenance/upgrade.html#maintenance-mode)。

```yaml
- name: Nextcloud
  type: Nextcloud
  logo: assets/tools/sample.png
  url: https://my-service.url
```

## OctoPrint / Moonraker

OctoPrint/Moonraker 服务只需一个 `apikey` 和 `endpoint`，可选地提供 `display` 或 `url` 选项。`url` 用于点击服务时跳转到指定地址。
Moonraker 的 API 模拟了 OctoPrint 的部分端点，因此这两个服务是兼容的。详情见 <https://moonraker.readthedocs.io/en/latest/web_api/#octoprint-api-emulation>。

```yaml
- name: "Octoprint"
  type: "OctoPrint"
  logo: assets/tools/sample.png
  endpoint: "https://my-service-api.url:port"
  apikey: "<---在此插入 API 密钥--->"
  display: "text" # 'text' 或 'bar'，默认为 'text'
```

## OliveTin

显示 OliveTin 版本。

```yaml
- name: OliveTin
  type: OliveTin
  logo: assets/tools/sample.png
  url: https://my-service.url
```

## OpenHAB

显示 OpenHAB 系统状态、Thing 数量和 Item 数量。

```yaml
- name: "OpenHAB"
  type: "OpenHAB"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  apikey: "<---在此插入 API 密钥--->"
  things: true # 查询 things API 获取数量
  items: true  # 查询 items API 获取数量
```

**API 令牌**：按照 [OpenHAB 官方文档](https://www.openhab.org/docs/configuration/apitokens.html) 创建 API 令牌

**CORS 配置**：编辑 `services/runtime.cfg` 并添加：

```ini
org.openhab.cors:enable=true
```

## OpenWeatherMap

使用 OpenWeatherMap 服务可以显示指定位置的天气信息。
OpenWeatherMap 服务有以下可用配置：

```yaml
- name: "天气"
  type: "OpenWeather"
  apikey: "<---在此插入 API 密钥--->" # 从 https://openweathermap.org/api 获取
  location: "Amsterdam" # 您的位置
  locationId: "2759794" # 可选：指定 OpenWeatherMap 城市 ID 以提高准确性
  units: "metric" # 显示温度的单位，可选：metric、imperial、kelvin，默认为 kelvin
  background: "square" # 图片背景样式，可选：square、circle、none，默认为 none
```

**说明：**
如果通过 `location` 属性输入城市名找不到您的城市，也可以尝试在 `locationId` 属性中配置 OWM 城市 ID。要获取特定城市 ID，请访问 [OWM 网站](https://openweathermap.org)，搜索您的城市并从 URL 中获取 ID（例如阿姆斯特丹的城市 ID 是 2759794）。

## Paperless-NGX

显示存储的文档总数。

```yaml
- name: "Paperless"
  type: "PaperlessNG"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  apikey: "<---在此插入 API 密钥--->"
```

**API 密钥**：在 Settings > Administration > Auth Tokens 中生成

## PeaNUT

显示 UPS 设备的当前状态和负载。

```yaml
- name: "PeaNUT"
  type: PeaNUT
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  # device: "ups" # 设备 ID
```

## PiAlert

显示 PiAlert 服务器的统计数据。

```yaml
- name: "PiAlert"
  type: "PiAlert"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  updateInterval: 5000 # (可选) 更新统计的时间间隔（毫秒）
```

## PiHole

直接在 Homer 仪表盘上显示本地 PiHole 实例的信息。

```yaml
- name: "Pi-hole"
  type: "PiHole"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  # endpoint: "https://my-service-api.url" # 可选，对于 v6 API，这是获取 Pi-hole 数据的基础 URL，会覆盖 url
  apikey: "<---在此插入 API 密钥--->" # 可选，Web 界面有密码保护时需要
  apiVersion: 5 # 可选，默认为 5。如果 PiHole 实例使用 API v6，请设为 6
  checkInterval: 3000 # 可选，默认为 300000。检查 Pi-hole 状态的间隔（毫秒）
```

**API 密钥**：仅在 Pi-hole Web 界面有密码保护时需要。进入 **Settings > API/Web Interface > Show API token**

**API 版本**：

- **v5**（默认）：使用旧版 API 端点
- **v6**：使用带会话管理的现代 API —— 设置 `apiVersion: 6`

## Ping

检查目标链接是否可用，并显示请求的往返时间（RTT）。
默认使用 HEAD 方法，但可以通过可选的 `method` 属性配置为使用 GET。
可选地，使用 `successCodes` 定义哪些 HTTP 响应状态码应被视为可用状态。

```yaml
- name: "示例应用"
  type: Ping
  logo: "assets/tools/sample.png"
  url: "https://www.wikipedia.org/"
  # method: "head"
  # successCodes: [200, 418] # 可选，默认为所有 2xx HTTP 响应状态码
  # timeout: 500 # 超时时间（毫秒），超时后中止 ping，默认为 2000
  # subtitle: "书签示例" # 默认情况下，未设置副标题时显示请求往返时间
  # updateInterval: 5000 # (可选) 更新 ping 状态的时间间隔（毫秒）
```

## Plex

显示 Plex 服务器的活动流数量、电影总数和电视剧总数。

```yaml
- name: "Plex"
  type: "Plex"
  logo: "assets/tools/sample.png"
  url: "https://my-service.url/web"
  endpoint: "https://my-service.url"
  token: "<---在此插入 Plex 令牌--->"
```

**Plex 令牌**：请参阅[如何查找 Plex 令牌](https://www.plexopedia.com/plex-media-server/general/plex-token/)

## Portainer

显示 Portainer 实例的容器数量（运行中/停止/其他）、版本和在线状态。

```yaml
- name: "Portainer"
  type: "Portainer"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  apikey: "<---在此插入 API 密钥--->"
  environments: # 可选：指定要检查的特定环境
    - "raspberry"
    - "local"
```

**要求**：Portainer 版本 1.11 或更高

**API 密钥**：在 Portainer UI 中生成访问令牌。参见 [创建访问令牌](https://docs.portainer.io/api/access#creating-an-access-token)

## Prometheus

```yaml
- name: "Prometheus"
  type: "Prometheus"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
```

## Proxmox

显示 Proxmox 节点的状态信息（运行的 VM、磁盘/内存/CPU 使用情况）。

```yaml
- name: "Proxmox - 节点"
  type: "Proxmox"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  node: "your-node-name"
  warning_value: 50
  danger_value: 80
  api_token: "PVEAPIToken=root@pam!your-api-token-name=your-api-token-key"
  # 以下均为可选（默认为 false/空）：
  hide_decimals: true # 移除统计数值中的小数位
  hide: [] # 隐藏某些信息，可选值："vms"、"vms_total"、"lxcs"、"lxcs_total"、"disk"、"mem"、"cpu"
  small_font_on_small_screens: true # 在小屏幕（如手机）上使用小字体
  small_font_on_desktop: true # 在桌面上使用小字体（以防显示信息过多）
```

**API 密钥**：在 Proxmox 的 Permissions > API Tokens 中设置。还需要知道 API 令牌用户所属的 realm（默认为 pam）。

API 令牌（或令牌分配的用户，如果没有分离权限）的权限检查如下：

| 路径 | 权限 | 备注 |
|---------------------|------------|-------------------------------------------------------------------|
| /nodes/\<your-node> | Sys.Audit  | |
| /vms/\<id-vm> | VM.Audit | 需要对需要统计的每个 VM 都有此权限 |

强烈建议创建一个仅具有这些权限的只读模式 API 令牌。

## qBittorrent

显示全局上传和下载速率，以及列出的种子数量。此服务通过 qBittorrent API 接口通信，浏览器需能访问该接口。设置说明请参阅[此处](https://github.com/qbittorrent/qBittorrent/pull/12579)。

```yaml
- name: "qBittorrent"
  type: "qBittorrent"
  logo: "assets/tools/sample.png"
  url: https://my-service.url # 您的 rTorrent Web UI，如 ruTorrent 或 Flood
  rateInterval: 2000 # 更新下载和上传速率的间隔
  torrentInterval: 5000 # 更新种子数量的间隔
```

## rTorrent

显示 rTorrent 中的全局上传和下载速率，以及列出的种子数量。此服务通过 rTorrent XML-RPC 接口通信，浏览器需能访问该接口。设置说明请参阅[此处](https://github.com/rakshasa/rtorrent-doc/blob/master/RPC-Setup-XMLRPC.md)。

```yaml
- name: "rTorrent"
  type: "Rtorrent"
  logo: "assets/tools/sample.png"
  url: "https://my-service.url" # 您的 rTorrent Web UI，如 ruTorrent 或 Flood
  xmlrpc: "https://my-service.url:port" # rTorrent XML-RPC 的反向代理
  rateInterval: 5000 # 更新下载和上传速率的间隔
  torrentInterval: 60000 # 更新种子数量的间隔
  username: "username" # 登录 rTorrent 的用户名（如适用）
  password: "password" # 登录 rTorrent 的密码（如适用）
```

## SABnzbd

显示 SABnzbd 实例中当前活动下载的数量。

```yaml
- name: "SABnzbd"
  type: "SABnzbd"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  apikey: "<---在此插入 API 密钥--->"
  downloadInterval: 5000 # (可选) 更新下载数量的时间间隔（毫秒）
```

**API 密钥**：需要 API 密钥，可从 Web UI 的 SABnzbd 配置的 "Config" > "General" 部分获取。

## Scrutiny

显示通过和失败 S.M.A.R.T 检查以及 Scrutiny 检查的磁盘总数信息。

```yaml
- name: "Scrutiny"
  type: "Scrutiny"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  updateInterval: 5000 # (可选) 更新状态的时间间隔（毫秒）
```

## Speedtest Tracker

以 Mbit/s 显示下载和上传速度，以毫秒显示延迟。

```yaml
- name: "Speedtest Tracker"
  type: "SpeedtestTracker"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
```

## Tautulli

显示 Plex 实例上当前活动的流数量。

```yaml
- name: "Tautulli"
  type: "Tautulli"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  checkInterval: 5000 # (可选) 更新状态的时间间隔（毫秒）
  apikey: "<---在此插入 API 密钥--->"
```

**API 密钥**：需要 API 密钥，可从 Tautulli 网页界面的设置 "Web Interface" 部分获取。

由于服务类型和链接不一定需要匹配，您甚至可以在 Plex 卡片上使用 Tautulli 类型，并提供指向 Tautulli 的独立端点！

```yaml
- name: "Plex"
  type: "Tautulli"
  logo: "assets/tools/sample.png"
  url: https://my-plex.url/web # Plex
  endpoint: https://my-tautulli.url # Tautulli
  apikey: "<---在此插入 API 密钥--->"
```

## Tdarr

显示 Tdarr 实例中当前转码队列中的项目数以及错误项目数。

```yaml
- name: "Tdarr"
  type: "Tdarr"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  checkInterval: 5000 # (可选) 更新队列和错误计数的时间间隔（毫秒）
```

## Traefik

显示 Traefik 版本。

```yaml
- name: "Traefik"
  type: "Traefik"
  logo: "assets/tools/sample.png"
  url: "http://traefik.example.com"
  # basic_auth: "admin:password" # (可选) 发送 Authorization 头
```

**认证**：如果设置了 BasicAuth，凭据将编码为 Base64 并作为 Authorization 头发送（`Basic <encoded_value>`），值必须格式化为 "admin:password"。

## Transmission

显示 Transmission 守护进程的全局限速和上传速率，以及活动种子的数量。
此服务与 Transmission RPC 接口通信，浏览器需能访问该接口。

```yaml
- name: "Transmission"
  logo: "assets/tools/sample.png"
  url: "http://192.168.1.2:9091" # 您的 Transmission Web 界面 URL
  type: "Transmission"
  auth: "username:password" # 可选：HTTP Basic Auth
  interval: 5000 # 可选：数据刷新间隔（毫秒）
  target: "_blank" # 可选：HTML a 标签 target 属性
```

此服务自动处理 Transmission 的会话管理和 CSRF 保护。

## TrueNAS Scale

显示 TrueNAS 版本。

```yaml
- name: "Truenas"
  type: "TruenasScale"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  api_token: "<---在此插入 API 密钥--->"
```

## Uptime Kuma

显示 Uptime Kuma 状态页面的总体状态、可用性百分比和事件信息。

```yaml
- name: "Uptime Kuma"
  type: "UptimeKuma"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  slug: "default" # 状态页 slug，默认为 "default"
```

**要求**：Uptime Kuma 版本需为 `1.13.1` 或更高（支持[多状态页面](https://github.com/louislam/uptime-kuma/releases/tag/1.13.1)）

## Vaultwarden

显示 Vaultwarden 版本和状态。

```yaml
- name: "Vaultwarden - 服务器"
  type: "Vaultwarden"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
```

## Wallabag

显示 Wallabag 版本。

```yaml
- name: Wallabag
  type: Wallabag
  logo: "assets/tools/sample.png"
  url: https://my-service.url
```

## What's Up Docker

在 Homer 仪表盘上显示正在运行的容器数量以及有可用更新的容器数量。

```yaml
- name: "What's Up Docker"
  type: "WUD"
  logo: "assets/tools/sample.png"
  url: https://my-service.url
  subtitle: "Docker 镜像更新通知"
```

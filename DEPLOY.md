# Homer Dashboard 部署指南

## 快速开始

### 本地构建部署

```bash
# 1. 复制配置示例
cp config-example.yml config.yml

# 2. 编辑 config.yml 添加你的服务

# 3. 构建并启动
docker-compose up -d --build

# 4. 访问 http://服务器IP:30880
```

### 远程构建部署（使用 GHCR）

```bash
# 1. 登录 GHCR
docker login ghcr.io -u 你的GitHub用户名 -p 你的TOKEN

# 2. 复制配置示例
cp config-example.yml config.yml

# 3. 编辑 config.yml 添加你的服务

# 4. 拉取并启动
docker-compose -f docker-compose.remote.yml up -d
```

---

## 目录结构

```
.
├── docker-compose.yml           # 本地构建配置
├── docker-compose.remote.yml    # 远程构建配置（GHCR）
├── config-example.yml          # 配置文件示例
├── config.yml                  # 实际配置文件（需手动创建，忽略推送）
├── Dockerfile                  # Docker 镜像构建
├── nginx-homer.conf            # Nginx 反向代理配置
└── README.md                   # 项目说明
```

---

## 配置说明

### config.yml 必填项

```yaml
title: "Dashboard"              # 页面标题
subtitle: "Homer"               # 副标题
logo: "logo.png"                # 左上角 Logo
theme: homarr                   # 主题名称
columns: "4"                    # 每行卡片数量
connectivityCheck: true         # 是否检测服务连通性

services:
  - name: "分组名称"            # 服务分组
    icon: "fas fa-icon"         # 分组图标
    items:
      - name: "服务名称"        # 服务名称
        logo: "图标URL"         # 卡片图标
        url: "https://..."      # 跳转链接
        target: "_blank"        # _blank=新窗口
```

### 智能组件配置

```yaml
# 时钟（内置）
- name: "时钟"
  type: "Clock"
  icon: "fas fa-clock"
  showDate: true
  hour12: false
  locale: "zh-CN"

# 天气（需 OpenWeatherMap API）
- name: "天气"
  type: "OpenWeather"
  apikey: "你的API密钥"
  location: "Tokyo"
  units: "metric"

# Ping 检测
- name: "网络状态"
  type: "Ping"
  url: "https://google.com"
```

详细智能组件文档请查看 `docs/customservices.md`（中文版）。

---

## GitHub Actions 自动构建

每次推送到 `main` 分支，GitHub Actions 自动构建并推送镜像到 GHCR。

### 镜像地址

```
ghcr.io/你的用户名/homer:latest
ghcr.io/你的用户名/homer:sha-xxxxxxx
```

### 更新服务器

```bash
# 登录 GHCR（如尚未登录）
docker login ghcr.io -u 你的用户名 -p 你的TOKEN

# 拉取最新镜像
docker-compose -f docker-compose.remote.yml pull

# 重启服务
docker-compose -f docker-compose.remote.yml up -d
```

---

## Nginx 反向代理配置

复制到 `/etc/nginx/conf.d/homer.conf`，修改 `homer.your-domain.com` 为实际域名：

```nginx
server {
    listen 80;
    server_name homer.your-domain.com;
    return 301 https://homer.your-domain.com$request_uri;
}

server {
    listen 443 ssl http2;
    server_name homer.your-domain.com;

    ssl_certificate     /etc/letsencrypt/live/homer.your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/homer.your-domain.com/privkey.pem;

    client_max_body_size 10M;

    location / {
        proxy_pass         http://127.0.0.1:30880;
        proxy_set_header   Host $host;
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
    }
}
```

重载 Nginx：`sudo systemctl reload nginx`

---

## Docker 命令参考

```bash
# 查看运行状态
docker ps

# 查看日志
docker logs -f homer

# 进入容器
docker exec -it homer sh

# 查看资源使用
docker stats homer

# 停止服务
docker-compose down

# 重新构建启动
docker-compose up -d --build

# 完整重建
docker-compose down --rmi local
docker-compose up -d --build
```

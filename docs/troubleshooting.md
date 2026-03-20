# 故障排除

## 我的 Docker 容器拒绝启动 / 一直重启

可能是权限问题。首先检查容器日志（根据需要调整容器名称）：

```sh
$ docker logs homer
[...]
Assets directory not writable. Check assets directory permissions & docker user or skip default assets install by setting the INIT_ASSETS env var to 0
```

在这种情况下，您需要确保挂载的 assets 目录具有与容器用户相同的 GID / UID（默认为 1000:1000），并且该用户或组被授予了读写权限。

您可以：

- 更新 assets 目录权限（例如：`chown -R 1000:1000 /your/assets/folder/`，`chmod -R u+rw /your/assets/folder/`）
- 使用 docker cli 的 `--user` 参数或 docker compose 中的 `user: 1000:1000` 更改 docker 用户

> [!NOTE]
>
> - **不要**使用环境变量来设置运行容器的用户的 GID / UID，请使用 Docker 的 `user` 选项。
> - **不要**使用 0:0 作为用户值，这会带来安全风险，也不能保证能正常工作。

更多信息请查看[此讨论串](https://github.com/bastienwirtz/homer/issues/459)来调试权限问题。

## 我的服务卡片不工作，什么都不显示或显示离线状态（pi-hole、sonarr、ping...）

可能是遇到了 [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)（跨域资源共享）问题。
当目标服务托管在不同的域名或端口时会发生此问题。
Web 浏览器不允许在未获得明确许可的情况下从不同站点获取信息（目标服务必须包含特殊的 `Access-Control-Allow-Origin: *` HTTP 头）。
如果发生此问题，您的 Web 控制台（`Ctrl+Shift+I` 或 `F12`）中会充满类似这样的错误：

```text
Access to fetch at 'https://<target-service>' from origin 'https://<homer>' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource. If an opaque response serves your needs, set the request's mode to 'no-cors' to fetch the resource with CORS disabled.
```

解决方法：

- 将所有目标服务托管在同一域名和端口下
- 修改目标服务器配置，使响应包含 `Access-Control-Allow-Origin: *` 头（<https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS#simple_requests>）。可能是目标服务的一个选项，否则根据服务的托管方式，反向代理或 Web 服务器可以无缝地添加此头
- **使用代理**添加必要的 CORS 头（方案很多，部分可参见[这里](https://enable-cors.org/server.html)，也推荐轻量简单的方案 [`CORSair`](https://github.com/bastienwirtz/corsair)）

## 我正在使用认证代理，Homer 说我离线了

这应该是配置问题。

- 确保配置中的 `connectivityCheck` 选项设为 `true`
- 检查您的代理配置，预期行为是当用户未认证时使用 302 重定向到登录页面

## 我把 API 密钥放入了 OpenWeather 服务，但它仍然不工作

如果您刚刚创建了一个 OpenWeatherMap 账户和/或一个新的 API 密钥，很可能需要等待它被激活（通常需要几个小时）。如果等待后仍然不工作，请确保检查您提供的位置是否有效。

一些基本调试步骤：

- 在配置中使用大城市（如阿姆斯特丹）作为指定位置进行测试
- 确保在更新位置后运行最新版本的 homer 配置（Ctrl + Shift + R）
- 检查浏览器控制台（Ctrl + Shift + I）中与 api.openweathermap.org 相关的错误

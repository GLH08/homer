# 技巧与提示

这里收集了 Homer 用户们发现的一些实用技巧！

## 仪表盘图标

查找服务图标的好资源：

- <https://selfh.st/icons/>
- <https://github.com/homarr-labs/dashboard-icons>

## 将 Homer 用作自定义"新标签页"

#### `@vosdev` 提供

以下浏览器扩展可以让您在新标签页中显示 Homer 仪表盘，同时保持地址栏焦点意味着您仍然可以随时输入搜索或跳转：

Firefox 扩展：[Firefox](https://addons.mozilla.org/firefox/addon/custom-new-tab-page)
Chrome 及相关浏览器：[Chrome & Friends](https://chrome.google.com/webstore/detail/new-tab-changer/occbjkhimchkolibngmcefpjlbknggfh)

Firefox 扩展将 Homer 加载到新标签页的 iframe 中，因此您需要在每个项目中添加 `target: '_top'`。

```yaml
- name: "Reddit"
  logo: "assets/daily/reddit.png"
  url: "https://reddit.com"
  target: '_top'

- name: "YouTube"
  logo: "assets/daily/youtube.png"
  url: "https://youtube.com"
  target: '_top'
```

## YAML 锚点

#### `@JamiePhonic` 提供

由于 Homer 使用 YAML 配置，因此支持 YAML 的所有实用功能，例如锚点！

例如，您可以为服务中的每个"项目"定义标签和标签样式。使用锚点，您可以像这样一次性定义所有标签及其样式：（例如）

```yaml
# 一些预定义的标签样式。在项目定义中用 <<: *{名称} 引用；例如，<<: *Apps
tags:
  Favourite: &Favourite
    - tag: "Favourite"
      tagstyle: "is-medium is-primary"
  CI: &CI
    - tag: "CI"
      tagstyle: "is-medium is-success"
  Apps: &Apps
    - tag: "App"
      tagstyle: "is-medium is-info"
```

然后只需在每个项目中这样引用预定义（锚定）的标签：

```yaml
- name: "VS Code"
  logo: "/assets/vscode.png"
  subtitle: "Develop Code Anywhere, On Anything!"
  <<: *Apps # 引用预定义的"App"标签
  url: "https://vscode.example.com/"
  target: "_blank" # 可选的 HTML 标签 target 属性
```

然后 Homer 读取配置时会自动替换您的锚点，上述示例等同于：

```yaml
- name: "VS Code"
  logo: "/assets/vscode.png"
  subtitle: "Develop Code Anywhere, On Anything!"
  tag: "App"
  tagstyle: "is-medium is-info"
  url: "https://vscode.example.com/"
  target: "_blank" # 可选的 HTML 标签 target 属性
```

最终效果是：如果您想更新任何特定标签的名称或样式，只需在标签部分更新一次即可！
如果您有很多服务或很多标签，这特别有用！

## YAML 自动补全与 YAML Schema

许多编辑器支持自动补全，参见 <https://www.schemastore.org/json/>
Homer Schema 在此处可用：<https://raw.githubusercontent.com/bastienwirtz/homer/main/.schema/config-schema.json>

例如在 IntelliJ 中可以这样定义：

```yaml
# $schema: https://raw.githubusercontent.com/bastienwirtz/homer/main/.schema/config-schema.json
```

在 VSCode 中可以这样定义：

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/bastienwirtz/homer/main/.schema/config-schema.json
```

## 使用 Code Server 远程编辑配置

#### `@JamiePhonic` 提供

Homer 本身尚未提供从内部编辑配置的方式，但这并不意味着不能做到！

您可以设置并使用 [Code-Server](https://github.com/cdr/code-server) 从任何地方编辑您的 `config.yml` 文件。

如果您在 Docker 中运行 Homer，可以设置一个 Code-Server 容器并将您的 homer 配置目录传入。
只需将 homer 配置目录作为额外的 -v 参数传递给 code-server 容器：

```sh
-v '/your/local/homer/config-dir/':'/config/homer':'rw'
```

这会将您的 homer 配置目录（例如 /docker/appdata/homer/）映射到 code-server 的 `/config/` 目录中的 `homer` 子文件夹中。

另外，Code-Server 会在 URL 栏中放置"当前文件夹"作为参数，所以您可以在 Homer 中添加一个 `links:` 条目，指向您的 code-server 实例并预填目录，实现一键编辑！

例如：

```yml
links:
  - name: 编辑配置
    icon: fas fa-cog
    url: https://vscode.example.net/?folder=/config/homer
    target: "_blank" # 可选的 HTML 标签 target 属性
```

其中 `?folder=` 后的路径是您**在 Code-Server 容器内部**挂载的 homer 配置目录的路径。

### Code-Server Docker 创建命令示例

```sh
docker create \
  --name=code-server \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e PASSWORD={YOUR_PASSWORD} `#optional` \
  -e SUDO_PASSWORD={YOUR SUDO_PASSWORD} `#optional` \
  -p 8443:8443 \
  -v /path/to/appdata/config:/config \
  -v /your/local/homer/config-dir/:/config/homer \
  --restart unless-stopped \
  linuxserver/code-server
```

## 在 Homer 中获取新闻头条

### 字段映射

大多数情况下，您获取头条新闻的 URL 所遵循的 schema 与 Homer 期望的不同。

例如，如果您想显示来自 ChuckNorris.io 的笑话，您会发现 URL <https://api.chucknorris.io/jokes/random> 返回的信息如下：

```json
{
  "categories": [],
  "created_at": "2020-01-05 13:42:22.089095",
  "icon_url": "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
  "id": "MR2-BnMBR667xSpQBIleUg",
  "updated_at": "2020-01-05 13:42:22.089095",
  "url": "https://api.chucknorris.io/jokes/MR2-BnMBR667xSpQBIleUg",
  "value": "Chuck Norris can quitely sneak up on himself"
}
```

但...您需要将这些信息转换为类似这样的格式：

```json
{
  "title": "MR2-BnMBR667xSpQBIleUg",
  "content": "Chuck Norris can quitely sneak up on himself"
}
```

现在，您可以使用 `message` 配置中的 `mapping` 字段来实现这种转换。示例配置如下：

```yml
message:
  url: https://api.chucknorris.io/jokes/random
  mapping:
    title: 'id'
    content: 'value'
```

如您所见，用 ID 作为标题看起来不太友好，因此在字段为空时它会保留默认值，如下所示：

```yml
message:
  url: https://api.chucknorris.io/jokes/random
  mapping:
    content: 'value'
  title: "Chuck Norris 冷知识！"
```

甚至在 `url` 没有响应或出错时显示错误消息：

```yml
message:
  url: https://api.chucknorris.io/jokes/random
  mapping:
    content: 'value'
  title: "Chuck Norris 冷知识！"
  content: "无法加载消息"
```

#### `@JamiePhonic` 提供

Homer 允许您设置一个"消息"，它将显示在页面顶部，当然您也可以提供 `url:`。

如果您指定的 URL 返回一个定义 `title` 和 `content` 项目的 JSON 对象，homer 将用返回对象中的值替换 `config.yml` 中的这些值。

因此，使用 [Node-Red](https://nodered.org/docs/getting-started/) 和一个快速流程，您可以处理 RSS 提要来用新闻项目替换消息！
要开始使用，只需将[此流程](https://flows.nodered.org/flow/4b6406c9a684c26ace0430dd1826e95d)导入您的 Node-Red 实例，并将"获取新闻 RSS 提要"节点中的 RSS 提要更改为您选择的即可！

目前已在 BBC News 和 Sky News 上测试过该流程，但如果其他 RSS 提要不适用，应该也不难修改！

## 向仪表盘写入 HTML

### 显示最新摄像头画面

#### `@matheusvellone` 提供

`message.content` 配置项接受 HTML 代码，因此您可以添加图片。
如果您使用 Frigate，或者有摄像头的任何 `latest.jpg` URL，您可以将其添加到仪表盘。您还可以对 `div`/`img` 标签进行样式调整，使其在仪表盘上看起来更美观。

```yml
message:
  title: 摄像头
  content: >
    <div>
      <a href="http://frigate.local:5000/cameras/garage">
        <img src="http://frigate.local:5000/api/garage/latest.jpg?h=220"/>
      </a>
      <a href="http://frigate.local:5000/cameras/backyard">
        <img src="http://frigate.local:5000/api/backyard/latest.jpg?h=220"/>
      </a>
    </div>
```

使用 Frigate 时，您甚至可以向仪表盘添加实时画面，如下所示：

```yml
message:
  title: 摄像头
  content: >
    <img src="http://frigate.local:5000/api/piscina"/>
```

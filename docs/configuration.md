# 配置

Homer 依赖一个位于 `/assets` 目录下的 [YAML](http://yaml.org/) 配置文件。
`.dist` 示例配置文件可供参考，或者直接复制下面的示例到配置文件中。

> [!NOTE]
> 在 Docker 安装方式下，如果没有找到配置文件，且配置目录对 Docker 用户可写，系统会自动安装示例配置。
> 如果没有自动安装，请检查容器日志以及挂载的配置目录的所有权和权限。

```yaml
---
# 首页配置
# 图标选项请参阅 https://fontawesome.com/search

# 可选：使用外部配置文件
# 使用此选项将忽略本文件中的其余配置
# externalConfig: https://example.com/server-luci/config.yaml

title: "应用仪表盘"
subtitle: "Homer"
# documentTitle: "欢迎" # 自定义浏览器标签页标题
logo: "assets/logo.png"
# 也可以使用 fa 图标：
# icon: "fas fa-skull-crossbones"

header: true # 设为 false 可隐藏顶部标题栏
# 可选：自定义搜索快捷键，默认为 "/"
# hotkey:
#   search: "Shift"
footer: '<p>使用 <span class="has-text-danger">❤️</span> 和 <a href="https://bulma.io/">bulma</a>、<a href="https://vuejs.org/">vuejs</a> 及 <a href="https://fontawesome.com/">font awesome</a> 创建 // 在 <a href="https://github.com/bastienwirtz/homer"><i class="fab fa-github-alt"></i></a> 上 Fork 我</p>' # 设为 false 可隐藏页脚

columns: "3" # "auto" 或数字（必须能被 12 整除：1, 2, 3, 4, 6, 12）
connectivityCheck: true # 是否在应用无法访问时显示提示（如 VPN 断开时）
                       # 使用认证代理时应设为 true，检测到重定向时会刷新页面。

# 可选：代理/托管配置
proxy:
  useCredentials: false # 拉取服务数据时发送 cookies 和 authorization 头。使用认证代理时请设为 `true`。可在服务级别覆盖。
  headers: # 拉取服务数据时发送自定义请求头。也可在服务级别设置。
    Test: "示例"
    Test1: "示例1"


# 设置默认布局和配色方案
defaults:
  layout: columns # 可选 'columns' 或 'list'
  colorTheme: auto # 可选 'auto'、'light' 或 'dark'

# 可选：主题设置
theme: default # 'default' 或 'src/assets/themes/' 中可用的其他主题

# 可选：自定义样式表
# 加载自定义 CSS 文件，对自定义图标集特别有用
# stylesheet:
#   - "assets/custom.css"

# 以下是所有可自定义参数的完整列表
# 所有参数都是可选的，未设置时使用默认值
# 如果只修改部分颜色，可以删除所有未使用的键。
colors:
  light:
    highlight-primary: "#3367d6"
    highlight-secondary: "#4285f4"
    highlight-hover: "#5a95f5"
    background: "#f5f5f5"
    card-background: "#ffffff"
    text: "#363636"
    text-header: "#424242"
    text-title: "#303030"
    text-subtitle: "#424242"
    card-shadow: rgba(0, 0, 0, 0.1)
    link: "#3273dc"
    link-hover: "#363636"
    background-image: "/assets/your/light/bg.png" # 如有子路径需加上前缀（例如 /homer/assets/...）
  dark:
    highlight-primary: "#3367d6"
    highlight-secondary: "#4285f4"
    highlight-hover: "#5a95f5"
    background: "#131313"
    card-background: "#2b2b2b"
    text: "#eaeaea"
    text-header: "#ffffff"
    text-title: "#fafafa"
    text-subtitle: "#f5f5f5"
    card-shadow: rgba(0, 0, 0, 0.4)
    link: "#3273dc"
    link-hover: "#ffdd57"
    background-image: "/assets/your/dark/bg.png" # 如有子路径需加上前缀（例如 /homer/assets/...）

# 可选：消息提示框
message:
  # url: "https://<my-api-endpoint>" # 可以从接口获取信息并覆盖下面的值
  # mapping: # 将远程格式的字段映射为 Homer 期望的格式
  #   title: 'id' # 使用 'id' 字段的值作为标题
  #   content: 'value' # 使用 'value' 字段的值作为内容
  # refreshInterval: 10000 # 可选：刷新消息的时间间隔（毫秒）
  #
  # 使用 chucknorris.io 显示冷知识笑话的示例：
  # url: https://api.chucknorris.io/jokes/random
  # mapping:
  #   title: 'id'
  #   content: 'value'
  # refreshInterval: 10000
  style: "is-warning"
  title: "提示消息！"
  icon: "fa fa-exclamation-triangle"
  # content 也接受 HTML 内容，可以添加 div、图片或任何你需要的元素
  content: "这是示例内容。"

# 可选：导航栏链接
# links: [] # 只显示导航控件（深色模式、布局切换、搜索）而不显示链接
links:
  - name: "链接 1"
    icon: "fab fa-github"
    url: "https://github.com/bastienwirtz/homer"
    target: "_blank" # 可选的 HTML a 标签 target 属性
  - name: "链接 2"
    icon: "fas fa-book"
    url: "https://github.com/bastienwirtz/homer"
  # 以下会链接到第二个 Homer 页面，从 page2.yml 加载配置，同时保留 config.yml 中的默认值
  # 参考下面的 url 字段和 assets/page.yml：
  - name: "第二页"
    icon: "fas fa-file-alt"
    url: "#page2"

# 服务
# 第一层数组代表一个分组
# 如果不使用分组，只需保留 "items" 键即可（分组名称、图标和 tagstyle 都是可选的，分隔线不会显示）。
services:
  - name: "应用程序"
    icon: "fas fa-code-branch"
    # 也可以提供图片路径。注意：如果同时设置了 icon 和 logo，icon 优先。
    # logo: "path/to/logo"
    # class: "highlight-purple" # 可选：添加到服务分组的 CSS 类
    items:
      - name: "示例应用"
        logo: "assets/tools/sample.png"
        # 也可以使用 fa 图标：
        # icon: "fab fa-jenkins"
        subtitle: "书签示例"
        tag: "应用"
        keywords: "自托管 reddit" # 可选：用于搜索的关键词
        url: "https://www.reddit.com/r/selfhosted/"
        target: "_blank" # 可选的 HTML a 标签 target 属性
      - name: "另一个应用"
        logo: "assets/tools/sample2.png"
        subtitle: "另一个应用程序"
        tag: "应用"
        # 可选的标签样式
        tagstyle: "is-success"
        url: "#"
  - name: "其他分组"
    icon: "fas fa-heartbeat"
    items:
      - name: "Pi-hole"
        logo: "assets/tools/sample.png"
        # subtitle: "网络级广告拦截" # 可选，未定义副标题时将显示 PiHole 统计信息
        tag: "其他"
        url: "http://192.168.0.151/admin"
        type: "PiHole" # 可选：加载提供额外功能的特定组件。必须与 `src/components/services` 中存在的文件名（不含扩展名）匹配
        target: "_blank" # 可选的 HTML a 标签 target 属性
        # class: "green" # 可选：自定义 CSS 类，配合自定义样式表使用
        # background: red # 可选：直接设置卡片背景色，无需自定义样式表
```

有关所有可用卡片（如 `PiHole`）的详细信息及配置方法，请参阅 **[智能卡片](customservices.md)**。

如果选择从接口获取消息信息，输出格式应如下（也可以按 [技巧提示](./tips-and-tricks.md#mapping-fields) 中所示自定义字段映射）：

```json
{
  "style": null,
  "title": "示例标题 42",
  "content": "示例内容..."
}
```

`null` 值或缺失的键将被忽略，如果配置文件中存在相应值则使用配置文件的值。
空值（无论在 `config.yml` 还是接口数据中）将隐藏该元素（例如设置 `"title": ""` 可隐藏标题栏）。

## 连接状态检测

作为一个 Web 应用（PWA），即使 Homer 服务器离线，仪表盘仍可正常显示。
连接检测器会定期发送 HEAD 请求（绕过 PWA 缓存）到仪表盘页面，以确保其仍然可访问。

当通过 VPN 或 SSH 隧道访问仪表盘时，此功能特别有用，可以了解连接是否正常。在使用认证代理的情况下也有帮助——当认证过期时（收到 HEAD 请求的响应中包含重定向），页面会自动刷新。

## 样式选项

Homer 使用 [Bulma CSS](https://bulma.io/)，提供了[修饰符语法](https://bulma.io/documentation/start/syntax/)。配置中的 `tagstyle` 选项可使用任意 Bulma 修饰符，通常使用以下四种主色之一：

- `is-info`（蓝色）
- `is-success`（绿色）
- `is-warning`（黄色）
- `is-danger`（红色）

其他尺寸、样式或状态选项请参阅 [Bulma 修饰符页面](https://bulma.io/documentation/start/syntax/)。

## 主题与自定义

配置示例中的 `colors` 设置请参见上方。
网站图标和应用程序图标（PWA）位于 `assets/icons` 目录，可以替换为任意图片（保持相同的名称和尺寸即可）。
`/assets/manifest.json` 也可编辑，用于修改应用（PWA）名称、描述和其他设置。

### 社区主题

- [Catppuccin 主题](https://github.com/mrpbennett/catppucin-homer) 作者：[@mrpbenett](https://github.com/mrpbennett)
- [DietPi 主题](https://codeberg.org/Cs137/homer-theme-dietpi) 作者：[@Cs137](https://codeberg.org/Cs137)
- [Dracula 主题](https://draculatheme.com/homer) 作者：[@Tuetenk0pp](https://github.com/Tuetenk0pp)
- [Homer Theme v2](https://github.com/walkxcode/homer-theme) 作者：[@walkxcode](https://github.com/walkxcode)

## PWA 图标

图标文档请参阅[此处](https://github.com/bastienwirtz/homer/blob/main/public/assets/icons/README.md)。

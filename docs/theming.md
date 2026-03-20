# 主题

## 更换主题

可以使用 YAML 配置文件更改默认主题：

```yaml
theme: default # 'default'、'walkxcode' 或 'neon'，参见 'src/assets/themes' 中的文件
```

## 颜色和背景自定义

可以使用 YAML 配置文件或 CSS 变量（见下文"附加样式表"）为每个主题变体（浅色和深色）自定义默认颜色和背景。

### 可用选项

| yaml | css | 说明 |
| --------------------- | ----------------------- | --- |
| `highlight-primary` | `--highlight-primary` | 顶部标题栏背景、分组标题图标 |
| `highlight-secondary` | `--highlight-secondary` | 导航栏背景、默认标签颜色 |
| `highlight-hover` | `--highlight-hover` | 导航栏链接悬停、搜索输入框背景 |
| `background` | `--background` | 页面背景色 |
| `card-background` | `--card-background` | 服务卡片背景色 |
| `text` | `--text` | 主文本颜色 |
| `text-header` | `--text-header` | 顶部标题文本颜色 |
| `text-title` | `--text-title` | 服务卡片标题颜色 |
| `text-subtitle` | `--text-subtitle` | 服务卡片副标题颜色 |
| `card-shadow` | `--card-shadow` | 服务卡片 `box-shadow` |
| `link` | `--link` | 链接颜色（页脚和消息）、服务卡片图标颜色 |
| `link-hover` | `--link-hover` | 链接悬停颜色（页脚和消息）、服务卡片图标悬停颜色 |
| `background-image` | `--background-image` | 页面背景图片 URL（在 CSS 中使用时，需要设置为 `url(<image-url>)`，见下方示例）|


YAML 示例

```yml
colors:
  light:
    highlight-primary: "#3367d6"
    background-image: "assets/your/light/bg.webp"
    ...
  dark:
    highlight-primary: "#3367d6"
    background-image: "assets/your/dark/bg.webp"
    ...
```

CSS 示例

```css
.light {
    --highlight-primary: #3367d6;
    --background-image: url("assets/your/light/bg.webp");
    ...
}

.dark {
    --highlight-primary: #3367d6;
    --background-image: url("assets/your/dark/bg.webp");
    ...
}
```

## 附加样式表

可以加载一个或多个附加样式表来添加或覆盖当前主题的样式。在 YAML 配置文件中使用 `stylesheet` 选项来加载您自己的 CSS 文件。

```yml
stylesheet:
   - "assets/custom.css"
```

### 自定义示例

#### 修改最大宽度

```css
body #main-section .container {
    max-width: 2000px; // 根据需要调整（例如 calc(100% - 100px)、none 等）
}
```

#### 背景渐变

```css
#app {
    height: 100%;
    background: linear-gradient(90deg, #5c2483, #0095db);
}
```

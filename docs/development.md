# 开发

如果您想为 Homer 做贡献，请先阅读[贡献指南](https://github.com/bastienwirtz/homer/blob/main/CONTRIBUTING.md)。

```sh
pnpm install
pnpm dev
```

## 自定义服务

自定义服务是轻量的 Vue.js 组件（位于 `src/components/services/`），为基础的"静态"仪表盘项目添加额外功能。它应该非常简单。
由于一个仪表盘可能包含大量项目，性能非常重要。

[`Generic`](https://github.com/bastienwirtz/homer/blob/main/src/components/services/Generic.vue) 服务提供了典型的卡片布局，您可以扩展它来添加特定功能。
除非需要完全不同的设计，否则建议扩展通用服务。它提供 3 个可扩展的[插槽](https://vuejs.org/v2/guide/components-slots.html#Named-Slots)：`icon`、`content` 和 `indicator`。
每个插槽都是**可选的**，省略时将显示常规信息。

每个服务组件必须实现 `item` [属性](https://vuejs.org/v2/guide/components-props.html)，如使用了 Generic 组件则需要绑定它。

### 骨架代码

```Vue
<template>
  <Generic :item="item">
    <template #icon>
      <!-- 左上区域，包含图标 -->
    </template>
    <template #content>
      <!-- 主区域，包含标题、副标题等 -->
    </template>
    <template #indicator>
      <!-- 右上区域，默认留空 -->
    </template>
  </Generic>
</template>

<script>
import Generic from "./Generic.vue";

export default {
  name: "MyNewService",
  props: {
    item: Object,
  },
  components: {
    Generic,
  }
};
</script>
```

## 主题

主题是对样式的简单自定义（使用 [SCSS](https://sass-lang.com/documentation/syntax) 编写）。
要添加新主题，只需在主题目录中添加一个文件，并将所有样式放在 `body #app.theme-<name>` 作用域内，然后在主样式文件中导入它。

```scss
// `src/assets/themes/my-awesome-theme.scss`
body #app.theme-my-awesome-theme. { ... }
```

```scss
// `src/assets/app.scss`
// 主题导入
@import "./themes/sui.scss";
...
@import "./themes/my-awesome-theme.scss";
```

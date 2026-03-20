import "./assets/app.scss";
import { createApp, h } from "vue";
import App from "./App.vue";
import i18nPlugin from "./i18n/index.js";

const app = createApp(App);

// 注册 i18n 插件，提供全局 $t() 函数
app.use(i18nPlugin);

import Generic from "./components/services/Generic.vue";

app
  .component("Generic", Generic)
  .component("DynamicStyle", (_props, context) => {
    return h("style", {}, context.slots);
  });

app.mount("#app-mount");

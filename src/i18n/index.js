/**
 * Homer i18n 插件
 * 提供全局 $t() 翻译函数
 */
import zhCN from "./zh-CN.js";

const messages = {
  "zh-CN": zhCN,
};

// 获取浏览器语言
function getBrowserLanguage() {
  const lang = navigator.language || navigator.userLanguage || "";
  if (messages[lang]) return lang;
  const primary = lang.split("-")[0];
  const match = Object.keys(messages).find((key) => key.startsWith(primary));
  return match || "zh-CN";
}

// 翻译函数
function t(key) {
  const lang = getBrowserLanguage();
  const keys = key.split(".");
  let value = messages[lang];
  for (const k of keys) {
    value = value?.[k];
  }
  return value ?? key;
}

export { t };

export default {
  install(app) {
    app.config.globalProperties.$t = t;
  },
};

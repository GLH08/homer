<template>
  <a
    :aria-label="$t('darkMode.toggle')"
    class="navbar-item is-inline-block-mobile"
    @click="toggleTheme()"
  >
    <i
      :class="isDark ? 'fas fa-moon' : 'fas fa-sun'"
      class="fa-fw"
      :title="isDark ? $t('darkMode.dark') : $t('darkMode.light')"
    ></i>
  </a>
</template>

<script>
export default {
  name: "Darkmode",
  props: {
    defaultValue: String,
  },
  emits: ["updated"],
  data: function () {
    return {
      isDark: null,
    };
  },
  created: function () {
    // 初始化：根据配置或系统偏好设置
    if ("overrideDark" in localStorage) {
      this.isDark = JSON.parse(localStorage.overrideDark);
    } else if (this.defaultValue === "dark") {
      this.isDark = true;
    } else if (this.defaultValue === "light") {
      this.isDark = false;
    } else {
      // 默认跟随系统
      this.isDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
    }
    this.$emit("updated", this.isDark);
    this.watchSystemTheme();
  },
  methods: {
    toggleTheme: function () {
      // 只在 light/dark 之间切换
      this.isDark = !this.isDark;
      localStorage.overrideDark = this.isDark;
      this.$emit("updated", this.isDark);
    },

    watchSystemTheme: function () {
      // 如果用户没有手动设置，跟随系统主题变化
      if (!("overrideDark" in localStorage)) {
        window.matchMedia("(prefers-color-scheme: dark)").addEventListener(
          "change",
          (e) => {
            this.isDark = e.matches;
            this.$emit("updated", this.isDark);
          },
        );
      }
    },
  },
};
</script>

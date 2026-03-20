<template>
  <div class="search-bar">
    <form role="search">
      <i class="fas fa-search search-icon"></i>
      <input
        id="search"
        ref="search"
        name="search"
        type="search"
        :value="value"
        :placeholder="$t('search.placeholder')"
        @input.stop="search($event.target.value)"
        @keydown.enter.exact.prevent="open()"
        @keydown.alt.enter.prevent="open('_blank')"
      />
    </form>
  </div>
</template>

<script>
export default {
  name: "SearchInput",
  props: {
    value: String,
    hotkey: {
      type: String,
      default: "/",
    },
  },
  emits: ["search-open", "search-focus", "search-cancel", "input"],
  mounted() {
    this._keyListener = function (event) {
      if (!this.hasFocus() && event.key === this.hotkey) {
        event.preventDefault();
        this.focus();
      }
      if (event.key === "Escape") {
        this.cancel();
      }
    };
    document.addEventListener("keydown", this._keyListener.bind(this));

    // fill search from get parameter.
    const search = new URLSearchParams(window.location.search).get("search");
    if (search) {
      this.$refs.search.value = search;
      this.search(search);
      this.focus();
    }
  },
  beforeUnmount() {
    document.removeEventListener("keydown", this._keyListener);
  },
  methods: {
    open: function (target = null) {
      if (!this.$refs.search.value) {
        return;
      }
      this.$emit("search-open", target);
    },
    focus: function () {
      this.$emit("search-focus");
      this.$nextTick(() => {
        this.$refs.search.focus();
      });
    },
    hasFocus: function () {
      return document.activeElement == this.$refs.search;
    },
    setSearchURL: function (value) {
      const url = new URL(window.location);
      if (value === "") {
        url.searchParams.delete("search");
      } else {
        url.searchParams.set("search", value);
      }
      window.history.replaceState("search", null, url);
    },
    cancel: function () {
      this.setSearchURL("");
      this.$refs.search.value = "";
      this.$refs.search.blur();
      this.$emit("search-cancel");
    },
    search: function (value) {
      this.setSearchURL(value);
      this.$emit("input", value.toLowerCase());
    },
  },
};
</script>

<style lang="scss" scoped>
.search-bar {
  position: relative;
  display: inline-block;

  form {
    position: relative;
    display: flex;
    align-items: center;
  }

  .search-icon {
    position: absolute;
    left: 8px;
    top: 50%;
    transform: translateY(-50%);
    font-size: 12px;
    color: var(--outline);
    pointer-events: none;
    z-index: 1;
  }

  input {
    border: none;
    background-color: var(--surface-container-low);
    border-radius: 8px;
    padding: 4px 10px 4px 26px;
    color: var(--text);
    height: 30px;
    width: 30px;
    transition: all 0.2s ease;
    font-size: 0.85rem;

    &:focus {
      background-color: #ffffff;
      box-shadow: 0 0 0 2px var(--highlight-primary);
      outline: none;
      width: 120px;
    }

    &::placeholder {
      color: transparent;
    }

    &:focus::placeholder {
      color: var(--outline);
    }
  }
}
</style>

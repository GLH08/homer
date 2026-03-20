<template>
  <div class="card" :class="item.class">
    <a :href="item.url" :target="item.target" rel="noreferrer">
      <div class="card-content">
        <div class="media">
          <div v-if="item.icon || showIcon" class="media-left">
            <figure class="image is-48x48">
              <i
                v-if="item.icon"
                style="font-size: 32px"
                :class="['fa-fw', item.icon]"
              ></i>
              <i v-else style="font-size: 32px" class="fa-fw fas fa-clock"></i>
            </figure>
          </div>
          <div class="media-content">
            <p class="title is-5">{{ item.name || $t('clock.title') }}</p>
            <p class="subtitle is-4 has-text-weight-bold">{{ formattedTime }}</p>
            <p v-if="item.showDate !== false" class="is-size-7 has-text-grey-light">
              {{ formattedDate }}
            </p>
          </div>
        </div>
        <div v-if="item.tag" class="tag" :class="item.tagstyle || 'is-primary'">
          <span class="tag-text">#{{ item.tag }}</span>
        </div>
      </div>
    </a>
  </div>
</template>

<script>
export default {
  name: "Clock",
  props: {
    item: Object,
  },
  data: function () {
    return {
      currentTime: new Date(),
      timer: null,
    };
  },
  computed: {
    formattedTime: function () {
      const options = {
        hour: "2-digit",
        minute: "2-digit",
        hour12: this.item.hour12 === true,
      };
      return this.currentTime.toLocaleTimeString(
        this.item.locale || "zh-CN",
        options,
      );
    },
    formattedDate: function () {
      const options = {
        weekday: "long",
        year: "numeric",
        month: "long",
        day: "numeric",
      };
      return this.currentTime.toLocaleDateString(
        this.item.locale || "zh-CN",
        options,
      );
    },
    showIcon: function () {
      return this.item.showIcon !== false;
    },
  },
  created: function () {
    this.updateTime();
  },
  beforeUnmount: function () {
    if (this.timer) {
      clearInterval(this.timer);
    }
  },
  methods: {
    updateTime: function () {
      this.currentTime = new Date();
      this.timer = setInterval(() => {
        this.currentTime = new Date();
      }, 1000);
    },
  },
};
</script>

<style scoped lang="scss">
.media-left {
  .image {
    display: flex;
    align-items: center;
    justify-content: center;
  }
  img {
    max-height: 100%;
    object-fit: contain;
  }
}
</style>

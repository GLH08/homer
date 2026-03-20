<template>
  <article>
    <div class="m-6 has-text-centered py-6 title">
      <p class="is-size-5 mb-2">{{ $t("getStarted.title") }}</p>
      <p>{{ $t("getStarted.description") }}</p>
      <p>
        <a
          class="button is-primary mt-5 has-text-weight-bold"
          href="https://github.com/bastienwirtz/homer/blob/main/docs/configuration.md#configuration"
          target="_blank"
        >
          {{ $t("getStarted.button") }}
        </a>
      </p>
    </div>
  </article>
</template>

<script>
export default {
  name: "GetStarted",
};
</script>

<style lang="scss" scoped>
body #app a {
  font-weight: 900;
  color: #ffffff;
}
</style>

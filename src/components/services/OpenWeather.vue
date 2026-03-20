<template>
  <div :class="{ 'component-error': error }">
    <div class="card" :class="item.class">
      <a
        :href="item.url || `https://openweathermap.org/city/${id}`"
        :target="item.target"
        rel="noreferrer"
      >
        <div class="card-content">
          <div class="media">
            <div v-if="icon || !error" class="media-left" :class="item.background">
              <figure class="image is-48x48">
                <img
                  v-if="owmIcon"
                  :src="`https://openweathermap.org/img/wn/${owmIcon}@2x.png`"
                  :alt="conditions"
                  :title="conditions"
                />
                <i v-else :class="weatherIcon" style="font-size: 32px"></i>
              </figure>
            </div>
            <div class="media-content">
              <div>
                <p class="title is-4">{{ name }}</p>
                <p v-if="error" class="subtitle is-6">
                  天气信息加载失败
                </p>
                <p v-else class="subtitle is-6">
                  <span>{{ temperature }}</span>
                  <span v-if="locationTime" class="location-time">
                    {{ locationTime }}
                  </span>
                </p>
              </div>
            </div>
            <div v-if="error" name="indicator" class="indicator">⚠️</div>
          </div>
          <div v-if="item.tag" class="tag" :class="item.tagstyle">
            <strong class="tag-text">#{{ item.tag }}</strong>
          </div>
        </div>
      </a>
    </div>
  </div>
</template>

<script>
export default {
  name: "OpenWeather",
  props: {
    item: Object,
  },
  data: () => ({
    id: null,
    owmIcon: null,
    name: null,
    temp: null,
    conditions: null,
    error: false,
    timezoneOffset: 0,
    weatherIcon: "fas fa-cloud-sun",
  }),
  computed: {
    temperature: function () {
      if (!this.temp) return "";
      let unit = "K";
      if (this.item.units === "metric") {
        unit = "°C";
      } else if (this.item.units === "imperial") {
        unit = "°F";
      }
      return `${this.temp} ${unit}`;
    },
    locationTime: function () {
      if (!this.timezoneOffset) return "";
      return this.calcTime(this.timezoneOffset);
    },
    icon: function () {
      return this.owmIcon || this.weatherIcon;
    },
  },
  created() {
    this.fetchWeather();
  },
  methods: {
    fetchWeather: async function () {
      const apiKey = this.item.apikey || this.item.apiKey;

      try {
        if (apiKey) {
          // 使用 OpenWeatherMap API
          await this.fetchFromOWM(apiKey);
        } else {
          // 使用 wttr.in 免费接口（无需 API Key）
          await this.fetchFromWttr();
        }
      } catch (e) {
        console.error("Weather error:", e);
        this.name = this.item.name;
        this.error = true;
      }
    },

    fetchFromOWM: async function (apiKey) {
      let locationQuery;
      if (this.item.locationId) {
        locationQuery = `id=${this.item.locationId}`;
      } else {
        locationQuery = `q=${this.item.location}`;
      }

      let url = `https://api.openweathermap.org/data/2.5/weather?${locationQuery}&appid=${apiKey}&units=${this.item.units || "metric"}`;
      if (this.item.endpoint) {
        url = this.item.endpoint;
      }

      const response = await fetch(url);
      if (!response.ok) throw new Error(response.statusText);

      const weather = await response.json();
      this.id = weather.id;
      this.name = weather.name;
      this.temp = parseInt(weather.main.temp).toFixed(1);
      this.owmIcon = weather.weather[0].icon;
      this.conditions = weather.weather[0].description;
      this.timezoneOffset = weather.timezone;
    },

    fetchFromWttr: async function () {
      const location = this.item.location || "Beijing";
      const url = `https://wttr.in/${encodeURIComponent(location)}?format=j1`;
      const response = await fetch(url);
      if (!response.ok) throw new Error(response.statusText);

      const data = await response.json();
      if (!data.current_condition || !data.current_condition[0]) {
        throw new Error("Invalid response");
      }

      const current = data.current_condition[0];
      this.name = this.item.name || data.nearest_area?.[0]?.areaName?.[0]?.value || location;
      this.temp = current.temp_C;
      this.conditions = current.weatherDesc?.[0]?.value || "";
      this.timezoneOffset = 8 * 3600; // 北京时区

      // 根据天气描述设置图标
      this.weatherIcon = this.getWeatherIcon(current.weatherCode);
    },

    getWeatherIcon: function (code) {
      const codeMap = {
        "113": "fas fa-sun",           // Sunny/Clear
        "116": "fas fa-cloud-sun",     // Partly cloudy
        "119": "fas fa-cloud",         // Cloudy
        "122": "fas fa-cloud",         // Overcast
        "143": "fas fa-smog",          // Mist
        "176": "fas fa-cloud-rain",    // Patchy rain possible
        "179": "fas fa-snowflake",     // Patchy snow possible
        "182": "fas fa-snowflake",     // Patchy sleet possible
        "185": "fas fa-snowflake",     // Patchy freezing drizzle
        "200": "fas fa-bolt",          // Thundery outbreaks possible
        "227": "fas fa-snowflake",     // Blowing snow
        "230": "fas fa-snowflake",     // Blizzard
        "248": "fas fa-smog",          // Fog
        "260": "fas fa-smog",          // Freezing fog
        "263": "fas fa-cloud-rain",    // Patchy light drizzle
        "266": "fas fa-cloud-rain",    // Light drizzle
        "281": "fas fa-snowflake",     // Freezing drizzle
        "284": "fas fa-snowflake",     // Heavy freezing drizzle
        "293": "fas fa-cloud-rain",    // Patchy light rain
        "296": "fas fa-cloud-rain",    // Light rain
        "299": "fas fa-cloud-rain",    // Moderate rain at times
        "302": "fas fa-cloud-rain",    // Moderate rain
        "305": "fas fa-cloud-rain",    // Heavy rain at times
        "308": "fas fa-cloud-rain",    // Heavy rain
        "311": "fas fa-cloud-rain",    // Light freezing rain
        "314": "fas fa-cloud-rain",    // Moderate or heavy freezing rain
        "317": "fas fa-snowflake",     // Light sleet
        "320": "fas fa-snowflake",     // Moderate or heavy sleet
        "323": "fas fa-snowflake",     // Light sleet showers
        "326": "fas fa-snowflake",     // Moderate or heavy sleet showers
        "329": "fas fa-snowflake",     // Patchy moderate snow
        "332": "fas fa-snowflake",     // Moderate or heavy snow
        "335": "fas fa-snowflake",     // Patchy heavy snow
        "338": "fas fa-snowflake",     // Heavy snow
        "350": "fas fa-snowflake",     // Ice pellets
        "353": "fas fa-cloud-rain",    // Light rain showers
        "356": "fas fa-cloud-rain",    // Moderate or heavy rain showers
        "359": "fas fa-cloud-rain",    // Torrential rain shower
        "362": "fas fa-snowflake",     // Light showers of ice pellets
        "365": "fas fa-snowflake",     // Moderate or heavy showers of ice pellets
        "368": "fas fa-snowflake",     // Light snow showers
        "371": "fas fa-snowflake",     // Moderate or heavy snow showers
        "374": "fas fa-snowflake",     // Shower of ice pellets
        "377": "fas fa-snowflake",     // Moderate or heavy showers of ice pellets
        "386": "fas fa-bolt",          // Patchy light rain with thunder
        "389": "fas fa-bolt",          // Moderate or heavy rain with thunder
        "392": "fas fa-bolt",          // Patchy light snow with thunder
        "395": "fas fa-bolt",          // Moderate or heavy snow with thunder
      };
      return codeMap[String(code)] || "fas fa-cloud-sun";
    },

    calcTime: (offset) => {
      const localTime = new Date();
      const utcTime = localTime.getTime() + localTime.getTimezoneOffset() * 60000;
      const calculatedTime = new Date(utcTime + 1000 * offset);
      return calculatedTime.toLocaleString([], {
        hour: "2-digit",
        minute: "2-digit",
      });
    },
  },
};
</script>

<style scoped lang="scss">
.media-left {
  &.circle,
  &.square {
    background-color: #e4e4e4;
  }

  &.circle {
    border-radius: 90%;
  }

  img {
    max-height: 100%;
  }
}

.error {
  color: #de0000;
}

.is-dark {
  .media-left {
    &.circle,
    &.square {
      background-color: #909090;
    }
  }
}

.location-time {
  margin-left: 20px;
}
</style>

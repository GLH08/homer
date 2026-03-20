#!/usr/bin/env node
/**
 * Homer 配置文件校验工具
 *
 * 使用方式：
 *   node scripts/validate-config.js [配置文件路径]
 *
 * 示例：
 *   node scripts/validate-config.js ../config.yml
 */

import { parse } from "yaml";
import fs from "fs";
import path from "path";

const CONFIG_PATH = process.argv[2] || "../public/assets/config.yml";

// 必需字段
const REQUIRED_FIELDS = [
  "title",
  "theme",
];

// 有效主题列表
const VALID_THEMES = [
  "default",
  "callibration",
  "dashy",
  "fundamental",
  "hack",
  "hesper",
  "hitman",
  "homarr",
  "matter",
  "netSeb",
  "nord",
  "obsidian",
  "sma",
  "waterfall",
];

// 有效服务类型
const VALID_TYPES = [
  "Generic",
  "AdGuardHome",
  "CopyToClipboard",
  "DockerSocketProxy",
  "Docuseal",
  "Emby",
  "FreshRSS",
  "Gatus",
  "Gitea",
  "Glances",
  "Gotify",
  "Healthchecks",
  "HomeAssistant",
  "Immich",
  "Jellystat",
  "Lidarr",
  "Linkding",
  "Matrix",
  "Mealie",
  "Medusa",
  "Miniflux",
  "Nextcloud",
  "OctoPrint",
  "OliveTin",
  "OpenHAB",
  "OpenWeather",
  "PaperlessNG",
  "PeaNUT",
  "PiAlert",
  "PiHole",
  "Ping",
  "Plex",
  "Portainer",
  "Prometheus",
  "Proxmox",
  "Prowlarr",
  "qBittorrent",
  "Radarr",
  "Readarr",
  "Rtorrent",
  "SABnzbd",
  "Scrutiny",
  "Sonarr",
  "SpeedtestTracker",
  "Tautulli",
  "Tdarr",
  "Traefik",
  "Transmission",
  "TruenasScale",
  "UptimeKuma",
  "Vaultwarden",
  "Wallabag",
  "WUD",
  "Clock",
];

// 智能组件必需字段映射
const TYPE_REQUIRED_FIELDS = {
  OpenWeather: ["location"],
  Glances: ["url"],
  PiHole: ["url"],
  Portainer: ["url", "apikey"],
  Proxmox: ["url", "node", "api_token"],
  Emby: ["url", "apikey"],
  Plex: ["url", "token"],
  Sonarr: ["url", "apikey"],
  Radarr: ["url", "apikey"],
};

let errors = [];
let warnings = [];

function validateConfig(config, filePath) {
  console.log(`\n📋 校验配置文件: ${filePath}\n`);

  // 检查文件是否存在
  if (!fs.existsSync(filePath)) {
    errors.push(`❌ 配置文件不存在: ${filePath}`);
    return false;
  }

  // 解析 YAML
  let configData;
  try {
    const content = fs.readFileSync(filePath, "utf-8");
    configData = parse(content, { merge: true });
  } catch (e) {
    errors.push(`❌ YAML 解析错误: ${e.message}`);
    return false;
  }

  // 检查必需字段
  for (const field of REQUIRED_FIELDS) {
    if (!configData[field]) {
      errors.push(`❌ 缺少必需字段: ${field}`);
    }
  }

  // 检查主题是否有效
  if (configData.theme && !VALID_THEMES.includes(configData.theme)) {
    warnings.push(`⚠️  未知主题: ${configData.theme}，将使用默认主题`);
  }

  // 检查服务分组
  if (!configData.services || !Array.isArray(configData.services)) {
    warnings.push("⚠️  未找到 services 配置或格式不正确");
  } else {
    configData.services.forEach((group, groupIndex) => {
      if (!group.name) {
        warnings.push(`⚠️  分组 ${groupIndex} 缺少 name 字段`);
      }

      if (!group.items || !Array.isArray(group.items)) {
        errors.push(`❌ 分组 "${group.name || groupIndex}" 缺少 items 数组`);
        return;
      }

      group.items.forEach((item, itemIndex) => {
        if (!item.name) {
          errors.push(`❌ 分组 "${group.name}" 的第 ${itemIndex + 1} 项缺少 name`);
        }

        // 检查服务类型
        if (item.type && !VALID_TYPES.includes(item.type)) {
          warnings.push(`⚠️  服务 "${item.name}" 使用未知类型: ${item.type}`);
        }

        // 检查智能组件必需字段
        if (item.type && TYPE_REQUIRED_FIELDS[item.type]) {
          for (const field of TYPE_REQUIRED_FIELDS[item.type]) {
            if (!item[field]) {
              warnings.push(
                `⚠️  服务 "${item.name}" (${item.type}) 缺少字段: ${field}`
              );
            }
          }
        }

        // 检查 URL 或 type
        if (!item.url && !item.type) {
          errors.push(`❌ 服务 "${item.name}" 缺少 url 或 type`);
        }

        // 检查 API Key
        if (
          (item.type === "OpenWeather" || item.type === "PiHole") &&
          !item.apikey &&
          !item.apiKey
        ) {
          warnings.push(
            `💡 服务 "${item.name}" 未配置 API Key，将使用免费接口`
          );
        }
      });
    });
  }

  // 检查 colors 配置
  if (configData.colors) {
    const validColorKeys = [
      "highlight-primary",
      "highlight-secondary",
      "background",
      "card-background",
      "text",
      "text-header",
      "text-title",
      "text-subtitle",
      "link",
      "link-hover",
    ];

    ["light", "dark"].forEach((mode) => {
      if (configData.colors[mode]) {
        for (const key of Object.keys(configData.colors[mode])) {
          if (!validColorKeys.includes(key)) {
            warnings.push(
              `⚠️  颜色配置 "${mode}.${key}" 不是标准字段`
            );
          }
        }
      }
    });
  }

  return errors.length === 0;
}

// 执行校验
const isValid = validateConfig(null, path.resolve(CONFIG_PATH));

// 输出结果
console.log("=".repeat(50));
if (errors.length > 0) {
  console.log("\n❌ 错误:");
  errors.forEach((e) => console.log(`   ${e}`));
}

if (warnings.length > 0) {
  console.log("\n⚠️  警告:");
  warnings.forEach((w) => console.log(`   ${w}`));
}

console.log("\n" + "=".repeat(50));
if (isValid) {
  console.log("✅ 配置校验通过！\n");
  process.exit(0);
} else {
  console.log("❌ 配置校验失败，请修复上述错误。\n");
  process.exit(1);
}

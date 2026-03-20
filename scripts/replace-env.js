#!/usr/bin/env node
/**
 * Homer 环境变量替换工具
 *
 * 使用方式：
 *   node scripts/replace-env.js [输入文件] [输出文件]
 *
 * 示例：
 *   node scripts/replace-env.js config.yml config.env.yml
 *
 * config.yml 中使用 ${VAR_NAME} 引用环境变量
 */

import fs from "fs";

const INPUT_FILE = process.argv[2] || "../config.yml";
const OUTPUT_FILE = process.argv[3] || "../config.env.yml";

/**
 * 替换字符串中的环境变量
 * 支持格式：${VAR_NAME} 或 ${VAR_NAME:-default}
 */
function replaceEnvVars(content) {
  return content.replace(/\$\{([^}]+)\}/g, (match, expr) => {
    const [varName, defaultValue] = expr.split(":-");
    const value = process.env[varName.trim()];

    if (value !== undefined) {
      return value;
    }

    if (defaultValue !== undefined) {
      return defaultValue;
    }

    console.warn(`⚠️  环境变量未设置: ${varName}`);
    return match;
  });
}

// 读取并处理文件
const content = fs.readFileSync(INPUT_FILE, "utf-8");
const result = replaceEnvVars(content);

// 输出到文件
fs.writeFileSync(OUTPUT_FILE, result, "utf-8");

console.log(`✅ 环境变量替换完成`);
console.log(`   输入: ${INPUT_FILE}`);
console.log(`   输出: ${OUTPUT_FILE}`);

// 显示已替换的环境变量
const envVars = content.match(/\$\{[^}]+\}/g) || [];
if (envVars.length > 0) {
  console.log(`\n📌 检测到的环境变量引用:`);
  envVars.forEach((v) => console.log(`   ${v}`));
}

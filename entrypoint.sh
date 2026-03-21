#!/bin/sh

# Homer 环境变量替换 + 启动脚本

CONFIG_FILE="/www/assets/config.yml"

# 替换环境变量
replace_env_vars_in_file() {
    if [ ! -f "$CONFIG_FILE" ]; then
        return
    fi

    # 检查是否包含需要替换的变量
    if ! grep -q '\${[A-Za-z_][A-Za-z0-9_]*}' "$CONFIG_FILE" 2>/dev/null; then
        return
    fi

    # 使用 sed 一次性替换所有 ${VAR} 格式的变量
    # 构建 sed 替换命令
    SED_CMD=""

    # 遍历所有环境变量，生成替换规则
    for var in $(set | grep -E '^[A-Za-z_][A-Za-z0-9_]*=' | cut -d= -f1); do
        # 跳过内部变量
        case "$var" in
            PATH|HOME|USER|PWD|SHELL|TERM|HOSTNAME|IFS) continue ;;
        esac
        value=$(eval echo \$$var 2>/dev/null)
        # 转义 value 中的特殊字符（/ 和 &）
        value=$(echo "$value" | sed 's/[&/]/\\&/g')
        SED_CMD="${SED_CMD} -e s|\${${var}}|${value}|g"
    done

    # 执行替换
    sed ${SED_CMD} "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
    mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    echo "[Homer] Environment variables replaced"
}

# 默认资源配置（原始逻辑）
if [ "${INIT_ASSETS}" = "1" ] && [ ! -f "/www/assets/config.yml" ]; then
    echo "No configuration found, installing default config & assets"
    if [ -w "/www/assets/" ]; then
        while true; do echo n; done | cp -Ri /www/default-assets/* /www/assets/
        yes n | cp -i /www/default-assets/config.yml.dist /www/assets/config.yml
    else
        echo "Assets directory not writable, skipping default config install."
    fi
fi

# 替换环境变量
replace_env_vars_in_file

# 启动服务
echo "Starting webserver"
exec 3>&1
exec lighttpd -D -f /lighttpd.conf

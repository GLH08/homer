#!/bin/sh

# Homer 环境变量替换脚本
# 将 config.yml 中的 ${VAR_NAME} 替换为实际的环境变量值

CONFIG_FILE="/www/assets/config.yml"

replace_env_vars() {
    local line="$1"
    local result=""

    # 匹配 ${VAR_NAME} 格式（不含默认值）
    while echo "$line" | grep -q '\${[A-Za-z_][A-Za-z0-9_]*}'; do
        local var=$(echo "$line" | sed -n 's/.*\${\([A-Za-z_][A-Za-z0-9_]*\)}.*/\1/p')
        if [ -z "$var" ]; then
            break
        fi
        local value=$(eval echo "\$$var" 2>/dev/null)
        if [ -n "$value" ]; then
            line=$(echo "$line" | sed "s|\${${var}}|${value}|")
        else
            # 变量未设置，替换为空
            line=$(echo "$line" | sed "s|\${${var}}||")
        fi
    done

    echo "$line"
}

if [ -f "$CONFIG_FILE" ]; then
    TMP_FILE=$(mktemp)

    while IFS= read -r line; do
        replace_env_vars "$line"
    done < "$CONFIG_FILE" > "$TMP_FILE"

    cp "$TMP_FILE" "$CONFIG_FILE"
    rm -f "$TMP_FILE"
    echo "[Homer] Environment variables replaced"
fi

# 执行原始 entrypoint
exec /docker-entrypoint.sh "$@"

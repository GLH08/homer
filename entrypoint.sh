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

    TMP_FILE=$(mktemp)

    while IFS= read -r line; do
        new_line="$line"
        while echo "$new_line" | grep -q '\${[A-Za-z_][A-Za-z0-9_]*}'; do
            var=$(echo "$new_line" | sed -n 's/.*\${\([A-Za-z_][A-Za-z0-9_]*\)}.*/\1/p')
            if [ -z "$var" ]; then
                break
            fi
            value=$(eval echo "\$$var" 2>/dev/null)
            if [ -n "$value" ]; then
                new_line=$(echo "$new_line" | sed "s|\${${var}}|${value}|")
            else
                new_line=$(echo "$new_line" | sed "s|\${${var}}|")
            fi
        done
        echo "$new_line"
    done < "$CONFIG_FILE" > "$TMP_FILE"

    cp "$TMP_FILE" "$CONFIG_FILE"
    rm -f "$TMP_FILE"
    echo "[Homer] Environment variables replaced"
}

# 默认资源配置（原始逻辑）
if [[ "${INIT_ASSETS}" == "1" ]] && [[ ! -f "/www/assets/config.yml" ]]; then
    echo "No configuration found, installing default config & assets"
    if [[ -w "/www/assets/" ]]; then
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

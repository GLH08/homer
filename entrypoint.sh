#!/bin/sh

# Homer 环境变量替换 + 启动脚本

CONFIG_FILE="/www/assets/config.yml"
TEMPLATE_FILE="/www/assets/config.yml.template"

# 替换环境变量
replace_env_vars_in_file() {
    # 如果存在模板文件，生成 config.yml
    if [ -f "$TEMPLATE_FILE" ]; then
        cp "$TEMPLATE_FILE" "$CONFIG_FILE.tmp"
        
        for var in $(set | grep -E '^[A-Za-z_][A-Za-z0-9_]*=' | cut -d= -f1); do
            case "$var" in
                PATH|HOME|USER|PWD|SHELL|TERM|HOSTNAME|IFS) continue ;;
            esac
            value=$(eval echo \$$var 2>/dev/null)
            value=$(echo "$value" | sed 's/[&\/|]/\\&/g')
            
            if grep -q "\${$var}" "$CONFIG_FILE.tmp" 2>/dev/null; then
                # 使用双引号防止带空格的 value 造成命令分割错误
                sed -i "s|\${${var}}|${value}|g" "$CONFIG_FILE.tmp"
            fi
        done
        
        mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
        echo "[Homer] Environment variables replaced from template"
    else
        # 兼容旧逻辑
        if [ ! -f "$CONFIG_FILE" ]; then
            return
        fi

        cp "$CONFIG_FILE" "$CONFIG_FILE.tmp"
        for var in $(set | grep -E '^[A-Za-z_][A-Za-z0-9_]*=' | cut -d= -f1); do
            case "$var" in
                PATH|HOME|USER|PWD|SHELL|TERM|HOSTNAME|IFS) continue ;;
            esac
            value=$(eval echo \$$var 2>/dev/null)
            value=$(echo "$value" | sed 's/[&\/|]/\\&/g')
            if grep -q "\${$var}" "$CONFIG_FILE.tmp" 2>/dev/null; then
                sed -i "s|\${${var}}|${value}|g" "$CONFIG_FILE.tmp"
            fi
        done
        
        if cat "$CONFIG_FILE.tmp" > "$CONFIG_FILE" 2>/dev/null; then
            rm "$CONFIG_FILE.tmp"
            echo "[Homer] Environment variables replaced in-place"
        else
            rm "$CONFIG_FILE.tmp"
            echo "[Homer] Warning: Could not replace environment variables in-place (possibly ready-only or bind mount issue)"
        fi
    fi
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

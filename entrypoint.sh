#!/bin/sh

# Homer 环境变量替换脚本
# 将 config.yml 中的 ${VAR_NAME} 替换为实际的环境变量值

CONFIG_FILE="/www/assets/config.yml"

replace_env_vars_in_file() {
    if [ ! -f "$CONFIG_FILE" ]; then
        return
    fi

    # 检查是否包含需要替换的变量
    if ! grep -q '\${[A-Za-z_][A-Za-z0-9_]*}' "$CONFIG_FILE" 2>/dev/null; then
        return
    fi

    # 创建临时文件
    TMP_FILE=$(mktemp)

    # 逐行处理，替换环境变量
    while IFS= read -r line; do
        new_line="$line"
        # 匹配 ${VAR_NAME} 格式
        while echo "$new_line" | grep -q '\${[A-Za-z_][A-Za-z0-9_]*}'; do
            var=$(echo "$new_line" | sed -n 's/.*\${\([A-Za-z_][A-Za-z0-9_]*\)}.*/\1/p')
            if [ -z "$var" ]; then
                break
            fi
            value=$(eval echo "\$$var" 2>/dev/null)
            if [ -n "$value" ]; then
                new_line=$(echo "$new_line" | sed "s|\${${var}}|${value}|")
            else
                new_line=$(echo "$new_line" | sed "s|\${${var}}||")
            fi
        done
        echo "$new_line"
    done < "$CONFIG_FILE" > "$TMP_FILE"

    # 如果有变化则更新文件
    if ! cmp -s "$CONFIG_FILE" "$TMP_FILE" 2>/dev/null; then
        # 检查文件是否只读（挂载的 :ro 文件）
        if [ -w "$CONFIG_FILE" ] 2>/dev/null; then
            cp "$TMP_FILE" "$CONFIG_FILE"
            echo "[Homer] Environment variables replaced"
        fi
    fi
    rm -f "$TMP_FILE"
}

replace_env_vars_in_file

# 启动 lighttpd
echo "Starting webserver"
exec lighttpd -D -f /lighttpd.conf

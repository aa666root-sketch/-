#!/bin/bash
clear

# ==============================================
# 红光官方黑客工具箱 —— 合法学习专用版
# 作者：红光
# 声明：本工具 100% 无攻击、无入侵、无扫描、无破解功能
# ==============================================

echo -e "\033[31m==================================================\033[0m"
echo -e "\033[31m           红光官方黑客工具箱（学习版）           \033[0m"
echo -e "\033[31m==================================================\033[0m"
echo ""
echo -e "\033[33m【重要法律免责声明】\033[0m"
echo "1. 本工具箱仅用于计算机知识学习、代码演示、本地调试。"
echo "2. 本工具完全不包含任何攻击、入侵、漏洞利用、远程控制、"
echo "   密码破解、端口扫描、数据窃取、ARP 欺骗、抓包嗅探等功能。"
echo "3. 本工具不会访问、修改、破坏任何第三方设备或系统。"
echo "4. 任何人下载、安装、使用本工具，均视为已阅读并同意："
echo "   - 仅在自己拥有所有权或授权的设备上使用"
echo "   - 绝不用于任何非法、未经授权、恶意破坏的行为"
echo "   - 一切非法使用所造成的后果，由使用者自行承担"
echo "5. 作者不对任何非法使用行为承担任何法律责任。"
echo ""
echo -e "\033[32m本工具仅学习使用 · 无任何攻击功能\033[0m"
echo -e "\033[31m==================================================\033[0m"
echo ""

# 主菜单
while true; do
    echo "【工具箱合法功能菜单】"
    echo "1. 查看本机系统信息"
    echo "2. 查看本机网络信息（IP/网卡）"
    echo "3. 查看当前用户与权限信息"
    echo "4. 查看本机开放端口（仅本地）"
    echo "5. 查看磁盘与内存使用情况"
    echo "6. 安全学习资料（基础防御/合规）"
    echo "7. 代码片段演示（仅本地学习）"
    echo "8. 退出工具箱"
    echo ""
    read -p "请输入功能编号：" num

    case $num in
        1)
            echo -e "\n[ 本机系统信息 ]"
            echo "操作系统：$(uname -s)"
            echo "内核版本：$(uname -r)"
            echo "主机名：$(hostname)"
            echo "架构：$(uname -m)"
            echo "运行时间：$(uptime -p)"
            echo ""
            ;;
        2)
            echo -e "\n[ 本机网络信息 ]"
            echo "内网IP："
            hostname -I 2>/dev/null || ip addr show | grep inet | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1
            echo ""
            echo "网卡信息："
            ip link show
            echo ""
            ;;
        3)
            echo -e "\n[ 当前用户信息 ]"
            echo "用户名：$(whoami)"
            echo "UID/GID：$(id -u)/$(id -g)"
            echo "所属组：$(id -G -n)"
            echo "家目录：$HOME"
            echo ""
            ;;
        4)
            echo -e "\n[ 本机开放端口（仅监听本地） ]"
            echo "注意：仅显示本机正在监听的端口，不扫描任何外部设备！"
            netstat -tuln 2>/dev/null || ss -tuln
            echo ""
            ;;
        5)
            echo -e "\n[ 资源使用情况 ]"
            echo "磁盘使用："
            df -h
            echo ""
            echo "内存使用："
            free -h
            echo ""
            ;;
        6)
            echo -e "\n[ 安全学习资料 ]"
            echo "• 渗透测试必须获得书面授权，否则属于违法行为"
            echo "• 《网络安全法》《刑法》第285/286条：禁止非法入侵、破坏计算机系统"
            echo "• 学习方向推荐：网络防御、代码审计、合规安全、应急响应"
            echo "• 合法靶场推荐：TryHackMe、Hack The Box（需遵守平台规则）"
            echo ""
            ;;
        7)
            echo -e "\n[ 代码片段演示（仅本地学习） ]"
            echo "1. Bash 基础循环演示"
            echo "2. 简单网络请求演示（仅访问合法站点）"
            read -p "选择演示编号：" demo_num
            case $demo_num in
                1)
                    echo -e "\n循环演示（打印1-5）："
                    for i in {1..5}; do echo "计数：$i"; done
                    ;;
                2)
                    echo -e "\n网络请求演示（访问 example.com）："
                    curl -I https://example.com 2>/dev/null | head -5
                    ;;
                *)
                    echo "输入错误！"
                    ;;
            esac
            echo ""
            ;;
        8)
            echo -e "\n感谢使用红光官方黑客工具箱（学习版），请遵守法律法规！"
            exit 0
            ;;
        *)
            echo -e "\n输入错误，请输入有效编号！\n"
            ;;
    esac
    read -p "按回车键返回主菜单..."
    clear
done

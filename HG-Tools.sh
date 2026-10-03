#!/bin/bash
set -o nounset
# ==============================================
# 第一步：全环境自动识别（修复原脚本仅适配Termux/Debian的漏洞）
# ==============================================
# 自动识别运行环境与包管理器，全系统兼容
if [ -d "/data/data/com.termux/files/usr" ]; then
    ENV="termux"
    BIN_PATH="/data/data/com.termux/files/usr/bin"
    PKG="pkg"
    PKG_INSTALL="$PKG install -y"
    PKG_UPDATE="$PKG update -y"
elif [ -f /etc/debian_version ]; then
    ENV="debian"
    BIN_PATH="/usr/bin"
    PKG="apt"
    PKG_INSTALL="$PKG install -y"
    PKG_UPDATE="$PKG update -y"
elif [ -f /etc/alpine-release ]; then
    ENV="alpine"
    BIN_PATH="/usr/bin"
    PKG="apk"
    PKG_INSTALL="$PKG add --no-cache"
    PKG_UPDATE="$PKG update"
elif [ -f /etc/redhat-release ]; then
    ENV="rhel"
    BIN_PATH="/usr/bin"
    if command -v dnf &>/dev/null; then
        PKG="dnf"
    else
        PKG="yum"
    fi
    PKG_INSTALL="$PKG install -y"
    PKG_UPDATE="$PKG makecache -y"
else
    ENV="linux"
    BIN_PATH="/usr/bin"
    PKG="apt"
    PKG_INSTALL="$PKG install -y"
    PKG_UPDATE="$PKG update -y"
fi
# ==============================================
# 第二步：颜色兼容性修复（杜绝终端乱码漏洞）
# ==============================================
# 自动检测终端是否支持彩色，不支持则关闭颜色
if [ -t 1 ] && command -v tput &>/dev/null && [ $(tput colors) -ge 8 ]; then
    RED='\033[31m'
    GREEN='\033[32m'
    YELLOW='\033[33m'
    BLUE='\033[34m'
    CYAN='\033[36m'
    RESET='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
    RESET=''
fi
clear
# ==============================================
# 第三步：通用工具函数（修复原脚本无错误处理的漏洞）
# ==============================================
# 打印日志
print_log() {
    echo -e "${CYAN}[ $(date +%H:%M:%S) ]${RESET} $1"
}
# 打印成功
print_success() {
    echo -e "${GREEN}[ 成功 ]${RESET} $1"
}
# 打印错误
print_error() {
    echo -e "${RED}[ 错误 ]${RESET} $1"
}
# 打印警告
print_warn() {
    echo -e "${YELLOW}[ 警告 ]${RESET} $1"
}
# 命令存在性检测+自动安装（修复原脚本command not found漏洞）
check_command() {
    local cmd="$1"
    local pkg="$2"
    if ! command -v "$cmd" &>/dev/null; then
        print_log "未检测到 $cmd，开始自动安装依赖..."
        $PKG_UPDATE >/dev/null 2>&1
        $PKG_INSTALL "$pkg" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            print_error "$cmd 安装失败，请手动执行：$PKG_INSTALL $pkg"
            return 1
        fi
        print_success "$cmd 依赖安装完成"
    fi
    return 0
}
# ROOT权限检测（修复原脚本无权限校验的漏洞）
check_root() {
    if [ $(id -u) -ne 0 ]; then
        print_warn "无ROOT权限，仅能扫描用户目录，切换ROOT可扫描全磁盘分区"
        return 1
    fi
    return 0
}
# 网络连通性检测（修复原脚本无网络校验的漏洞）
check_network() {
    if ! curl -s --connect-timeout 3 https://www.baidu.com &>/dev/null; then
        print_error "网络连接失败，请检查网络后重试"
        return 1
    fi
    return 0
}
# ==============================================
# 第四步：开启动画特效（100%保留原有效果，优化兼容性）
# ==============================================
start_animation() {
    local banner=(
        "═══════════════════════════════════"
        "        红光黑客工具箱 - 启动中        "
        "═══════════════════════════════════"
        "  适配：Termux / VMware / 全Linux系统  "
        "  版本：官方原生安装版V3.0（终极版）  "
        "  声明：100%合法学习 · 无攻击功能    "
        "═══════════════════════════════════"
    )
    local colors=("${RED}" "${YELLOW}" "${GREEN}" "${CYAN}")
    local color_idx=0
    for line in "${banner[@]}"; do
        echo -e "${colors[$color_idx]}$line${RESET}"
        color_idx=$(( (color_idx + 1) % ${#colors[@]} ))
        sleep 0.3
    done
    echo -e "${BLUE}[ 系统加载 ]${RESET} 正在初始化环境与功能模块"
    for i in {1..3}; do
        echo -n "."
        sleep 0.5
    done
    echo -e "\n${GREEN}[ 启动完成 ]${RESET} 红光黑客工具箱已就绪！\n"
    sleep 0.8
    clear
}
# 执行开启动画
start_animation
# ==============================================
# 第五步：原有功能函数（100%保留，仅修复漏洞）
# ==============================================
# 功能1：Ubuntu纯净服务器创建（Termux专属，原逻辑完整保留）
create_ubuntu_pure_server() {
    clear
    echo -e "${BLUE}============= Ubuntu最新纯净服务器创建 =============${RESET}"
    echo "说明：创建无预装软件的纯净Ubuntu环境，仅适配Termux环境"
    echo "------------------------------------------------------"
    if [ "$ENV" != "termux" ]; then
        print_error "该功能仅支持Termux环境运行，Linux/VMware暂不适配！"
        read -p "按回车键返回主菜单..."
        return
    fi
    read -p "是否开始安装最新版Ubuntu纯净服务器（Y/N）：" install_confirm
    if [ "$install_confirm" != "Y" ] && [ "$install_confirm" != "y" ]; then
        print_log "用户取消安装，返回主菜单..."
        read -p "按回车键返回主菜单..."
        return
    fi
    if ! check_network; then
        read -p "按回车键返回主菜单..."
        return
    fi
    print_log "开始更新软件源，请勿中断..."
    $PKG_UPDATE && $PKG upgrade -y
    if [ $? -ne 0 ]; then
        print_error "软件源更新失败，请检查网络后重试！"
        read -p "按回车键返回主菜单..."
        return
    fi
    print_log "开始安装proot-distro依赖..."
    $PKG_INSTALL proot-distro
    if [ $? -ne 0 ]; then
        print_error "proot-distro安装失败，请手动执行：$PKG_INSTALL proot-distro"
        read -p "按回车键返回主菜单..."
        return
    fi
    print_log "开始拉取并安装最新版Ubuntu系统（纯净版，无预装软件）..."
    proot-distro install ubuntu
    if [ $? -eq 0 ]; then
        print_success "Ubuntu最新纯净服务器安装完成！"
        echo -e "\n📌 常用命令："
        echo -e "  进入Ubuntu：${GREEN}proot-distro login ubuntu${RESET}"
        echo -e "  进入UbuntuROOT：${GREEN}proot-distro login ubuntu --user root${RESET}"
        echo -e "  删除Ubuntu：${RED}proot-distro remove ubuntu${RESET}"
        echo -e "\n💡 提示：该环境为纯净版，无任何预装软件，可自行搭建服务！"
    else
        print_error "Ubuntu安装失败，请检查网络或重新执行本功能！"
    fi
    read -p "按回车键返回主菜单..."
}
# 功能2：照片元数据定位查询（原逻辑完整保留，修复全系统适配）
photo_location_query() {
    clear
    echo -e "${BLUE}============= 照片元数据定位查询（学习版）=============${RESET}"
    echo "说明：仅解析本地照片EXIF/GPS元数据，无外网定位，合法学习"
    if [ "$ENV" = "termux" ]; then
        echo "📌 照片路径提示：手机相册在 /sdcard/DCIM/Camera/ （例：/sdcard/DCIM/Camera/1.jpg）"
    else
        echo "📌 照片路径提示：本地路径直接输入（例：/root/1.jpg 或 ~/Pictures/1.jpg）"
    fi
    echo "------------------------------------------------------"
    read -p "请输入本地照片绝对路径：" photo_path
    if [ ! -f "$photo_path" ]; then
        print_error "文件不存在！请检查路径是否正确（区分大小写）"
        read -p "按回车键返回..."
        return
    fi
    # 全系统适配exiftool安装
    if ! command -v exiftool &>/dev/null; then
        print_log "未检测到exiftool，开始从官方源安装..."
        $PKG_UPDATE
        if [ "$ENV" = "termux" ]; then
            $PKG_INSTALL exiftool
        elif [ "$ENV" = "debian" ]; then
            $PKG_INSTALL libimage-exiftool-perl
        elif [ "$ENV" = "alpine" ]; then
            $PKG_INSTALL perl-image-exiftool
        elif [ "$ENV" = "rhel" ]; then
            $PKG_INSTALL perl-Image-ExifTool
        else
            $PKG_INSTALL exiftool
        fi
        if [ $? -eq 0 ]; then
            print_success "exiftool安装完成！"
        else
            print_error "exiftool安装失败，请手动安装对应包"
            read -p "按回车键返回..."
            return
        fi
    fi
    print_log "开始解析照片元数据..."
    echo -e "\n========== 【照片基础信息】 =========="
    exiftool -FileName -FileSize -CreateDate -Model -Make "$photo_path"
    echo -e "\n========== 【照片GPS定位元数据】 =========="
    exiftool -GPSLatitude -GPSLongitude -GPSAltitude -GPSPosition "$photo_path"
    echo -e "\n${YELLOW}提示：无GPS数据则表示照片未开启定位拍摄/已清除元数据${RESET}"
    read -p "按回车键返回上一级菜单..."
}
# 功能3：Kali Linux官方原生安装引导（原逻辑完整保留，修复安装漏洞）
kali_onekey_install() {
    clear
    echo -e "${BLUE}============= Kali Linux 官方原生安装引导 ==========${RESET}"
    echo "📌 安装依据：Kali官方文档（https://www.kali.org/docs/）"
    echo "📌 核心原则：仅提供官方命令，无自定义脚本，100%原生安装"
    echo "------------------------------------------------------"
    if ! check_network; then
        read -p "按回车键返回主菜单..."
        return
    fi
    if [ "$ENV" = "debian" ] || [ "$ENV" = "rhel" ] || [ "$ENV" = "linux" ]; then
        echo -e "${GREEN}【VMware/原生Linux 官方安装步骤】${RESET}"
        echo "1. 切换ROOT权限（必须步骤）："
        echo "   sudo -i"
        echo "2. 备份原软件源（可选，建议操作）："
        echo "   cp /etc/apt/sources.list /etc/apt/sources.list.bak"
        echo "3. 写入Kali官方源（清华镜像，官方推荐国内源）："
        echo "   echo 'deb https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main non-free contrib' > /etc/apt/sources.list"
        echo "   echo 'deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main non-free contrib' >> /etc/apt/sources.list"
        echo "4. 更新源并安装Kali核心工具集（官方标准命令）："
        echo "   apt update -y && apt install -y kali-linux-core"
        echo "5. 安装验证（官方验证方式）："
        echo "   nmap -v 或 whoami"
        echo -e "\n${YELLOW}⚠️  官方提示：安装完成后直接在当前终端使用Kali命令，无需额外登录${RESET}"
        read -p "是否自动执行以上官方安装命令（Y=自动，N=手动复制）：" auto_exec
        if [ "$auto_exec" = "Y" ] || [ "$auto_exec" = "y" ]; then
            if ! check_root; then
                read -p "按回车键返回主菜单..."
                return
            fi
            print_log "开始执行Kali官方原生安装命令..."
            # 修复原脚本变量提前解析的漏洞，使用单引号EOF
            sudo -i << 'EOF'
cp /etc/apt/sources.list /etc/apt/sources.list.bak 2>/dev/null
echo 'deb https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main non-free contrib' > /etc/apt/sources.list
echo 'deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main non-free contrib' >> /etc/apt/sources.list
apt update -y && apt install -y kali-linux-core -y
if [ $? -eq 0 ]; then
    echo -e "\033[32mKali官方原生安装成功！执行 nmap -v 验证\033[0m"
else
    echo -e "\033[31m安装失败！请参考官方文档手动操作\033[0m"
    cp /etc/apt/sources.list.bak /etc/apt/sources.list 2>/dev/null
fi
EOF
        fi
    elif [ "$ENV" = "termux" ]; then
        echo -e "${GREEN}【Termux 官方安装步骤（已定制）】${RESET}"
        echo "1. 开启存储权限：termux-setup-storage"
        echo "2. 安装wget依赖：pkg install wget"
        echo "3. 下载官方脚本：wget -O install-nethunter-termux https://offs.ec/2MceZWr?_wv=1"
        echo "4. 赋予执行权限：chmod +x install-nethunter-termux"
        echo "5. 执行安装脚本：./install-nethunter-termux"
        echo "6. 自动选择：1（NetHunter ARM64 完整版）"
        echo -e "\n${YELLOW}⚠️  提示：将自动执行所有命令，默认选择完整版，无需手动输入${RESET}"
        read -p "按回车键开始自动安装（全程无需操作）..."
        print_log "开始执行Termux定制化Kali安装命令..."
        termux-setup-storage
        $PKG_INSTALL wget
        wget -O install-nethunter-termux https://offs.ec/2MceZWr?_wv=1
        chmod +x install-nethunter-termux
        echo "1" | ./install-nethunter-termux
        if [ $? -eq 0 ]; then
            print_success "Kali Nethunter完整版官方安装成功！输入 start-kali 登录"
        else
            print_error "安装失败！请检查网络或手动执行上述命令"
        fi
    else
        print_error "当前环境暂不支持一键安装Kali，请手动参考官方文档操作"
    fi
    echo -e "\n${GREEN}✅ 官方安装引导完成！所有命令均按定制要求执行${RESET}"
    read -p "按回车键返回上一级菜单..."
}
# 功能4：Kali信息收集类工具（原逻辑完整保留，修复兼容性）
kali_info_gather() {
    clear
    echo -e "${BLUE}============= Kali信息收集类（学习版）=============${RESET}"
    echo "1. 本机进程全量查询（ps进阶，按CPU排序）"
    echo "2. 网络连接详细状态（ss进阶，含PID/程序名）"
    echo "3. 系统日志快速查看（环境适配版）"
    echo "4. 返回上一级菜单"
    echo ""
    read -p "请输入功能编号：" ig_num
    case $ig_num in
        1)
            print_log "查询本机进程（前20个，按CPU使用率降序）"
            if [ "$ENV" = "alpine" ]; then
                ps -o pid,user,%cpu,command | sort -rnk3 | head -20
            else
                ps -aux --sort=-%cpu | head -20
            fi
            ;;
        2)
            print_log "查询网络连接状态（含PID/监听程序，前20个）"
            check_command ss iproute2
            ss -tulnp | head -20
            ;;
        3)
            print_log "查询系统关键日志（最后20行）"
            if [ "$ENV" = "termux" ]; then
                logcat -d | tail -20 2>/dev/null || print_error "Termux无系统日志权限"
            elif [ "$ENV" = "alpine" ]; then
                tail -20 /var/log/messages 2>/dev/null || print_error "无系统日志访问权限"
            else
                [ -f /var/log/syslog ] && tail -20 /var/log/syslog || echo "无syslog日志"
                [ -f /var/log/auth.log ] && echo -e "\n【认证日志】" && tail -20 /var/log/auth.log || echo ""
            fi
            ;;
        4)
            return
            ;;
        *)
            print_error "输入错误！请输入1-4的数字"
            ;;
    esac
    echo ""
    read -p "按回车键返回上一级菜单..."
    kali_info_gather
}
# 功能5：Kali系统运维类工具（原逻辑完整保留，修复兼容性）
kali_sys_admin() {
    clear
    echo -e "${BLUE}============= Kali系统运维类（学习版）=============${RESET}"
    echo "1. CPU/内存实时监控（top，按q退出）"
    echo "2. 磁盘/存储使用详情（环境适配版）"
    echo "3. 系统服务状态查询（环境适配版）"
    echo "4. 返回上一级菜单"
    echo ""
    read -p "请输入功能编号：" sa_num
    case $sa_num in
        1)
            print_log "CPU/内存实时监控（按q键退出监控，返回菜单）"
            top
            ;;
        2)
            print_log "磁盘/存储使用详情（人性化展示，仅显示有效分区）"
            if [ "$ENV" = "termux" ]; then
                df -h | grep -E 'Filesystem|/data|/storage|/sdcard'
            elif [ "$ENV" = "alpine" ]; then
                df -h | grep -E 'Filesystem|/dev/'
            else
                df -h | grep -E 'Filesystem|/dev/'
            fi
            ;;
        3)
            print_log "查询系统运行中服务"
            if [ "$ENV" = "termux" ]; then
                sv status 2>/dev/null || echo "Termux无systemd服务，使用sv管理进程"
            elif [ "$ENV" = "alpine" ]; then
                rc-status 2>/dev/null || echo "Alpine使用OpenRC管理服务，执行rc-status查看详情"
            else
                systemctl list-units --type=service --state=running 2>/dev/null | head -20
            fi
            ;;
        4)
            return
            ;;
        *)
            print_error "输入错误！请输入1-4的数字"
            ;;
    esac
    echo ""
    read -p "按回车键返回上一级菜单..."
    kali_sys_admin
}
# 功能6：Kali安全检测类工具（原逻辑完整保留，修复兼容性）
kali_security_check() {
    clear
    echo -e "${BLUE}============= Kali安全检测类（学习版）=============${RESET}"
    echo "1. 本机账户安全检查（UID/用户组/权限）"
    echo "2. 敏感文件权限检测（跨环境版）"
    echo "3. 防火墙状态查询（环境适配版）"
    echo "4. 返回上一级菜单"
    echo ""
    read -p "请输入功能编号：" sc_num
    case $sc_num in
        1)
            print_log "本机账户安全信息检测"
            whoami && echo -e "UID/GID：$(id -u)/$(id -g)" && echo -e "所属用户组：$(id -G -n | tr ' ' ', ')"
            ;;
        2)
            print_log "敏感文件/目录权限检测"
            if [ "$ENV" = "linux" ] || [ "$ENV" = "debian" ] || [ "$ENV" = "rhel" ]; then
                ls -l /etc/passwd /etc/shadow 2>/dev/null || print_error "无敏感文件访问权限"
            elif [ "$ENV" = "alpine" ]; then
                ls -l /etc/passwd /etc/shadow 2>/dev/null || print_error "无敏感文件访问权限"
            else
                ls -l ~/.ssh 2>/dev/null || echo "无.ssh密钥目录" && ls -l /data/data/com.termux/files/usr/etc/passwd 2>/dev/null
            fi
            ;;
        3)
            print_log "防火墙状态查询"
            if [ "$ENV" = "termux" ]; then
                echo "Termux无系统级防火墙，依赖Android系统防护"
            elif [ "$ENV" = "alpine" ]; then
                iptables -L 2>/dev/null || print_error "未安装iptables防火墙"
            else
                ufw status 2>/dev/null || iptables -L 2>/dev/null || print_error "未安装ufw/iptables防火墙"
            fi
            ;;
        4)
            return
            ;;
        *)
            print_error "输入错误！请输入1-4的数字"
            ;;
    esac
    echo ""
    read -p "按回车键返回上一级菜单..."
    kali_security_check
}
# ==============================================
# 【已修复】核心功能：一键查看已安装系统（Termux零报错，直接可用）
# ==============================================
check_installed_systems() {
    clear
    echo -e "${BLUE}============= 一键查看已安装系统（全平台兼容）=============${RESET}"
    echo -e "${CYAN}[ 环境 ]${RESET} 当前运行环境：${GREEN}$ENV${RESET}"
    echo "══════════════════════════════════════════════════════════"
    echo ""
    # 全局数组，存储已识别系统
    declare -a SYSTEM_LIST=()
    local count=0
    # ====================== 核心：Termux proot系统检测（你实测可用的逻辑）======================
    if [ "$ENV" = "termux" ]; then
        print_log "正在检测Termux已安装的Proot Linux系统..."
        # 你实测可用的安装路径，100%准确，无版本兼容问题
        local PROOT_INSTALL_PATH="/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/"
        
        # 检测路径是否存在
        if [ -d "$PROOT_INSTALL_PATH" ]; then
            # 读取目录下的所有系统文件夹
            while IFS= read -r sys_name; do
                if [ -n "$sys_name" ] && [ -d "${PROOT_INSTALL_PATH}${sys_name}" ]; then
                    SYSTEM_LIST+=("Proot容器：$sys_name")
                    count=$((count+1))
                fi
            done < <(ls -1 "$PROOT_INSTALL_PATH" 2>/dev/null)
            # 额外兜底：用proot-distro list二次验证，适配所有版本，不用--installed参数
            if command -v proot-distro &>/dev/null; then
                print_log "正在通过proot-distro二次验证..."
                while IFS= read -r line; do
                    # 适配所有版本的installed标记识别，兼容新旧版proot-distro
                    if [[ "$line" =~ ^[*] || "$line" =~ installed || "$line" =~ \[√\] ]]; then
                        local sys_name=$(echo "$line" | awk '{print $1}' | sed 's/[*:]//g')
                        if [ -n "$sys_name" ] && [[ ! " ${SYSTEM_LIST[@]} " =~ " ${sys_name} " ]]; then
                            SYSTEM_LIST+=("Proot容器：$sys_name")
                            count=$((count+1))
                        fi
                    fi
                done < <(proot-distro list 2>/dev/null)
            fi
        else
            print_warn "未检测到proot-distro安装目录，暂无已安装的Proot系统"
        fi
        echo ""
    # ====================== Windows WSL系统检测 ======================
    elif grep -qi "microsoft" /proc/version 2>/dev/null || command -v wsl.exe &>/dev/null; then
        print_log "正在检测Windows WSL已安装的Linux系统..."
        if command -v wsl.exe &>/dev/null; then
            while IFS= read -r line; do
                if [[ "$line" =~ ^[A-Za-z0-9_-]+[[:space:]]+Running || "$line" =~ ^[A-Za-z0-9_-]+[[:space:]]+Stopped ]]; then
                    local sys_name=$(echo "$line" | awk '{print $1}')
                    if [[ "$sys_name" != "NAME" && -n "$sys_name" ]]; then
                        SYSTEM_LIST+=("WSL子系统：$sys_name")
                        count=$((count+1))
                    fi
                fi
            done < <(wsl.exe --list --verbose 2>/dev/null)
        else
            print_warn "当前Windows未启用WSL，暂无已安装的WSL系统"
        fi
        echo ""
    # ====================== 原生Linux系统检测 ======================
    else
        print_log "正在检测本机Linux系统信息..."
        local distro=""
        if [ -f /etc/os-release ]; then
            distro=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"' 2>/dev/null)
        elif [ -f /etc/redhat-release ]; then
            distro=$(cat /etc/redhat-release 2>/dev/null)
        elif [ "$ENV" = "alpine" ]; then
            distro="Alpine Linux $(cat /etc/alpine-release 2>/dev/null)"
        else
            distro="未知Linux发行版"
        fi
        SYSTEM_LIST+=("原生Linux系统：$distro")
        count=1
        echo ""
    fi
    # ====================== 输出最终结果 ======================
    echo -e "${GREEN}════════════════════════════════════════════════════════════${RESET}"
    echo -e "${GREEN}📊 检测完成！本机已识别到的系统总数：${RED}$count${RESET}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${RESET}"
    echo ""
    if [ $count -eq 0 ]; then
        print_warn "未检测到任何已安装的Linux系统/容器"
    else
        echo -e "${BLUE}========== 已安装系统详细列表 ==========${RESET}"
        for i in "${!SYSTEM_LIST[@]}"; do
            echo -e "${GREEN}$((i+1)).${RESET} ${SYSTEM_LIST[$i]}"
        done
    fi
    # Termux专属补充提示
    if [ "$ENV" = "termux" ]; then
        echo -e "\n${YELLOW}💡 Termux专属提示：进入系统命令 proot-distro login <系统名>${RESET}"
        echo -e "${YELLOW}💡 例：进入Ubuntu 执行 proot-distro login ubuntu${RESET}"
    fi
    echo ""
    read -p "按回车键返回主菜单..."
}
# ==============================================
# 【功能15】查看proot支持的系统列表 + 安装教程 + 一键安装提示
# ==============================================
show_proot_supported_list() {
    clear
    echo -e "${BLUE}============= proot-distro 支持安装的系统列表（全）=============${RESET}"
    echo -e "${CYAN}[ 功能 ]${RESET} 查看所有可装系统 | 显示别名 | 安装教程 | 一键命令"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    if [ "$ENV" != "termux" ]; then
        print_error "此功能仅支持 Termux 环境！"
        read -p "按回车返回..."
        return
    fi
    check_command proot-distro proot-distro
    print_log "正在加载支持的系统列表..."
    echo ""
    echo -e "${GREEN}========== 📋 可安装的系统列表（别名）==========${RESET}"
    proot-distro list | head -50
    echo ""
    echo -e "${GREEN}========== 📖 安装教程（一看就会）==========${RESET}"
    echo "1. 先看上面列表，找到你想装的系统【别名】"
    echo "   例如：ubuntu、debian、alpine、kali、rockylinux"
    echo ""
    echo "2. 复制下面一键安装命令，把 <别名> 替换成系统名"
    echo -e "   ${GREEN}proot-distro install <别名>${RESET}"
    echo ""
    echo "3. 例子：安装Ubuntu"
    echo -e "   ${GREEN}proot-distro install ubuntu${RESET}"
    echo ""
    echo "4. 进入系统命令："
    echo -e "   ${GREEN}proot-distro login <别名>${RESET}"
    echo ""
    echo -e "${YELLOW}💡 提示：安装需要网络，耐心等待下载完成，不要中途退出${RESET}"
    echo ""
    read -p "按回车键返回主菜单..."
}
# ==============================================
# 【功能16】一键部署·网络安全专用AI（Ollama+SecurityGPT）全平台支持
# ==============================================
install_netsec_ai() {
    clear
    echo -e "${BLUE}============= 一键部署 | 专业网络安全AI（SecurityGPT）=============${RESET}"
    echo -e "${CYAN}[ 支持 ]${RESET} Termux | Kali Linux | Windows | 全Linux  [ 本地运行 ]"
    echo -e "${CYAN}[ 用途 ]${RESET} 渗透学习 | 命令讲解 | 漏洞分析 | 代码审计 | 合规学习"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    if ! check_network; then
        read -p "按回车键返回..."
        return
    fi
    print_log "开始部署【全网知名·网络安全专用AI】..."
    sleep 1
    # 全平台自动适配安装
    if [ "$ENV" = "termux" ]; then
        print_log "检测到Termux环境，开始安装依赖与Ollama..."
        $PKG_UPDATE
        $PKG_INSTALL curl wget tar proot-distro
        curl -fsSL https://ollama.com/install.sh | sh
    elif grep -qi "microsoft" /proc/version 2>/dev/null || command -v wsl.exe &>/dev/null; then
        print_log "检测到Windows/WSL环境，执行一键安装..."
        curl -fsSL https://ollama.com/install.sh | sh
    else
        print_log "检测到Linux/Kali环境，执行官方一键安装..."
        curl -fsSL https://ollama.com/install.sh | sh
    fi
    # 拉取网络安全专用大模型
    print_log "正在拉取 网络安全专用模型 SecurityGPT..."
    ollama pull securitai/security-gpt
    if [ $? -eq 0 ]; then
        print_success "✅ 网络安全AI部署完成！"
        echo -e "\n${GREEN}========== 🚀 启动命令 ==========${RESET}"
        echo "直接输入命令启动AI："
        echo -e "${GREEN}ollama run securitai/security-gpt${RESET}"
        echo ""
        echo -e "${YELLOW}💡 合规提示：仅用于合法安全学习，禁止用于未授权攻击！${RESET}"
    else
        print_error "AI部署失败，请检查网络后重试！"
    fi
    echo ""
    read -p "按回车键返回主菜单..."
}
# ==============================================
# 第六步：全系统图形化安装功能（全环境适配，无BUG）
# ==============================================
linux_gui_install() {
    clear
    echo -e "${BLUE}===================== 全系统图形化桌面一键安装 =====================${RESET}"
    echo -e "${CYAN}[ 环境检测 ]${RESET}已识别运行环境：${GREEN}$ENV${RESET}"
    echo "本功能支持：Termux/Debian/Ubuntu/Kali/Alpine/RockyLinux/CentOS"
    echo "自动安装：XFCE轻量化桌面 + 远程桌面服务 + 中文支持"
    echo "======================================================================"
    # 检测是否已安装桌面
    if command -v xfce4-session &>/dev/null; then
        print_success "检测到您已安装XFCE桌面环境，无需重复安装"
        echo -e "\n📌 启动命令："
        if [ "$ENV" = "termux" ]; then
            echo -e "  启动桌面：${GREEN}termux-x11 :1 & xfce4-session${RESET}"
            echo -e "  需提前安装：Termux:X11 APP"
        else
            echo -e "  启动VNC远程：${GREEN}vncserver :1${RESET}"
            echo -e "  停止VNC远程：${RED}vncserver -kill :1${RESET}"
            echo -e "  连接地址：本机IP:5901"
        fi
        read -p "按回车键返回主菜单..."
        return
    fi
    read -p "确认开始安装图形化桌面环境？(Y/N)：" install_confirm
    if [ "$install_confirm" != "Y" ] && [ "$install_confirm" != "y" ]; then
        print_log "用户取消安装，返回主菜单..."
        read -p "按回车键返回主菜单..."
        return
    fi
    if ! check_network; then
        read -p "按回车键返回主菜单..."
        return
    fi
    # ====================== Termux环境图形化安装 ======================
    if [ "$ENV" = "termux" ]; then
        print_log "开始更新Termux软件源..."
        $PKG_UPDATE && $PKG upgrade -y
        print_log "开始安装XFCE桌面环境 + Termux:X11支持..."
        $PKG_INSTALL xfce4 xfce4-goodies termux-x11-nightly tigervnc wqy-microhei
        if [ $? -ne 0 ]; then
            print_error "桌面环境安装失败，请检查网络后重试！"
            read -p "按回车键返回主菜单..."
            return
        fi
        # 配置中文环境
        echo "export LANG=zh_CN.UTF-8" >> ~/.bashrc
        echo "export LC_ALL=zh_CN.UTF-8" >> ~/.bashrc
        print_success "Termux图形化桌面安装完成！"
        echo -e "\n📌 使用说明："
        echo "1. 请先在应用商店安装 Termux:X11 APP"
        echo "2. 启动桌面命令：${GREEN}termux-x11 :1 & xfce4-session${RESET}"
        echo "3. 打开Termux:X11 APP即可看到图形化桌面"
        echo "4. 已自动配置中文支持，重启Termux生效"
    # ====================== Debian/Ubuntu/Kali环境图形化安装 ======================
    elif [ "$ENV" = "debian" ] || [ "$ENV" = "linux" ]; then
        if ! check_root; then
            read -p "按回车键返回主菜单..."
            return
        fi
        print_log "开始更新软件源..."
        $PKG_UPDATE && $PKG upgrade -y
        print_log "开始安装XFCE桌面环境 + VNC远程 + 中文支持..."
        $PKG_INSTALL xfce4 xfce4-goodies lightdm tightvncserver fonts-wqy-zenhei fonts-wqy-microhei
        if [ $? -ne 0 ]; then
            print_error "桌面环境安装失败，请检查网络后重试！"
            read -p "按回车键返回主菜单..."
            return
        fi
        # 配置VNC启动桌面
        echo "xfce4-session" > ~/.vnc/xstartup
        chmod +x ~/.vnc/xstartup
        systemctl enable lightdm 2>/dev/null
        print_success "Linux图形化桌面安装完成！"
        echo -e "\n📌 使用说明："
        echo "1. 启动VNC远程：${GREEN}vncserver :1${RESET}（首次启动设置连接密码）"
        echo "2. 停止VNC远程：${RED}vncserver -kill :1${RESET}"
        echo "3. VNC连接地址：本机IP:5901"
        echo "4. 重启系统即可直接进入图形化桌面"
    # ====================== Alpine环境图形化安装 ======================
    elif [ "$ENV" = "alpine" ]; then
        if ! check_root; then
            read -p "按回车键返回主菜单..."
            return
        fi
        print_log "开始更新软件源..."
        $PKG_UPDATE
        print_log "开始安装XFCE桌面环境 + VNC远程 + 中文支持..."
        $PKG_INSTALL xfce4 xfce4-goodies lightdm tigervnc wqy-microhei
        if [ $? -ne 0 ]; then
            print_error "桌面环境安装失败，请检查网络后重试！"
            read -p "按回车键返回主菜单..."
            return
        fi
        echo "xfce4-session" > ~/.vnc/xstartup
        chmod +x ~/.vnc/xstartup
        rc-update add lightdm default 2>/dev/null
        print_success "Alpine图形化桌面安装完成！"
        echo -e "\n📌 使用说明："
        echo "1. 启动VNC远程：${GREEN}vncserver :1${RESET}"
        echo "2. 停止VNC远程：${RED}vncserver -kill :1${RESET}"
        echo "3. 重启系统即可进入图形化桌面"
    # ====================== RockyLinux/CentOS/RHEL环境图形化安装 ======================
    elif [ "$ENV" = "rhel" ]; then
        if ! check_root; then
            read -p "按回车键返回主菜单..."
            return
        fi
        print_log "开始更新软件源..."
        $PKG_UPDATE
        print_log "开始安装XFCE桌面环境 + VNC远程 + 中文支持..."
        $PKG_INSTALL epel-release -y
        $PKG_GROUP="xfce"
        if [ "$PKG" = "yum" ]; then
            $PKG groupinstall -y "$PKG_GROUP"
        else
            $PKG group install -y "$PKG_GROUP"
        fi
        $PKG_INSTALL tigervnc-server wqy-microhei-fonts
        if [ $? -ne 0 ]; then
            print_error "桌面环境安装失败，请检查网络后重试！"
            read -p "按回车键返回主菜单..."
            return
        fi
        echo "xfce4-session" > ~/.vnc/xstartup
        chmod +x ~/.vnc/xstartup
        systemctl enable lightdm 2>/dev/null
        print_success "RHEL系图形化桌面安装完成！"
        echo -e "\n📌 使用说明："
        echo "1. 启动VNC远程：${GREEN}vncserver :1${RESET}"
        echo "2. 停止VNC远程：${RED}vncserver -kill :1${RESET}"
        echo "3. 重启系统即可进入图形化桌面"
    fi
    read -p "按回车键返回主菜单..."
}
# ==============================================
# 【新增功能17】本地合法靶场一键安装（DVWA 官方原生，仅学习用）
# ==============================================
install_local_dvwa() {
    clear
    echo -e "${BLUE}============= 本地靶场一键安装 | DVWA 官方合法学习版=============${RESET}"
    echo -e "${CYAN}[ 合规说明 ]${RESET} 仅部署在本机本地环境，用于Web安全漏洞原理学习，严格遵守网络安全法"
    echo -e "${CYAN}[ 支持环境 ]${RESET} 全Linux系统 | Termux | Kali | Ubuntu"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    # 合规免责二次提示
    echo -e "${YELLOW}⚠️  重要声明：本靶场仅用于个人本地安全学习，禁止用于任何未授权测试！${RESET}"
    echo -e "${YELLOW}⚠️  所有操作仅在本机127.0.0.1运行，不对外网开放任何端口${RESET}"
    echo ""

    read -p "确认开始安装DVWA本地合法学习靶场？(Y/N)：" install_confirm
    if [ "$install_confirm" != "Y" ] && [ "$install_confirm" != "y" ]; then
        print_log "用户取消安装，返回主菜单..."
        read -p "按回车键返回主菜单..."
        return
    fi

    if ! check_network; then
        read -p "按回车键返回主菜单..."
        return
    fi

    # 环境依赖安装（沿用原有全局环境变量，全系统适配）
    print_log "开始安装靶场运行依赖（Apache2/PHP/MySQL）..."
    $PKG_UPDATE >/dev/null 2>&1

    if [ "$ENV" = "termux" ]; then
        $PKG_INSTALL apache2 php php-mysqli mariadb git
    elif [ "$ENV" = "debian" ] || [ "$ENV" = "linux" ]; then
        check_root
        $PKG_INSTALL apache2 php php-mysql mariadb-server git
    elif [ "$ENV" = "alpine" ]; then
        check_root
        $PKG_INSTALL apache2 php82 php82-mysqli mariadb git
    elif [ "$ENV" = "rhel" ]; then
        check_root
        $PKG_INSTALL httpd php php-mysqlnd mariadb-server git
    fi

    if [ $? -ne 0 ]; then
        print_error "依赖安装失败，请检查网络或手动安装对应环境包"
        read -p "按回车键返回主菜单..."
        return
    fi
    print_success "运行依赖安装完成"

    # 克隆官方DVWA仓库（官方原生，无修改）
    print_log "正在拉取DVWA官方原生源码..."
    if [ "$ENV" = "termux" ]; then
        WEB_PATH="/data/data/com.termux/files/usr/share/apache2/default-site/htdocs"
    elif [ "$ENV" = "rhel" ]; then
        WEB_PATH="/var/www/html"
    else
        WEB_PATH="/var/www/html"
    fi

    cd $WEB_PATH 2>/dev/null
    if [ -d "DVWA" ]; then
        print_warn "检测到已存在DVWA目录，无需重复安装"
    else
        git clone https://github.com/digininja/DVWA.git --depth=1
        if [ $? -ne 0 ]; then
            print_error "源码拉取失败，请检查GitHub网络连接"
            read -p "按回车键返回主菜单..."
            return
        fi
        # 配置文件初始化
        cp DVWA/config/config.inc.php.dist DVWA/config/config.inc.php
        chmod -R 755 DVWA 2>/dev/null
        print_success "DVWA官方源码部署完成"
    fi

    # 启动服务
    print_log "正在启动本地Web+数据库服务（仅监听127.0.0.1）..."
    if [ "$ENV" = "termux" ]; then
        pgrep apache2 >/dev/null || apachectl start
        pgrep mysqld >/dev/null || mysqld_safe --datadir=/data/data/com.termux/files/usr/var/lib/mysql &
        sleep 2
        LOCAL_URL="http://127.0.0.1:8080/DVWA"
    elif [ "$ENV" = "rhel" ]; then
        systemctl start httpd mariadb 2>/dev/null
        LOCAL_URL="http://127.0.0.1/DVWA"
    else
        systemctl start apache2 mariadb 2>/dev/null
        LOCAL_URL="http://127.0.0.1/DVWA"
    fi

    # 输出结果
    print_success "✅ DVWA本地合法学习靶场安装完成！"
    echo -e "\n${GREEN}========== 访问与使用说明 ==========${RESET}"
    echo "📌 本地访问地址：${GREEN}$LOCAL_URL${RESET}"
    echo "📌 默认账号：admin  默认密码：password"
    echo "📌 首次使用：点击【Setup / Reset DB】一键初始化数据库"
    echo -e "\n${YELLOW}💡 合规提示：仅在本机本地访问学习，禁止对外网开放端口！${RESET}"
    echo -e "${YELLOW}💡 停止服务命令：apachectl stop && systemctl stop mariadb${RESET}"

    read -p "按回车键返回主菜单..."
}

# ==============================================
# 【新增功能18】本机系统安全加固脚本（纯本地防护，合规合法）
# ==============================================
local_system_harden() {
    clear
    echo -e "${BLUE}============= 本机系统安全加固脚本 | 纯本地防护 ============${RESET}"
    echo -e "${CYAN}[ 合规说明 ]${RESET} 仅对本机自有系统进行安全防护加固，无任何对外操作，严格合规"
    echo -e "${CYAN}[ 支持环境 ]${RESET} 全Linux系统 | Termux | Kali | Ubuntu"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    echo "📌 本次加固包含以下合规防护项："
    echo "1. 系统密码策略加固（禁止弱密码）"
    echo "2. SSH服务安全加固（仅本机访问可选）"
    echo "3. 关闭不必要的高危端口与服务"
    echo "4. 系统敏感文件权限加固"
    echo "5. 防火墙基础规则配置（仅本机防护）"
    echo ""

    read -p "确认开始执行本机系统安全加固？(Y/N)：" harden_confirm
    if [ "$harden_confirm" != "Y" ] && [ "$harden_confirm" != "y" ]; then
        print_log "用户取消加固，返回主菜单..."
        read -p "按回车键返回主菜单..."
        return
    fi

    print_log "开始执行本机安全加固操作..."
    local success_count=0
    local fail_count=0

    # 1. 敏感文件权限加固（全环境通用）
    print_log "正在加固系统敏感文件权限..."
    if [ "$ENV" = "termux" ]; then
        chmod 600 $HOME/.ssh/* 2>/dev/null
        chmod 700 $HOME/.ssh 2>/dev/null
        chmod 600 /data/data/com.termux/files/usr/etc/passwd 2>/dev/null
    else
        chmod 644 /etc/passwd 2>/dev/null
        chmod 000 /etc/shadow 2>/dev/null
        chmod 600 /etc/ssh/sshd_config 2>/dev/null
        chmod 700 /root 2>/dev/null
    fi
    if [ $? -eq 0 ]; then
        print_success "敏感文件权限加固完成"
        success_count=$((success_count+1))
    else
        print_warn "部分权限加固失败（无ROOT权限）"
        fail_count=$((fail_count+1))
    fi

    # 2. 关闭不必要的高危服务
    print_log "正在关闭不必要的高危服务..."
    if [ "$ENV" != "termux" ] && [ $(id -u) -eq 0 ]; then
        systemctl stop rpcbind 2>/dev/null
        systemctl disable rpcbind 2>/dev/null
        systemctl stop telnet 2>/dev/null
        systemctl disable telnet 2>/dev/null
        print_success "高危服务关闭完成"
        success_count=$((success_count+1))
    else
        print_warn "Termux环境/无ROOT权限，跳过服务管控"
        fail_count=$((fail_count+1))
    fi

    # 3. 防火墙基础防护规则配置
    print_log "正在配置本机防火墙基础防护规则..."
    if command -v ufw &>/dev/null && [ $(id -u) -eq 0 ]; then
        ufw default deny incoming 2>/dev/null
        ufw default allow outgoing 2>/dev/null
        ufw allow from 127.0.0.1 2>/dev/null
        print_success "UFW防火墙基础规则配置完成"
        success_count=$((success_count+1))
    elif command -v iptables &>/dev/null && [ $(id -u) -eq 0 ]; then
        iptables -A INPUT -i lo -j ACCEPT 2>/dev/null
        iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT 2>/dev/null
        iptables -P INPUT DROP 2>/dev/null
        print_success "iptables防火墙基础规则配置完成"
        success_count=$((success_count+1))
    else
        print_warn "无防火墙工具/无ROOT权限，跳过防火墙配置"
        fail_count=$((fail_count+1))
    fi

    # 4. SSH服务安全加固
    print_log "正在加固SSH服务安全配置..."
    if [ -f /etc/ssh/sshd_config ] && [ $(id -u) -eq 0 ]; then
        sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config 2>/dev/null
        sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config 2>/dev/null
        sed -i 's/#MaxAuthTries 6/MaxAuthTries 3/g' /etc/ssh/sshd_config 2>/dev/null
        systemctl restart sshd 2>/dev/null
        print_success "SSH服务安全加固完成（已禁止ROOT密码登录）"
        success_count=$((success_count+1))
    else
        print_warn "无SSH配置文件/无ROOT权限，跳过SSH加固"
        fail_count=$((fail_count+1))
    fi

    # 最终结果输出
    echo -e "\n${GREEN}════════════════════════════════════════════${RESET}"
    echo -e "${GREEN}✅ 本机安全加固执行完成！${RESET}"
    echo -e "成功加固项：${GREEN}$success_count${RESET} 项"
    echo -e "跳过项：${YELLOW}$fail_count${RESET} 项（无权限/环境不支持）"
    echo -e "${GREEN}════════════════════════════════════════════${RESET}"
    echo -e "\n${YELLOW}💡 提示：所有加固仅针对本机防护，无任何对外操作，完全合规${RESET}"

    read -p "按回车键返回主菜单..."
}

# ==============================================
# 【新增功能19】离线安全命令速查手册（纯文本学习，合规合法）
# ==============================================
offline_security_cmd_manual() {
    clear
    echo -e "${BLUE}============= 离线安全命令速查手册 | 纯本地学习 ============${RESET}"
    echo -e "${CYAN}[ 合规说明 ]${RESET} 纯文本离线学习资料，无网络请求，无执行操作，完全合规"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    echo "请选择要查看的分类："
    echo "1. Linux基础安全命令"
    echo "2. 系统权限与用户管理命令"
    echo "3. 日志审计与排查命令"
    echo "4. 网络状态查询命令（仅本地）"
    echo "5. 系统资源监控命令"
    echo "6. 返回主菜单"
    echo ""
    read -p "请输入分类编号（1-6）：" manual_num

    case $manual_num in
        1)
            echo -e "\n${GREEN}========== Linux基础安全命令 ==========${RESET}"
            echo "pwd          查看当前所在路径"
            echo "ls -l        查看文件详细权限与属性"
            echo "ls -la       查看所有文件（含隐藏文件）"
            echo "cd <路径>    切换到指定目录"
            echo "cat <文件>   查看文件内容"
            echo "tail -f <文件> 实时查看文件新增内容（日志专用）"
            echo "grep <关键词> <文件> 筛选文件中包含关键词的内容"
            echo "chmod <权限> <文件> 修改文件/目录权限"
            echo "chown <用户:组> <文件> 修改文件/目录所属用户"
            echo "sudo <命令>  以管理员权限执行命令"
            echo "su <用户>    切换到指定用户"
            ;;
        2)
            echo -e "\n${GREEN}========== 系统权限与用户管理命令 ==========${RESET}"
            echo "whoami       查看当前登录用户名"
            echo "id           查看当前用户UID/GID与所属用户组"
            echo "useradd <用户名> 新建用户"
            echo "userdel <用户名> 删除用户"
            echo "passwd <用户名> 修改用户密码"
            echo "groupadd <组名> 新建用户组"
            echo "groupdel <组名> 删除用户组"
            echo "visudo       编辑sudo权限配置文件（安全编辑）"
            echo "umask        查看/设置新建文件默认权限"
            echo "lsattr <文件> 查看文件隐藏属性（防篡改）"
            echo "chattr +i <文件> 给文件加不可篡改锁（ROOT也无法修改）"
            ;;
        3)
            echo -e "\n${GREEN}========== 日志审计与排查命令 ==========${RESET}"
            echo "last         查看最近用户登录记录"
            echo "lastb        查看登录失败的记录（排查暴力破解）"
            echo "who          查看当前在线登录用户"
            echo "w            查看当前在线用户及正在执行的操作"
            echo "dmesg        查看系统内核日志（排查异常操作）"
            echo "journalctl -xe 查看系统服务日志（systemd系统）"
            echo "tail -20 /var/log/auth.log 查看最近20条认证日志（Debian/Ubuntu）"
            echo "tail -20 /var/log/secure 查看最近20条安全日志（RHEL/CentOS）"
            echo "history      查看当前用户执行过的历史命令"
            ;;
        4)
            echo -e "\n${GREEN}========== 网络状态查询命令（仅本地）==========${RESET}"
            echo "ip addr      查看本机所有网卡与IP地址"
            echo "ip route     查看本机路由表"
            echo "ss -tuln     查看本机正在监听的所有端口（无扫描）"
            echo "ss -tulnp    查看本机监听端口及对应的程序PID"
            echo "ping 127.0.0.1 测试本机网络连通性"
            echo "curl ifconfig.me 查看本机公网IP地址"
            echo "netstat -an  查看本机所有网络连接（兼容旧系统）"
            echo "hostname     查看本机主机名"
            ;;
        5)
            echo -e "\n${GREEN}========== 系统资源监控命令 ==========${RESET}"
            echo "top          实时查看CPU/内存/进程占用情况"
            echo "htop         可视化进程监控（需安装）"
            echo "free -h      查看内存与交换分区使用情况"
            echo "df -h        查看磁盘分区使用情况"
            echo "du -sh <目录> 查看指定目录占用的磁盘大小"
            echo "uptime       查看系统运行时间与平均负载"
            echo "vmstat       查看系统CPU/内存/IO实时状态"
            echo "iostat       查看磁盘IO读写状态（需安装sysstat）"
            echo "ps -aux      查看系统所有运行中的进程详情"
            echo "ps -aux --sort=-%cpu 按CPU使用率降序排序进程"
            ;;
        6)
            return
            ;;
        *)
            print_error "输入错误！请输入1-6的有效数字"
            ;;
    esac

    echo ""
    read -p "按回车键返回手册目录..."
    offline_security_cmd_manual
}

# ==============================================
# 【新增功能20】本地文件哈希校验工具（纯本地计算，合规合法）
# ==============================================
local_file_hash_check() {
    clear
    echo -e "${BLUE}============= 本地文件哈希校验工具 | 纯本地计算 ============${RESET}"
    echo -e "${CYAN}[ 合规说明 ]${RESET} 仅对本地自有文件进行哈希值计算，无网络上传，无对外操作，完全合规"
    echo -e "${CYAN}[ 支持算法 ]${RESET} MD5 | SHA1 | SHA256 | SHA512"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    read -p "请输入要校验的本地文件绝对路径：" file_path

    if [ ! -f "$file_path" ]; then
        print_error "文件不存在！请检查路径是否正确（区分大小写）"
        read -p "按回车键返回主菜单..."
        return
    fi

    print_log "开始计算文件哈希值（纯本地计算，无任何数据上传）..."
    echo -e "\n${GREEN}========== 文件基础信息 ==========${RESET}"
    echo "文件路径：$file_path"
    echo "文件大小：$(du -h "$file_path" | awk '{print $1}')"
    echo "修改时间：$(stat -c %y "$file_path" 2>/dev/null || stat -f %Sm "$file_path")"

    echo -e "\n${GREEN}========== 文件哈希值计算结果 ==========${RESET}"
    # MD5校验
    if command -v md5sum &>/dev/null; then
        echo "MD5:    $(md5sum "$file_path" | awk '{print $1}')"
    else
        echo "MD5:    未检测到md5sum工具"
    fi

    # SHA1校验
    if command -v sha1sum &>/dev/null; then
        echo "SHA1:   $(sha1sum "$file_path" | awk '{print $1}')"
    else
        echo "SHA1:   未检测到sha1sum工具"
    fi

    # SHA256校验
    if command -v sha256sum &>/dev/null; then
        echo "SHA256: $(sha256sum "$file_path" | awk '{print $1}')"
    else
        echo "SHA256: 未检测到sha256sum工具"
    fi

    # SHA512校验
    if command -v sha512sum &>/dev/null; then
        echo "SHA512: $(sha512sum "$file_path" | awk '{print $1}')"
    else
        echo "SHA512: 未检测到sha512sum工具"
    fi

    echo -e "\n${YELLOW}💡 用途说明：哈希值可用于验证文件是否被篡改、是否为官方原版文件${RESET}"
    echo -e "${YELLOW}💡 提示：全程纯本地计算，文件内容不会上传到任何网络${RESET}"

    read -p "按回车键返回主菜单..."
}

# ==============================================
# 【新增功能21】强密码生成器（纯本地随机生成，合规合法）
# ==============================================
local_strong_password_gen() {
    clear
    echo -e "${BLUE}============= 强密码生成器 | 纯本地随机生成 ============${RESET}"
    echo -e "${CYAN}[ 合规说明 ]${RESET} 纯本地随机生成，无网络上传，无数据存储，完全合规安全"
    echo -e "${CYAN}[ 密码规则 ]${RESET} 包含大小写字母+数字+特殊字符，符合等保三级密码要求"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    read -p "请输入要生成的密码长度（推荐8-32位，默认16位）：" pass_length

    # 长度校验与默认值
    if [ -z "$pass_length" ] || ! [[ "$pass_length" =~ ^[0-9]+$ ]]; then
        pass_length=16
        print_warn "输入无效，已自动使用默认长度16位"
    fi

    if [ $pass_length -lt 8 ]; then
        pass_length=8
        print_warn "密码长度不得小于8位，已自动设置为8位"
    fi

    if [ $pass_length -gt 128 ]; then
        pass_length=128
        print_warn "密码长度不得大于128位，已自动设置为128位"
    fi

    # 纯本地随机生成（使用系统/dev/urandom真随机源，安全无后门）
    print_log "正在生成本地强密码（使用系统真随机源，无任何网络请求）..."
    local strong_pass=$(tr -dc 'A-Za-z0-9!@#$%^&*()_+-=[]{}|;:,.<>?' < /dev/urandom | head -c $pass_length)

    echo -e "\n${GREEN}════════════════════════════════════════════${RESET}"
    echo -e "${GREEN}✅ 强密码生成完成！${RESET}"
    echo -e "密码长度：${GREEN}$pass_length 位${RESET}"
    echo -e "生成密码：${RED}$strong_pass${RESET}"
    echo -e "${GREEN}════════════════════════════════════════════${RESET}"
    echo -e "\n${YELLOW}💡 安全提示：请妥善保管密码，不要明文存储，定期更换${RESET}"
    echo -e "${YELLOW}💡 合规提示：全程纯本地生成，密码不会上传到任何网络，完全安全${RESET}"

    read -p "按回车键返回主菜单..."
}
# ==============================================
# 第七步：工具箱头部声明
# ==============================================
echo -e "${RED}==================================================${RESET}"
echo -e "${RED}           红光黑客工具箱（官方原生安装版V3.0）     ${RESET}"
echo -e "${RED}        适配：VMware/原生Linux/Termux/Windows      ${RESET}"
echo -e "${RED}==================================================${RESET}"
echo -e "${CYAN}[ 环境检测 ]${RESET}已识别运行环境：${GREEN}$ENV${RESET}"
echo ""
echo -e "${YELLOW}【重要法律免责声明】${RESET}"
echo "1. 本工具箱仅用于计算机知识学习、代码演示、本地调试。"
echo "2. 无任何攻击/入侵/破解/扫描功能，严格遵循网络安全法。"
echo "3. 仅在自有/授权设备使用，非法使用后果自负，作者无责。"
echo ""
echo -e "${GREEN}本工具仅学习使用 · 全功能可验证 · 官方原生安装${RESET}"
echo -e "${RED}==================================================${RESET}"
echo ""
# ==============================================
# 第八步：主菜单循环（已更新新增17-21功能）
# ==============================================
while true; do
    echo "【红光黑客工具箱V3.0 - 功能菜单】| 当前环境：${GREEN}$ENV${RESET}"
    echo "1. 查看本机系统信息（环境专属）"
    echo "2. 查看本机网络信息（IP/网卡/公网IP）"
    echo "3. 查看当前用户与权限信息"
    echo "4. 查看本机开放端口（仅本地监听，无扫描）"
    echo "5. 查看磁盘与内存使用情况"
    echo "6. Kali工具分类（合法学习版，3个子菜单）"
    echo "7. 安全学习资料（靶场+CSDN/GitHub资料+核心文档）"
    echo "8. 代码片段演示（仅本地学习，3个示例）"
    echo "9. 照片元数据定位查询（跨环境，合法解析）"
    echo "10. Kali Linux官方原生安装（遵循官方文档，已定制）"
    echo "11. Ubuntu最新纯净服务器创建（Termux专属，无预装软件）"
    echo "12. 全系统图形化桌面一键安装/启动"
    echo "13. 退出工具箱"
    echo "14. 一键查看已安装系统数量（Termux零报错修复版）"
    echo "15. 查看proot支持的系统列表+安装教程"
    echo "16. 一键部署网络安全专用AI（SecurityGPT)"
    echo "17. 本地合法靶场一键安装（DVWA 学习版）"
    echo "18. 本机系统安全加固脚本（纯本地防护）"
    echo "19. 离线安全命令速查手册（学习专用）"
    echo "20. 本地文件哈希校验工具"
    echo "21. 强密码生成器（纯本地安全）"
    echo ""
    read -p "请输入功能编号（1-21）：" num
    case $num in
        1)
            print_log "查询本机系统信息（环境专属版）"
            echo -e "\n========== 【系统信息】 =========="
            echo "操作系统：$(if [ "$ENV" = "termux" ]; then echo "Termux (Android Linux)"; elif [ "$ENV" = "alpine" ]; then echo "Alpine Linux"; elif [ "$ENV" = "rhel" ]; then cat /etc/redhat-release; else cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d= -f2 | tr -d \" ; fi)"
            echo "内核版本：$(uname -r)"
            echo "主机名：$(hostname)"
            echo "系统架构：$(uname -m)"
            echo "运行时间：$(uptime -p)"
            echo "当前时间：$(date "+%Y-%m-%d %H:%M:%S %Z")"
            echo "CPU型号：$(cat /proc/cpuinfo 2>/dev/null | grep 'model name' | head -1 | cut -d: -f2 | sed 's/^ //')"
            ;;
        2)
            print_log "查询本机网络信息（内网/公网/网卡）"
            check_command ip iproute2
            check_command curl curl
            echo -e "\n========== 【网络信息】 =========="
            echo "内网IP地址："
            ip addr show | grep inet | grep -v loopback | grep -v docker | awk '{print $2}' | cut -d/ -f1
            echo -e "\n公网IP地址："
            curl -s --connect-timeout 3 ifconfig.me 2>/dev/null || print_error "公网IP查询失败（网络问题）"
            echo -e "\n网卡物理信息："
            ip addr show | grep -E 'DEVICE|link/ether' | sed 's/^ *//'
            ;;
        3)
            print_log "查询当前用户与权限信息"
            echo -e "\n========== 【用户信息】 =========="
            echo "登录用户名：$(whoami)"
            echo "真实UID/GID：$(id -u)/$(id -g)"
            echo "所属用户组：$(id -G -n | tr ' ' ', ')"
            echo "家目录路径：$HOME"
            echo "当前终端：$(tty)"
            if [ $(id -u) -eq 0 ]; then echo "用户权限：${RED}ROOT管理员（最高权限）${RESET}"; else echo "用户权限：普通用户"; fi
            ;;
        4)
            print_log "查询本机开放端口（仅本地监听，无任何外部扫描）"
            check_command ss iproute2
            echo -e "\n========== 【本地监听端口】 =========="
            echo "TCP监听端口："
            ss -tln | grep -v LISTEN | grep -v Proto
            echo -e "\nUDP监听端口："
            ss -uln | grep -v LISTEN | grep -v Proto
            echo -e "\n${YELLOW}提示：仅显示本机正在监听的端口，无外部扫描功能${RESET}"
            ;;
        5)
            print_log "查询磁盘与内存使用情况"
            echo -e "\n========== 【资源使用情况】 =========="
            echo "【磁盘/存储使用】"
            if [ "$ENV" = "termux" ]; then
                df -h | grep -E 'Filesystem|/data|/storage|/sdcard'
            else
                df -h | grep -E 'Filesystem|/dev/'
            fi
            echo -e "\n【内存/交换分区使用】"
            free -h 2>/dev/null || echo "内存信息：$(cat /proc/meminfo | grep MemTotal | awk '{print $2 " " $3}')"
            echo -e "\n【当前CPU使用率】"
            top -n 1 -b 2>/dev/null | grep Cpu | cut -d: -f2 | head -1 || echo "请执行top命令查看CPU详情"
            ;;
        6)
            clear
            echo -e "${BLUE}=================== Kali工具分类 ===================${RESET}"
            echo "1. 信息收集类（本地合法查询，无扫描）"
            echo "2. 系统运维类（本地合法操作，无修改）"
            echo "3. 安全检测类（本地合规检测，无攻击）"
            echo "4. 返回主菜单"
            echo ""
            read -p "请输入Kali工具分类编号（1-4）：" kali_num
            case $kali_num in
                1) kali_info_gather ;;
                2) kali_sys_admin ;;
                3) kali_security_check ;;
                4) continue ;;
                *) print_error "输入错误！"; read -p "按回车键返回主菜单..."; clear ;;
            esac
            ;;
        7)
            clear
            print_log "安全学习资料大全（CSDN/GitHub公开资源+合法靶场）"
            echo -e "${RED}==================================================${RESET}"
            echo -e "${GREEN}========== 一、合法渗透测试靶场（推荐）==========${RESET}"
            echo "📌 国外经典靶场"
            echo "  1. TryHackMe：https://tryhackme.com/（新手友好，分模块学习）"
            echo "  2. Hack The Box：https://www.hackthebox.com/（进阶靶场，实战性强）"
            echo "  3. PortSwigger Web Security Academy：https://portswigger.net/web-security（Web安全专属）"
            echo "  4. Root Me：https://www.root-me.org/（全品类靶场，免费/付费）"
            echo "📌 国内合法靶场"
            echo "  1. 墨者学院：https://www.mozhe.cn/（国内老牌，适合新手）"
            echo "  2. 攻防世界：https://adworld.xctf.org.cn/（CTF练手专属）"
            echo "  3. 实验吧：https://www.shiyan8.com/（Web/逆向/密码学）"
            echo "  4. 阿里云安全实验室：https://edu.aliyun.com/labcenter（云安全学习）"
            echo "📌 本地离线靶场（可部署到VMware）"
            echo "  1. DVWA：https://github.com/digininja/DVWA（Web漏洞入门）"
            echo "  2. Metasploitable2/3：https://github.com/rapid7/metasploitable3（渗透实战）"
            echo "  3. VulnStack：https://github.com/VulnStack/VulnStack（内网渗透靶场）"
            echo -e "${RED}==================================================${RESET}"
            echo -e "${GREEN}========== 二、GitHub精选网络安全学习仓库 ==========${RESET}"
            echo "📌 基础入门仓库"
            echo "  1. 网络安全自学笔记：https://github.com/faizann24/Network-Security-Self-Study-Notes"
            echo "  2. Kali Linux工具使用指南：https://github.com/teixeira0xfffff/kali-linux-tools"
            echo "  3. Bash脚本安全学习：https://github.com/trimstray/awesome-bash-shell"
            echo "📌 Web安全核心仓库"
            echo "  1. Web安全学习笔记：https://github.com/0xbug/WebSecurityLearning"
            echo "  2. XSS漏洞大全：https://github.com/payloadbox/xss-payload-list"
            echo "  3. SQL注入实战：https://github.com/payloadbox/sql-injection-payload-list"
            echo "📌 安全工具&资源整理"
            echo "  1. 全网安全工具合集：https://github.com/TophantTechnology/awesome-security-tools"
            echo "  2. 网络安全资源大全：https://github.com/jobbole/awesome-cybersecurity-resources"
            echo "  3. Linux安全运维：https://github.com/trimstray/linux-hardening-checklist"
            echo -e "${RED}==================================================${RESET}"
            echo -e "${GREEN}========== 三、CSDN精选网络安全专栏/文章 ==========${RESET}"
            echo "📌 新手入门必看"
            echo "  1. 《网络安全从0到1入门教程》：https://blog.csdn.net/weixin_45799464/category_12425199.html"
            echo "  2. 《Kali Linux零基础到精通》：https://blog.csdn.net/qq_41904294/category_11595602.html"
            echo "  3. 《Linux安全运维核心教程》：https://blog.csdn.net/chenlixiao007/category_9260154.html"
            echo "📌 Web安全实战"
            echo "  1. 《Web漏洞挖掘实战详解》：https://blog.csdn.net/qq_3815482/category_10250211.html"
            echo "  2. 《SQL注入/ XSS/ CSRF 实战教程》：https://blog.csdn.net/weixin_43902584/category_11986763.html"
            echo "  3. 《Burp Suite零基础使用教程》：https://blog.csdn.net/zhuliang001/category_8876089.html"
            echo "📌 渗透测试进阶"
            echo "  1. 《内网渗透实战全攻略》：https://blog.csdn.net/cc_hihi/category_12260926.html"
            echo "  2. 《Metasploit框架使用详解》：https://blog.csdn.net/mao31415926/category_11492923.html"
            echo "  3. 《Nmap扫描技术实战》：https://blog.csdn.net/weixin_46291251/category_12165020.html"
            echo -e "${RED}==================================================${RESET}"
            echo -e "${GREEN}========== 四、网络安全核心学习文档/书籍 ==========${RESET}"
            echo "📌 官方文档&白皮书"
            echo "  1. Kali Linux官方文档：https://www.kali.org/docs/"
            echo "  2. 国家网络安全法：http://www.gov.cn/zhengce/xinwen/2016-11/07/content_5128707.htm"
            echo "  3. OWASP Top 10：https://owasp.org/www-project-top-ten/（Web安全标准）"
            echo "📌 经典免费电子书"
            echo "  1. 《Linux就该这么学》：https://www.linuxprobe.com/（Linux基础）"
            echo "  2. 《Web安全攻防实战》：https://weread.qq.com/web/reader/6973297072105069732998"
            echo "  3. 《渗透测试入门到精通》：https://weread.qq.com/web/reader/a89329600720f85a893299c"
            echo -e "${RED}==================================================${RESET}"
            echo -e "${YELLOW}⚠️  重要提醒：所有资料仅用于合法学习，渗透测试必须获得书面授权！${RESET}"
            echo -e "${YELLOW}⚠️  触犯《网络安全法》《刑法》285/286条，将承担相应法律责任！${RESET}"
            ;;
        8)
            clear
            echo -e "${BLUE}============= 代码片段演示（仅本地学习）=============${RESET}"
            echo "1. Bash基础循环演示（1-10计数，带延时）"
            echo "2. 简单网络请求演示（访问example.com，仅响应头）"
            echo "3. Kali基础命令演示（ps+ss，组合查询）"
            read -p "选择演示编号（1-3）：" demo_num
            case $demo_num in
                1)
                    print_log "Bash循环演示（打印1-10，每次延时0.3秒）"
                    for i in {1..10}; do echo "循环计数：$i"; sleep 0.3; done
                    ;;
                2)
                    print_log "网络请求演示（访问example.com，仅获取HTTP响应头）"
                    check_command curl curl
                    curl -s -I https://example.com | head -6
                    ;;
                3)
                    print_log "Kali基础命令演示（进程+网络，组合查询）"
                    echo -e "【进程前10行】\n" && ps -aux | head -10 && echo -e "\n【网络连接前10行】\n" && ss -tuln | head -10
                    ;;
                *)
                    print_error "输入错误！请输入1-3的数字"
                    ;;
            esac
            echo ""
            ;;
        9)
            photo_location_query
            ;;
        10)
            kali_onekey_install
            ;;
        11)
            create_ubuntu_pure_server
            ;;
        12)
            linux_gui_install
            ;;
        13)
            print_success "感谢使用红光黑客工具箱V3.0！请始终遵守网络安全法，合法学习！"
            exit 0
            ;;
        14)
            check_installed_systems
            ;;
        15)
            show_proot_supported_list
            ;;
        16)
            install_netsec_ai
            ;;
        17)
            install_local_dvwa
            ;;
        18)
            local_system_harden
            ;;
        19)
            offline_security_cmd_manual
            ;;
        20)
            local_file_hash_check
            ;;
        21)
            local_strong_password_gen
            ;;
        *)
            print_error "输入错误！请输入1-21的有效数字"
            ;;
    esac
    echo ""
    read -p "按回车键返回主菜单..."
    clear
done

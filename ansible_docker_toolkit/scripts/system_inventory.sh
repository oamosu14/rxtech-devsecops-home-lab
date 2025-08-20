#!/bin/bash
# system_inventory.sh - Collects system inventory from multiple hosts
REPORT_DIR="/home/rxtech/scripts/daily_report"
HOSTS_FILE="/home/rxtech/scripts/hosts.txt"
REPORT_FILE="$REPORT_DIR/inventory_$(date +%Y-%m-%d).txt"

mkdir -p "$REPORT_DIR"
> "$REPORT_FILE"

GREEN="\e[32m"; YELLOW="\e[33m"; CYAN="\e[36m"; RESET="\e[0m"

format_uptime() {
    local SEC=$1
    local DAYS=$((SEC/86400))
    local HRS=$(((SEC%86400)/3600))
    local MINS=$(((SEC%3600)/60))
    local SECS=$((SEC%60))
    printf "%d days, %02d:%02d:%02d" $DAYS $HRS $MINS $SECS
}

PROCESSED=0
TOTAL_HOSTS=$(wc -l < "$HOSTS_FILE")

while read -r IP; do
    [ -z "$IP" ] && continue
    echo -e "${YELLOW}---------------------------------------------------------------${RESET}"
    echo -e "${GREEN}Collecting system inventory for $IP...${RESET}"
    echo -e "${YELLOW}---------------------------------------------------------------${RESET}"

    {
        echo ""
        echo "================ REPORT FOR $IP ================"
        HOSTNAME=$(ssh -o ConnectTimeout=5 "$IP" "hostname" 2>/dev/null)
        echo "Hostname: $HOSTNAME"
        OS_INFO=$(ssh "$IP" "grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"'" 2>/dev/null)
        echo "OS: $OS_INFO"
        KERNEL=$(ssh "$IP" "uname -r" 2>/dev/null)
        ARCH=$(ssh "$IP" "uname -m" 2>/dev/null)
        echo "Kernel: $KERNEL"
        echo "Architecture: $ARCH"
        CPU_MODEL=$(ssh "$IP" "lscpu | grep 'Model name:' | awk -F ':' '{print $2}' | sed 's/^ //'" 2>/dev/null)
        CPU_CORES=$(ssh "$IP" "nproc" 2>/dev/null)
        echo "CPU: $CPU_MODEL"
        echo "CPU Cores: $CPU_CORES"
        MEM_TOTAL=$(ssh "$IP" "grep MemTotal /proc/meminfo | awk '{print $2/1024}'" 2>/dev/null)
        SWAP_TOTAL=$(ssh "$IP" "grep SwapTotal /proc/meminfo | awk '{print $2/1024}'" 2>/dev/null)
        echo "Memory Total: ${MEM_TOTAL} MB"
        echo "Swap Total: ${SWAP_TOTAL} MB"
        UPTIME_SEC=$(ssh "$IP" "awk '{print $1}' /proc/uptime" 2>/dev/null | cut -d. -f1)
        HR_UPTIME=$(format_uptime $UPTIME_SEC)
        echo "Uptime: $HR_UPTIME"
        LAST_BOOT=$(ssh "$IP" "who -b | awk '{print $3" "$4}'" 2>/dev/null)
        echo "Last Boot: $LAST_BOOT"
        echo "Disk Usage:"
        ssh "$IP" "df -h --output=source,size,avail,target -x tmpfs -x devtmpfs | tail -n +2" 2>/dev/null | while read line; do
            echo "  - $line"
        done
        echo "Network Interfaces:"
        ssh "$IP" "ip -o -4 addr show | awk '{print $2": "$4}'" 2>/dev/null | while read line; do
            echo "  - $line"
        done
        echo "Active Users:"
        ssh "$IP" "who | awk '{print $1, $2, $3, $4}'" 2>/dev/null | while read line; do
            echo "  - $line"
        done
        echo "---------------------------------------------------------------"
    } >> "$REPORT_FILE"

    ((PROCESSED++))
    echo -e "${CYAN}Progress: $PROCESSED / $TOTAL_HOSTS hosts completed.${RESET}"
done < "$HOSTS_FILE"

echo -e "${GREEN}System inventory collection complete. Report saved to $REPORT_FILE${RESET}"

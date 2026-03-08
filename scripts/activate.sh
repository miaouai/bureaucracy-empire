#!/bin/bash

# 🏛️ AI 官僚帝国 - 自动激活脚本
# 用法：当 Copaw 检测到消息包含 "🍀圣旨到！" 时调用此脚本

set -e

# ===== 配置 =====
WORKING_DIR="/app/working"
SKILL_DIR="${WORKING_DIR}/customized_skills/bureaucracy-empire"
LOGS_DIR="${SKILL_DIR}/logs"

# ===== 辅助函数 =====
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

generate_id() {
    date '+%Y%m%d%H%M%S' | md5sum | head -c 8
}

# ===== 主流程 =====
main() {
    local message="$1"
    
    # Step 0: 检查触发条件
    if [[ ! "$message" =~ "🍀圣旨到！" ]]; then
        log "❌ 未检测到圣旨关键词，跳过"
        return 1
    fi
    
    log "🍀 检测到圣旨！启动官僚帝国系统..."
    
    # Step 1: 记录圣旨
    local timestamp=$(date '+%Y-%m-%d %H:%M')
    local task_id=$(generate_id)
    local task_desc=$(echo "$message" | sed 's/🍀圣旨到！//g' | tr '\n' ' ' | cut -c1-50)
    
    echo "[${timestamp}] #${task_id} | ${task_desc} | 状态：待办" >> "${LOGS_DIR}/圣旨.log"
    
    log "📜 圣旨编号：#${task_id}"
    log "📝 任务描述：${task_desc}"
    
    # Step 2: 输出工作流指引 (供 Copaw 执行)
    cat <<EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
       🍀 圣旨已接收！启动官僚帝国 🏛️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【下一步操作流程】

Step 1 👉 打开内阁会议室
         路径：${SKILL_DIR}/templates/议政纪要.md
         动作：创建新文件 logs/议政录/${timestamp}_${task_id}.md
         内容：依次模拟 10 位顾问发言

Step 2 👉 尚书发令
         路径：${SKILL_DIR}/templates/发配令.md  
         动作：根据议政结果拆分任务，分配给六部

Step 3 👉 六部执行
         路径：${SKILL_DIR}/memory/六部/六部首脑.md
         动作：各部并行执行各自任务

Step 4 👉 御前汇报
         动作：汇总所有奏折，向主公呈报最终方案

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          ⚡ Token 节省提示：
          • 若任务简单，可简化为只启用 3-5 个关键角色
          • 若主公未追问细节，可用摘要代替完整过程
          • 重复类型任务可复用之前的讨论模板
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    
    log "✅ 官僚帝国系统已就绪，等待指令继续..."
    
    return 0
}

# ===== 执行入口 =====
if [[ $# -gt 0 ]]; then
    main "$*"
else
    echo "用法：$0 '用户的消息内容'"
    exit 1
fi

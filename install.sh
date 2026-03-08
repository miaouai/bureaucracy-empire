#!/usr/bin/env bash
# bureaucracy-empire 一键配置脚本
# 用法：bash install.sh

set -e

echo "🏛️ 官僚帝国技能 - 自动配置脚本"
echo ""

# 步骤 1: 确认路径
AGENT_CONFIG="/app/working/AGENTS.md"
SKILL_DIR="/app/working/active_skills/bureaucracy-empire"

echo "📂 目标目录：$SKILL_DIR"
echo "⚙️  配置文件：$AGENT_CONFIG"
echo ""

# 步骤 2: 检查是否已存在触发词
if grep -q "🍀圣旨到" "$AGENT_CONFIG" 2>/dev/null; then
    echo "✅ 检测到 AGENTS.md 已有 '🍀圣旨到！' 触发词配置"
else
    echo "⚠️  AGENTS.md 中未找到触发词配置，正在添加..."
    
    # 备份原文件
    cp "$AGENT_CONFIG" "${AGENT_CONFIG}.bak.$(date +%Y%m%d%H%M%S)"
    
    # 查找插入位置
    if grep -q "技能触发规则" "$AGENT_CONFIG" 2>/dev/null; then
        # 已存在触发规则表，追加新行
        sed -i '/| `🍀圣旨到！`/!{ | `现有规则` $a\\n| `🍀圣旨到！` | `bureaucracy-empire` | 启动官僚帝国任务管理系统，10 人内阁议政 + 六部执行 | |}' "$AGENT_CONFIG"
    else
        # 整个追加到文件末尾
        cat >> "$AGENT_CONFIG" << 'EOF'

### ⚡ 技能触发规则

**强制触发关键词**（检测到必须立即加载对应技能）：

| 关键词 | 触发技能 | 说明 |
|--------|----------|------|
| `🍀圣旨到！` | `bureaucracy-empire` | 启动官僚帝国任务管理系统，10 人内阁议政 + 六部执行 |

**触发协议**：
1. 扫描用户消息是否包含触发关键词
2. 匹配成功 → **立即加载**对应技能
3. 严格按照技能文档执行流程
4. 禁止跳过或忽略触发词
EOF
    fi
    
    echo "✅ 已添加触发词配置"
fi

# 步骤 3: 验证配置
echo ""
echo "🔍 验证配置完整性..."

MISSING_FILES=""
for file in "SKILL.md" "README.md" "组织结构.md" "memory/内阁/全员档案.md" "templates/议政纪要.md"; do
    if [ ! -f "$SKILL_DIR/$file" ]; then
        MISSING_FILES="$MISSING_FILES\n  - $file"
    fi
done

if [ -z "$MISSING_FILES" ]; then
    echo "✅ 所有必需文件存在"
else
    echo "❌ 缺少以下文件:$MISSING_FILES"
    exit 1
fi

# 步骤 4: 完成
echo ""
echo "========================================"
echo "✨ 配置完成！现在可以使用了："
echo ""
echo "在对话框中输入:"
echo "  🍀圣旨到！{你的任务}"
echo ""
echo "例如:"
echo "  🍀圣旨到！帮我规划求职方案"
echo ""
echo "仓库：https://github.com/miaouai/bureaucracy-empire"
echo "========================================"

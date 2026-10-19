config.load_autoconfig(False)
# ===== 主题（由 quickshell/scripts/theme.sh 切换，勿手动改动下一行格式） =====
THEME = "dark"
config.source(f"themes/{THEME}.py")

# ===== qutebrowser 会话恢复配置 =====
# 启用自动保存会话
c.auto_save.session = True
# 设置默认会话名称
c.session.default_name = 'default'
# 启用懒加载恢复（提高启动速度）
c.session.lazy_restore = True
# 自动保存间隔（毫秒）
c.auto_save.interval = 15000  # 15秒自动保存一次

# ui配置
c.window.hide_decoration = True
c.fonts.default_size = "12pt"

c.statusbar.padding = {"top": 4, "bottom": 4, "left": 2, "right": 2}
c.fonts.statusbar = "14pt monospace"

c.tabs.padding = {'top': 2, 'bottom': 2, 'left': 0, 'right': 0}
c.fonts.tabs.selected = "12pt monospace"
c.fonts.tabs.unselected = "12pt monospace"

# ===== 快捷键 =====
# 先关闭所有默认快捷键（所有模式），再按模式分别定义
for _mode, _bindings in c.bindings.default.items():
    c.bindings.commands[_mode] = {str(_key): None for _key in _bindings}

# ----- normal 模式 -----
# hjkl 逐步滚动页面
config.bind('h', 'scroll left', mode='normal')
config.bind('j', 'scroll down', mode='normal')
config.bind('k', 'scroll up', mode='normal')
config.bind('l', 'scroll right', mode='normal')
# J/K 整页上下翻页
config.bind('J', 'scroll-page 0 1', mode='normal')
config.bind('K', 'scroll-page 0 -1', mode='normal')
# H/L 切换标签页
config.bind('H', 'tab-prev', mode='normal')
config.bind('L', 'tab-next', mode='normal')
# : 进入命令模式
config.bind(':', 'cmd-set-text :', mode='normal')
# gg/ge 移动到页面顶部/底部
config.bind('gg', 'scroll-to-perc 0', mode='normal')
config.bind('ge', 'scroll-to-perc', mode='normal')
# v 进入 caret 模式
config.bind('v', 'mode-enter caret', mode='normal')
# i/a 进入 insert 模式
config.bind('i', 'mode-enter insert', mode='normal')
config.bind('a', 'mode-enter insert', mode='normal')
# Ctrl-o 打开新标签页
config.bind('<Ctrl-o>', 'open -t', mode='normal')

# ----- caret 模式（光标浏览与选择） -----
# Escape / Ctrl-j 退出到 normal 模式
config.bind('<Escape>', 'mode-leave', mode='caret')
config.bind('<Ctrl-j>', 'mode-leave', mode='caret')
# v 开始/切换选区
config.bind('v', 'selection-toggle', mode='caret')
# hjkl 移动光标
config.bind('h', 'move-to-prev-char', mode='caret')
config.bind('j', 'move-to-next-line', mode='caret')
config.bind('k', 'move-to-prev-line', mode='caret')
config.bind('l', 'move-to-next-char', mode='caret')
# w/b/e 按单词移动
config.bind('w', 'move-to-next-word', mode='caret')
config.bind('b', 'move-to-prev-word', mode='caret')
config.bind('e', 'move-to-end-of-word', mode='caret')
# gg/ge 移动到页面顶部/底部
config.bind('gg', 'move-to-start-of-document', mode='caret')
config.bind('ge', 'move-to-end-of-document', mode='caret')
# y 复制选中内容到系统剪贴板
config.bind('y', 'yank selection', mode='caret')

# ----- insert 模式 -----
# Escape / Ctrl-j 退出到 normal 模式
config.bind('<Escape>', 'mode-leave', mode='insert')
config.bind('<Ctrl-j>', 'mode-leave', mode='insert')

# ----- command 模式 -----
# Escape 退出到 normal 模式
config.bind('<Escape>', 'mode-leave', mode='command')
# 回车执行命令
config.bind('<Return>', 'command-accept', mode='command')
# 上下选择（方向键）
config.bind('<Up>', 'completion-item-focus --history prev', mode='command')
config.bind('<Down>', 'completion-item-focus --history next', mode='command')
# Ctrl-j/k 上下移动
config.bind('<Ctrl-j>', 'completion-item-focus --history next', mode='command')
config.bind('<Ctrl-k>', 'completion-item-focus --history prev', mode='command')
# Tab 向下选择补全项
config.bind('<Tab>', 'completion-item-focus next', mode='command')

# ----- prompt 模式 -----
# Escape / Ctrl-j 退出到 normal 模式
config.bind('<Escape>', 'mode-leave', mode='prompt')
config.bind('<Ctrl-j>', 'mode-leave', mode='prompt')

# ===== 命令别名 =====
c.aliases['bc'] = 'tab-close'
c.aliases['bco'] = 'tab-only'

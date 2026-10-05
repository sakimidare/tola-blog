#import "/templates/fuwari.typ": post, admonition, code-block, quote-block, github-card, link-card

#show: post.with(
  title: "Niri 安装与配置",
  date: "2025-10-24",
  summary: "Niri 窗口管理器的安装配置以及踩坑备忘录",
  tags: ("Manual",),
  category: none,
  image: none,
  words: 1767,
  minutes: 6,
  draft: false,
)

= Niri 简介

#link-card("https://wiki.archlinux.org/title/Niri", "Niri", avatar: "https://wiki.archlinuxcn.org/favicon.ico", description: "")

Niri 和 我们熟悉的 Windows 桌面或 KDE Plasma 不同。他是一个水平式排列的窗口管理器。每当新打开一个窗口，便会显示在当前窗口的右侧（而非像 Windows 那样堆叠）。在 Niri 中，没有开始按钮、没有最小化、没有最大化，有的只是随心所欲用快捷键和触摸板切换窗口的流畅操作和炫酷动画！


= 成品图

话不多说，赶快端上成品图：

#html.elem("img", attrs: (src: "/assets/posts/niri-manual/screenshot1.png", alt: "", loading: "lazy"))
#html.elem("img", attrs: (src: "/assets/posts/niri-manual/screenshot2.png", alt: "", loading: "lazy"))
#html.elem("img", attrs: (src: "/assets/posts/niri-manual/screenshot3.png", alt: "", loading: "lazy"))

通知栏的图标暂时没有配置，不过问题不大。想拥有这个炫酷 WM (Window Manager) 吗？跟我一步一步配置，你也可以做到！


= 安装步骤

#admonition(kind: "note", title: none)[
下面的安装步骤假定你已经安装好了 Arch Linux。如果并非如此，请参阅其他安装 Arch Linux 的教程。我推荐阅读 #link("https://wiki.archlinuxcn.org/wiki/%E5%AE%89%E8%A3%85%E6%8C%87%E5%8D%97")[Archwiki]。


]

#admonition(kind: "warning", title: none)[
以下教程对你有以下要求：

+ 耐心，愿意试错；
+ 阅读过#link("https://www.sakimidare.top/posts/how-to-ask-questions-the-smart-way/")[提问的智慧]；
+ 有初步的 Linux 知识；


]

开始之前，放几个链接：

#link-card("https://yalter.github.io/niri/Getting-Started.html", "Niri", avatar: "https://yalter.github.io/favicon.ico", description: "")

#github-card("YaLTeR/niri")


== 安装 Niri 软件包

#admonition(kind: "warning", title: none)[
Niri 并不像 KDE Plasma 和 Xfce 一样附带了一系列 GUI 程序可以开箱即用。因此，你可能需要安装附加程序如 `blueman` 来管理蓝牙设备、`dolphin` 来浏览文件、`alacritty` 来运行终端、`gwenview` 来看图、 `vlc` 打开媒体、`fcitx5` 作为中文输入法、`noto-fonts`来显示中文字体等等。具体安装步骤不再赘述，请参阅#link("https://wiki.archlinuxcn.org/")[Arch Linux 中文维基]获得必要信息。

另外，如上文所述，本文假定你是一个 Linux 用户。所以你的电脑上理应有 `git` `yay` `gcc` `clang` `rust`  `make` `python`等最基本的软件包。Niri 使用 Rust 编写，所以你得安装 `rust` 软件包来执行 `make` 操作。如有这些软件包缺失，请自行安装。


]

你可以用这两条命令：

#code-block("sudo pacman -S niri xdg-desktop-portal-gtk xdg-desktop-portal-gnome alacritty swaybg swayidle hyprlock xwayland-satellite dolphin sddm brightnessctl wireplumber grim flameshot breeze wshowkeys-git fcitx5 fcitx5-qt fcitx5-chinese-addons blueman noto-fonts libnotify pipewire pipewire-pulse\nyay -S noctalia-shell vicinae ttf-jetbrains-mono misans \n", lang: "sh")

安装必要的软件包。

Noctalia Shell 是一个使用 Material Design 的用户界面。它可以接管系统通知，声音和显示亮度调节，并在最上方显示一个很他吗炫酷的状态栏。

Vicinae 是一个 App 启动器，可以把它理解为 Windows 上的开始菜单。在我的配置中，所有不在快捷键配置里的程序都需要从这里启动。


== 配置


== SDDM

Niri 安装完成后，会自动创建 `.desktop` 文件。这个 `.desktop` 文件会被 SDDM 识别并提供登录到会话的选项。如果你还没有使用 SDDM 作为登录管理器，请先启用服务。

#code-block("sudo systemctl enable sddm.service", lang: "sh")

这样在系统开机时会自动运行 SDDM，以便启动 Niri 会话。


== 编辑 niri.service 的 wants

#code-block("systemctl --user add-wants niri swayidle", lang: "sh")

这样做可以让 `swayidle` 软件包接管锁屏、睡眠等系统操作。

#admonition(kind: "note", title: none)[
不需要照着官方文档加上 `waybar` 和 `mako`！我的配置没装这两个软件包，Shell 和通知全由 Noctalia Shell 接管！


]

编辑 `~/.config/systemd/user/niri.service.wants/swayidle.service`。
填入以下配置：

#code-block("[Unit]\nPartOf=graphical-session.target\nAfter=graphical-session.target\nRequisite=graphical-session.target\n\n[Service]\nExecStart=/usr/bin/swayidle -w timeout 601 'niri msg action power-off-monitors' timeout 600 'hyprlock' before-sleep 'hyprlock'\nRestart=on-failure", lang: "ini")

这个配置是为了无操作 600 秒后用 `hyprlock` 锁屏，601 秒后关闭显示器。
如果有睡眠、休眠等需求，请查阅 Swaylock 官方文档。


== 修改 Niri 配置文件

创建 `~/.config/niri/config.kdl` 文件并写入配置。
除了显示器配置，其他你可以抄我的。显示器配置请根据注释自行修改。

#code-block("// 键盘鼠标触摸板等输入设备相关配置\ninput {\n    keyboard {\n        xkb {\n            layout \"us\"\n        }\n\n        // 在启动上启用numlock，省略此设置会禁用它。\n        numlock\n    }\n\n    touchpad {\n        tap\n        natural-scroll\n        scroll-method \"two-finger\"\n    }\n\n    mouse {\n        // 设置鼠标移动速度,-1到1之间由慢到快\n        accel-speed 1\n    }\n\n    // niri默认接管电源按钮的功能是sleep,这里禁用以使用关机功能\n    disable-power-key-handling\n    // 切换mod键：正常使用alt，嵌套窗口内使用Super。\n    mod-key \"Super\"\n    mod-key-nested \"Alt\"\n}\n\n// 可以在niri实例中运行`niri msg outputs`找到显示器名称。\noutput \"HDMI\" {\n    // 取消注释以禁用此显示器。\n    off\n\n    // 默认聚焦在这个显示器\n    focus-at-startup\n\n    // 格式为\"<width>x<height>\" 或者 \"<width>x<height>@<refresh rate>\".\n    // 如果省略了刷新率，niri将为分辨率选择最高的刷新率。\n    mode \"3840x2160@60.000\"\n\n    // 您可以使用整数或分数量表，例如，比例为150％。\n    scale 2\n\n    // transform允许逆时针旋转显示，有效值为:\n    // normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.\n    transform \"normal\"\n\n    // 输出在所有显示器坐标空间中的位置。未明确配置位置的显示器将放置在所有已放置的显示器右侧。\n    // position x=1280 y=0\n}\n\n// 如果 eDP-2 没有连接，将会默认聚焦在这个显示器\noutput \"eDP-2\" {\n    // off\n    focus-at-startup\n    mode \"2560x1600@300.000\"\n    transform \"normal\"\n    position x=0 y=0\n}\n\n// 可以使用wev来查询特定的按键对应的XKB名称\nbinds {\n    Alt+Tab { spawn \"niri-switch\"; }\n    // Mod-Shift-/显示重要的热键列表(通常与 Mod-? 相同)。\n    Mod+Shift+Slash { show-hotkey-overlay; }\n    Mod+D hotkey-overlay-title=\"Open the File Manager\" { spawn \"/usr/bin/dolphin\"; } \n    // Mod+L hotkey-overlay-title=\"Lock the Screen: swaylock\" { spawn \"/usr/bin/swaylock\" \"-f\" \"-i\" \"$HOME/.dotfiles/sway/.config/sway/lock.png\"; }\n    Mod+L hotkey-overlay-title=\"Lock the Screen: hyprlock\" { spawn \"/usr/bin/hyprlock\"; }\n    Mod+Return hotkey-overlay-title=\"Open a Terminal\" { spawn \"/usr/bin/alacritty\"; }\n   // Mod+A hotkey-overlay-title=\"Run an Application\" { spawn \"/usr/bin/fuzzel\"; }\n    Mod+A hotkey-overlay-title=\"Run an Application\" { spawn \"/usr/bin/vicinae\" \"toggle\"; }\n    Mod+X hotkey-overlay-title=\"Open a browser: zen\" { spawn \"/usr/bin/google-chrome-stable\"; }\n    // Mod+D hotkey-overlay-title=\"同步切换obs和mpv状态\" { spawn \"/usr/bin/touch\" \"/tmp/obs_mpv_toggle_pause\"; }\n    Mod+K hotkey-overlay-title=\"打开screenkey\" { spawn \"/usr/bin/wshowkeys\" \"-a\" \"right\" \"-a\" \"bottom\" \"-F\" \"ComicShannsMono Nerd Font 30\"; }\n    Mod+Shift+K hotkey-overlay-title=\"关闭screenkey\" { spawn \"/usr/bin/killall\" \"wshowkeys\"; }\n    // Mod+Shift+C hotkey-overlay-title=\"重启waybar\" { spawn-sh \"pkill waybar && waybar\"; }\n\n    // 音量控制 allow-when-locked=true 在锁屏时的按键也会生效。这里的wpctl是wireplumber包中附带的\n    XF86AudioRaiseVolume allow-when-locked=true { spawn-sh \"wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+\"; }\n    XF86AudioLowerVolume allow-when-locked=true { spawn-sh \"wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-\"; }\n    XF86AudioMute        allow-when-locked=true { spawn-sh \"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\"; }\n    XF86AudioMicMute     allow-when-locked=true { spawn-sh \"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\"; }\n\n    // 亮度控制。brightnessctl 有独立的包\n    XF86MonBrightnessUp allow-when-locked=true { spawn \"brightnessctl\" \"set\" \"+10%\"; }\n    XF86MonBrightnessDown allow-when-locked=true { spawn \"brightnessctl\" \"set\" \"10%-\"; }\n\n    // 开关overview\n    Mod+Tab repeat=false { toggle-overview; }\n    // 关闭窗口\n    Mod+Q repeat=false { close-window; }\n\n    // 窗口焦点切换，位置移动\n    Mod+Left  { focus-column-left; }\n    Mod+Down  { focus-window-down; }\n    Mod+Up    { focus-window-up; }\n    Mod+Right { focus-column-right; }\n    Mod+N     { focus-column-left; }\n    Mod+i     { focus-column-right; }\n    Mod+Alt+Left { consume-or-expel-window-left; }\n    Mod+Alt+Right {consume-or-expel-window-right; }\n    // Mod+N     { spawn-sh \"niri msg action focus-column-left && niri msg action center-column\"; }\n    // Mod+i     { spawn-sh \"niri msg action focus-column-right && niri msg action center-column\"; }\n    Mod+Shift+Left  { move-column-left; }\n    Mod+Shift+Down  { move-window-down; }\n    Mod+Shift+Up    { move-window-up; }\n    Mod+Shift+Right { move-column-right; }\n    Mod+Shift+N     { move-column-left; }\n    Mod+Shift+I     { move-column-right; }\n\n    Mod+Home { focus-column-first; }\n    Mod+End  { focus-column-last; }\n    Mod+Shift+Home { move-column-to-first; }\n    Mod+Shift+End  { move-column-to-last; }\n\n    // workspace焦点切换，窗口在workspace之间移动\n    Mod+Page_Down      { focus-workspace-down; }\n    Mod+Page_Up        { focus-workspace-up; }\n    Mod+Ctrl+Page_Down { move-column-to-workspace-down; }\n    Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }\n    // 上下移动整个workspace\n    Mod+Shift+Page_Down { move-workspace-down; }\n    Mod+Shift+Page_Up   { move-workspace-up; }\n\n    // 上下方向共用的窗口、工作空间的焦点切换和位置移动\n    Mod+E     { focus-window-or-workspace-down; }\n    Mod+U     { focus-window-or-workspace-up; }\n    Mod+Shift+E     { move-window-down-or-to-workspace-down; }\n    Mod+Shift+U     { move-window-up-or-to-workspace-up; }\n\n    // 显示器焦点切换\n    Mod+Ctrl+Left  { focus-monitor-left; }\n    Mod+Ctrl+Down  { focus-monitor-down; }\n    Mod+Ctrl+Up    { focus-monitor-up; }\n    Mod+Ctrl+Right { focus-monitor-right; }\n    Mod+Ctrl+N     { focus-monitor-left; }\n    Mod+Ctrl+E     { focus-monitor-down; }\n    Mod+Ctrl+U     { focus-monitor-up; }\n    Mod+Ctrl+I     { focus-monitor-right; }\n\n    // 跨显示器移动窗口\n    Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }\n    Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }\n    Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }\n    Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }\n    Mod+Shift+Ctrl+N     { move-column-to-monitor-left; }\n    Mod+Shift+Ctrl+E     { move-column-to-monitor-down; }\n    Mod+Shift+Ctrl+U     { move-column-to-monitor-up; }\n    Mod+Shift+Ctrl+I     { move-column-to-monitor-right; }\n\n    // 鼠标相关快捷键\n    Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }\n    Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }\n    Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }\n    Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }\n\n    Mod+WheelScrollRight      { focus-column-right; }\n    Mod+WheelScrollLeft       { focus-column-left; }\n    Mod+Ctrl+WheelScrollRight { move-column-right; }\n    Mod+Ctrl+WheelScrollLeft  { move-column-left; }\n\n    Mod+Shift+WheelScrollDown      { focus-column-right; }\n    Mod+Shift+WheelScrollUp        { focus-column-left; }\n    Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }\n    Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }\n\n    Mod+TouchpadScrollDown { spawn-sh \"wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02+\"; }\n    Mod+TouchpadScrollUp   { spawn-sh \"wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02-\"; }\n\n    Mod+1 { focus-workspace 1; }\n    Mod+2 { focus-workspace 2; }\n    Mod+3 { focus-workspace 3; }\n    Mod+4 { focus-workspace 4; }\n    Mod+5 { focus-workspace 5; }\n    Mod+6 { focus-workspace 6; }\n    Mod+7 { focus-workspace 7; }\n    Mod+8 { focus-workspace 8; }\n    Mod+9 { focus-workspace 9; }\n    Mod+0 { focus-workspace 10; }\n    Mod+Shift+1 { move-column-to-workspace 1; }\n    Mod+Shift+2 { move-column-to-workspace 2; }\n    Mod+Shift+3 { move-column-to-workspace 3; }\n    Mod+Shift+4 { move-column-to-workspace 4; }\n    Mod+Shift+5 { move-column-to-workspace 5; }\n    Mod+Shift+6 { move-column-to-workspace 6; }\n    Mod+Shift+7 { move-column-to-workspace 7; }\n    Mod+Shift+8 { move-column-to-workspace 8; }\n    Mod+Shift+9 { move-column-to-workspace 9; }\n    Mod+Shift+0 { move-column-to-workspace 10; }\n\n    // 最大化和全屏\n    Mod+W { toggle-windowed-fullscreen; }\n    Mod+F { expand-column-to-available-width; }\n    Mod+Shift+F { fullscreen-window; }\n\n    // 未最大化的窗口居中\n    Mod+C { center-column; }\n    Mod+Ctrl+C { center-visible-columns; }\n\n    // 在layout中预设的宽度和高度之间切换\n    Mod+R { switch-preset-column-width; }\n    Mod+Shift+R { switch-preset-window-height; }\n    // 改变宽度单位可以有pixels、百分比\n    Mod+Minus { set-column-width \"-10%\"; }\n    Mod+Equal { set-column-width \"+10%\"; }\n\n    // 改变高度\n    Mod+Shift+Minus { set-window-height \"-10%\"; }\n    Mod+Shift+Equal { set-window-height \"+10%\"; }\n\n    // 切换悬浮窗，改变平铺和悬浮窗焦点\n    Mod+Shift+Space       { toggle-window-floating; }\n    Mod+Space { switch-focus-between-floating-and-tiling; }\n\n    // 截图\n    Alt+J { spawn-sh \"grim -g \\\"$(slurp)\\\" - | satty --filename - --output-filename ~/$(date '+%Y%m%d-%H:%M:%S').png\"; }\n    Alt+Shift+J { spawn \"flameshot\" \"gui\"; }\n    Print { screenshot show-pointer=false; }\n    Ctrl+Print { screenshot-screen write-to-disk=true; }\n    Alt+Print { screenshot-window write-to-disk=true; }\n\n    // 针对虚拟机软件可能需要键盘控制权。allow-inhibiting=false 忽略当前快捷键本身\n    Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }\n\n    // 退出niri将显示一个确认对话框，以避免意外退出。\n    Mod+Shift+Q { quit; }\n\n    // 关闭显示器。移动鼠标或按下任意按键恢复\n    Mod+Shift+P { power-off-monitors; }\n}\n\n// 影响窗口的位置和尺寸的设置。\nlayout {\n    // 在逻辑像素中设置Windows周围的缝隙。\n    gaps 10\n    background-color \"transparent\"\n    // 存在多个窗口时，未最大化的窗口不自动居中，方便分屏\n    center-focused-column \"never\"\n    // 只有一个窗口时自动居中显示\n    always-center-single-column\n\n    // mod+r在预设之间切换的宽度。\n    preset-column-widths {\n        proportion 0.5\n        proportion 0.2444\n        proportion 0.7556\n        // 固定设置逻辑像素的宽度精确设置。（受scale影响）\n        // fixed 1920\n    }\n\n    preset-window-heights {\n        proportion 0.5\n        proportion 0.8\n        proportion 1.0\n    }\n    // 关闭聚焦框\n    focus-ring {\n        // off\n    }\n\n    // 关闭边框\n    border {\n        off\n    }\n}\n\n// 覆盖由niri启动的进程的环境变量\nenvironment {\n    QT_QPA_PLATFORMTHEME \"qt5ct\"\n    ALL_PROXY \"http://127.0.0.1:7890\"\n    LANG \"zh_CN.UTF-8\"\n    LC_CTYPE \"zh_CN.UTF-8\"\n    LC_NUMERIC \"zh_CN.UTF-8\"\n    LC_TIME \"zh_CN.UTF-8\"\n    LC_COLLATE \"zh_CN.UTF-8\"\n    LC_MONETARY \"zh_CN.UTF-8\"\n    LC_MESSAGES \"zh_CN.UTF-8\"\n    LC_PAPER \"zh_CN.UTF-8\"\n    LC_NAME \"zh_CN.UTF-8\"\n    LC_ADDRESS \"zh_CN.UTF-8\"\n    LC_TELEPHONE \"zh_CN.UTF-8\"\n    LC_MEASUREMENT \"zh_CN.UTF-8\"\n    LC_IDENTIFICATION \"zh_CN.UTF-8\"\n    LC_ALL null\n    // XDG_DATA_DIRS \"$HOME/.local/share\" \"$XDG_DATA_DIRS\"\n    // GTK_IM_MODULE \"fcitx\"\n    QT_IM_MODULE \"fcitx\"\n    // https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#Sway\n    XMODIFIERS \"@im=fcitx\"\n    QT_IM_MODULES \"wayland;fcitx\"\n    GTK_IM_MODULE null\n    SDL_IM_MODULE null\n    GLFW_IM_MODULE null\n}\nspawn-at-startup \"niri-switch-daemon\"\n\n// 启动niri时自动启动的软件\nspawn-at-startup \"/usr/bin/fcitx5\"\n// spawn-at-startup \"/usr/bin/v2rayn\"\n// spawn-at-startup \"/usr/bin/waybar\"\nspawn-at-startup \"/usr/bin/vicinae\" \"server\"\nspawn-at-startup \"~/.cargo/bin/soteria\"\nspawn-at-startup \"~/Desktop/tools/update_repositories.sh\"\nspawn-at-startup \"qs\" \"-c\" \"noctalia-shell\"\nspawn-at-startup \"/usr/bin/hyprlock\"\n// 要运行shell命令（带有变量，管道等），请使用spawn-sh-at-at-startup：\nspawn-sh-at-startup \"swaybg -i /path/to/your/wallpaper.png -m fill\"\n\nhotkey-overlay {\n    // 跳过“重要的热键”弹出窗口。\n    skip-at-startup\n}\n\n// 设置截图保存的路径，null将会禁止保存到磁盘\nscreenshot-path \"~/Pictures/ScreenShot/%Y-%m-%d %H-%M-%S.png\"\n\n// 忽略软件自带的装饰(例如标题栏)\nprefer-no-csd\n\n// 指定光标的主题和大小，打字时隐藏光标\ncursor {\n    // xcursor-theme \"Dracula-cursors\"\n    xcursor-theme \"breeze\"\n    xcursor-size 24\n    hide-when-typing\n}\n\n// 使用`niri msg windows`查看Title和App ID等信息\nwindow-rule {\n    open-on-output \"eDP-2\"\n    // default-window-height { proportion 0.9; }\n    // default-floating-position x=100 y=200 relative-to=\"bottom-left\"\n    // default-column-width { proportion 0.7556; }\n    geometry-corner-radius 20 \n    clip-to-geometry true\n    border {\n        // off\n        on\n        width 4\n        active-gradient from=\"#bd93f9\" to=\"#94b9fa\" angle=135\n        inactive-color \"#505050\"\n        urgent-color \"#9b0000\"\n        // active-gradient from=\"#80c8ff\" to=\"#bbddff\" angle=45\n        // inactive-gradient from=\"#505050\" to=\"#808080\" angle=45 relative-to=\"workspace-view\"\n        // urgent-gradient from=\"#800\" to=\"#a33\" angle=45\n    }\n\n    focus-ring{\n        off\n    }\n    // opacity 0.75\n}\nwindow-rule {\n    open-on-output \"eDP-2\"\n    match app-id=\"scrcpy\"\n    default-column-width { proportion 0.2444; }\n}\nwindow-rule {\n    open-on-output \"eDP-2\"\n    match app-id=r#\"chrome\"#\n    default-column-width { proportion 0.8; }\n    // border {\n    //    on\n    //    width 4\n    //    active-color \"#61AFEF\"\n    // }\n    // open-focused false\n}\nwindow-rule {\n    match app-id=\"com.gabm.satty\" title=\"satty\"\n    border {\n        on\n        width 2\n        active-color \"#61AFEF\"\n    }\n}\n\n// `niri msg layers`显示有namespace可以在这里配置waybar透明度\nlayer-rule {\n    match namespace=\"^quickshell-overview$\"\n    place-within-backdrop true\n    //     opacity 0.75\n}\n\n// Put swaybg inside the overview backdrop.\nlayer-rule {\n    match namespace=\"^wallpaper$\"\n    place-within-backdrop true\n}\n\ndebug {\n    honor-xdg-activation-with-invalid-serial\n}\n// 禁用鼠标左上角热脚\ngestures {\n    hot-corners {\n        // off\n    }\n}\n\nanimations {\n    // Uncomment to turn off all animations.\n    // You can also put \"off\" into each individual animation to disable it.\n    // off\n\n    // Slow down all animations by this factor. Values below 1 speed them up instead.\n    // slowdown 3.0\n\n    // Individual animations.\n\n    workspace-switch {\n        spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001\n    }\n\n    window-open {\n        duration-ms 150\n        curve \"ease-out-expo\"\n    }\n\n    window-close {\n        duration-ms 150\n        curve \"ease-out-quad\"\n    }\n\n    horizontal-view-movement {\n        spring damping-ratio=1.0 stiffness=800 epsilon=0.0001\n    }\n\n    window-movement {\n        spring damping-ratio=1.0 stiffness=800 epsilon=0.0001\n    }\n\n    window-resize {\n        spring damping-ratio=1.0 stiffness=800 epsilon=0.0001\n    }\n\n    config-notification-open-close {\n        spring damping-ratio=0.6 stiffness=1000 epsilon=0.001\n    }\n\n    exit-confirmation-open-close {\n        spring damping-ratio=0.6 stiffness=500 epsilon=0.01\n    }\n\n    screenshot-ui-open {\n        duration-ms 200\n        curve \"ease-out-quad\"\n    }\n\n    overview-open-close {\n        spring damping-ratio=1.0 stiffness=800 epsilon=0.0001\n    }\n}\n\n", lang: "typescript")

这里面热键配置部分的 `Mod` 在 SDDM 启动的 Niri 下全部代指 Super 键（也就是印刷着 Windows 徽标的那个键）。

以下是几个常用热键：

#table(
  columns: 2,
  [*热键*],
  [*功能*],
  [Mod + Shift + /(?)],
  [显示热键菜单],
  [Mod + A],
  [打开 Vicinae (App 启动器)],
  [Mod + D],
  [打开 Dolphin（文件管理器）],
  [Mod + X],
  [打开 `google-chrome-stable`],
  [Mod + Enter],
  [打开 Konsole （终端）],
  [Mod + R],
  [在预设的列宽中切换],
  [Mod + Shift + R],
  [在预设的列高中切换],
  [Mod + F],
  [将当前列的宽度扩展到最大],
  [Mod + L],
  [用 Hyprlock 锁屏],
  [Mod + 左右箭头],
  [切换窗口左右焦点],
  [Mod + Shift + 左右箭头],
  [将当前列和左右列互换位置],
  [Mod + Alt + 左右箭头],
  [将该窗口吸收进左右列中或从当前列释放出去],
  [Mod + PgUp / PgDn],
  [上下切换工作区],
  [Mod + Ctrl + PgUp / PgDn],
  [将当前列移动到上下工作区],
  [Mod + Tab],
  [进入 Overview （缩小整个屏幕以显示工作区概览）],
  [PrtSc],
  [截屏并复制到剪贴板以及保存到 \~],
  [Ctrl + PrtSc],
  [截全屏，操作同上],
  [三指滑动触摸板],
  [切换窗口以及工作区],
  [四指滑动触摸板],
  [操作同 Mod + Tab],
)

还有不少热键，懒得打了，看上面的配置吧。个人用得比较多的就这几个了。

注意：

#code-block("// 要运行shell命令（带有变量，管道等），请使用spawn-sh-at-at-startup：\nspawn-sh-at-startup \"swaybg -i /path/to/your/wallpaper.png -m fill\"", lang: "ts")

这一行请务必填入自己的壁纸位置，否则壁纸是灰的！

#admonition(kind: "note", title: none)[
本配置使用 `swaybg` 接管壁纸，所以无需在 Noctalia Shell 里面设置壁纸。


]


== 修改 Hyprlock 配置文件

#strike[（我喜欢混搭）]

#code-block("~/.config/hypr\n├── hyprlock.conf\n└── mocha\n    └── mocha.conf", lang: "plain")

请创建如上所示的目录结构，即运行

#code-block("mkdir ~/.config/hypr\nmkdir ~/.config/hypr/mocha\ntouch ~/.config/hypr/hyprlock.conf\ntouch ~/.config/hypr/mocha/mocha.conf", lang: "sh")

请编辑 `~/.config/hypr/hyprlock.conf`，填入以下配置：

#code-block("source = $HOME/.config/hypr/mocha/mocha.conf\n\n$accent = $mauve\n$accentAlpha = $mauveAlpha\n$font = JetBrains Mono\n\n# GENERAL\ngeneral {\n  hide_cursor = true\n}\n\n# BACKGROUND\nbackground {\n  monitor =\n  path = /path/to/your/lock/screen/wallpaper.png\n  blur_passes = 2\n  color = $base\n}\n\n# LAYOUT\nlabel {\n  monitor =\n  text = 键盘布局: $LAYOUT\n  color = $text\n  font_size = 25\n  font_family = $font\n  position = 30, -30\n  halign = left\n  valign = top\n}\n\n# TIME\nlabel {\n  monitor =\n  text = $TIME\n  color = $text\n  font_size = 90\n  font_family = $font\n  position = -30, 0\n  halign = right\n  valign = top\n}\n\n# DATE\nlabel {\n  monitor =\n  text = cmd[update:43200000] date +\"%Y年 %m月 %d日, %A\"\n  color = $text\n  font_size = 25\n  font_family = $font\n  position = -30, -150\n  halign = right\n  valign = top\n}\n\n# FINGERPRINT\n{\n  monitor = \"\";\n  text = \"$FPRINTPROMPT\";\n  color = \"$text\";\n  font_size = 14;\n  font_family = $font;\n  position = \"0, -107\";\n  halign = \"center\";\n  valign = \"center\";\n}\n\n# USER AVATAR\nimage {\n  monitor =\n  path = $HOME/.face\n  # size = 100\n  size = 200\n  border_color = $accent\n  position = 0, 90\n  # position = 0, 75\n  halign = center\n  valign = center\n}\n\n# INPUT FIELD\ninput-field {\n  monitor =\n  size = 300, 60\n  outline_thickness = 4\n  dots_size = 0.2\n  dots_spacing = 0.2\n  dots_center = true\n  outer_color = $accent\n  inner_color = $surface0\n  font_color = $text\n  fade_on_empty = false\n  # placeholder_text = <span foreground=\"##$textAlpha\"><i>󰌾 Logged in as </i><span foreground=\"##$accentAlpha\">$USER</span></span>\n  placeholder_text = <span foreground=\"##$textAlpha\">󰌾 <span foreground=\"##$accentAlpha\">$USER</span> 已登录 </span>\n  hide_input = false\n  check_color = $accent\n  fail_color = $red\n  fail_text = <i> 已失败 <b>($ATTEMPTS)</b> 次 </i>\n  capslock_color = $yellow\n  # position = 0, -47\n  position = 0, -80\n  halign = center\n  valign = center\n\n", lang: "ini")

请在

#code-block("# BACKGROUND\nbackground {\n  monitor =\n  path = /path/to/your/lock/screen/wallpaper.png\n  blur_passes = 0\n  color = $base\n}", lang: "ini")

填入锁屏壁纸的位置。

并请复制一份你的头像到 `~/.face`。（注意：是创建一个`.face`文件，而不是在 `.face` 文件夹里面放上自己的头像图片！）

编辑 `~/.config/hypr/mocha/mocha.conf`，填入以下配置：

#code-block("$rosewater = rgb(f5e0dc)\n$rosewaterAlpha = f5e0dc\n\n$flamingo = rgb(f2cdcd)\n$flamingoAlpha = f2cdcd\n\n$pink = rgb(f5c2e7)\n$pinkAlpha = f5c2e7\n\n$mauve = rgb(cba6f7)\n$mauveAlpha = cba6f7\n\n$red = rgb(f38ba8)\n$redAlpha = f38ba8\n\n$maroon = rgb(eba0ac)\n$maroonAlpha = eba0ac\n\n$peach = rgb(fab387)\n$peachAlpha = fab387\n\n$yellow = rgb(f9e2af)\n$yellowAlpha = f9e2af\n\n$green = rgb(a6e3a1)\n$greenAlpha = a6e3a1\n\n$teal = rgb(94e2d5)\n$tealAlpha = 94e2d5\n\n$sky = rgb(89dceb)\n$skyAlpha = 89dceb\n\n$sapphire = rgb(74c7ec)\n$sapphireAlpha = 74c7ec\n\n$blue = rgb(89b4fa)\n$blueAlpha = 89b4fa\n\n$lavender = rgb(b4befe)\n$lavenderAlpha = b4befe\n\n$text = rgb(cdd6f4)\n#$text = rgb(6c8cf5)\n#$textAlpha = 6c8cf5\n$textAlpha = cdd6f4\n\n$subtext1 = rgb(bac2de)\n$subtext1Alpha = bac2de\n\n$subtext0 = rgb(a6adc8)\n$subtext0Alpha = a6adc8\n\n$overlay2 = rgb(9399b2)\n$overlay2Alpha = 9399b2\n\n$overlay1 = rgb(7f849c)\n$overlay1Alpha = 7f849c\n\n$overlay0 = rgb(6c7086)\n$overlay0Alpha = 6c7086\n\n$surface2 = rgb(585b70)\n$surface2Alpha = 585b70\n\n$surface1 = rgb(45475a)\n$surface1Alpha = 45475a\n\n$surface0 = rgb(313244)\n$surface0Alpha = 313244\n\n$base = rgb(1e1e2e)\n$baseAlpha = 1e1e2e\n\n$mantle = rgb(181825)\n$mantleAlpha = 181825\n\n$crust = rgb(11111b)\n$crustAlpha = 11111b", lang: "ini")

左右上角的文字颜色定义在

#code-block("$text = rgb(cdd6f4)\n#$text = rgb(6c8cf5)\n#$textAlpha = 6c8cf5\n$textAlpha = cdd6f4", lang: "ini")

若觉得和壁纸不搭，可以直接替换成喜欢的 RGB 色值。


== 配置 Alacritty

#code-block("git clone https://github.com/catppuccin/alacritty.git ~/.config/alacritty/catppuccin\ntouch ~/.config/alacritty/alacritty.toml", lang: "sh")

在 `~/.config/alacritty/alacritty.toml` 填入以下内容：

#code-block("[env]\nTERM = \"xterm-256color\"\n\n[general]\nlive_config_reload = true\nimport = [\"~/.config/alacritty/catppuccin/catppuccin-mocha.toml\"]\n\n[window]\ndecorations = \"buttonless\"\ndynamic_padding = false\nopacity = 1.0\n\n[window.padding]\nx = 25\ny = 20\n\n[font]\nsize = 12.0\n\n[font.bold]\nfamily = \"JetBrains Mono\"\nstyle = \"Heavy\"\n\n[font.bold_italic]\nfamily = \"JetBrains Mono\"\nstyle = \"Heavy Italic\"\n\n[font.italic]\nfamily = \"JetBrains Mono\"\nstyle = \"Medium Italic\"\n\n[font.normal]\nfamily = \"JetBrains Mono\"\nstyle = \"Medium\"\n", lang: "ini")


== 配置 SDDM 自动登录

上面 Niri 配置中我们写到了

#code-block("spawn-at-startup \"/usr/bin/hyprlock\"", lang: "ts")

为了跳过 SDDM 之后仍保证系统安全，这里会在启动 Niri 时自动锁屏。所以我们现在来配置 SDDM 自动登录。

编辑 `/etc/sddm.conf.d/autologin.conf` ，在里面加入：

#code-block("[Autologin]\nUser=#your_username\nSession=niri", lang: "ini")

请将 `#your_username` 改成你的用户名。


== 重启，拥抱 Niri!

不出意外的话，重启之后，输入密码，你就能看到 Noctalia Shell 的欢迎界面了！

拥抱 Niri 吧！拥抱一个比 KDE Plasma 占用少得多且美观的 WM ！


= 疑难解答

由于我是中途从 KDE 转向了 Niri 而非全新安装，所以这篇教程很有可能有软件包依赖以及其他大大小小的问题。如果遇到了问题，欢迎在评论区提出！


== 为什么我的输入法在 QQ 里面坏掉了？

你需要创建 `~/.config/qq-flags.conf`，在里面填入

#code-block("--ozone-platform=wayland\n--enable-wayland-ime\n--wayland-text-input-version=3", lang: "ini")


== 为什么右上角的应用图标这么丑？

我不到啊我也很难受！我会想办法的（跪）


== 为什么有些 GTK 软件是亮色的？这与我的主题不搭！

#code-block("dconf write /org/gnome/desktop/interface/color-scheme '\"prefer-dark\"'", lang: "sh")


== ... ？

留言吧求求了！！


= 最后

#code-block("sudo pacman -S fastfetch hyfetch\nhyfetch", lang: "sh")

盯着你的电脑屏幕看几分钟，享受你的艺术品吧！

# tomatoClock 

一个用 SwiftUI 编写的番茄钟 iOS 应用，核心特色是有一只虚拟小猫陪你一起专注工作/学习。本项目是在 Xcode 中，使用 Copilot for Xcode（GPT‑5.1）在多轮对话中逐步生成和完善的示例工程。

> 适合：想练习 SwiftUI、番茄钟逻辑设计、简单状态管理和互动 UI 的开发者。

---

## 功能概览（当前 MVP 版本）

当前仓库实现的是 **第一阶段 MVP**，包含：

### 1. 番茄钟基础功能
- 默认一轮番茄包含：
  - 专注：25 分钟
  - 短休息：5 分钟
  - 长休息：15 分钟（每 4 个专注后触发）
- 支持：
  - **开始 / 暂停** 计时
  - **重置** 当前阶段
  - 专注与休息在完成后自动切换（专注 → 休息 → 专注 → ...）
- 界面显示剩余时间（`MM:SS`）

### 2. 虚拟小猫陪伴
- 主界面中始终显示一只“小猫”，采用 emoji 作为占位视觉：
  - 专注中：专注表情
  - 休息中：放松表情
  - 完成专注：庆祝表情
- 小猫会根据当前番茄阶段展示 **不同的心情与提示文案**，例如：
  - 「小猫正安静陪你专心工作~」
  - 「辛苦啦，休息一下，陪小猫玩会儿~」
- 轻点小猫，有一个轻微的弹跳动画，让陪伴更有趣。

### 3. 简单设置页面
- 通过设置页可以调整：
  - 专注时长（分钟）
  - 短休息时长（分钟）
  - 长休息时长（分钟）
- 使用 `@AppStorage`/`UserDefaults` 持久化这些设置（后续可以扩展为 SwiftData 等）。

> 当前版本重点在于：清晰的架构、可扩展的模型与 ViewModel，方便你继续迭代为更完整的“猫咪番茄钟”产品。

---

## 项目结构

仓库结构（核心部分）：

```text
tomatoClock/
├── tomatoClockApp.swift        # SwiftUI 应用入口
├── Assets.xcassets/            # 应用图标 & 颜色资源
├── Models/
│   ├── PomodoroModels.swift    # 番茄钟相关模型（SessionType/Settings/Session）
│   └── CatModels.swift         # 猫咪相关模型（CatMood/CatProfile）
├── ViewModels/
│   ├── PomodoroTimerViewModel.swift  # 番茄计时逻辑（开始/暂停/重置/切换）
│   └── CatViewModel.swift            # 猫咪心情与文案逻辑
├── Views/
│   ├── RootView.swift          # 顶层 TabView（专注 / 设置）
│   ├── PomodoroTimerView.swift # 主番茄 + 猫咪界面
│   ├── CatCompanionView.swift  # 小猫的展示 & 点击交互
│   └── SettingsView.swift      # 修改番茄时长的设置页
└── ... 其他 Xcode 工程文件
``

各模块职责简述：

- `tomatoClockApp.swift`
  - 使用 `@main` 作为应用入口
  - 创建全局的 `PomodoroTimerViewModel`、`CatViewModel`
  - 通过 `.environmentObject` 注入给整个视图树（起点为 `RootView`）

- `Models/PomodoroModels.swift`
  - `SessionType`：`focus` / `shortBreak` / `longBreak`
  - `SessionState`：`idle` / `running` / `paused` / `finished`
  - `PomodoroSettings`：一轮番茄的配置（专注/短休/长休时长、多少个专注后长休）
  - `PomodoroSession`：当前这一个阶段的状态（类型、总时长、剩余时间等）

- `Models/CatModels.swift`
  - `CatMood`：`idle` / `focusing` / `resting` / `celebrating`
  - `CatProfile`：猫咪档案（名称 + 当前心情），后续可以扩展等级、皮肤等字段

- `ViewModels/PomodoroTimerViewModel.swift`
  - 负责整个番茄计时逻辑：
    - 启动/暂停/重置计时
    - 每秒 tick 更新剩余时间
    - 在阶段结束时在专注/短休/长休之间切换
  - 使用 `Combine` 的 `Timer.publish(every:on:in:)` 驱动 UI 刷新
  - 对外暴露 `formattedRemainingTime()` 方便 UI 显示

- `ViewModels/CatViewModel.swift`
  - 持有当前的 `CatProfile`
  - 提供 `updateMood(for: PomodoroSession)` 方法：根据番茄状态映射心情
  - 暴露 `statusMessage`，让视图显示合适的情绪文案

- `Views/RootView.swift`
  - 使用 `TabView` 提供两个 Tab：
    - "专注"：`PomodoroTimerView`
    - "设置"：`SettingsView`

- `Views/PomodoroTimerView.swift`
  - 主界面，展示：
    - 剩余时间（大号数字）
    - `CatCompanionView`（小猫）
    - 控制按钮：开始/暂停、重置
  - 根据当前 session 类型切换背景颜色（专注更暖、休息更柔和）
  - 使用 `onChange(of: timerVM.currentSession)` 来驱动猫咪心情更新

- `Views/CatCompanionView.swift`
  - 根据 `CatMood` 显示不同的 emoji + 背景色
  - 支持点击小猫触发一个简短的弹跳动画
  - 显示从 `CatViewModel` 提供的状态文案

- `Views/SettingsView.swift`
  - 使用 `@AppStorage` 持久化番茄时长配置
  - 通过 `Stepper` 提供简单的时间调整（以分钟为单位）

---

## 运行方式

### 环境要求

- macOS（Apple Silicon 或 Intel 均可）
- Xcode 15+（本项目示例环境为 Xcode 26）
- iOS 17+ 模拟器 或 真机

### 使用 Xcode 运行

1. 打开工程：
   - 双击 `tomatoClock.xcodeproj` 打开项目
2. 在 Xcode 顶部选择 Scheme：`tomatoClock`
3. 选择一个 iOS 模拟器设备，例如：
   - `iPhone 17`
   - `iPhone 17 Pro`
   - `iPhone 16e`
4. 点击“运行”（或使用快捷键 `⌘R`）

应用启动后你会看到：

- Tab1 「专注」：
  - 大号倒计时数字
  - 中间是可爱的“小猫”表情和陪伴文案
  - 底部是“开始/暂停”和“重置”按钮
- Tab2 「设置」：
  - 调整专注/短休/长休时间的 Stepper 控件

### 使用命令行构建（可选）

```bash
cd /Users/jason/Documents/tomatoClock

# 可选：查看所有可用模拟器设备
xcrun simctl list devices

# 构建（请把 name 改成你本机存在的某个模拟器，比如 iPhone 17）
xcodebuild -scheme tomatoClock \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build
```

---

## 架构与技术点

- **UI 框架**：SwiftUI
- **状态管理**：
  - `ObservableObject` + `@StateObject` + `@EnvironmentObject`
  - `@Published` 属性用于驱动界面刷新
- **计时实现**：
  - 使用 `Combine.Timer`（`Timer.publish(every:on:in:)` + `.autoconnect()`）
- **配置持久化**：
  - `@AppStorage` / `UserDefaults` 存储番茄时长设置
- **动画与交互**：
  - SwiftUI 内置动画：`withAnimation`、`scaleEffect`、`opacity` 等
  - 轻触小猫的交互动效

整个项目按照 **MVVM + 模块分层** 的方式组织：

- `Models`：只关心数据结构与枚举，不依赖 UI
- `ViewModels`：封装业务逻辑和状态变化，面向 View 提供友好的属性/方法
- `Views`：尽量保持“展示 + 绑定”职责，不直接操作业务逻辑细节

这样的划分，方便后续继续扩展诸如：任务系统、统计页面、猫咪皮肤与内购等功能。

---

## 由 Copilot for Xcode / GPT‑5.1 生成的说明

本项目的大部分代码，是通过在 Xcode 中使用 **Copilot for Xcode（GPT‑5.1）** 与助手多轮对话协作完成的：

- 助手先帮忙规划整体功能和分阶段实现方案（MVP → 猫咪成长 → 任务统计 → 商业化）。
- 再逐步生成：模型、ViewModel、SwiftUI 视图和入口接线代码。
- 在每轮修改后，通过 `xcodebuild` 和错误检查工具修复编译问题，直到项目可以稳定运行。

你可以把这个仓库当作：

- **如何用 AI 辅助，从空工程逐步搭建一个完整 SwiftUI App 的示例**。
- 也可以直接在此基础上，继续用 Copilot / GPT 迭代新功能。

---

## 后续可以扩展的方向

这个 README 对应的只是 MVP 实现；根据最初的产品设想，你可以继续在此基础上扩展：

1. **猫咪成长 & 情绪系统**
   - 完成一个番茄获得经验值（XP）
   - 猫咪升级，解锁新姿势 / 表情
   - 根据连续使用天数、完成数量调整猫的心情

2. **任务与统计**
   - 为每个专注 session 关联一个任务（如“写代码”、“背单词”）
   - 使用 SwiftData 记录每日番茄日志
   - 新增“统计” Tab：日 / 周 / 月专注情况图表

3. **猫咪皮肤与装饰**
   - 为猫咪设计多套皮肤和装饰（帽子、围巾等）
   - 完成一定成就或消耗“虚拟小鱼干”解锁

4. **音效与更丰富的动画**
   - 专注结束/休息结束时增加提示音效
   - 使用 Lottie 或 SpriteKit 做更可爱的猫咪动画

5. **商业化（可选）**
   - 使用 StoreKit 集成内购或订阅，解锁高级猫咪、皮肤、统计功能

---

## 许可证

> 本仓库目前未显式指定开源许可证，如需使用/分发，请根据你的实际需求补充 LICENSE 文件。

你可以自由基于这个项目继续学习、实验或改造，若在开发中使用了 Copilot / GPT 生成的代码，建议在文档中保留相应说明。

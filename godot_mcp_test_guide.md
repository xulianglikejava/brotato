# Godot-MCP 测试指南

本指南将帮助您测试已安装的 Godot-MCP 是否正常工作，以及如何验证 Trae IDE 与 Godot 引擎的集成状态。

## 测试前准备

在开始测试前，请确保您已完成以下准备工作：

1. 已成功安装 Node.js 和 npm
2. 已成功克隆并编译 Godot-MCP 项目
3. 已在 Trae IDE 中配置好 MCP 设置
4. Godot 引擎已正确安装且可通过命令行访问
5. 您的 Godot 项目（如当前的 Brotato 项目）已准备就绪

## 测试步骤

### 1. 基础连接测试

**目标**：验证 Trae IDE 能否与 Godot-MCP 服务器建立连接

**步骤**：

1. 打开 Trae IDE
2. 打开您的 Godot 项目
3. 在 Trae 的底部状态栏查看 MCP 连接状态
4. 如果显示已连接，则表示基础连接成功

**预期结果**：Trae 状态栏显示 MCP 已连接，无错误信息

### 2. Godot 版本信息测试

**目标**：验证 Godot-MCP 是否能够正确获取 Godot 引擎的版本信息

**步骤**：

1. 在 Trae IDE 中打开命令面板（通常是 Ctrl+Shift+P 或 Cmd+Shift+P）
2. 输入 "Godot: Get Version" 或类似命令
3. 查看命令执行结果

**预期结果**：显示当前安装的 Godot 引擎版本号（例如："Godot Engine v4.4.stable.official"）

### 3. 项目分析测试

**目标**：验证 Godot-MCP 是否能够正确分析 Godot 项目结构

**步骤**：

1. 在 Trae IDE 中，右键点击项目根目录
2. 选择 "Godot: Analyze Project" 或类似选项
3. 等待分析完成
4. 查看生成的项目分析报告

**预期结果**：Trae 能够正确识别项目中的场景、脚本、资源等，并提供结构化的分析报告

### 4. 场景管理测试

**目标**：验证 Godot-MCP 是否能够创建和管理 Godot 场景

**步骤**：

1. 在 Trae IDE 中，右键点击 `scenes` 目录
2. 选择 "Godot: Create New Scene" 或类似选项
3. 指定场景名称（例如："test_scene"）和根节点类型（例如："Node2D"）
4. 点击确认创建
5. 检查 `scenes` 目录是否生成了新的 `.tscn` 文件

**预期结果**：成功创建新的场景文件，且文件内容符合 Godot 场景格式规范

### 5. 脚本编辑测试

**目标**：验证通过 Trae 编辑的脚本能否被 Godot 正确识别

**步骤**：

1. 在 Trae IDE 中打开一个现有的 GDScript 文件（例如：`scripts/characters/player.gd`）
2. 对脚本进行小的修改（例如：添加一个简单的注释）
3. 保存修改
4. 在 Godot 编辑器中打开同一个文件

**预期结果**：Godot 编辑器中能够看到相同的修改内容

### 6. 运行项目测试

**目标**：验证通过 Trae 是否能够启动并运行 Godot 项目

**步骤**：

1. 在 Trae IDE 中打开命令面板
2. 输入 "Godot: Run Project" 或类似命令
3. 观察是否能够成功启动 Godot 引擎并运行项目
4. 查看 Trae 中的调试输出窗口

**预期结果**：Godot 引擎成功启动，项目正常运行，Trae 能够捕获并显示游戏的调试输出信息

### 7. 调试输出测试

**目标**：验证 Godot-MCP 是否能够正确捕获 Godot 的调试输出

**步骤**：

1. 在 Trae IDE 中打开一个脚本文件（例如：`scripts/core/GameManage.gd`）
2. 在 `_ready()` 函数中添加一条打印语句：`print("Godot-MCP test: GameManage is ready")`
3. 保存修改
4. 通过 Trae 运行项目
5. 查看 Trae 中的调试输出窗口

**预期结果**：在调试输出窗口中能够看到 "Godot-MCP test: GameManage is ready" 这条信息

## 高级功能测试

如果基础测试都通过了，您还可以测试以下高级功能：

### 8. 节点操作测试

**目标**：验证 Godot-MCP 是否能够添加、修改和删除场景中的节点

**步骤**：

1. 在 Trae IDE 中打开一个场景文件
2. 使用命令或右键菜单添加一个新节点（例如：向场景中添加一个 Sprite2D 节点）
3. 设置节点的一些属性（例如：纹理、位置等）
4. 保存场景
5. 在 Godot 编辑器中打开该场景，验证节点是否正确添加和配置

**预期结果**：新节点被正确添加到场景中，属性设置正确

### 9. UID 管理测试（Godot 4.4+）

**目标**：验证 Godot-MCP 是否能够正确处理 Godot 4.4+ 中的 UID 系统

**步骤**：

1. 在 Trae IDE 中打开命令面板
2. 输入 "Godot: Get UID" 并选择一个资源文件
3. 查看返回的 UID 信息
4. 修改该资源文件并保存
5. 使用命令更新 UID 引用

**预期结果**：能够正确获取和更新资源的 UID 信息

## 常见问题和解决方案

### 测试失败的常见原因及解决方法

1. **MCP 服务器未启动**
   - **问题**：Trae 无法连接到 MCP 服务器
   - **解决方法**：手动启动 Godot-MCP 服务器：
     ```powershell
     cd godot-mcp
     node dist/index.js
     ```

2. **Godot 引擎路径配置错误**
   - **问题**：MCP 无法找到或启动 Godot 引擎
   - **解决方法**：检查系统环境变量中是否包含了 Godot 的安装路径，或在 Trae 的 MCP 配置中指定 Godot 引擎的完整路径

3. **权限问题**
   - **问题**：MCP 服务器没有足够的权限访问项目文件或执行操作
   - **解决方法**：以管理员身份运行 Trae IDE 和 Godot-MCP 服务器

4. **端口冲突**
   - **问题**：MCP 服务器使用的端口被其他程序占用
   - **解决方法**：在 Godot-MCP 的配置文件中修改默认端口

5. **版本不兼容**
   - **问题**：Godot-MCP 版本与 Godot 引擎版本不兼容
   - **解决方法**：确保使用的 Godot-MCP 版本支持您安装的 Godot 引擎版本

## 测试成功标准

当您完成上述测试后，如果满足以下条件，则表示 Godot-MCP 已成功集成：

1. Trae IDE 能够与 Godot-MCP 服务器建立稳定连接
2. 能够通过 Trae 获取 Godot 引擎的版本信息
3. 能够通过 Trae 分析项目结构
4. 能够通过 Trae 创建、编辑和管理场景和脚本
5. 能够通过 Trae 启动和运行 Godot 项目
6. 能够在 Trae 中查看 Godot 的调试输出信息

通过成功完成这些测试，您可以确保 Godot-MCP 已经正确集成到您的开发环境中，并且可以开始享受 AI 辅助开发带来的便利。
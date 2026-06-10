---
name: "build-webframework-dev"
description: "为web-framework打开发包(dev.zip)并部署到目标项目。执行npm run build:portal-dev，将dev.zip复制到目标项目的node_modules/portal-template目录，并删除dev文件夹。当用户请求打包web-framework开发包时调用此技能。"
---

# Web Framework 开发包构建技能

## 功能描述

此技能用于为 web-framework 项目打开发包，并将生成的 `dev.zip` 文件部署到指定的目标项目中。

## 执行流程

1. **执行构建命令**：在 web-framework 目录下执行 `npm run build:portal-dev`
2. **验证构建结果**：检查 `packages/portal-template` 目录下是否生成了 `dev.zip` 文件
3. **部署到目标项目**：
   - 将 `dev.zip` 复制到目标项目的 `node_modules/portal-template` 目录
   - 删除目标项目 `node_modules/portal-template` 目录下的 `dev` 文件夹（如果存在）

## 使用场景

当用户提出以下需求时，应调用此技能：
- "帮我打web-framework的npm开发包"
- "打包web-framework"
- "构建portal-dev包"
- "部署web-framework开发包到目标项目"

## 参数要求

### 必需参数

| 参数名 | 类型 | 说明 |
|--------|------|------|
| targetProjectPath | string | 目标项目的绝对路径，dev.zip将被部署到该项目的node_modules/portal-template目录 |

### 默认值

如果用户未提供目标项目路径，技能将询问用户目标项目位置。

## 依赖环境

- Node.js 环境
- web-framework 项目目录：`C:\Users\22695\workpalce\code\EAP5\平台\web-framework`
- 需要在 web-framework 目录下执行 npm 命令

## 注意事项

1. 确保 web-framework 项目已安装依赖（执行过 `npm install`）
2. 构建过程可能需要较长时间，请耐心等待
3. 如果目标项目不存在 `node_modules/portal-template` 目录，将自动创建
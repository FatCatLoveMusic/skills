---
name: idea-fe-web
description: 提供web-framework前端组件的使用支持，包括组件文档、工具函数和开发包构建。当项目包含portal-template依赖或用户需要web-framework相关操作时触发此技能。
metadata:
  version: "1.0"
  author: "xiewenjie"
---

# idea-fe-web

## 描述

提供 web-framework 前端框架的组件支持，包括组件文档、工具函数和开发包构建能力。帮助 AI 在 web-framework 项目中高效开发前端功能。

## 触发条件

### 适用场景
- 项目的 package.json 中包含 "portal-template" 字段
- 项目名称为 "web-framework"
- 用户请求 "打包web-framework"、"构建portal-dev"、"部署web-framework开发包" 等操作

### 不适用场景
- 仅查看 web-framework 文档或代码
- 项目不包含 portal-template 依赖且非 web-framework 项目
- 用户仅询问技术方案而无需实际操作

## 输入输出定义

### Input
- projectPath: string - 项目路径（可选，默认为当前工作目录）
- operationType: string - 操作类型（build/dev/deploy）
- targetProject: string - 目标部署项目（部署时必填）

### Output
- success: boolean - 操作是否成功
- message: string - 操作结果描述
- outputPath: string - 输出文件路径（构建成功时返回）

## 执行步骤

1. 验证项目环境：检查 package.json 是否包含 portal-template 依赖
2. 根据 operationType 选择对应操作：
   - build: 执行开发包构建
   - dev: 启动开发服务器
   - deploy: 部署到目标项目
3. 执行对应脚本或调用子技能
4. 返回执行结果

## 失败策略

- 项目验证失败：返回错误信息，提示检查项目配置
- 构建失败：返回错误日志，建议检查依赖或配置
- 部署失败：回滚操作，保留原始状态

## 技能结构

### 子技能目录
- `sub-skills/build-webframework-dev/` - web-framework开发包构建技能
- `sub-skills/getBasicInfo/` - 获取当前登录用户信息方法
- `sub-skills/dialog-template/` - 弹窗模板技能
- `sub-skills/list-template/` - 列表页面模板技能

### 快速入门
1. 需要打包 web-framework 开发包时，使用 `sub-skills/build-webframework-dev/` 子技能

## 使用方式

当检测到项目符合触发条件时，您可以：
1. 请求打包 web-framework 开发包（将调用 `build-webframework-dev` 子技能）

## 全局API服务前缀

web-framework 提供了以下全局接口服务前缀，这些前缀已包含 API 版本号：

| 服务前缀 | 说明 | 使用示例 |
|---------|------|---------|
| `this.$aiServerUrl` | AI服务接口前缀 | `this.$get(\`${this.$aiServerUrl}/agent/chat/threads\`, ...)` |
| `this.$sysServerUrl` | 系统服务接口前缀 | `this.$get(\`${this.$sysServerUrl}/users\`, ...)` |

## 注意事项

- 该技能仅适用于 web-framework 项目或包含 portal-template 的项目
- 所有详细文档请查看技能目录下的各个 .md 文件
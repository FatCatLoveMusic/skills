---
name: "idea-fe-web"
description: "提供web-framework前端组件的使用支持，包括组件文档、工具函数和开发包构建。当项目包含portal-template依赖或用户需要web-framework相关操作时触发此技能。"
---

# idea-fe-web

## 技能名称
idea-fe-web

## 触发条件
当项目的package.json中包含"portal-template"字段，或者项目名称为"web-framework"时，可触发该技能。
当用户请求"打包web-framework"、"构建portal-dev"、"部署web-framework开发包"等相关操作时，也会触发此技能。

## 技能描述
该技能会帮助AI使用web-framework中的前端组件。web-framework是一个前端框架，包含丰富的UI组件和工具函数。

## 技能结构
由于该技能内容较多，主入口文件将指引您查找相关的.md文件以获取详细信息：

### 组件文档目录

### 子技能目录
- `sub-skills/build-webframework-dev/` - web-framework开发包构建技能，用于打包portal-dev并部署到目标项目
- `sub-skills/getBasicInfo/` - 获取当前登录用户信息方法的使用文档
- `sub-skills/dialog-template/` - 弹窗模板技能，基于 sapi-form-panel 组件实现，用于创建弹窗组件
- `sub-skills/list-template/` - 列表页面模板技能，包含查询、分页、增删改操作，用于创建列表页面组件

### 快速入门
1. 需要打包web-framework开发包时，使用 `sub-skills/build-webframework-dev/` 子技能

## 使用方式
当检测到项目符合触发条件时，您可以：
1. 请求打包web-framework开发包（将调用 `build-webframework-dev` 子技能）

## 全局API服务前缀

web-framework提供了以下全局接口服务前缀，这些前缀已包含API版本号（如v1），使用时无需额外添加版本路径：

| 服务前缀 | 说明 | 使用示例 |
|---------|------|---------|
| `this.$aiServerUrl` | AI服务接口前缀 | `this.$get(\`${this.$aiServerUrl}/agent/chat/threads\`, ...)` |
| `this.$sysServerUrl` | 系统服务接口前缀 | `this.$get(\`${this.$sysServerUrl}/users\`, ...)` |

## 注意事项
- 该技能仅适用于web-framework项目或包含portal-template的项目
- 所有详细文档请查看技能目录下的各个.md文件
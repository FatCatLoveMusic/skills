---
name: idea-fe-web
description: web-framework前端开发技能集合总入口。当项目包含portal-template依赖或用户需要web-framework相关操作时激活。提供全局API前缀、组件规范、以及各子技能的索引导航。
---

# idea-fe-web

## 概述

web-framework 前端开发技能集合，为 AI 提供在 web-framework 项目中高效开发的能力。包含组件模板、工具方法、构建部署等技能。

## 技能索引

### 构建部署
- **build-dev-package** - 打包 web-framework 开发包并部署到目标项目

### 组件模板
- **dialog-template** - 弹窗组件模板（基于 sapi-form-panel）
- **list-template** - 列表页面模板（基于 sapi-list-layout）

### 工具与API
- **utils** - `this.$utils` 公共工具方法索引（80+ 工具函数）
- **userinfo** - 获取当前登录用户信息（`this.$getBasicInfo()`）

## 全局 API 服务前缀

web-framework 提供了以下全局接口服务前缀，这些前缀已包含 API 版本号：

| 服务前缀 | 说明 | 使用示例 |
|---------|------|---------|
| `this.$aiServerUrl` | AI服务接口前缀 | `this.$get(\`${this.$aiServerUrl}/agent/chat/threads\`, ...)` |
| `this.$sysServerUrl` | 系统服务接口前缀 | `this.$get(\`${this.$sysServerUrl}/users\`, ...)` |

## 通用规范

### 弹窗组件规范
- 基于 `sapi-form-panel` 组件实现
- 使用 `v-model` 控制显示/隐藏
- 包含分页表格时必须混入 `Vue.$mixins.pagerMixin`
- 在列表页面中，弹窗必须放在 `<template slot="other">` 插槽内

### 列表页面规范
- 基于 `sapi-list-layout` 组件实现
- 使用 `v-fixed-eltable-header` 固定表头
- `maxBodyHeight` 由组件提供，用于自适应表格高度
- 所有弹窗组件放在 `slot="other"` 插槽中

### 工具方法规范
- 组件内使用 `this.$utils.xxx()`
- 全局使用 `Vue.$utils.xxx()`
- 存储操作第三个参数 `signOutClear` 设为 `true` 时，退出登录自动清除

## 如何选择技能

| 用户需求 | 推荐技能 |
|---------|---------|
| 打包/部署 web-framework 开发包 | build-dev-package |
| 创建弹窗组件 | dialog-template |
| 创建列表页面 | list-template |
| 使用工具函数 | utils |
| 获取当前用户信息 | userinfo |

## 注意事项

- 所有技能仅适用于 web-framework 项目或包含 portal-template 依赖的项目
- 每个子技能都是独立的，可根据具体需求直接使用对应技能
- 详细用法请参考各子技能的 SKILL.md 文件

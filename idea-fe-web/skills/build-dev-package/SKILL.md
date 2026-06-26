---
name: build-dev-package
description: 打包web-framework开发包(dev.zip)并部署到目标项目。当用户请求"打包web-framework"、"构建portal-dev"、"部署web-framework开发包"、"打npm开发包"时使用此技能。执行npm run build:portal-dev，将dev.zip复制到目标项目node_modules/portal-template目录。
---

# build-dev-package

## 描述

为 web-framework 项目打开发包，并将生成的 `dev.zip` 文件部署到指定的目标项目中。

## 触发条件

### 适用场景
- 用户请求"帮我打web-framework的npm开发包"
- 用户请求"打包web-framework"
- 用户请求"构建portal-dev包"
- 用户请求"部署web-framework开发包到目标项目"

### 不适用场景
- 仅查看 web-framework 构建配置
- 生产环境构建（build:prod）
- 目标项目不包含 portal-template 依赖

## 输入输出定义

### Input
- targetProjectPath: string - 目标项目的绝对路径，dev.zip将被部署到该项目的node_modules/portal-template目录（必填）
- sourceProjectPath: string - web-framework 项目路径（可选，默认为 C:\Users\22695\workpalce\code\EAP5\平台\web-framework）

### Output
- success: boolean - 操作是否成功
- message: string - 操作结果描述
- outputPath: string - dev.zip 输出路径（成功时返回）
- deployPath: string - 部署到目标项目的路径（成功时返回）

## 执行步骤

1. 验证环境：检查 web-framework 项目是否存在，确认已安装依赖
2. 执行构建：在 web-framework 目录下执行 `npm run build:portal-dev`
3. 验证构建结果：检查 `packages/portal-template` 目录下是否生成了 `dev.zip` 文件
4. 准备目标目录：确保目标项目的 `node_modules/portal-template` 目录存在，不存在则创建
5. 部署文件：将 `dev.zip` 复制到目标项目的 `node_modules/portal-template` 目录
6. 清理旧文件：删除目标项目 `node_modules/portal-template` 目录下的 `dev` 文件夹（如果存在）
7. 返回结果：返回构建和部署的执行结果

## 失败策略

- web-framework 项目不存在：返回错误信息，提示指定正确的项目路径
- 依赖未安装：提示先执行 `npm install`
- 构建命令执行失败：返回错误日志，建议检查依赖或配置
- dev.zip 未生成：提示构建失败，查看构建日志
- 目标项目路径不存在：返回错误信息，提示指定正确的目标项目路径
- 文件复制失败：返回错误信息，检查文件权限

## 示例

### 输入示例
- "帮我打web-framework的npm开发包，部署到adp项目"
- "打包web-framework开发包到 D:\\project\\myapp"

### 输出示例
```
success: true
message: "构建并部署成功"
outputPath: "C:\\...\\web-framework\\packages\\portal-template\\dev.zip"
deployPath: "D:\\project\\myapp\\node_modules\\portal-template\\dev.zip"
```

## 注意事项

- 确保 web-framework 项目已安装依赖（执行过 `npm install`）
- 构建过程可能需要较长时间，请耐心等待
- 如果目标项目不存在 `node_modules/portal-template` 目录，将自动创建
- 部署前会删除目标目录下的 `dev` 文件夹（如果存在）

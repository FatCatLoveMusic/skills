---
name: build-dev-package
description: 打包web-framework开发包(dev.zip)并部署到目标项目，以及打包发布web-framework npm包。当用户请求"打包web-framework"、"构建portal-dev"、"部署web-framework开发包"、"打npm开发包"、"发布web-framework"、"打包发布"时使用此技能。
---

# build-dev-package

## 描述

为 web-framework 项目提供两种打包能力：
1. **开发包**：执行 `npm run build:portal-dev`，将生成的 `dev.zip` 部署到目标项目
2. **发布包**：更新版本号、生成改动记录、执行 `npm run build:portal` 打包发布产物

---

# 一、开发包（dev.zip）

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

---

# 二、发布包（publish.zip）

## 触发条件

### 适用场景
- 用户请求"发布web-framework"
- 用户请求"打包发布web-framework"
- 用户请求"发布web-framework npm包"
- 用户请求"正式发布web-framework"

### 不适用场景
- 打开发包（dev.zip）→ 使用上面的"开发包"流程
- 仅修改版本号不打包
- 非 web-framework 项目（只有 web-framework 能发布 npm 包）

## 输入输出定义

### Input
- version: string - 发布版本号，例如 `1.10.25`（必填，由用户确认）
- versionTime: string - 版本日期，格式 `YYYY-MM-DD`，默认使用当天日期
- sourceProjectPath: string - web-framework 项目路径（可选，默认为 C:\Users\22695\workpalce\code\EAP5\平台\web-framework）

### Output
- success: boolean - 操作是否成功
- message: string - 操作结果描述
- outputFiles: string[] - 生成的文件列表（metas, build.zip, dev.zip, publish.zip）

## 执行步骤

### 步骤1：确认当前分支

使用 `git branch --show-current` 获取当前分支，然后使用 AskUserQuestion 工具向用户确认是否基于当前分支打包：
- 显示当前分支名称（如 `develop`、`release/1.10.x`）
- 询问用户是否确认基于该分支打包

如果用户选择"否"，则提示用户先切换到目标分支，然后重新执行技能。

### 步骤2：确认发布版本号

使用 AskUserQuestion 工具向用户确认发布版本号，需要提供以下信息：
- 当前版本号（从 `packages/portal-template/package.json` 的 version 字段读取）
- 让用户输入新的发布版本号

版本号格式示例：
- 正式版本：`1.10.25`
- Alpha版本：`1.10.25-alpha.1`
- RC版本：`1.10.25-rc.1`

### 步骤3：判断版本类型并更新版本信息

根据版本号判断是否为正式版本：
- **正式版本**（无 `-alpha`、`-rc` 等后缀）：需要更新所有四个文件
- **预发布版本**（包含 `-alpha`、`-rc` 等后缀）：只更新 `packages/portal-template/package.json`

#### 3.1 正式版本更新（version 不包含 -alpha、-rc）

修改以下四个文件中的版本信息：

**文件1**: `src/static/config-local.js`
- 修改 `frameworkVersion` 为 `'v{version}'`（如 `'v1.10.25'`）
- 修改 `versionTime` 为 `'YYYY-MM-DD'`（当天日期）

**文件2**: `src/static/config.js`
- 修改 `frameworkVersion` 为 `'v{version}'`
- 修改 `versionTime` 为 `'YYYY-MM-DD'`

**文件3**: `packages/portal-template/package.json`
- 修改 `version` 字段为 `{version}`

**文件4**: `README.md` - 生成并插入版本改动记录（见步骤4）

#### 3.2 预发布版本更新（version 包含 -alpha、-rc）

仅修改 `packages/portal-template/package.json`：
- 修改 `version` 字段为 `{version}`

**注意**：预发布版本不需要更新 `config-local.js`、`config.js` 和 `README.md`。

### 步骤4：生成版本改动记录（仅正式版本）

1. 获取 git 历史提交记录，从上一个版本的 tag 到当前 HEAD：
   ```bash
   git log --oneline <上一个版本tag>..HEAD
   ```

2. 根据提交记录生成**精简**的改动记录，每条记录控制在一行内，合并重复或相似的内容，只保留关键改动，格式参考：
   ```
   ### <a name="3_NNN">v{version}({versionTime})</a>
   1. fix 修复xxx问题
   2. feat 新增xxx功能
   ```
   每条改动分类为 `fix`（修复）或 `feat`（新增功能），控制改动记录在 3-8 条之间。

3. 使用 AskUserQuestion 工具向用户展示生成的改动记录，并询问是否确认使用。用户可以：
   - 确认使用（直接插入 README.md）
   - 手动修改（用户提供新的改动记录）

4. 将确认后的改动记录插入到 README.md 的"版本内容"章节中，放在最新版本的位置（即"<a name=\"3\">版本内容</a>"下方第一个版本条目）。

   同时更新导航栏，在 `>>- <a href="#3">版本内容</a>` 下方添加新版本的导航链接，格式为：
   ```
   >>>- <a href="#3_NNN">v{version}</a>
   ```
   其中 `NNN` 为递增的序号（当前最大是 191，则新版本为 192）。

### 步骤5：执行构建

在 web-framework 项目根目录执行：
```bash
npm run build:portal
```

等待构建完成，确认命令执行成功（退出码为 0）。

### 步骤6：验证构建产物

检查 `packages/portal-template` 目录下是否生成了以下文件：
- `metas/` 目录（或相关配置文件）
- `build.zip`
- `dev.zip`
- `publish.zip`

如果全部生成成功，则打包成功。

### 步骤7：提示用户发布

打包成功后，提醒用户：

> 打包完成！请在 `packages/portal-template` 目录下打开集成终端，执行以下命令发布 npm 包：
> ```
> npm publish
> ```
> 注意：发布需要 `http://172.56.71.101:7077/repository/npm_group/` 的发布权限，需要账号密码认证，请手动完成。

## 失败策略

- 构建命令执行失败：返回错误日志，建议检查依赖或配置
- 构建产物缺失：列出缺失的文件，提示构建可能不完整
- 版本号冲突：提醒用户版本号已存在，需确认是否覆盖
- git 历史获取失败：提示用户手动填写改动记录

## 示例

### 输入示例
- "发布web-framework，版本 1.10.25"
- "打包发布web-framework"

### 输出示例
```
success: true
message: "web-framework v1.10.25 发布包构建完成"
version: "1.10.25"
versionTime: "2026-07-03"
outputFiles: ["metas/", "build.zip", "dev.zip", "publish.zip"]
nextStep: "请在 packages\portal-template 目录下执行 npm publish 手动发布"
```

## 注意事项

- 只有 web-framework 项目能发布 npm 包，其他项目不适用
- 发布前必须确认当前分支是否正确
- 正式版本需要同步更新四个文件（config-local.js、config.js、package.json、README.md）
- 预发布版本（alpha/rc）仅更新 package.json
- 版本改动记录需要用户确认后才会插入 README.md
- 发布需要 npm 仓库权限，无法自动化，必须由用户手动执行 `npm publish`

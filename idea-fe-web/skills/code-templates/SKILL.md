---
name: code-templates
description: Web-framework代码模板集合,提供弹窗模板、列表页面模板等。当用户需要创建弹窗组件、列表页面、管理页面、数据表格页面、增删改查页面时触发此技能。
---

# code-templates

## 描述

web-framework 提供了一套标准化的代码模板集合，用于快速生成各类功能代码。当前包含以下模板：

- **弹窗模板**：基于 `sapi-form-panel` 组件的各类弹窗
- **列表页面模板**：基于 `sapi-list-layout` 组件的列表管理页面

后续将持续增加更多模板类型。

## 触发条件

### 弹窗模板适用场景
- 用户需要创建弹窗组件
- 用户需要创建编辑弹窗
- 用户需要创建详情弹窗
- 用户需要创建确认弹窗
- 用户需要创建自定义弹窗
- 用户需要基于 sapi-form-panel 实现弹窗

### 列表模板适用场景
- 用户需要创建列表页面组件
- 用户需要创建数据管理页面
- 用户需要创建带查询和分页的表格页面
- 用户需要基于 sapi-list-layout 实现页面
- 用户需要创建增删改查页面

### 不适用场景
- 仅使用 Element UI 原生组件（el-dialog、el-table 等）
- 创建非业务功能页面
- 不需要 web-framework 特定组件的简单功能

## 输入输出定义

### Input
根据用户需求，模板系统可接受以下参数：

**弹窗模板参数**：
- dialogType: string - 弹窗类型（edit/detail/custom）（可选，默认为 custom）
- hasPager: boolean - 是否包含分页表格（可选，默认为 false）
- title: string - 弹窗标题（可选）
- width: string - 弹窗宽度（可选，默认为 '800px'）

**列表模板参数**：
- pageType: string - 页面类型（standard/simple）（可选，默认为 standard）
- hasFilters: boolean - 是否有查询条件（可选，默认为 true）
- hasPager: boolean - 是否有分页（可选，默认为 true）
- hasDialog: boolean - 是否有弹窗（可选，默认为 true）
- apiUrl: string - 数据接口地址（可选）

### Output
- success: boolean - 操作是否成功
- componentCode: string - 生成的组件代码
- message: string - 操作结果描述

## 执行步骤

1. **确认需求**：根据用户描述确定需要的模板类型（弹窗/列表）及具体参数
2. **选择模板**：根据需求选择对应的基础模板或组合模板
3. **生成代码**：基于模板生成完整的 Vue 组件代码
4. **检查规范**：验证代码是否符合 web-framework 规范
5. **返回结果**：返回生成的组件代码和使用说明

## 失败策略

- 需求不明确：询问用户具体需求（页面功能、数据结构等）
- 模板生成失败：返回错误信息，提供基础模板示例
- 参数错误：提示正确的参数格式和可选值

## 模板参考文档

本技能包含以下参考文档，详细内容请查阅：

### 1. 弹窗模板参考
**文件位置**：[references/dialog-template.md](file:///c:/Users/22695/workpalce/myself/skills/idea-fe-web/skills/code-templates/references/dialog-template.md)

**内容概要**：
- 基础弹窗模板
- 带分页表格的弹窗模板
- pagerMixin 使用说明
- 弹窗使用说明和注意事项

### 2. 列表页面模板参考
**文件位置**：[references/list-template.md](file:///c:/Users/22695/workpalce/myself/skills/idea-fe-web/skills/code-templates/references/list-template.md)

**内容概要**：
- 列表页面模板结构
- 更多筛选功能
- 弹窗组件位置规范（重要）
- 常用方法和数据结构
- 检查清单和常见问题排查

## 使用流程

1. 根据用户需求判断使用哪种模板
2. 读取对应的参考文档，获取完整的模板代码和说明
3. 根据参数定制化生成代码
4. 确保遵循关键规范（如弹窗位置、mixin 混入等）
5. 提供生成结果和使用指导
---
name: list-template
description: web-framework列表页面模板，基于sapi-list-layout组件，包含查询条件、操作按钮、数据表格、分页器。当用户需要创建列表页面、管理页面、数据表格页面、增删改查页面时使用此技能。弹窗组件必须放在slot="other"插槽内。
---

# list-template

## 描述

web-framework 提供了列表页面模板，包含查询、分页、增删改操作，用于快速创建列表页面。

## 触发条件

### 适用场景
- 用户需要创建列表页面组件
- 用户需要创建数据管理页面
- 用户需要创建带查询和分页的表格页面
- 用户需要基于 sapi-list-layout 实现页面

### 不适用场景
- 仅使用 Element UI 的 el-table 组件
- 创建非列表类页面
- 不需要 sapi-list-layout 布局的简单表格

## 输入输出定义

### Input
- pageType: string - 页面类型（standard/simple）（可选，默认为 standard）
- hasFilters: boolean - 是否有查询条件（可选，默认为 true）
- hasPager: boolean - 是否有分页（可选，默认为 true）
- hasDialog: boolean - 是否有弹窗（可选，默认为 true）
- apiUrl: string - 数据接口地址（可选）

### Output
- success: boolean - 操作是否成功
- componentCode: string - 生成的列表页面组件代码
- message: string - 操作结果描述

## 执行步骤

1. 确认需求：确定页面类型、是否需要查询、分页、弹窗等功能
2. 选择模板：根据需求选择对应的列表模板
3. 生成代码：基于模板生成完整的 Vue 组件代码
4. 检查规范：验证代码是否符合 web-framework 规范，特别是弹窗位置规范
5. 返回结果：返回生成的组件代码和使用说明

## 失败策略

- 需求不明确：询问用户具体需求（页面功能、数据结构等）
- 模板生成失败：返回错误信息，提供基础模板示例
- 参数错误：提示正确的参数格式和可选值

## 模板结构

```vue
<template>
    <sapi-list-layout>
        <template slot="filters">
            <!-- 查询条件 -->
        </template>

        <template slot="btns">
            <!-- 操作按钮 -->
        </template>

        <template slot="table">
            <el-table
                border
                v-fixed-eltable-header
                :data="tableData"
                ref="bodyTable"
                :height="maxBodyHeight"
                @sort-change="sortChange"
            >
                <!-- 表格列定义 -->
            </el-table>
        </template>

        <template slot="pagination">
            <el-pagination
                @size-change="pageSizeChange"
                @current-change="pageCurrentChange"
                :current-page="params.pageIndex"
                :page-sizes="pageArr"
                :page-size="params.pageSize"
                :layout="layout"
                :total="pageTotal">
            </el-pagination>
        </template>

        <template slot="other">
            <!-- 弹窗组件必须放在这里 -->
        </template>
    </sapi-list-layout>
</template>
```

## 重要注意事项

### 弹框组件位置

**强制要求**：所有弹窗组件（包括编辑弹窗、详情弹窗、确认弹窗、自定义弹窗等）**必须**放置在 `<template slot="other">` 插槽内。

**原因说明**：
- `sapi-list-layout` 组件内部使用了 `keep-alive` 和 `transition` 进行页面状态管理
- 弹窗组件如果放在插槽外部或其他位置，会导致：
  - 弹窗无法正常显示（被遮罩层覆盖或渲染在错误层级）
  - 弹窗状态无法正确响应（v-model 绑定失效）
  - 组件生命周期异常（mounted 不触发或重复触发）
  - 样式冲突（z-index 层级错误）

**✅ 正确示例**：
```vue
<sapi-list-layout>
    <template slot="filters">...</template>
    <template slot="table">...</template>
    <template slot="pagination">...</template>
    
    <!-- ✅ 弹窗组件正确位置 -->
    <template slot="other">
        <edit-dialog v-model="editVisible" :row="currentRow"></edit-dialog>
        <detail-dialog v-model="detailVisible" :id="detailId"></detail-dialog>
        <confirm-dialog v-model="confirmVisible"></confirm-dialog>
        <custom-dialog v-model="customVisible" :thread-id="threadId"></custom-dialog>
    </template>
</sapi-list-layout>
```

**❌ 错误示例1**（弹窗放在组件外部）：
```vue
<sapi-list-layout>
    <template slot="filters">...</template>
    <template slot="table">...</template>
</sapi-list-layout>
<!-- ❌ 错误：弹窗组件放在 sapi-list-layout 外部 -->
<edit-dialog v-model="editVisible"></edit-dialog>
```

**❌ 错误示例2**（弹窗放在其他插槽内）：
```vue
<sapi-list-layout>
    <template slot="filters">
        <!-- ❌ 错误：弹窗组件放在 filters 插槽内 -->
        <edit-dialog v-model="editVisible"></edit-dialog>
        ...
    </template>
    <template slot="table">...</template>
</sapi-list-layout>
```

**❌ 错误示例3**（弹窗直接放在组件内部但不在插槽中）：
```vue
<sapi-list-layout>
    <!-- ❌ 错误：弹窗组件直接放在组件内但不在任何 slot 中 -->
    <edit-dialog v-model="editVisible"></edit-dialog>
    <template slot="filters">...</template>
    <template slot="table">...</template>
</sapi-list-layout>
```

## 常用方法说明

| 方法名 | 说明 | 参数 |
|-------|------|------|
| `loadData()` | 加载列表数据 | 无 |
| `openAddDialog()` | 打开新增弹窗 | 无 |
| `openEditDialog(row)` | 打开编辑弹窗 | row: 当前行数据 |
| `deleteItems(row)` | 删除数据 | row: 当前行数据 |
| `filterChange()` | 查询条件变更 | 无 |
| `pageSizeChange(size)` | 每页条数变更 | size: 每页条数 |
| `pageCurrentChange(index)` | 当前页码变更 | index: 当前页码 |
| `sortChange(obj)` | 排序变更 | obj: 排序对象 |

## 数据结构

| 字段名 | 类型 | 说明 |
|-------|------|------|
| `tableData` | Array | 表格数据 |
| `pageTotal` | Number | 总记录数 |
| `params.pageIndex` | Number | 当前页码 |
| `params.pageSize` | Number | 每页条数 |
| `params.keywords` | String | 搜索关键词 |
| `subView` | String | 弹窗组件名称 |
| `subVisible` | Boolean | 弹窗显示状态 |
| `subOption` | Object | 弹窗参数 |

## 使用示例

```javascript
// 打开编辑弹窗
openEditDialog(row) {
    this.subView = 'form-comp';
    this.subOption = { mode: 'Edit', id: row.id };
    this.subVisible = true;
},

// 打开自定义弹窗（如调用次数弹窗）
openCallCountDialog(row) {
    this.currentThreadId = row.id;
    this.callCountDialogVisible = true;
}
```

## 检查清单

在创建或修改列表页面时，请检查以下几点：

1. 所有弹窗组件是否都在 `<template slot="other">` 插槽内
2. 弹窗组件是否使用 `v-model` 绑定显示状态
3. 是否正确传递了弹窗所需的参数（如 id、row 数据等）
4. 弹窗关闭时是否正确清理了相关状态

## 常见问题排查

| 问题现象 | 可能原因 | 解决方案 |
|---------|---------|---------|
| 弹窗打开后看不到内容 | 弹窗放在了错误位置 | 将弹窗移到 `<template slot="other">` 中 |
| 弹窗显示在遮罩层下方 | z-index 层级问题 | 确保弹窗在 `other` 插槽内 |
| 弹窗打开时接口重复调用 | 弹窗初始化逻辑问题 | 检查 watch 和 mounted 中的调用逻辑 |
| 弹窗关闭后再次打开数据未更新 | 状态未重置 | 在 close 方法中重置相关数据 |

## 示例

### 输入示例
- "创建一个用户管理列表页面"
- "做一个带查询和分页的数据列表"
- "基于 sapi-list-layout 创建列表页"

### 输出示例
- 返回符合规范的 Vue 列表页面组件代码
- 包含查询条件、操作按钮、数据表格、分页器
- 弹窗组件正确放置在 `other` 插槽内

## 注意事项

- 列表页面中的所有弹窗组件必须放在 `<template slot="other">` 插槽内
- 分页功能依赖 `Vue.$mixins.pagerMixin`，确保已正确混入
- 使用 `v-fixed-eltable-header` 指令固定表头
- `maxBodyHeight` 由 `sapi-list-layout` 提供，用于自适应表格高度

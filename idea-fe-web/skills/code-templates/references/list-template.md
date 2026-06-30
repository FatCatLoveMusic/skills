# 列表页面模板参考

## 描述

web-framework 提供了列表页面模板，包含查询、分页、增删改操作，用于快速创建列表页面。

## 模板结构

```vue
<template>
    <sapi-list-layout>
        <template slot="filters">
            <!-- 主要查询条件（始终显示） -->
        </template>

        <template slot="filters-more">
            <!-- 更多筛选条件（可折叠显示） -->
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

### 更多筛选（filters-more）

`slot="filters-more"` 用于放置次要查询条件，这些条件会被默认折叠到"更多筛选"区域中。

**使用场景**：
- 不常用的筛选条件
- 日期范围等占用空间较大的筛选
- 需要折叠以保持界面简洁的场景

### 筛选记录显示（addFilterRecord）

**重要**：当 `filters-more` 中的筛选条件发生变更时，**必须**调用 `this.addFilterRecord()` 方法在列表顶部生成筛选记录标签。这样在"更多筛选"区域折叠起来时，用户仍然能看到当前应用的筛选条件。

**方法说明**：
- `addFilterRecord` 是 web-framework 通过 `baseInit.js` 注入到页面组件中的方法
- 用于在页面顶部的筛选结果区域显示当前筛选条件
- 用户点击筛选记录标签上的关闭按钮时，会触发 `remove` 函数重置筛选条件

**参数结构**：
```javascript
{
    key: string,      // 当前筛选唯一标识，用于去重和移除
    label: string,    // 当前筛选结果文本，如 "模型类型: 聊天"；为空字符串时会清空该筛选记录
    remove: Function  // 重置函数，当用户点击关闭时执行
}
```

**清空筛选记录**：
当需要移除某个筛选记录时，可以调用 `this.addFilterRecord({ key: 'xxx', label: '' })`，传入空的 `label` 参数即可清空指定 key 的筛选记录。

**应用场景**：
- 用户取消筛选条件时，主动清空对应的顶部筛选记录
- 筛选条件变更导致之前的筛选记录不再有效时

**完整示例**：
```vue
<template>
    <sapi-list-layout>
        <!-- 主要查询条件（始终显示） -->
        <template slot="filters">
            <sapi-filter-item :label="$t('xxx.status')">
                <el-select v-model="params.status" clearable @change="filterChange">
                    <el-option label="全部" value=""></el-option>
                    <el-option v-for="item in statusOptions" :key="item.value" :label="item.label" :value="item.value"></el-option>
                </el-select>
            </sapi-filter-item>
            <sapi-filter-item :label="$t('xxx.agent')">
                <el-select v-model="params.agentName" clearable @change="agentChange">
                    <el-option label="全部" value=""></el-option>
                    <el-option v-for="item in agentOptions" :key="item.value" :label="item.label" :value="item.value"></el-option>
                </el-select>
            </sapi-filter-item>
            <!-- 条件显隐：根据其他筛选值动态显示/隐藏 -->
            <sapi-filter-item :label="$t('xxx.assistant')" v-if="['knowledge_qa', 'chat_bi'].includes(params.agentName)">
                <el-select v-model="params.ns" clearable @change="filterChange">
                    <el-option label="全部" value=""></el-option>
                    <el-option v-for="item in assistantOptions" :key="item.value" :label="item.label" :value="item.value"></el-option>
                </el-select>
            </sapi-filter-item>
        </template>

        <!-- 更多筛选（折叠区域） -->
        <template slot="filters-more">
            <sapi-filter-item :label="$t('xxx.date')">
                <el-date-picker
                    v-model="dateRange"
                    type="daterange"
                    range-separator="-"
                    :start-placeholder="$t('xxx.startDate')"
                    :end-placeholder="$t('xxx.endDate')"
                    style="width: 280px;"
                    @change="onDateRangeChange"
                    value-format="yyyy-MM-dd"
                ></el-date-picker>
            </sapi-filter-item>
            <sapi-filter-item :label="$t('xxx.status')">
                <sapi-tile-filter
                    v-model="params.status"
                    :props="{ label: 'label', value: 'value' }"
                    :data="statusOptions"
                    @change="onTileFilterChange('status', $event, $t('xxx.status'), { label: 'label', value: 'value' })"
                ></sapi-tile-filter>
            </sapi-filter-item>
        </template>

        <template slot="table">
            <!-- ... -->
        </template>

        <template slot="other">
            <!-- ... -->
        </template>
    </sapi-list-layout>
</template>

<script>
export default {
    mixins: [Vue.$mixins.pagerMixin, Vue.$mixins.filterMixin],
    data() {
        return {
            agentOptions: [],
            assistantOptions: [],
            dateRange: [],
            params: {
                status: '',
                agentName: '',
                ns: '',
                startDate: '',
                endDate: '',
                pageIndex: 1,
                pageSize: 20,
            }
        };
    },
    methods: {
        // 智能体切换时重置助手选项
        agentChange() {
            this.params.ns = '';
            this.assistantOptions = [];
            this.getAssistants();
            this.filterChange();
        },
        // 加载助手列表（仅特定智能体需要）
        getAssistants() {
            if (!['knowledge_qa', 'chat_bi'].includes(this.params.agentName)) return;
            this.$get(`${this.$aiServerUrl}/agent/trace/list/${this.params.agentName}/namespaces`, {
                user_id: this.$getBasicInfo().id,
                page_index: 1,
                page_size: 99
            }, res => {
                this.assistantOptions = (res.rows || []).map(item => ({
                    value: item.ns,
                    label: item.ns_title,
                }));
            });
        },
        // 日期范围变更（带筛选记录）
        onDateRangeChange() {
            const _this = this;
            const hasValue = this.dateRange && this.dateRange.length === 2;
            const label = hasValue ? `${this.$t('xxx.date')}${this.dateRange.join(' - ')}` : '';
            
            this.addFilterRecord({
                key: 'dateRange',
                label: label,
                remove() {
                    _this.dateRange = [];
                    _this.params.startDate = '';
                    _this.params.endDate = '';
                    _this.params.pageIndex = 1;
                    _this.loadData();
                }
            });

            if (hasValue) {
                this.params.startDate = this.dateRange[0];
                this.params.endDate = this.dateRange[1];
            } else {
                this.params.startDate = '';
                this.params.endDate = '';
            }
            this.params.pageIndex = 1;
            this.loadData();
        },
        // Tile筛选变更（带筛选记录）
        onTileFilterChange(key, item, label, props, allowFalse = false) {
            const _this = this;
            const value = item ? item[props.value] : '';
            const hasValue = allowFalse ? value !== '' : !!value;
            const displayLabel = hasValue ? `${label}${item[props.label]}` : '';

            this.params[key] = hasValue ? value : '';
            this.addFilterRecord({
                key: key,
                label: displayLabel,
                remove() {
                    _this.params[key] = '';
                    _this.params.pageIndex = 1;
                    _this.loadData();
                }
            });
            this.params.pageIndex = 1;
            this.loadData();
        },
        // 通用筛选变更（filters 区域使用）
        filterChange() {
            this.params.pageIndex = 1;
            this.loadData();
        },
        loadData() {
            const params = {
                agent_name: this.params.agentName || null,
                ns: this.params.ns || null,
                start: this.params.startDate || null,
                end: this.params.endDate || null,
                page_index: this.params.pageIndex,
                page_size: this.params.pageSize,
            };
            this.$get(`${this.$aiServerUrl}/xxx/list`, params, res => {
                this.tableData = res.rows || [];
                this.pageTotal = res.total || 0;
            });
        },
    },
    created() {
        this.$init();
        this.loadAgentOptions(); // 加载智能体列表
    }
};
</script>
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
| `addFilterRecord(record)` | 在页面顶部添加筛选记录标签 | record: { key, label, remove } |

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
5. `filters-more` 中的筛选条件变更时是否调用了 `addFilterRecord` 在顶部生成筛选记录

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
- `filters-more` 中的筛选条件变更时，**必须**调用 `this.addFilterRecord()` 在页面顶部生成筛选记录，确保折叠后仍能看到筛选条件
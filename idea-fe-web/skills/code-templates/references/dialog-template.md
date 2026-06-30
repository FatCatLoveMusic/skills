# 弹窗模板参考

## 描述

web-framework 提供了基于 sapi-form-panel 组件的弹窗模板，用于创建各种弹窗组件（如编辑弹窗、详情弹窗等）。

## 模板结构

### 基础弹窗模板

```vue
<template>
    <sapi-form-panel
        :dialog="!append"
        :dialog-options="{ width: '800px', top: '15%' }"
        v-model="visible"
        @on-open="open"
        @on-close="close"
    >
        <template slot="title">
            <span>{{ title }}</span>
        </template>

        <template>
            <!-- 弹窗内容 -->
        </template>

        <template slot="footer">
            <el-button size="small" @click="close" v-text="$t('cancel')"></el-button>
        </template>
    </sapi-form-panel>
</template>

<script>
export default {
    props: {
        option: Object,
        value: Boolean,
        append: Boolean
    },
    data () {
        return {
            visible: false,
            title: ''
        }
    },
    watch: {
        value(val) {
            this.visible = this.value
        }
    },
    methods: {
        close () {
            this.$emit('input', false)
        },
    },
    mounted() {
        this.visible = this.value
    }
}
</script>
```

### 带分页表格的弹窗模板

**强制要求**：如果弹窗中包含表格并需要分页功能，**必须**在组件中混入 `Vue.$mixins.pagerMixin`，以确保分页参数和方法正常工作。

**原因说明**：
- `pagerMixin` 提供了分页所需的基础属性（如 `pageTotal`、`pageArr`、`layout`）和方法（如 `pageSizeChange`、`pageCurrentChange`）
- 如果不混入此 mixin，分页组件可能无法正常显示或分页事件无法响应

```vue
<template>
    <sapi-form-panel
        :dialog="!append"
        :dialog-options="{ width: '800px', top: '15%' }"
        v-model="visible"
        @on-open="open"
        @on-close="close"
    >
        <template slot="title">
            <span>{{ title }}</span>
        </template>

        <template>
            <el-table
                border
                :data="tableData"
                :height="400"
            >
                <el-table-column prop="query" :label="$t('question')"></el-table-column>
                <el-table-column prop="created_at" :label="$t('callTime')"></el-table-column>
            </el-table>

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

        <template slot="footer">
            <el-button size="small" @click="close" v-text="$t('cancel')"></el-button>
        </template>
    </sapi-form-panel>
</template>

<script>
export default {
    mixins: [Vue.$mixins.pagerMixin],
    props: {
        option: Object,
        value: Boolean,
        append: Boolean,
        threadId: String
    },
    data () {
        return {
            visible: false,
            title: '',
            tableData: [],
            params: {
                pageIndex: 1,
                pageSize: 20
            }
        }
    },
    watch: {
        value(val) {
            this.visible = val
        }
    },
    methods: {
        close () {
            this.$emit('input', false)
        },
        open() {
            this.params.pageIndex = 1
            this.loadData()
        },
        loadData() {
            this.$get(`${this.$aiServerUrl}/api/endpoint`, {
                page_index: this.params.pageIndex,
                page_size: this.params.pageSize
            }, res => {
                const pageData = res && res.data ? res.data : res || {}
                this.tableData = pageData.rows || []
                this.pageTotal = pageData.total || 0
            })
        }
    },
    mounted() {
        this.visible = this.value
    }
}
</script>
```

### pagerMixin 提供的属性和方法

| 属性/方法 | 类型 | 说明 |
|----------|------|------|
| `pageTotal` | Number | 总记录数，由 mixin 提供初始值 0 |
| `pageArr` | Array | 每页条数选项，默认 `[10, 20, 50]` |
| `layout` | String | 分页器布局，默认 `'total, sizes, prev, pager, next, jumper'` |
| `pageSizeChange(size)` | Function | 每页条数变更处理方法 |
| `pageCurrentChange(index)` | Function | 当前页码变更处理方法 |

## 使用说明

- 使用 `v-model` 控制弹窗的显示/隐藏
- 通过 `slot="title"` 定义弹窗标题
- 通过默认插槽定义弹窗主体内容
- 通过 `slot="footer"` 定义弹窗底部按钮
- 在 `open` 方法中处理弹窗打开时的逻辑
- 在 `close` 方法中处理弹窗关闭时的逻辑

## 示例

### 输入示例
- "创建一个编辑弹窗组件"
- "创建一个带表格分页的详情弹窗"
- "基于 sapi-form-panel 做一个弹窗"

### 输出示例
- 返回符合规范的 Vue 弹窗组件代码
- 包含分页功能时自动混入 `Vue.$mixins.pagerMixin`

## 注意事项

- 弹窗中使用分页功能时，必须混入 `Vue.$mixins.pagerMixin`
- 在列表页面中使用弹窗时，弹窗组件必须放置在 `<template slot="other">` 插槽内（详见列表模板说明）
- 弹窗关闭时注意清理相关状态，避免下次打开时数据残留
- 使用 `this.$emit('input', false)` 关闭弹窗，保持 v-model 双向绑定
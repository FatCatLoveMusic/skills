# Mixins 混合方法详解

web-framework 提供了一系列 Mixins（混合），用于复用常见的组件逻辑。

## Mixins 列表

### Vue.$mixins.pagerMixin

分页混合，提供分页相关的数据属性和方法。

**源码位置：** `src/mixins/pager.js`

**混入的数据属性：**

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `pageNum` | number | 1 | 当前页码 |
| `pageSize` | number | 20 | 每页条数 |
| `total` | number | 0 | 总记录数 |
| `pageSizes` | array | [10, 20, 50, 100] | 每页条数选项 |

**混入的方法：**

| 方法 | 说明 |
|------|------|
| `handleSizeChange(size)` | 每页条数变更处理 |
| `handleCurrentChange(page)` | 当前页变更处理 |
| `resetPage()` | 重置分页到第一页 |

---

### 使用示例

#### 基础用法

```vue
<template>
  <div>
    <el-table :data="tableData">
      <el-table-column prop="name" label="名称" />
      <el-table-column prop="status" label="状态" />
    </el-table>

    <el-pagination
      v-if="total > 0"
      :current-page="pageNum"
      :page-sizes="pageSizes"
      :page-size="pageSize"
      :total="total"
      layout="total, sizes, prev, pager, next, jumper"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
    />
  </div>
</template>

<script>
export default {
  mixins: [Vue.$mixins.pagerMixin],

  data() {
    return {
      tableData: []
    }
  },

  created() {
    this.loadData();
  },

  methods: {
    loadData() {
      this.$get('/api/list', {
        pageNum: this.pageNum,
        pageSize: this.pageSize
      }, (res) => {
        this.tableData = res.data.list;
        this.total = res.data.total;
      });
    },

    // 每页条数变更
    handleSizeChange(size) {
      this.pageSize = size;
      this.pageNum = 1;  // 重置到第一页
      this.loadData();
    },

    // 页码变更
    handleCurrentChange(page) {
      this.pageNum = page;
      this.loadData();
    },

    // 搜索时调用，重置分页
    handleSearch() {
      this.resetPage();  // 等同于 this.pageNum = 1
      this.loadData();
    }
  }
}
</script>
```

---

#### 配合搜索表单使用

```vue
<template>
  <div>
    <!-- 搜索表单 -->
    <el-form inline>
      <el-form-item label="名称">
        <el-input v-model="searchForm.name" placeholder="请输入名称" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleSearch">搜索</el-button>
        <el-button @click="handleReset">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 表格 -->
    <el-table :data="tableData">
      <el-table-column prop="name" label="名称" />
      <el-table-column prop="createTime" label="创建时间" />
    </el-table>

    <!-- 分页 -->
    <el-pagination
      v-if="total > 0"
      :current-page="pageNum"
      :page-sizes="pageSizes"
      :page-size="pageSize"
      :total="total"
      layout="total, sizes, prev, pager, next, jumper"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
    />
  </div>
</template>

<script>
export default {
  mixins: [Vue.$mixins.pagerMixin],

  data() {
    return {
      searchForm: {
        name: ''
      },
      tableData: []
    }
  },

  created() {
    this.loadData();
  },

  methods: {
    loadData() {
      this.$get('/api/list', {
        pageNum: this.pageNum,
        pageSize: this.pageSize,
        ...this.searchForm
      }, (res) => {
        this.tableData = res.data.list;
        this.total = res.data.total;
      });
    },

    handleSearch() {
      this.resetPage();  // 搜索时重置到第一页
      this.loadData();
    },

    handleReset() {
      this.searchForm = { name: '' };
      this.resetPage();
      this.loadData();
    },

    handleSizeChange(size) {
      this.pageSize = size;
      this.resetPage();
      this.loadData();
    },

    handleCurrentChange(page) {
      this.pageNum = page;
      this.loadData();
    }
  }
}
</script>
```

---

## Vue.$mixins.filterMixin

筛选混合，提供筛选相关的数据和方法。

**源码位置：** `src/static/js/baseInit`

**混入的数据属性：**

| 属性 | 类型 | 说明 |
|------|------|------|
| `filter` | object | 筛选条件对象 |
| `filterForm` | object | 筛选表单数据 |

**混入的方法：**

| 方法 | 说明 |
|------|------|
| `initFilter()` | 初始化筛选条件 |
| `resetFilter()` | 重置筛选条件 |
| `buildFilterParams()` | 构建筛选参数 |

---

### 使用示例

```vue
<template>
  <div>
    <!-- 筛选表单 -->
    <div class="filter-bar">
      <el-select v-model="filter.status" placeholder="请选择状态" clearable>
        <el-option label="启用" value="1" />
        <el-option label="禁用" value="0" />
      </el-select>

      <el-date-picker
        v-model="filter.dateRange"
        type="daterange"
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        value-format="yyyy-MM-dd"
      />

      <el-button type="primary" @click="handleFilter">筛选</el-button>
      <el-button @click="resetFilter">重置</el-button>
    </div>

    <el-table :data="tableData" />

    <el-pagination
      v-if="total > 0"
      :current-page="pageNum"
      :page-size="pageSize"
      :total="total"
      @current-change="loadData"
    />
  </div>
</template>

<script>
export default {
  mixins: [Vue.$mixins.pagerMixin, Vue.$mixins.filterMixin],

  data() {
    return {
      tableData: []
    }
  },

  created() {
    this.initFilter();  // 初始化筛选条件
    this.loadData();
  },

  methods: {
    initFilter() {
      this.filter = {
        status: '',
        dateRange: []
      };
    },

    loadData() {
      const params = {
        pageNum: this.pageNum,
        pageSize: this.pageSize,
        ...this.buildFilterParams()  // 自动构建筛选参数
      };

      this.$get('/api/list', params, (res) => {
        this.tableData = res.data.list;
        this.total = res.data.total;
      });
    },

    handleFilter() {
      this.resetPage();
      this.loadData();
    },

    resetFilter() {
      this.initFilter();
      this.resetPage();
      this.loadData();
    }
  }
}
</script>
```

---

## Vue.$mixins.tabMixin

标签页混合，提供标签页切换相关功能。

**源码位置：** `src/mixins/tab.js`

**混入的数据属性：**

| 属性 | 类型 | 说明 |
|------|------|------|
| `activeTab` | string | 当前激活的标签页 |

**混入的方法：**

| 方法 | 说明 |
|------|------|------|
| `handleTabChange(tab)` | 标签页切换处理 |

---

### 使用示例

```vue
<template>
  <div>
    <el-tabs v-model="activeTab" @tab-change="handleTabChange">
      <el-tab-pane label="待处理" name="pending">
        <pending-list />
      </el-tab-pane>
      <el-tab-pane label="已处理" name="processed">
        <processed-list />
      </el-tab-pane>
      <el-tab-pane label="全部" name="all">
        <all-list />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
export default {
  mixins: [Vue.$mixins.tabMixin],

  data() {
    return {
      activeTab: 'pending'
    }
  },

  methods: {
    handleTabChange(tab) {
      this.activeTab = tab;
      // 根据标签页加载不同数据
      this.loadData();
    },

    loadData() {
      const apiMap = {
        pending: '/api/pending',
        processed: '/api/processed',
        all: '/api/all'
      };

      this.$get(apiMap[this.activeTab], (res) => {
        this.currentList = res.data;
      });
    }
  }
}
</script>
```

---

## Vue.$mixins.downlistHiddenMixin

下拉列表隐藏混合，用于解决下拉框在特定场景下的显示问题。

**源码位置：** `src/mixins/downlist-hidden-mixin`

### 使用示例

```vue
<template>
  <div>
    <el-select v-model="value" placeholder="请选择">
      <el-option
        v-for="item in options"
        :key="item.value"
        :label="item.label"
        :value="item.value"
      />
    </el-select>
  </div>
</template>

<script>
export default {
  mixins: [Vue.$mixins.downlistHiddenMixin],

  data() {
    return {
      value: '',
      options: [
        { value: '1', label: '选项一' },
        { value: '2', label: '选项二' }
      ]
    }
  }
}
</script>
```

---

## 组合使用多个 Mixins

```vue
<template>
  <div>
    <!-- 筛选区域 -->
    <el-form inline>
      <el-form-item label="状态">
        <el-select v-model="filter.status" clearable>
          <el-option label="启用" value="1" />
          <el-option label="禁用" value="0" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleSearch">搜索</el-button>
        <el-button @click="resetSearch">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 标签页 -->
    <el-tabs v-model="activeTab" @tab-change="handleTabChange">
      <el-tab-pane label="全部" name="all" />
      <el-tab-pane label="待审核" name="pending" />
      <el-tab-pane label="已通过" name="approved" />
      <el-tab-pane label="已拒绝" name="rejected" />
    </el-tabs>

    <!-- 表格 -->
    <el-table :data="tableData">
      <el-table-column prop="name" label="名称" />
      <el-table-column prop="status" label="状态" />
    </el-table>

    <!-- 分页 -->
    <el-pagination
      v-if="total > 0"
      :current-page="pageNum"
      :page-size="pageSize"
      :total="total"
      layout="total, prev, pager, next"
      @current-change="loadData"
    />
  </div>
</template>

<script>
// 组合使用多个 mixins
export default {
  mixins: [
    Vue.$mixins.pagerMixin,
    Vue.$mixins.filterMixin,
    Vue.$mixins.tabMixin
  ],

  data() {
    return {
      filter: {
        status: ''
      },
      activeTab: 'all',
      tableData: []
    }
  },

  created() {
    this.initFilter();
    this.loadData();
  },

  methods: {
    initFilter() {
      this.filter = {
        status: ''
      };
    },

    loadData() {
      this.$get('/api/list', {
        pageNum: this.pageNum,
        pageSize: this.pageSize,
        status: this.filter.status,
        tab: this.activeTab
      }, (res) => {
        this.tableData = res.data.list;
        this.total = res.data.total;
      });
    },

    handleSearch() {
      this.resetPage();
      this.loadData();
    },

    resetSearch() {
      this.initFilter();
      this.resetPage();
      this.loadData();
    },

    handleTabChange(tab) {
      this.activeTab = tab;
      this.resetPage();
      this.loadData();
    }
  }
}
</script>
```

---

## 自定义 Mixin

如果内置的 Mixins 不满足需求，可以创建自定义的 Mixin：

```javascript
// src/mixins/custom-mixin.js
export default {
  data() {
    return {
      customData: '',
      loading: false
    }
  },

  created() {
    console.log('Custom mixin created');
  },

  methods: {
    setCustomData(data) {
      this.customData = data;
    },

    toggleLoading() {
      this.loading = !this.loading;
    }
  }
}
```

```vue
<script>
import customMixin from '@/mixins/custom-mixin';

export default {
  mixins: [customMixin, Vue.$mixins.pagerMixin],

  // ... 组件内容
}
</script>
```
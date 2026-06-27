# 跨标签页通信详解

web-framework 提供了强大的跨标签页通信能力，允许在不同浏览器标签页之间传递消息和同步状态。

## 核心方法

### this.$broadcastAsyncTab(action, meta, triggerCurrentPage)

向其他标签页广播事件。

**参数说明：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `action` | string | 是 | 事件名称，用于标识消息类型 |
| `meta` | any | 否 | 传递的数据，可以是字符串、数字、对象等 |
| `triggerCurrentPage` | boolean | 否 | 是否同时触发当前页面，默认为 false |

**使用示例：**

```javascript
// 基础用法 - 广播刷新事件
this.$broadcastAsyncTab('refresh-page-table', 'modelConfig');

// 带数据广播
this.$broadcastAsyncTab('refresh-data', {
  userId: '123',
  action: 'update',
  timestamp: Date.now()
});

// 同时触发当前页面
this.$broadcastAsyncTab('refresh-table', null, true);

// 广播删除事件
this.$broadcastAsyncTab('delete-item', {
  itemId: '123',
  itemType: 'user'
});

// 广播状态更新
this.$broadcastAsyncTab('update-status', {
  id: '456',
  status: 'approved'
});
```

---

### this.$listenAsyncTab(action, fn)

监听其他标签页广播的事件。

**参数说明：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `action` | string | 是 | 要监听的事件名称 |
| `fn` | function | 是 | 回调函数，接收 `meta` 作为参数 |

**使用示例：**

```javascript
// 在组件 created 或 mounted 中监听
export default {
  created() {
    // 监听刷新列表事件
    this.$listenAsyncTab('refresh-page-table', (meta) => {
      console.log('收到刷新通知:', meta);
      if (meta === 'modelConfig') {
        this.loadData();
      }
    });
  },

  methods: {
    loadData() {
      this.$get('/api/list', (res) => {
        this.tableData = res.data;
      });
    }
  }
}
```

---

### Vue.$broadcastAsyncTab(action, meta)

全局广播事件（在 Vue 全局调用）。

**使用示例：**

```javascript
// 在组件外部或 Vue 实例外部调用
Vue.$broadcastAsyncTab('global-refresh', { source: 'header' });
```

---

### Vue.$asyncTab.bindEvent / removeEvent

全局级别的事件绑定和移除。

**使用示例：**

```javascript
// 绑定全局事件
Vue.$asyncTab.bindEvent('refresh', this.handleRefresh);

// 移除全局事件
Vue.$asyncTab.removeEvent('refresh', this.handleRefresh);
```

---

## 完整使用示例

### 场景一：数据更新后刷新列表

**列表页面（监听方）：**

```vue
<template>
  <div>
    <el-table :data="tableData">
      <el-table-column prop="name" label="名称" />
      <el-table-column prop="status" label="状态" />
    </el-table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      tableData: []
    }
  },

  created() {
    // 加载初始数据
    this.loadData();

    // 监听其他页面修改后的刷新通知
    this.$listenAsyncTab('refresh-model-config', () => {
      this.loadData();
    });
  },

  methods: {
    loadData() {
      this.$get('/api/modelConfig', (res) => {
        this.tableData = res.data;
      });
    }
  }
}
</script>
```

**编辑页面（广播方）：**

```vue
<template>
  <el-form>
    <el-form-item label="名称">
      <el-input v-model="form.name" />
    </el-form-item>
    <el-form-item>
      <el-button @click="submit">保存</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
export default {
  data() {
    return {
      form: { name: '' }
    }
  },

  methods: {
    submit() {
      this.$post('/api/modelConfig', this.form, (res) => {
        Vue.successMsg('保存成功');
        // 通知列表页面刷新
        this.$broadcastAsyncTab('refresh-model-config');
      });
    }
  }
}
</script>
```

---

### 场景二：跨标签页状态同步

**监听方：**

```javascript
created() {
  // 监听用户信息更新
  this.$listenAsyncTab('user-updated', (userInfo) => {
    this.currentUser = userInfo;
    Vue.successMsg('用户信息已更新');
  });

  // 监听权限变更
  this.$listenAsyncTab('permission-changed', (permissions) => {
    this.permissions = permissions;
    this.checkAccess();
  });
}
```

**广播方：**

```javascript
methods: {
  updateUser() {
    this.$post('/api/user', this.form, (res) => {
      // 更新成功后广播
      this.$broadcastAsyncTab('user-updated', res.data);
    });
  },

  changePermission() {
    this.$post('/api/permission', this.permissionData, (res) => {
      // 权限变更后广播
      this.$broadcastAsyncTab('permission-changed', res.data.permissions);
    });
  }
}
```

---

### 场景三：批量操作同步

**列表页面：**

```javascript
created() {
  // 监听批量删除完成
  this.$listenAsyncTab('batch-delete-complete', (deleteResult) => {
    console.log('删除统计:', deleteResult);
    this.$message.info(`已删除 ${deleteResult.count} 条记录`);
    this.loadData();
  });

  // 监听批量审核完成
  this.$listenAsyncTab('batch-approve-complete', (approveResult) => {
    console.log('审核统计:', approveResult);
    this.$message.success(`审核完成：成功 ${approveResult.success}，失败 ${approveResult.fail}`);
    this.loadData();
  });
}
```

**操作页面：**

```javascript
methods: {
  batchDelete() {
    const ids = this.selectedItems.map(item => item.id);

    this.$confirmTips(`确定删除选中的 ${ids.length} 条记录？`, () => {
      this.$post('/api/batchDelete', { ids }, (res) => {
        Vue.successMsg('删除成功');
        // 通知列表刷新
        this.$broadcastAsyncTab('batch-delete-complete', {
          count: ids.length,
          timestamp: Date.now()
        });
      });
    });
  },

  batchApprove() {
    const ids = this.selectedItems.map(item => item.id);

    this.$post('/api/batchApprove', { ids }, (res) => {
      // 通知列表刷新
      this.$broadcastAsyncTab('batch-approve-complete', {
        success: res.data.success,
        fail: res.data.fail,
        timestamp: Date.now()
      });
    });
  }
}
```

---

## 最佳实践

### 1. 事件命名规范

```javascript
// 推荐：使用 kebab-case，带前缀
'refresh-page-list'
'refresh-model-config'
'user-information-updated'
'permission-changed'

// 不推荐：过于简单或无意义
'refresh'
'update'
'save'
```

### 2. 监听时的清理

```javascript
export default {
  created() {
    this.$listenAsyncTab('refresh-list', this.handleRefresh);
  },

  beforeDestroy() {
    // 如果需要，可以在这里移除监听
    // 注意：通常不需要手动移除，框架会自动处理
  }
}
```

### 3. 错误处理

```javascript
this.$listenAsyncTab('refresh-data', (meta) => {
  try {
    // 执行刷新逻辑
    this.loadData();
  } catch (error) {
    console.error('刷新数据失败:', error);
    Vue.errorMsg('数据刷新失败，请稍后重试');
  }
});
```

### 4. 防止重复刷新

```javascript
export default {
  data() {
    return {
      isRefreshing: false
    }
  },

  created() {
    this.$listenAsyncTab('refresh-list', () => {
      if (this.isRefreshing) return;
      this.isRefreshing = true;

      this.loadData().finally(() => {
        this.isRefreshing = false;
      });
    });
  }
}
```

---

## 常见问题

### Q1: 如何在页面加载时避免重复请求？

```javascript
created() {
  // 只在非广播触发时执行初始加载
  this.loadData();

  this.$listenAsyncTab('refresh-list', () => {
    this.loadData();
  });
}
```

### Q2: 如何区分是自己的广播还是别人的广播？

```javascript
methods: {
  submit() {
    // 生成唯一标识
    const broadcastId = Date.now() + '_' + Math.random();

    this.$post('/api/save', this.form, (res) => {
      // 只广播给其他标签页，不触发自己
      this.$broadcastAsyncTab('data-updated', {
        id: broadcastId,
        data: res.data
      });
    });
  }
}

created() {
  this.$listenAsyncTab('data-updated', (meta) => {
    // 忽略自己生成的广播
    if (meta.id.startsWith(Date.now() + '_')) {
      return;
    }
    this.loadData();
  });
}
```

### Q3: 如何传递复杂数据？

```javascript
// 可以传递对象、数组等复杂数据
this.$broadcastAsyncTab('form-submitted', {
  formId: '123',
  fields: {
    name: '张三',
    email: 'zhangsan@example.com'
  },
  attachments: [
    { id: '1', name: '文件1.pdf' },
    { id: '2', name: '文件2.doc' }
  ],
  timestamp: Date.now()
});
```

---

## Vue.$asyncTab 全局方法

### Vue.$asyncTab.bindEvent(action, handler)

绑定全局事件处理器。

```javascript
// 在应用启动时绑定
Vue.$asyncTab.bindEvent('global-logout', () => {
  // 处理全局登出
  location.href = '/login';
});
```

### Vue.$asyncTab.removeEvent(action, handler)

移除全局事件处理器。

```javascript
// 移除之前绑定的事件
Vue.$asyncTab.removeEvent('global-logout', logoutHandler);
```
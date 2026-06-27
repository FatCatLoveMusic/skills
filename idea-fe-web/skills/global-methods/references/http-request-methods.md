# HTTP 请求方法详解

本文档详细说明 web-framework 中所有的 HTTP 请求方法。

## 方法列表

### this.$get(url, data, success, error, requestConfig)

GET 请求方法。

**参数说明：**
- `url` - 请求地址
- `data` - 请求数据或成功回调
- `success` - 成功回调函数
- `error` - 失败回调函数
- `requestConfig` - 额外配置

**使用示例：**
```javascript
// 基础 GET 请求
this.$get('/api/users', (res) => {
  this.users = res.data;
});

// 带参数 GET 请求
this.$get('/api/users', {
  pageNum: 1,
  pageSize: 10
}, (res) => {
  this.users = res.data;
  this.total = res.total;
}, (err) => {
  Vue.errorMsg('获取失败');
});

// 带完整配置的请求
this.$get('/api/users', {
  pageNum: 1
}, (res) => {
  this.users = res.data;
}, (err) => {
  Vue.errorMsg('获取失败');
}, {
  loading: false,
  headers: { 'Custom-Header': 'value' }
});
```

---

### this.$post(url, data, success, error, requestConfig)

POST 请求方法。

**参数说明：**
- `url` - 请求地址
- `data` - 请求数据
- `success` - 成功回调函数
- `error` - 失败回调函数
- `requestConfig` - 额外配置

**使用示例：**
```javascript
// 基础 POST 请求
this.$post('/api/user', {
  name: '张三',
  age: 25,
  email: 'zhangsan@example.com'
}, (res) => {
  Vue.successMsg('保存成功');
  this.loadData();
}, (err) => {
  Vue.errorMsg('保存失败');
});

// 不显示 loading 的请求
this.$post('/api/user', {
  name: '张三'
}, (res) => {
  Vue.successMsg('保存成功');
}, null, {
  loading: false
});
```

---

### this.$put(url, data, success, error, requestConfig)

PUT 请求方法（更新数据）。

**参数说明：**
- `url` - 请求地址
- `data` - 请求数据
- `success` - 成功回调函数
- `error` - 失败回调函数
- `requestConfig` - 额外配置

**使用示例：**
```javascript
// 更新用户信息
this.$put('/api/user/1', {
  name: '李四',
  age: 30
}, (res) => {
  Vue.successMsg('更新成功');
  this.loadData();
}, (err) => {
  Vue.errorMsg('更新失败');
});

// 只更新部分字段
this.$put('/api/user/1', {
  name: '王五'
}, (res) => {
  Vue.successMsg('更新成功');
});
```

---

### this.$delete(url, data, success, error, requestConfig)

DELETE 请求方法（删除数据）。

**参数说明：**
- `url` - 请求地址
- `data` - 请求数据或成功回调
- `success` - 成功回调函数
- `error` - 失败回调函数
- `requestConfig` - 额外配置

**使用示例：**
```javascript
// 删除单个用户
this.$delete('/api/user/1', (res) => {
  Vue.successMsg('删除成功');
  this.loadData();
}, (err) => {
  Vue.errorMsg('删除失败');
});

// 带条件的删除
this.$delete('/api/users', {
  ids: [1, 2, 3]
}, (res) => {
  Vue.successMsg('批量删除成功');
  this.loadData();
});
```

---

### this.$request(config, success, error)

通用请求方法，支持所有 HTTP 方法。

**参数说明：**
- `config.url` - 请求地址（必填）
- `config.method` - 请求方法：get/post/put/delete（默认get）
- `config.data` - 请求数据
- `config.params` - URL 参数
- `config.headers` - 请求头
- `config.loading` - 是否显示 loading（默认 true）
- `config.timeout` - 请求超时时间
- `config.crossSite` - 是否跨域
- `success` - 成功回调函数
- `error` - 失败回调函数

**使用示例：**
```javascript
// GET 请求
this.$request({
  url: '/api/users',
  method: 'get',
  params: { page: 1, size: 10 },
  loading: true
}, (res) => {
  this.users = res.data;
}, (err) => {
  Vue.errorMsg('获取失败');
});

// POST 请求
this.$request({
  url: '/api/users',
  method: 'post',
  data: { name: '张三', age: 25 },
  headers: { 'Content-Type': 'application/json' }
}, (res) => {
  Vue.successMsg('创建成功');
});

// 发送文件
this.$request({
  url: '/api/upload',
  method: 'post',
  data: formData,
  headers: { 'Content-Type': 'multipart/form-data' }
}, (res) => {
  Vue.successMsg('上传成功');
});

// 跨域请求
this.$request({
  url: 'https://external-api.com/data',
  method: 'get',
  crossSite: true
}, (res) => {
  this.externalData = res.data;
});
```

---

## 请求配置选项

### 全局配置

所有请求方法都支持以下配置选项：

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `loading` | boolean | true | 是否显示 loading |
| `headers` | object | {} | 请求头 |
| `timeout` | number | - | 超时时间（毫秒） |
| `crossSite` | boolean | false | 是否跨域 |

### 自动处理

请求方法会自动处理以下内容：

1. **Loading 显示/隐藏**
   - 请求开始时自动显示 loading
   - 请求完成后自动隐藏 loading
   - 设置 `{loading: false}` 可禁用

2. **禁用状态**
   - POST/PUT 请求自动禁用提交按钮
   - 请求完成后自动恢复

3. **菜单ID**
   - 自动从路由获取 menuId 并添加到请求头

---

## 常见问题

### 1. 如何取消请求？

目前框架不直接支持取消请求，但可以使用以下方式：

```javascript
// 使用 flag 控制
let requestPending = false;

methods: {
  async loadData() {
    if (requestPending) return;
    requestPending = true;

    this.$get('/api/data', (res) => {
      this.data = res.data;
    }, () => {
      Vue.errorMsg('请求失败');
    }).finally(() => {
      requestPending = false;
    });
  }
}
```

### 2. 如何处理登录失效？

框架会自动处理 401 未授权响应，通常会自动跳转到登录页面。

### 3. 如何阻止重复提交？

POST/PUT 请求会自动禁用按钮，但建议在业务层面也做防护：

```javascript
submitForm() {
  if (this.submitting) return;
  this.submitting = true;

  this.$post('/api/submit', this.formData, (res) => {
    Vue.successMsg('提交成功');
  }, () => {
    Vue.errorMsg('提交失败');
  }).finally(() => {
    this.submitting = false;
  });
}
```

---

## 请求示例模板

### 列表数据请求

```javascript
loadList() {
  this.$get('/api/list', {
    pageNum: this.pageNum,
    pageSize: this.pageSize,
    ...this.searchParams
  }, (res) => {
    this.tableData = res.data.list;
    this.total = res.data.total;
  });
}
```

### 表单提交

```javascript
submitForm() {
  // 验证
  if (!this.form.name) {
    Vue.errorMsg('请输入名称');
    return;
  }

  // 提交
  this.$post('/api/save', this.form, (res) => {
    Vue.successMsg('保存成功');
    this.$emit('refresh');
  }, (err) => {
    Vue.errorMsg(err.message || '保存失败');
  });
}
```

### 文件上传

```javascript
uploadFile(file) {
  const formData = new FormData();
  formData.append('file', file);

  this.$request({
    url: '/api/upload',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  }, (res) => {
    Vue.successMsg('上传成功');
    this.fileUrl = res.data.url;
  }, (err) => {
    Vue.errorMsg('上传失败');
  });
}
```
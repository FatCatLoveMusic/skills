# 对话框、确认框、提示方法详解

本文档详细说明 web-framework 中的对话框、确认框、消息提示、表单提示等 UI 交互方法。

## 消息提示方法

### Vue.successMsg(text, option)

成功提示信息。

**参数说明：**
- `text` - 提示内容（必填）
- `option.timeout` - 显示时长（默认 2000ms）
- `option.showClose` - 是否显示关闭按钮

**使用示例：**
```javascript
// 基础用法
Vue.successMsg('操作成功');

// 自定义显示时长
Vue.successMsg('保存成功', { timeout: 3000 });

// 带关闭按钮
Vue.successMsg('处理完成', { showClose: true });
```

---

### Vue.errorMsg(text, option)

错误提示信息。

**参数说明：**
- `text` - 提示内容（必填）
- `option.title` - 标题（可选）
- `option.showClose` - 是否显示关闭按钮（默认 true）

**使用示例：**
```javascript
// 基础用法
Vue.errorMsg('操作失败');

// 自定义标题
Vue.errorMsg('网络错误', { title: '错误提示' });

// 组件内使用
this.$errorMsg('保存失败');
```

---

### Vue.msg(text, option)

普通提示信息。

**参数说明：**
- `text` - 提示内容
- `option.type` - 提示类型：info、error、success、warning
- `option.timeout` - 显示时长（默认 2000ms）
- `option.showClose` - 是否显示关闭按钮
- `option.showIcon` - 是否显示图标（默认 true）

**使用示例：**
```javascript
// 信息提示
Vue.msg('这是一条普通提示', { type: 'info' });

// 警告提示
Vue.msg('数据已过期，请刷新', { type: 'warning' });

// 错误提示
Vue.msg('加载失败', { type: 'error', showClose: true });

// 成功提示
Vue.msg('操作完成', { type: 'success' });
```

---

## 确认框方法

### this.$confirmTips(content, confirmFunc, cancelFunc, btnTexts, option)

确认弹窗，用于需要用户确认的操作。

**参数说明：**
- `content` - 显示内容（必填，字符串）
- `confirmFunc` - 确认回调方法
- `cancelFunc` - 取消回调方法
- `btnTexts` - 按钮文字数组（最多两个），格式：`[取消按钮文字, 确认按钮文字]`
- `option.confirmtype` - 图标类型：
  - `warning` - 警告图标（默认）
  - `error` - 错误图标
  - `info` - 成功图标
- `option.showClose` - 是否显示关闭按钮
- `option.showCancelButton` - 是否显示取消按钮（默认 true）
- `option.closeOnClickModal` - 点击遮罩是否关闭（默认 false）
- `option.description` - 描述文本

**使用示例：**
```javascript
// 基础确认框
this.$confirmTips('确定要删除吗？', () => {
  this.deleteItem();
});

// 带取消回调
this.$confirmTips('确定要删除吗？', () => {
  this.deleteItem();
}, () => {
  console.log('用户取消了操作');
});

// 自定义按钮文字
this.$confirmTips('确定提交吗？', () => {
  this.submit();
}, null, ['取消', '提交']);

// 成功类型确认框
this.$confirmTips('操作成功，是否继续？', () => {
  this.continue();
}, null, null, { confirmtype: 'info' });

// 带描述的确认框
this.$confirmTips('确定删除此用户？', () => {
  this.deleteUser();
}, null, null, {
  description: '删除后数据将无法恢复'
});

// 不显示取消按钮
this.$confirmTips('确定执行此操作？', () => {
  this.executeAction();
}, null, null, {
  showCancelButton: false
});
```

---

### this.$deleteTips(confirmFunc, cancelFunc, content)

删除确认弹窗（简化版确认框）。

**参数说明：**
- `confirmFunc` - 确认回调方法（必填）
- `cancelFunc` - 取消回调方法（可选）
- `content` - 显示内容：
  - 字符串：直接显示为内容
  - 对象：`{ content, description }` 格式

**使用示例：**
```javascript
// 基础用法（使用默认文案）
this.$deleteTips(() => {
  this.deleteItem();
});

// 带取消回调
this.$deleteTips(() => {
  this.deleteItem();
}, () => {
  console.log('取消删除');
});

// 自定义内容
this.$deleteTips(() => {
  this.deleteItem();
}, null, '确定要删除这条记录吗？');

// 自定义内容和描述
this.$deleteTips(() => {
  this.deleteItem();
}, null, {
  content: '确定删除？',
  description: '删除后将无法恢复'
});
```

---

## 表单提示方法

### this.$tips(content, selector, option)

表单字段提示信息，自动滚动到目标元素。

**参数说明：**
- `content` - 提示内容
- `selector` - CSS 选择器或 DOM 元素
- `option.error` - 是否为错误提示（高亮显示）
- `option.timeout` - 显示时长（默认 5000ms）
- `option.callback` - 提示隐藏后的回调函数

**使用示例：**
```javascript
// 基础用法
this.$tips('请输入用户名', '#username');

// 错误提示
this.$tips('密码格式不正确', '#password', { error: true });

// 自定义显示时长
this.$tips('邮箱格式错误', '#email', {
  error: true,
  timeout: 10000
});

// 使用 DOM 元素
this.$tips('必填字段', this.$refs.requiredInput);
```

---

### this.$errorTips(content, selector, option)

错误提示信息（自动设置 error 为 true）。

**使用示例：**
```javascript
// 基础用法
this.$errorTips('邮箱格式不正确', '#email');

// 自定义配置
this.$errorTips('用户名已存在', '#username', {
  timeout: 8000
});
```

---

### this.$closeTips()

关闭当前显示的提示信息。

**使用示例：**
```javascript
// 关闭所有提示
this.$closeTips();

// 通常在表单提交前清除旧提示
submitForm() {
  this.$closeTips();

  if (!this.form.name) {
    this.$errorTips('请输入名称', '#name');
    return;
  }

  this.$post('/api/save', this.form);
}
```

---

### this.$waringTips(content, selector)

服务端校验返回的提示信息。

**参数说明：**
- `content` - 提示内容
- `selector` - CSS 选择器或 DOM 元素

**使用示例：**
```javascript
// 基础用法
this.$waringTips('用户名已存在', '#username');

// 配合服务端返回的验证错误使用
this.$post('/api/user', this.formData, (res) => {
  Vue.successMsg('保存成功');
}, (err) => {
  if (err.field) {
    // 字段级错误显示在对应位置
    this.$waringTips(err.message, `#${err.field}`);
  } else {
    // 全局错误使用 msg
    Vue.errorMsg(err.message);
  }
});
```

---

### this.$closeWaringTips(selector)

清除服务端校验提示信息。

**参数说明：**
- `selector` - CSS 选择器（可选，不传则清除所有）

**使用示例：**
```javascript
// 清除特定字段的警告
this.$closeWaringTips('#username');

// 清除所有警告
this.$closeWaringTips();
```

---

## 选择器对话框

### Vue.$sapi_dialog

对话框工具，提供各种选择弹窗。

**常用方法：**
- `chooseUser(props)` - 选择用户弹窗
- `chooseEmployee(props)` - 选择员工弹窗
- `chooseSupplier(props)` - 选择供应商弹窗
- `chooseStru(props)` - 选择组织结构弹窗
- `createDialog(componentId, props)` - 创建自定义弹窗
- `registerDialog(componentId, component)` - 注册自定义弹窗组件
- `creatRemoteDialog(appCode, componentId, props)` - 创建远程弹窗

**返回对象方法：**
- `show()` - 显示弹窗
- `on(eventName, callback)` - 监听事件

**使用示例：**

```javascript
// 选择用户
Vue.$sapi_dialog.chooseUser({
  multiple: true,
  onClose: (selectedUsers) => {
    console.log('选中的用户:', selectedUsers);
    if (selectedUsers && selectedUsers.length > 0) {
      this.selectedUsers = selectedUsers;
    }
  }
}).show();

// 单选用户
Vue.$sapi_dialog.chooseUser({
  multiple: false,
  onClose: (selectedUser) => {
    if (selectedUser) {
      this.form.userId = selectedUser.id;
      this.form.userName = selectedUser.name;
    }
  }
}).show();

// 选择员工
Vue.$sapi_dialog.chooseEmployee({
  onClose: (selected) => {
    this.employee = selected;
  }
}).show();

// 选择供应商
Vue.$sapi_dialog.chooseSupplier({
  multiple: true,
  onClose: (suppliers) => {
    this.suppliers = suppliers;
  }
}).show();

// 选择组织结构
Vue.$sapi_dialog.chooseStru({
  onClose: (stru) => {
    this.department = stru;
  }
}).show();

// 创建远程弹窗
Vue.$sapi_dialog.creatRemoteDialog('workflow', 'task-detail', {
  taskId: '123'
}).show();

// 注册自定义弹窗
Vue.$sapi_dialog.registerDialog('my-custom-dialog', {
  template: '<div>自定义弹窗内容</div>',
  props: ['data'],
  methods: {
    confirm() {
      this.$emit('confirm', this.data);
      this.$emit('close');
    }
  }
});

// 使用自定义弹窗
Vue.$sapi_dialog.createDialog('my-custom-dialog', {
  data: { value: 'test' }
}).on('confirm', (data) => {
  console.log('确认:', data);
}).show();
```

---

## 通知方法

### this.$notification

Element UI Notification 通知的封装。

**使用示例：**
```javascript
// 成功通知
this.$notification.success({
  title: '成功',
  message: '操作已完成',
  duration: 3000
});

// 错误通知
this.$notification.error({
  title: '错误',
  message: '操作失败',
  duration: 0  // 不自动关闭
});

// 警告通知
this.$notification.warning({
  title: '警告',
  message: '数据即将过期'
});

// 信息通知
this.$notification.info({
  title: '提示',
  message: '有新消息'
});

// 带回调的通知
this.$notification({
  title: '确认操作',
  message: '是否继续？',
  duration: 0,
  onClose: () => {
    console.log('通知已关闭');
  },
  onClick: () => {
    console.log('通知被点击');
  }
});
```

---

## 加载状态方法

### this.$loadingOpen(options)

打开加载状态。

**参数说明：**
- `options.pending` - loading 挂起模式，需要传 `{pending: false}` 才能关闭

**使用示例：**
```javascript
// 基础用法
this.$loadingOpen();

// 挂起模式
this.$loadingOpen({ pending: true });

// 在数据加载开始时
loadData() {
  this.$loadingOpen();
  this.$get('/api/data', (res) => {
    this.data = res.data;
    this.$loadingClose();
  });
}
```

---

### this.$loadingClose(options)

关闭加载状态。

**参数说明：**
- `options.pending` - 设为 false 关闭挂起的 loading

**使用示例：**
```javascript
// 基础关闭
this.$loadingClose();

// 关闭挂起的 loading
this.$loadingClose({ pending: false });

// 在请求完成时
this.$get('/api/data', (res) => {
  this.data = res.data;
  this.$loadingClose();
}, (err) => {
  this.$loadingClose();
  Vue.errorMsg('加载失败');
});
```

---

### this.$loading(flag)

手动控制加载状态。

**使用示例：**
```javascript
// 显示 loading
this.$loading(true);

// 关闭 loading
this.$loading(false);

// 配合请求使用
async fetchData() {
  this.$loading(true);
  try {
    const res = await this.$get('/api/data');
    this.data = res.data;
  } finally {
    this.$loading(false);
  }
}
```

---

## 注意事项

### 1. 方法调用范围

| 方法 | 调用方式 | 说明 |
|------|----------|------|
| `successMsg` | `Vue.successMsg()` | 全局调用 |
| `errorMsg` | `Vue.errorMsg()` | 全局调用 |
| `msg` | `Vue.msg()` | 全局调用 |
| `$confirmTips` | `this.$confirmTips()` | 组件内调用 |
| `$deleteTips` | `this.$deleteTips()` | 组件内调用 |
| `$tips` | `this.$tips()` | 组件内调用 |
| `$loadingOpen` | `this.$loadingOpen()` | 组件内调用 |

### 2. Loading 自动管理

HTTP 请求方法会自动管理 loading，无需手动调用：
- `$get`、`$post`、`$put`、`$delete` 默认显示 loading
- 设置 `{loading: false}` 可禁用自动 loading

### 3. 表单提示最佳实践

```javascript
// 1. 提交前清除旧提示
submitForm() {
  this.$closeTips();

  // 2. 逐个验证字段
  if (!this.form.name) {
    this.$errorTips('请输入名称', '#name');
    return;
  }

  if (!this.form.email) {
    this.$errorTips('请输入邮箱', '#email');
    return;
  }

  // 3. 提交
  this.$post('/api/save', this.form);
}
```

### 4. 选择器弹窗配合表单使用

```javascript
// 选择用户
selectUser() {
  Vue.$sapi_dialog.chooseUser({
    multiple: false
  }).on('close', (user) => {
    if (user) {
      this.form.userId = user.id;
      this.form.userName = user.name;
    }
  }).show();
}

// 模板中绑定
<template>
  <el-form>
    <el-form-item label="选择用户">
      <el-input v-model="form.userName" readonly @click="selectUser">
        <i slot="suffix" class="el-icon-search"></i>
      </el-input>
    </el-form-item>
  </el-form>
</template>
```
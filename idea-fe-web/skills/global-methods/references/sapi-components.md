# SAPI 组件工具详解

web-framework 提供了一系列 SAPI 组件工具，用于对话框、上传、导出、AI 助手等常见功能。

## 对话框工具

### Vue.$sapi_dialog

对话框工具模块，提供各种业务选择弹窗。

**源码位置：** `src/components/dialog.js`

**方法列表：**

| 方法 | 说明 | 返回值 |
|------|------|--------|
| `chooseUser(props)` | 选择用户弹窗 | Dialog实例 |
| `chooseEmployee(props)` | 选择员工弹窗 | Dialog实例 |
| `chooseSupplier(props)` | 选择供应商弹窗 | Dialog实例 |
| `chooseStru(props)` | 选择组织结构弹窗 | Dialog实例 |
| `createDialog(componentId, props)` | 创建自定义弹窗 | Dialog实例 |
| `registerDialog(componentId, component)` | 注册自定义弹窗组件 | void |
| `creatRemoteDialog(appCode, componentId, props)` | 创建远程弹窗 | Dialog实例 |

**Dialog 实例方法：**

| 方法 | 说明 |
|------|------|
| `show()` | 显示弹窗 |
| `on(eventName, callback)` | 监听事件 |

---

### 选择用户

```javascript
// 单选用户
Vue.$sapi_dialog.chooseUser({
  multiple: false,
  onClose: (user) => {
    if (user) {
      this.form.userId = user.id;
      this.form.userName = user.name;
    }
  }
}).show();

// 多选用户
Vue.$sapi_dialog.chooseUser({
  multiple: true,
  onClose: (users) => {
    if (users && users.length > 0) {
      this.form.userIds = users.map(u => u.id);
      this.form.userNames = users.map(u => u.name).join(',');
    }
  }
}).show();

// 带默认值
Vue.$sapi_dialog.chooseUser({
  multiple: false,
  value: [{ id: '123', name: '张三' }],
  onClose: (user) => {
    if (user) {
      this.form.userId = user.id;
    }
  }
}).show();
```

---

### 选择员工

```javascript
// 单选员工
Vue.$sapi_dialog.chooseEmployee({
  multiple: false,
  onClose: (employee) => {
    if (employee) {
      this.form.employeeId = employee.id;
      this.form.employeeName = employee.name;
    }
  }
}).show();

// 多选员工
Vue.$sapi_dialog.chooseEmployee({
  multiple: true,
  onClose: (employees) => {
    this.employees = employees;
  }
}).show();
```

---

### 选择供应商

```javascript
Vue.$sapi_dialog.chooseSupplier({
  multiple: true,
  onClose: (suppliers) => {
    if (suppliers && suppliers.length > 0) {
      this.form.supplierIds = suppliers.map(s => s.id);
      this.form.supplierNames = suppliers.map(s => s.name).join(',');
    }
  }
}).show();
```

---

### 选择组织结构

```javascript
Vue.$sapi_dialog.chooseStru({
  multiple: false,
  onClose: (stru) => {
    if (stru) {
      this.form.departmentId = stru.id;
      this.form.departmentName = stru.name;
    }
  }
}).show();

// 多选组织
Vue.$sapi_dialog.chooseStru({
  multiple: true,
  onClose: (struList) => {
    this.departments = struList;
  }
}).show();
```

---

### 创建自定义弹窗

```javascript
// 1. 注册自定义弹窗组件
Vue.$sapi_dialog.registerDialog('user-detail-dialog', {
  template: `
    <el-dialog title="用户详情" :visible.sync="visible">
      <el-form>
        <el-form-item label="用户名">
          {{ user.name }}
        </el-form-item>
        <el-form-item label="邮箱">
          {{ user.email }}
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="close">关闭</el-button>
        <el-button type="primary" @click="confirm">确认</el-button>
      </span>
    </el-dialog>
  `,
  props: ['userData'],
  data() {
    return {
      visible: true,
      user: this.userData
    }
  },
  methods: {
    close() {
      this.$emit('close');
    },
    confirm() {
      this.$emit('confirm', this.user);
      this.close();
    }
  }
});

// 2. 打开自定义弹窗
Vue.$sapi_dialog.createDialog('user-detail-dialog', {
  userData: { id: '123', name: '张三', email: 'zhangsan@example.com' }
}).on('confirm', (user) => {
  console.log('确认用户:', user);
  this.selectedUser = user;
}).on('close', () => {
  console.log('弹窗关闭');
}).show();
```

---

### 创建远程弹窗

```javascript
// 用于加载其他应用或模块的弹窗组件
Vue.$sapi_dialog.creatRemoteDialog('workflow', 'task-detail', {
  taskId: '123'
}).on('close', () => {
  console.log('远程弹窗已关闭');
}).show();

// 带回调的远程弹窗
Vue.$sapi_dialog.creatRemoteDialog('form', 'dynamic-form', {
  formId: '456',
  mode: 'edit'
}).on('submit', (formData) => {
  console.log('表单数据:', formData);
  this.$broadcastAsyncTab('form-submitted', formData);
}).on('cancel', () => {
  console.log('表单取消');
}).show();
```

---

## 上传工具

### Vue.$sapi_uploadTool

上传工具模块，提供文件上传相关功能。

**源码位置：** `src/components/sapi-upload/upload-tool.js`

**方法列表：**

| 方法 | 说明 |
|------|------|
| `getFileIcon(suffix)` | 获取文件图标 |
| `formatFileSize(size)` | 格式化文件大小 |
| `upload(options)` | 上传文件 |
| `download(url, fileName)` | 下载文件 |

---

### 获取文件图标

```javascript
// 根据文件后缀获取图标路径
const icon = Vue.$sapi_uploadTool.getFileIcon('.pdf');
// 返回: 图片路径或默认图标

const icon2 = Vue.$sapi_uploadTool.getFileIcon('.docx');
const icon3 = Vue.$sapi_uploadTool.getFileIcon('.xlsx');
const icon4 = Vue.$sapi_uploadTool.getFileIcon('.jpg');

// 显示文件图标
<img :src="Vue.$sapi_uploadTool.getFileIcon('.pdf')" />
```

---

### 格式化文件大小

```javascript
// 格式化文件大小为人类可读格式
const size1 = Vue.$sapi_uploadTool.formatFileSize(1024);
// 返回: "1 KB"

const size2 = Vue.$sapi_uploadTool.formatFileSize(1024 * 1024);
// 返回: "1 MB"

const size3 = Vue.$sapi_uploadTool.formatFileSize(1024 * 1024 * 1024);
// 返回: "1 GB"

const size4 = Vue.$sapi_uploadTool.formatFileSize(500);
// 返回: "500 byte"

// 在上传组件中使用
<el-table-column label="大小">
  <template slot-scope="scope">
    {{ Vue.$sapi_uploadTool.formatFileSize(scope.row.size) }}
  </template>
</el-table-column>
```

---

### 上传文件

```javascript
// 基础上传
Vue.$sapi_uploadTool.upload({
  url: '/api/upload',
  file: file,  // File 对象
  fileName: 'file',  // 参数名
  onProgress: (percent) => {
    console.log('上传进度:', percent + '%');
    this.uploadProgress = percent;
  },
  success: (res) => {
    console.log('上传成功:', res);
    Vue.successMsg('上传成功');
    this.fileUrl = res.data.url;
  },
  error: (err) => {
    console.error('上传失败:', err);
    Vue.errorMsg('上传失败');
  }
});
```

---

## Excel 导出工具

### Vue.$sapi_xlsxExportTool

Excel 导出工具模块。

**源码位置：** `src/components/xlsx-export/xlsx-export-tool.js`

**方法列表：**

| 方法 | 说明 |
|------|------|
| `export(options)` | 导出 Excel |

---

### 导出基本用法

```javascript
// 导出表格数据
Vue.$sapi_xlsxExportTool.export({
  columns: ['姓名', '年龄', '邮箱'],  // 表头
  data: [
    ['张三', 25, 'zhangsan@example.com'],
    ['李四', 30, 'lisi@example.com']
  ],
  fileName: '用户列表'  // 文件名（不含扩展名）
});
```

---

### 导出带配置

```javascript
Vue.$sapi_xlsxExportTool.export({
  columns: [
    { title: '姓名', key: 'name' },
    { title: '年龄', key: 'age' },
    { title: '邮箱', key: 'email' }
  ],
  data: this.userList,  // 对象数组
  fileName: '用户信息导出',
  sheetName: '用户列表',  // 工作表名称
  showHeader: true,  // 是否显示表头
  autoWidth: true,  // 自动列宽
  bookType: 'xlsx'  // 文件类型: xlsx, csv, txt
});
```

---

### 导出复杂表格

```javascript
// 多级表头
Vue.$sapi_xlsxExportTool.export({
  columns: [
    [
      { title: '姓名', key: 'name', rowspan: 2 },
      { title: '成绩', colspan: 2 }
    ],
    [
      { title: '语文', key: 'chinese' },
      { title: '数学', key: 'math' }
    ]
  ],
  data: this.studentScores,
  fileName: '学生成绩单'
});
```

---

### 导出百万级数据

```javascript
// 使用流式导出（大数据量）
Vue.$sapi_xlsxExportTool.export({
  url: '/api/export/users',  // 后端流式接口
  fileName: '用户数据导出',
  method: 'post',
  data: {
    startDate: this.startDate,
    endDate: this.endDate
  }
});
```

---

## AI 助手工具

### Vue.$sapi_ai / this.$sapi_ai

AI 助手工具，用于集成 AI 对话功能。

**源码位置：** `src/components/idea-ai-chat/sapi-ai.js`

**方法列表：**

| 方法 | 说明 |
|------|------|
| `open(options)` | 打开 AI 聊天窗口 |
| `close()` | 关闭 AI 聊天窗口 |
| `sendMessage(message)` | 发送消息 |

---

### 打开 AI 聊天

```javascript
// 基础用法
const aiChat = Vue.$sapi_ai.open({
  title: 'AI 助手',
  onMessage: (msg) => {
    console.log('收到 AI 消息:', msg);
  },
  onClose: () => {
    console.log('聊天窗口已关闭');
  }
});

// 带初始消息
const aiChat = Vue.$sapi_ai.open({
  title: '代码助手',
  initialMessage: '我可以帮你写代码、调试程序',
  onMessage: (msg) => {
    // 处理 AI 响应
    this.handleAiResponse(msg);
  }
});
```

---

### 发送消息

```javascript
const aiChat = Vue.$sapi_ai.open({
  onMessage: (msg) => {
    this.messages.push(msg);
  }
});

// 发送用户消息
aiChat.sendMessage('帮我写一个求和函数');

// 发送带上下文的消息
aiChat.sendMessage({
  content: '优化这段代码',
  context: {
    language: 'javascript',
    code: 'function sum(a, b) { return a + b }'
  }
});
```

---

### 在组件中使用

```vue
<template>
  <div>
    <el-button type="primary" @click="openAiAssistant">
      打开 AI 助手
    </el-button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      aiChatInstance: null
    }
  },

  methods: {
    openAiAssistant() {
      if (this.aiChatInstance) {
        return;
      }

      this.aiChatInstance = this.$sapi_ai.open({
        title: '智能助手',
        onMessage: (msg) => {
          this.handleAiMessage(msg);
        },
        onClose: () => {
          this.aiChatInstance = null;
        }
      });
    },

    handleAiMessage(msg) {
      console.log('AI 消息:', msg);

      if (msg.type === 'text') {
        // 处理文本消息
        this.$set(msg, 'rendered', this.parseMarkdown(msg.content));
      } else if (msg.type === 'code') {
        // 处理代码消息
        this.highlightCode(msg.content);
      }
    },

    askAi(question) {
      if (this.aiChatInstance) {
        this.aiChatInstance.sendMessage(question);
      }
    }
  },

  beforeDestroy() {
    if (this.aiChatInstance) {
      this.aiChatInstance.close();
    }
  }
}
</script>
```

---

## 其他 SAPI 工具

### Vue.$sapi_moveModule

模块移动工具。

```javascript
// 移动模块
Vue.$sapi_moveModule.move({
  source: 'moduleA',
  target: 'moduleB',
  onSuccess: () => {
    Vue.successMsg('模块移动成功');
  },
  onError: (err) => {
    Vue.errorMsg('移动失败: ' + err.message);
  }
});
```

---

### Vue.$sapi_renderSync

同步渲染工具。

```javascript
// 渲染组件为 HTML
const html = Vue.$sapi_renderSync.render('my-component', {
  props: {
    title: '测试标题',
    content: '测试内容'
  }
});

console.log(html); // 渲染后的 HTML 字符串
```

---

### Vue.$sapi_wheelEvent

滚轮事件处理工具。

```javascript
// 绑定滚轮事件
const unwatch = Vue.$sapi_wheelEvent.bind(this.$refs.scrollContainer, (delta, event) => {
  console.log('滚轮方向:', delta > 0 ? '向下' : '向上');
  console.log('滚轮距离:', delta);
});

// 解除绑定
unwatch();
```

---

### Vue.$sapi_getMenuItemData

获取菜单项数据。

```javascript
// 获取当前菜单数据
const menuData = Vue.$sapi_getMenuItemData();

if (menuData) {
  console.log('菜单ID:', menuData.id);
  console.log('菜单名称:', menuData.name);
  console.log('菜单路径:', menuData.path);
}
```

---

### Vue.$sapi_chameleonic

变色龙组件工具，用于动态值类型处理。

```javascript
// 获取值类型
const valueType = Vue.$sapi_chameleonic.getValueType('string');
console.log(valueType); // 'string'

// 格式化值
const formattedValue = Vue.$sapi_chameleonic.formatValue(123, 'currency');
console.log(formattedValue); // '¥123.00'
```
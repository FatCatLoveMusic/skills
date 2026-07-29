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

AI 助手工具，用于集成 AI 对话功能，支持文档提取、智能填表、招标文件生成等场景。

**源码位置：** `src/components/idea-ai-chat/sapi-ai.js`

**方法列表：**

| 方法 | 说明 |
|------|------|
| `open(options)` | 打开 AI 聊天窗口，返回聊天实例 |
| `close()` | 关闭 AI 聊天窗口 |

**聊天实例方法：**

| 方法 | 说明 |
|------|------|
| `on(eventName, callback)` | 监听事件（如 `updateField`） |
| `restore(chatId)` | 恢复历史聊天会话 |
| `send(options)` | 发送消息到 AI |
| `close()` | 关闭聊天窗口 |

---

### open 参数说明

```javascript
const aiChat = Vue.$sapi_ai.open({
  // === 布局相关 ===
  layout: 'drawer-layout',           // 布局类型: 'drawer-layout' | 'document-layout'
  width: '1000px',                   // 弹窗/抽屉宽度

  // === 标识相关 ===
  identifyType: 'document',          // 识别类型
  identifyTitle: '智能填表',         // 弹窗/抽屉标题
  value: true,                       // 显示控制

  // === 预览组件（用于展示 AI 生成结果） ===
  previewComponent: MyPreviewComponent,  // 预览组件
  previewComponentProps: {              // 预览组件的 props
    onFill: (file) => { /* 处理填入操作 */ }
  },

  // === 自定义事件组件（用于接收用户交互输入） ===
  customEventComponent: MyCustomEventComponent,  // 自定义事件组件
  customComponentProps: {                        // 传递给自定义组件的 props
    onConfirm: (data) => { /* 处理确认回调 */ },
    uploadFile: (file) => { /* 处理上传回调 */ }
  },

  // === 自定义应用列表（指定 AI 智能体） ===
  customAppList: [
    {
      agentId: 'agent-uuid',          // 智能体 ID（必填，使用 $utils.guid(12) 生成）
      agentName: '招标文件助手',       // 智能体名称
      agentNo: '',                    // 智能体编号
      agentType: 'bidding_doc',       // 智能体类型
      noNeedAssistant: true           // 是否不需要助手
    }
  ],

  // === 自定义事件处理器 ===
  customEventHandlers: (data, context) => {
    console.log('自定义事件处理', data, context);
  },

  // === 表单填充实例（用于 idea-form-fill 组件） ===
  formFillInstance: this,            // 当前组件实例
});
```

---

### 场景一：智能填表（文档提取）

用于从上传的文档中自动提取信息填充表单字段，配合 `idea-form-fill` 组件使用。

```vue
<template>
  <div>
    <idea-form-fill
      :json-schema="formSchema"
      agent-type="doc_extract"
      identify-title="智能填表"
      @confirm="onConfirm"
    >
      <!-- 可自定义触发的 slot -->
    </idea-form-fill>
  </div>
</template>

<script>
export default {
  data() {
    return {
      aiChat: null,
      agentId: null,
      chatId: null,
      formSchema: {
        type: 'object',
        properties: {
          name: { type: 'string', label: '姓名' },
          phone: { type: 'string', label: '电话' },
          address: { type: 'string', label: '地址' }
        }
      }
    }
  },

  methods: {
    smartFill() {
      if (!this.agentId) {
        this.agentId = this.$utils.guid(12);
      }

      this.aiChat = Vue.$sapi_ai.open({
        layout: 'document-layout',
        customEventComponent: this.myCustomComponent,
        identifyType: 'document',
        identifyTitle: '智能填表',
        formFillInstance: this,
        value: true,
        customComponentProps: {
          onConfirm: this.onConfirm,
          uploadFile: this.uploadFile
        },
        width: '1000px'
      }).on('updateField', ({ key, value }) => {
        if (key === 'currChatId' && value) {
          this.chatId = value;
        }
      });

      // 恢复历史会话
      if (this.chatId) {
        this.aiChat.restore(this.chatId);
      }
    },

    onConfirm(data) {
      // data 为 AI 提取的 JSON 数据
      console.log('AI 提取结果:', data);
      // 将数据填充到表单
      Object.keys(data).forEach(key => {
        if (this.form[key] !== undefined) {
          this.form[key] = data[key];
        }
      });
    },

    uploadFile(file) {
      // 上传文件后触发 AI 提取
      this.currChatId = this.$utils.guid(12);
      this.additionalKwargs = {
        file_path: file[0].filePath,
        json_schema: this.formSchema,
        enableThinking: false
      };
      this._sendContent();
    }
  },

  beforeDestroy() {
    if (this.aiChat) {
      this.aiChat.close();
      this.aiChat = null;
    }
  }
}
</script>
```

---

### 场景二：AI 生成文档（如招标文件）

用于 AI 生成文档并支持预览、填入等操作。

```vue
<script>
// 预览组件：展示 AI 生成结果并提供"填入"按钮
const DocPreview = {
  name: 'DocPreview',
  props: {
    data: { type: Object, default: () => ({}) },
    htmlContent: { type: String, default: '' },
    onFill: { type: Function, default: null }
  },
  computed: {
    iframeSrc() {
      if (!this.data) return '';
      let url = this.data.iframeSrc || this.data.dataPath || '';
      return this.$utils.appendQuery({ aichat: false }, url);
    }
  },
  methods: {
    handleFill() {
      if (typeof this.onFill === 'function') {
        this.onFill(this.data);
      }
    }
  },
  template: `
    <div class="doc-preview-wrap">
      <div class="doc-preview-content">
        <iframe
          v-if="iframeSrc"
          class="idea-ai-chat-preview-iframe"
          :src="iframeSrc"
          frameborder="0"
        ></iframe>
        <div v-else v-safe-html="htmlContent"></div>
      </div>
      <div class="doc-preview-footer">
        <el-button type="primary" size="small" @click="handleFill">填入</el-button>
      </div>
    </div>
  `
};

// 自定义事件组件：接收用户上传文件等交互
const CustomEvent = {
  name: 'CustomEvent',
  props: {
    data: { type: Object, default: () => ({}) },
    fromHistory: { type: Boolean, default: false },
    onConfirm: { type: Function }
  },
  data() {
    return { isUploading: false };
  },
  methods: {
    handleFileSelect(event) {
      const files = event.target.files;
      if (!files || !files.length) return;
      this.uploadFile(files[0]);
      event.target.value = '';
    },
    uploadFile(file) {
      this.isUploading = true;
      Vue.$sapi_uploadTool.requestUploadWithMd5(file, (res) => {
        const uploadedFile = res.data.files[0] || null;
        if (uploadedFile) {
          const fileData = {
            fileId: uploadedFile.id || '',
            hashCode: res.data.fileMd5 || '',
            fileName: uploadedFile.fileName || '',
            extension: uploadedFile.extension || '',
            filePath: uploadedFile.filePath || uploadedFile.relativePath || '',
            fileSize: uploadedFile.fileSize || 0,
            fileMd5: res.data.fileMd5 || ''
          };
          this.uploadChange([fileData]);
        }
        this.isUploading = false;
      }, (err) => {
        Vue.msg(err.message || '文件上传失败');
        this.isUploading = false;
      });
    },
    uploadChange(data) {
      if (!(data && data.length)) return;
      if (typeof this.onConfirm === 'function') {
        this.onConfirm(data);
      }
    }
  },
  template: `
    <div class="custom-event">
      <div class="form-item">
        <label>上传文件模板</label>
        <el-button size="small" :loading="isUploading" @click="$refs.fileInput.click()">
          选择文件
        </el-button>
        <input ref="fileInput" type="file" style="display: none;" @change="handleFileSelect" />
      </div>
    </div>
  `
};

export default {
  data() {
    return {
      agentId: null,
      chatId: null,
      aiChat: null
    }
  },

  methods: {
    aiGenerate() {
      if (!this.agentId) {
        this.agentId = this.$utils.guid(12);
      }

      this.aiChat = Vue.$sapi_ai.open({
        layout: 'drawer-layout',
        previewComponent: DocPreview,
        previewComponentProps: {
          onFill: (file) => this.handleFill(file)
        },
        customEventComponent: CustomEvent,
        customComponentProps: {
          onConfirm: (data) => this.handleUpload(data)
        },
        customAppList: [
          {
            agentId: this.agentId,
            agentName: '文档生成助手',
            agentNo: '',
            agentType: 'bidding_doc',
            noNeedAssistant: true
          }
        ],
        customEventHandlers: (data, context) => {
          console.log('customEventHandlers', data, context);
        }
      }).on('updateField', ({ key, value }) => {
        if (key === 'currChatId' && value) {
          this.chatId = value;
        }
      });

      // 恢复历史会话
      if (this.chatId) {
        this.aiChat.restore(this.chatId);
      } else {
        // 首次打开，自动发送初始消息
        this.aiChat.send({
          content: '生成文档',
          enableThinking: false,
          additionalKwargs: {
            field_values: this.formData
          }
        });
      }
    },

    // 用户上传文件后继续对话
    handleUpload(data) {
      const file = data[0] || {};
      this.aiChat.send({
        content: '已上传文件模板',
        enableThinking: false,
        displayFiles: [{
          fileId: file.fileId || '',
          hashCode: file.hashCode || '',
          fileName: file.fileName || '',
          extension: file.extension || '',
          filePath: file.filePath || '',
          fileSize: file.fileSize || 0
        }],
        additionalKwargs: {
          file_name: file.fileName + file.extension
        }
      });
    },

    // 处理 AI 生成结果的填入操作
    handleFill(file) {
      const filePath = file && (file.filePath || file.file_path || '');
      if (!filePath) {
        Vue.msg('未获取到可填入的文件');
        return;
      }
      // 保存文件到业务数据
      // ...
    }
  },

  beforeDestroy() {
    if (this.aiChat) {
      this.aiChat.close();
      this.aiChat = null;
      this.chatId = null;
    }
  }
}
</script>
```

---

### send 方法参数说明

```javascript
aiChat.send({
  content: '消息内容',                      // 消息文本
  enableThinking: false,                    // 是否启用思考模式
  displayFiles: [                           // 展示的文件列表
    {
      fileId: 'xxx',
      fileName: '招标文件.docx',
      extension: '.docx',
      filePath: '/path/to/file.docx',
      fileSize: 102400
    }
  ],
  additionalKwargs: {                       // 额外参数（传递给 AI 智能体）
    field_values: {},                       // 表单字段值
    json_schema: {},                        // JSON Schema
    file_name: 'xxx.docx',                  // 文件名
    file_path: '/path/to/file.docx',        // 文件路径
    enableThinking: false                   // 是否启用思考
  }
});
```

---

### 生命周期管理

```javascript
// 组件中正确管理 AI 聊天实例生命周期
export default {
  data() {
    return {
      aiChat: null,
      chatId: null
    }
  },

  methods: {
    openAiChat() {
      // 生成唯一 agentId（同一实例复用）
      if (!this.agentId) {
        this.agentId = this.$utils.guid(12);
      }

      this.aiChat = Vue.$sapi_ai.open({ /* options */ })
        .on('updateField', ({ key, value }) => {
          if (key === 'currChatId' && value) {
            this.chatId = value;
          }
        });

      // 恢复历史会话
      if (this.chatId) {
        this.aiChat.restore(this.chatId);
      }
    }
  },

  beforeDestroy() {
    // 必须：组件销毁时关闭 AI 聊天
    if (this.aiChat) {
      this.aiChat.close();
      this.aiChat = null;
      this.chatId = null;
    }
  }
}
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
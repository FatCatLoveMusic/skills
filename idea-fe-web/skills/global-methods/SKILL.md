---
name: global-methods
description: Provides unified access to web-framework global methods including $utils, $getBasicInfo, $init, etc. Invoke when needing utility functions, user info, or other global methods in web-framework projects.
---

# web-framework 全局方法

## 概述

web-framework 提供了一系列全局方法，通过 `this` 或 `Vue` 全局对象访问。

**核心原则：** 在实现自定义解决方案之前，先检查内置的全局方法。

## 快速索引

| 方法类别 | 常用方法 | 适用场景 |
|----------|----------|----------|
| **用户信息** | `$getBasicInfo()`, `$loginInfo`, `$getToken()`, `$basicInfo` | 获取用户信息、登录信息、token |
| **工具函数** | `$utils` (80+工具函数) | 类型判断、DOM操作、数据处理等 |
| **消息提示** | `successMsg()`, `errorMsg()`, `msg()` | 操作成功、失败、普通提示 |
| **确认框** | `$confirmTips()`, `$deleteTips()` | 需要用户确认操作时 |
| **加载状态** | `$loadingOpen()`, `$loadingClose()`, `$loading()` | 数据加载时显示loading |
| **表单提示** | `$tips()`, `$errorTips()`, `$closeTips()`, `$waringTips()` | 表单字段验证提示 |
| **页面初始化** | `$init()`, `$setTitle()` | 初始化权限、设置页面标题 |
| **HTTP请求** | `$get()`, `$post()`, `$put()`, `$delete()`, `$request()` | 发送HTTP请求 |
| **多语言** | `$t()`, `Vue.toLocale()` | 国际化翻译、语言切换 |
| **登录登出** | `$signOut()`, `$signIn()` | 用户登录、退出登录 |
| **跨标签页通信** | `$broadcastAsyncTab()`, `$listenAsyncTab()` | 标签页间事件通信 |
| **sapi组件工具** | `$sapi_dialog`, `$sapi_uploadTool`, `$sapi_xlsxExportTool`, `$sapi_ai` | 对话框、上传、导出、AI助手 |
| **Mixins** | `$mixins.pagerMixin`, `$mixins.filterMixin`, `$mixins.tabMixin` | 分页、筛选、标签页混合 |
| **配置信息** | `$webConfig`, `$appConfig`, `$oemConfig`, `$appDir` | 站点、应用、OEM配置 |
| **主题与样式** | `$changeSkinTheme()`, `$layoutDD`, `$elSelectMultSize` | 主题切换、布局配置 |
| **字符验证** | `$checkedASCII()`, `$checkedSpecial()` | ASCII字符验证、特殊字符验证 |
| **验证器** | `$validators` | 表单验证器 |
| **Element事件** | `$elementDispatch()`, `$elementBroadcast()` | Element UI组件事件 |
| **懒加载请求** | `$LazyRequest` | 懒加载请求 |
| **图片资源** | `$getImgResourse()`, `$setImagePrew()`, `$setVideoPrew()` | 图片视频预览 |
| **其他方法** | `$dateFormat()`, `$getUrlParams()`, `$typeof()`, `$clientStorage`, `$closeWindow()`, `$notification` | 日期、URL、类型、存储、窗口、通知等 |
| **懒加载库** | `$echartsLazy()`, `$xlsxLazy()`, `$jsoneditorLazy()`, `$luckysheetLazy()`, `$tinymceLazy()`, `$monacoEditorLazy()` | 按需加载第三方库 |

## 常用方法速查

### 用户信息

```javascript
// 获取当前登录用户信息
this.$getBasicInfo().id;           // 用户ID
this.$getBasicInfo().name;          // 用户名称
this.$getBasicInfo().userid;        // 用户账号

// 获取 Token
this.$getToken();

// 获取登录信息
this.$loginInfo;
```

### HTTP 请求

```javascript
// GET 请求
this.$get('/api/users', { page: 1 }, (res) => { /* 成功 */ });

// POST 请求
this.$post('/api/save', data, (res) => { /* 成功 */ }, (err) => { /* 失败 */ });

// PUT 请求
this.$put('/api/update/1', data, success);

// DELETE 请求
this.$delete('/api/delete/1', success);
```

### 消息提示

```javascript
Vue.successMsg('操作成功');           // 成功提示
Vue.errorMsg('操作失败');             // 错误提示
Vue.msg('提示信息', { type: 'warning' }); // 普通提示
```

### 确认框

```javascript
this.$confirmTips('确定删除吗？', () => {
  this.deleteItem();
});

this.$deleteTips(() => {
  this.deleteItem();
});
```

### 加载状态

```javascript
this.$loadingOpen();     // 打开 loading
this.$loadingClose();    // 关闭 loading
this.$loading(true);     // 手动控制 loading
```

### 表单提示

```javascript
this.$tips('请输入名称', '#input');        // 表单提示
this.$errorTips('格式错误', '#input');     // 错误提示
this.$closeTips();                         // 关闭提示
```

### 工具函数

```javascript
this.$utils.isEmpty(value);           // 判断空值
this.$utils.formatDate(date, 'yyyy-MM-dd'); // 日期格式化
this.$utils.getQueryString('id');    // 获取URL参数
this.$utils.debounce(fn, 300);       // 防抖
this.$utils.throttle(fn, 100);       // 节流
this.$utils.localStorage.set('key', value, true); // 存储（退出登录自动清除）
this.$utils.camelCase('user_name');  // 字符串转驼峰：userName
this.$utils.camelCaseKeys({ user_name: 'test', user_info: { user_age: 18 } }); // 深度递归转换对象属性名
```

### 页面初始化

```javascript
this.$init();                        // 完整初始化
this.$init({ noTable: true });       // 仅初始化权限
this.$setTitle('用户管理');          // 设置页面标题
```

### 跨标签页通信

```javascript
// 广播事件
this.$broadcastAsyncTab('refresh-list');

// 监听事件
this.$listenAsyncTab('refresh-list', () => {
  this.loadData();
});
```

### 多语言

```javascript
this.$t('common.save');                    // 获取翻译
Vue.toLocale({ 'zh-cn': langModule });    // 注册语言包
```

### 选择器对话框

```javascript
Vue.$sapi_dialog.chooseUser({
  multiple: true,
  onClose: (users) => {
    console.log('选中的用户:', users);
  }
}).show();
```

### Mixins 使用

```javascript
export default {
  mixins: [Vue.$mixins.pagerMixin],  // 分页混合
  created() {
    this.loadData();  // 自动包含 pageNum, pageSize, total 等
  }
}
```

### 懒加载第三方库

```javascript
Vue.$echartsLazy().then((echarts) => {
  const chart = echarts.init(this.$refs.chart);
  chart.setOption({ /* ... */ });
});

Vue.$xlsxLazy().then((xlsx) => {
  // 处理 Excel 文件
});

Vue.$monacoEditorLazy().then((monaco) => {
  // 使用 Monaco Editor
});
```

## 注意事项

### 调用方式

| 方法 | 调用方式 | 说明 |
|------|----------|------|
| `successMsg`, `errorMsg`, `msg` | `Vue.xxx()` | 全局调用 |
| `this.$utils` | `this.$utils.xxx()` | 组件内调用 |
| `$confirmTips`, `$tips`, `$init` | `this.$xxx()` | 组件内调用 |
| `$broadcastAsyncTab`, `$listenAsyncTab` | `this.$xxx()` | 组件内调用 |
| `$broadcastAsyncTab` (全局) | `Vue.$xxx()` | 组件外调用 |

### 存储安全

```javascript
// 敏感数据设置退出登录自动清除
this.$utils.localStorage.set('token', token, true);
```

### Loading 自动管理

HTTP 请求方法默认自动显示/关闭 loading，设置 `{loading: false}` 可禁用。

### 常见错误

| 错误 | 正确 |
|------|------|
| `Vue.successMsg()` 在组件内调用 | 使用 `Vue.successMsg()`（全局） |
| 忘记在组件内用 `this` | 使用 `this.$utils` |
| 敏感数据未设置 `signOutClear` | 第三个参数设为 `true` |

## 详细文档

详细的方法说明和示例请查看 references 目录下的文档：

| 文档 | 内容 |
|------|------|
| [utils-api-reference.md](references/utils-api-reference.md) | `$utils` 完整 API |
| [http-request-methods.md](references/http-request-methods.md) | HTTP 请求方法详解 |
| [dialog-and-confirm.md](references/dialog-and-confirm.md) | 对话框、确认框、提示方法 |
| [cross-tab-communication.md](references/cross-tab-communication.md) | 跨标签页通信详解 |
| [sapi-components.md](references/sapi-components.md) | SAPI 组件工具详解 |
| [mixins-reference.md](references/mixins-reference.md) | Mixins 混合方法详解 |
| [lazy-load-libs.md](references/lazy-load-libs.md) | 懒加载库详解 |
| [less-common-methods.md](references/less-common-methods.md) | 其他方法详解 |
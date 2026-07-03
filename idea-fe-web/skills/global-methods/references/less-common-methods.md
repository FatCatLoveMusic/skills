# 其他方法详解

本文档详细介绍 web-framework 中一些不太常用但有用的全局方法和属性。

---

## 用户信息与登录相关

### this.$loginInfo

登录信息对象。

**类型：** object

**使用示例：**

```javascript
// 获取登录信息
const loginInfo = this.$loginInfo;

console.log('用户ID:', loginInfo.userId);
console.log('用户名:', loginInfo.username);
console.log('Token:', loginInfo.accessToken);
```

---

### this.$getToken()

获取 access_token。

**返回值：** string - 当前用户的访问令牌

**使用示例：**

```javascript
// 获取 Token
const token = this.$getToken();

// 在请求头中使用
this.$request({
  url: '/api/data',
  headers: {
    'Authorization': `Bearer ${this.$getToken()}`
  }
});
```

---

### this.$basicInfo

基础信息对象（从用户接口获取的详细信息）。

**类型：** object

**使用示例：**

```javascript
// 获取基础信息
const basicInfo = this.$basicInfo;

if (basicInfo) {
  console.log('员工姓名:', basicInfo.employeeName);
  console.log('部门:', basicInfo.departmentName);
}
```

---

### this.$signOut(redirect, isTriggerSignOut)

退出登录。

**参数说明：**

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `redirect` | string | - | 退出后重定向的 URL |
| `isTriggerSignOut` | boolean | true | 是否调用后端退出接口 |

**使用示例：**

```javascript
// 基础退出
this.$signOut();

// 退出后跳转登录页
this.$signOut('/login');

// 只清除本地数据，不调用后端
this.$signOut(null, false);
```

---

## 工具方法

### this.$dateFormat(fmt, date)

日期格式化。

**参数说明：**

| 参数 | 类型 | 说明 |
|------|------|------|
| `fmt` | string | 格式字符串，如 'yyyy-MM-dd hh:mm:ss' |
| `date` | Date/string | 要格式化的日期 |

**使用示例：**

```javascript
// 格式化日期
const dateStr = this.$dateFormat('yyyy-MM-dd', new Date());
// 返回: "2024-01-15"

const dateTimeStr = this.$dateFormat('yyyy-MM-dd hh:mm:ss', new Date());
// 返回: "2024-01-15 14:30:00"

// 格式化时间字符串
const str = this.$dateFormat('yyyy年MM月dd日', '2024-01-15');
// 返回: "2024年01月15日"
```

---

### this.$getUrlParams(name)

获取 URL 参数。

**参数说明：**

| 参数 | 类型 | 说明 |
|------|------|------|
| `name` | string | 参数名称 |

**使用示例：**

```javascript
// URL: http://example.com/page?id=123&name=zhangsan

// 获取 id 参数
const id = this.$getUrlParams('id');
// 返回: "123"

// 获取 name 参数
const name = this.$getUrlParams('name');
// 返回: "zhangsan"

// 获取不存在的参数
const notExist = this.$getUrlParams('page');
// 返回: null
```

---

### this.$getHashParams(name)

获取路由 hash 参数。

**使用示例：**

```javascript
// URL: http://example.com/#/page?token=abc123

// 获取 token
const token = this.$getHashParams('token');
// 返回: "abc123"
```

---

### this.$utils.camelCaseKeys(data)

深度递归转换对象或数组中的属性名为驼峰命名。

**参数说明：**

| 参数 | 类型 | 说明 |
|------|------|------|
| `data` | object/array | 需要转换的数据对象或数组 |

**返回值：** object/array - 转换后的数据

**使用示例：**

```javascript
// 转换对象属性名
const result = this.$utils.camelCaseKeys({
  user_name: '张三',
  user_info: {
    user_age: 18,
    user_email: 'test@example.com'
  }
});
// 返回: { userName: '张三', userInfo: { userAge: 18, userEmail: 'test@example.com' } }

// 转换数组中的对象属性名
const arrResult = this.$utils.camelCaseKeys([
  { id: 1, user_name: '张三' },
  { id: 2, user_name: '李四' }
]);
// 返回: [{ id: 1, userName: '张三' }, { id: 2, userName: '李四' }]

// 嵌套数组和对象
const nestedResult = this.$utils.camelCaseKeys({
  list_data: [
    { item_id: 1, item_name: '商品1' },
    { item_id: 2, item_name: '商品2' }
  ]
});
// 返回: { listData: [{ itemId: 1, itemName: '商品1' }, { itemId: 2, itemName: '商品2' }] }
```

---

### this.$typeof(val)

判断数据类型。

**返回值：** string - 'string' | 'number' | 'boolean' | 'array' | 'object' | 'function' | 'date' | 'null' | 'undefined' 等

**使用示例：**

```javascript
// 判断各种类型
console.log(this.$typeof('hello'));    // "string"
console.log(this.$typeof(123));       // "number"
console.log(this.$typeof(true));      // "boolean"
console.log(this.$typeof([1, 2]));    // "array"
console.log(this.$typeof({ a: 1 })); // "object"
console.log(this.$typeof(function(){})); // "function"
console.log(this.$typeof(new Date()));   // "date"
console.log(this.$typeof(null));          // "null"
console.log(this.$typeof(undefined));     // "undefined"
```

---

### this.$clientStorage

本地存储对象，自动选择 localStorage 或 sessionStorage。

**类型：** object

**方法：**

| 方法 | 说明 |
|------|------|
| `get(key)` | 获取值 |
| `set(key, value)` | 设置值 |
| `remove(key)` | 删除值 |
| `clear()` | 清空所有值 |

**使用示例：**

```javascript
// 存储数据
this.$clientStorage.set('user', { name: '张三' });

// 获取数据
const user = this.$clientStorage.get('user');
console.log(user.name);

// 删除数据
this.$clientStorage.remove('user');

// 清空
this.$clientStorage.clear();
```

---

## 字符验证方法

### this.$checkedASCII(val)

检查是否只包含 ASCII 字符（无中文）。

**返回值：** boolean

**使用示例：**

```javascript
// 验证用户名（不能包含中文）
if (!this.$checkedASCII(this.username)) {
  this.$errorTips('用户名不能包含中文字符', '#username');
  return;
}
```

---

### this.$checkedSpecial(val)

检查是否只包含字母和数字（无中文和特殊字符）。

**返回值：** boolean

**使用示例：**

```javascript
// 验证密码格式（只能包含字母和数字）
if (!this.$checkedSpecial(this.password)) {
  this.$errorTips('密码只能包含字母和数字', '#password');
  return;
}
```

---

## 验证器

### this.$validators

自定义验证器集合。

**类型：** object

**使用示例：**

```javascript
// 在表单验证中使用
rules: {
  username: [
    { required: true, message: '请输入用户名' },
    {
      validator: (rule, value, callback) => {
        this.$validators.checkedASCII(rule, value, callback, this, '用户名不能包含中文');
      }
    }
  ],
  password: [
    { required: true, message: '请输入密码' },
    {
      validator: (rule, value, callback) => {
        this.$validators.checkedSpecial(rule, value, callback, this, '密码只能包含字母和数字');
      }
    }
  ]
}
```

---

## Element UI 事件方法

### this.$elementDispatch(componentInstance, eventName)

Element UI 组件事件派发。

**参数说明：**

| 参数 | 类型 | 说明 |
|------|------|------|
| `componentInstance` | Vue instance | 目标组件实例 |
| `eventName` | string | 事件名称 |

**使用示例：**

```javascript
// 派发事件到特定组件
this.$elementDispatch(this.$refs.selectComponent, 'visible-change', true);
```

---

### this.$elementBroadcast(componentInstance, eventName, params)

Element UI 组件事件广播。

**参数说明：**

| 参数 | 类型 | 说明 |
|------|------|------|
| `componentInstance` | Vue instance | 起始组件实例 |
| `eventName` | string | 事件名称 |
| `params` | any | 传递给子组件的参数 |

**使用示例：**

```javascript
// 广播事件给所有子组件
this.$elementBroadcast(this, 'table-sort-change', { order: 'ascending' });
```

---

## 懒加载请求

### this.$LazyRequest

请求缓存类，支持请求结果缓存。

**源码位置：** `src/static/js/install/methods/lazy-request.js`

**使用示例：**

```javascript
// 创建实例
const lazyRequest = new this.$LazyRequest({
  cacheId: 'user-list',
  cacheExpires: 60  // 缓存60秒
});

// GET 请求
lazyRequest.requestGet({
  url: '/api/users',
  params: { status: 1 }
}).then((res) => {
  this.users = res.data;
});

// POST 请求
lazyRequest.requestPost({
  url: '/api/users',
  data: { name: '张三' }
}).then((res) => {
  this.user = res.data;
});

// 清除缓存
lazyRequest.clearCache();

// 销毁
lazyRequest.destroy();
```

---

## 图片与预览

### this.$getImgResourse(path, index)

获取图片资源路径。

**使用示例：**

```javascript
// 获取图片资源
const imgPath = this.$getImgResourse('/images/logo.png');
console.log(imgPath);
```

---

### this.$setImagePrew(path, index)

预览图片。

**使用示例：**

```javascript
// 预览单张图片
await this.$setImagePrew('/images/photo.jpg');

// 预览图片列表
await this.$setImagePrew([
  '/images/photo1.jpg',
  '/images/photo2.jpg'
], 0);  // 从第一张开始
```

---

### this.$setVideoPrew(fileData)

预览视频。

**使用示例：**

```javascript
this.$setVideoPrew({
  url: '/videos/demo.mp4',
  name: '演示视频'
});
```

---

## 页面与窗口

### this.$setTitle(name)

设置页面标题。

**使用示例：**

```javascript
this.$setTitle('用户管理 - 管理后台');
```

---

### this.$closeWindow(delay)

关闭当前窗口。

**参数说明：**

| 参数 | 类型 | 说明 |
|------|------|------|
| `delay` | number/boolean | 延迟关闭时间（毫秒），true 表示 2000ms |

**使用示例：**

```javascript
// 立即关闭
this.$closeWindow();

// 延迟2秒关闭
this.$closeWindow(2000);

// 使用默认延迟
this.$closeWindow(true);
```

---

### this.$scrollToDom(dom, animate, callback, topOffset, bottomOffset)

滚动到指定元素位置。

**参数说明：**

| 参数 | 类型 | 说明 |
|------|------|------|
| `dom` | Element | 目标元素 |
| `animate` | boolean | 是否启用动画 |
| `callback` | function | 滚动完成回调 |
| `topOffset` | number | 上偏移量 |
| `bottomOffset` | number | 下偏移量 |

**使用示例：**

```javascript
// 滚动到表单顶部
this.$scrollToDom(this.$refs.form, true, () => {
  console.log('已滚动到表单');
}, 100);  // 上偏移100px
```

---

## 配置信息

### this.$webConfig

站点配置对象。

**属性：**

| 属性 | 类型 | 说明 |
|------|------|------|
| `baseUrl` | string | 基础 URL |
| `fileServer` | string | 文件服务器地址 |
| `loginUrl` | string | 登录页面 URL |
| `defaultUrl` | string | 默认首页 URL |
| `client` | string | 客户端标识 |

**使用示例：**

```javascript
// 获取 API 基础路径
const baseUrl = this.$webConfig.baseUrl;

// 获取文件服务器地址
const fileServer = this.$webConfig.fileServer;

// 拼接完整文件 URL
const fileUrl = fileServer + '/uploads/file.pdf';
```

---

### this.$appConfig

应用配置对象。

**使用示例：**

```javascript
const appName = this.$appConfig.appName;
const appVersion = this.$appConfig.version;
```

---

### this.$oemConfig

OEM 品牌配置。

**属性：**

| 属性 | 类型 | 说明 |
|------|------|------|
| `loginPageLogo` | string | 登录页 Logo |
| `systemName` | string | 系统名称 |
| `copyrightContent` | string | 版权信息 |

**使用示例：**

```javascript
// 获取 OEM 配置
const systemName = this.$oemConfig.systemName;
const logo = this.$oemConfig.loginPageLogo;
const copyright = this.$oemConfig.copyrightContent;
```

---

### this.$appDir

应用虚拟目录名称。

**使用示例：**

```javascript
const appDir = this.$appDir;
console.log('当前应用目录:', appDir);
```

---

## 主题与布局

### this.$changeSkinTheme(skinTheme, isAsyncTab)

更改主题。

**参数说明：**

| 参数 | 类型 | 说明 |
|------|------|------|
| `skinTheme` | string | 主题 ID，如 'blue', 'dark' |
| `isAsyncTab` | boolean | 是否同步到其他标签页 |

**使用示例：**

```javascript
// 切换到深色主题
this.$changeSkinTheme('dark', true);
```

---

### this.$layoutDD

布局配置对象。

**使用示例：**

```javascript
// 获取当前布局
const currentLayout = this.$layoutDD.panelLayout;
```

---

### this.$skinTheme

当前皮肤主题。

**使用示例：**

```javascript
const theme = this.$skinTheme;
console.log('当前主题:', theme);
```

---

### this.$layout

当前布局类型。

**使用示例：**

```javascript
if (this.$layout === this.$layoutDD.panelLayout) {
  // 面板布局处理
}
```

---

## 全局属性

### Vue.$_

lodash 库的全局引用。

**使用示例：**

```javascript
const arr = Vue.$_.chunk([1, 2, 3, 4], 2);
// [[1, 2], [3, 4]]

const sum = Vue.$_.sum([1, 2, 3, 4]);
// 10
```

---

### Vue.$NP

number-precision 库的全局引用（精确数字运算）。

**使用示例：**

```javascript
// 避免浮点数精度问题
const result = Vue.$NP.plus(0.1, 0.2);
// 0.3（正确）

const a = Vue.$NP.minus(0.3, 0.1);
// 0.2（正确）

const b = Vue.$NP.times(0.2, 0.3);
// 0.06（正确）

const c = Vue.$NP.divide(0.6, 0.2);
// 3（正确）
```

---

### Vue.$resizeEvent

窗口大小改变事件监听。

**使用示例：**

```javascript
// 添加 resize 监听
Vue.$resizeEvent.addResizeListener(this.$el, () => {
  console.log('容器大小已改变');
  this.handleResize();
});

// 移除监听
Vue.$resizeEvent.removeResizeListener(this.$el, () => {
  console.log('容器大小已改变');
  this.handleResize();
});
```

---

### Vue.$frameworkRoot

框架根 Vue 实例。

**使用示例：**

```javascript
const rootVm = Vue.$frameworkRoot;
console.log('框架根实例:', rootVm);
```

---

### Vue.$innerEmbedPage

内嵌页面处理工具。

**使用示例：**

```javascript
if (Vue.$innerEmbedPage) {
  Vue.$innerEmbedPage.hijackRoot(vm);
}
```

---

### Vue.$displayNoFrame

是否全屏模式（不显示框架）。

**使用示例：**

```javascript
if (Vue.$displayNoFrame) {
  // 全屏模式处理
  this.showHeader = false;
}
```

---

### Vue.$isOnlineApp

是否在线应用模式。

**使用示例：**

```javascript
if (Vue.$isOnlineApp) {
  console.log('在线应用模式');
}
```

---

### Vue.$onlineAppBasePath

在线应用基础路径。

**使用示例：**

```javascript
const basePath = Vue.$onlineAppBasePath;
console.log('在线应用路径:', basePath);
```

---

### Vue.$onlineAppClient

在线应用客户端标识。

**使用示例：**

```javascript
const client = Vue.$onlineAppClient;
console.log('客户端:', client);
```
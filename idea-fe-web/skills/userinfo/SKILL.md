---
name: userinfo
description: 获取web-framework当前登录用户信息，使用this.$getBasicInfo()方法。当用户需要获取用户ID、用户名、用户账号、员工信息、当前登录人信息时使用此技能。返回id、name、userid、skinTheme、employeeName、employeeid等字段。
---

# userinfo

## 描述

web-framework 提供了 `this.$getBasicInfo()` 方法用于获取当前登录用户的基本信息。

## 触发条件

### 适用场景
- 用户需要获取当前登录用户信息
- 用户询问如何获取用户ID、用户名等
- 代码中需要使用当前登录用户的信息

### 不适用场景
- 获取其他用户的信息
- 用户登录/登出操作
- 修改用户信息

## 输入输出定义

### Input
- 无参数

### Output
- userInfo: object - 当前登录用户信息对象
  - id: string - 用户ID
  - name: string - 用户名称
  - userid: string - 用户账号
  - skinTheme: string - 皮肤主题
  - employeeName: string - 员工姓名
  - employeeid: string - 员工ID

## 执行步骤

1. 确认需求：确定用户需要获取哪些用户信息字段
2. 提供方法：返回 `this.$getBasicInfo()` 的调用方式
3. 说明返回结构：解释返回对象的各个字段含义
4. 提供示例：给出常见的使用场景示例代码

## 失败策略

- 方法不存在：确认项目是否包含 portal-template 依赖
- 返回值为 null/undefined：提示用户可能未登录，建议检查登录状态
- 字段不明确：提供完整的字段说明表格

## 方法说明

```javascript
const userInfo = this.$getBasicInfo();
```

## 返回数据结构

```json
{
  "id": "d17e1601af6911e98af2005056b6b8b0",
  "name": "超级管理员",
  "userid": "admin",
  "skinTheme": "blue",
  "employeeName": "超管",
  "employeeid": "6353594226794363a426641aa42d011d"
}
```

## 字段说明

| 字段名 | 类型 | 说明 |
|-------|------|------|
| `id` | string | 用户ID |
| `name` | string | 用户名称 |
| `userid` | string | 用户账号 |
| `skinTheme` | string | 皮肤主题 |
| `employeeName` | string | 员工姓名 |
| `employeeid` | string | 员工ID |

## 示例

### 输入示例
- "怎么获取当前登录用户信息？"
- "获取当前用户ID"
- "this.$getBasicInfo() 怎么用？"

### 输出示例

```javascript
// 获取当前登录用户ID
const userId = this.$getBasicInfo().id;

// 获取当前登录用户名称
const userName = this.$getBasicInfo().name;

// 获取完整用户信息
const userInfo = this.$getBasicInfo();
console.log(userInfo.name, userInfo.userid);
```

## 注意事项

- 该方法返回的是当前登录用户的信息，不能用于获取其他用户
- 使用前请确保用户已登录，否则可能返回 null 或 undefined
- 如需修改用户信息，请使用对应的 API 接口，而非直接修改此返回对象
- 该方法为同步方法，无需 await

---
name: "getBasicInfo"
description: "提供获取当前登录用户信息的方法this.$getBasicInfo()的使用文档"
---

# getBasicInfo 子技能

## 技能名称
getBasicInfo

## 触发条件
当用户需要获取当前登录用户信息时触发此技能

## 技能描述
web-framework提供了`this.$getBasicInfo()`方法用于获取当前登录用户的基本信息

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

## 使用示例
```javascript
// 获取当前登录用户ID
const userId = this.$getBasicInfo().id;

// 获取当前登录用户名称
const userName = this.$getBasicInfo().name;
```
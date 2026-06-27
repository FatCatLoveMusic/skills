# Utils API 参考

## 类型判断

| 方法名 | 作用 |
|--------|------|
| `isType(type)` | 返回判定指定数据类型的函数，type可选值：Object/String/Boolean/Function/Date/Number/Array |
| `isArray(obj)` | 判定是否数组 |
| `isString(obj)` | 判断是否字符串 |
| `isBoolean(obj)` | 判断是否boolean类型 |
| `isFunction(obj)` | 判定是否函数 |
| `isDate(obj)` | 判定是日期类型 |
| `isNumber(obj)` | 判定是否数字类型 |
| `isInt(obj)` | 判定是否整数 |
| `isNull(obj)` | 判定是否Null值 |
| `isUndefined(obj)` | 判定是否undefined |
| `isNullOrUndefined(obj)` | 判定是否null或者undefined值 |
| `isNumeric(obj)` | 判定是否数值型数据，包含字符串数字 |
| `isPlainObject(obj)` | 判定是否普通对象 |
| `isObject(obj)` | 同 isPlainObject，判定是否普通对象 |
| `isEmpty(obj)` | 判定是否为空值（null/undefined/''/NaN） |
| `hasOwn(obj, prop)` | 判断对象是否拥有非继承的属性 |
| `hasOwns(obj, props)` | 判断对象是否拥有多个非继承属性 |

## DOM操作

| 方法名 | 作用 |
|--------|------|
| `query(el, dom?)` | 获取html元素，返回一个，不存在返回null |
| `queryAll(el, dom?)` | 获取html元素，返回多个，不存在返回null |
| `isDom(el)` | 判断是否dom元素 |
| `transformToDom(html)` | HTML字符串转DOM元素 |
| `on(el, event, handler)` | 监听事件 |
| `off(el, event, handler)` | 取消监听事件 |
| `once(el, event, handler)` | 只绑定一次监听事件 |
| `hasClass(el, cls)` | 判断元素是否有className |
| `addClass(el, cls)` | 给元素添加className |
| `removeClass(el, cls)` | 移除元素className |
| `getStyle(el, styleName, defaultVal?)` | 获取元素某个样式 |
| `setStyle(el, styleName, value)` | 设置元素某个样式，支持对象批量设置 |
| `cascadeStyle(parent, style)` | 限定样式作用在某个父级下有效 |
| `getMaxZIndex(currDom?)` | 获取页面最大的zIndex值 |
| `isHidden(el)` | 判断元素是否隐藏不可见 |

## 字符串处理

| 方法名 | 作用 |
|--------|------|
| `guid(len?)` | 获取guid唯一标识，默认长度27 |
| `trim(string)` | 清除字符串两边空格 |
| `capitalize(letter)` | 转换首字母大写 |
| `capitalizeTypeName(type)` | 转换数据类型名称 |
| `camelCase(name)` | 字符串转camel（驼峰）格式 |
| `amountToChinese(amount)` | 数字转换汉字大写金额 |
| `escapeHtml(target)` | 编码字符串中的html（防XSS） |
| `unescapeHtml(target)` | 解码字符串中的html |
| `safeHtml(value)` | 消毒html字符串（基于sanitize-html） |

## 数字处理

| 方法名 | 作用 |
|--------|------|
| `parseInt(number, defaultValue?)` | 转整数，存在小数会四舍五入 |
| `parseDecimal(number, places?, min?, max?, defaultValue?)` | 转换小数格式，默认保留2位小数 |
| `parsePercent(number, places?, defaultValue?)` | 转百分比格式 |
| `toThousands(number, places?, defaultValue?)` | 数字转千分位格式 |

## 数组与对象操作

| 方法名 | 作用 |
|--------|------|
| `unique(arr)` | 数组去重 |
| `merge(...args)` | 合并数组，最后一个参数为boolean时表示是否去重 |
| `transpose(arr, index1, index2)` | 数组元素互换位置/对象属性值互换 |
| `namespace(namespace, root)` | 返回指定的命名空间下对象，若不存在则创建 |
| `isExistNamespace(namespace, root)` | 判断命名空间是否存在 |
| `forEach(data, callback)` | 遍历数组和对象属性 |
| `assign(target, obj, bCover?, bDepth?)` | 将obj属性并入target对象，默认不覆盖 |
| `get(object, path, defaultValue?)` | 根据属性路径返回值（lodash get） |
| `set(object, path, value)` | 根据属性路径赋值（lodash set） |
| `getter(target, path?, valid?)` | 取值方法，支持路径校验 |

## 日期处理

| 方法名 | 作用 |
|--------|------|
| `parseDate(strDate, defaultValue?)` | 字符串转换为Date对象 |
| `formatDate(date, fmt?)` | 日期格式化，默认格式：yyyy-MM-dd hh:mm:ss |
| `getDateInterval(start, end, unit?, defaultValue?)` | 获取两个时间差，单位：d/h/m/s/ms |
| `getDateByDaysApart(date, number, defaultValue?)` | 获取相隔几天后的日期 |
| `getDateByMonthApart(date, number, defaultValue?)` | 获取相隔几月后的日期 |
| `getDateByMonthApartExtend(date, number, isStart?, defaultValue?)` | 获取月份开始/结束日期 |
| `getDateByYearApart(date, number, defaultValue?)` | 获取相隔几年后的日期 |
| `getDateByYearApartExtend(date, number, isStart?, defaultValue?)` | 获取年份开始/结束日期 |
| `setWorkDays(days)` | 设置工作日（数字数组，范围0-6） |
| `isWorkDay(date)` | 判断是否工作日 |

## URL处理

| 方法名 | 作用 |
|--------|------|
| `getQueryString(name, url?, isDeCode?)` | 获取url上query参数 |
| `setQueryString(params, url?, transcoding?)` | 给url设置params参数 |
| `appendQuery(params, url?)` | 给url追加params参数（新参数覆盖原有） |
| `parseQuery(url, separator?, decode?)` | 获取query参数对象 |
| `replacePathParams(url, params)` | 替换请求api上path参数（{param}格式） |
| `addRandomQuery(url?, random?, refresh?)` | 给url添加随机query参数 |
| `isSiteUrl(url)` | 判断是否是完整站点URL（http/https开头） |
| `parseAppUrl(url)` | 解析应用URL，支持虚拟目录部署 |
| `innerRedirect(url)` | 站点内页面跳转 |
| `innerReplace(url)` | 站点内跳转，不留历史记录 |
| `innerOpen(url)` | 弹出应用内页面 |
| `joinPath(...paths)` | 拼接路径，自动处理斜杠 |

## 存储操作

| 方法名 | 作用 |
|--------|------|
| `localStorage.set(key, value, signOutClear?)` | 设置localStorage，支持退出登录自动清除 |
| `localStorage.get(key, defaultValue?)` | 获取localStorage值 |
| `localStorage.remove(key)` | 删除localStorage项 |
| `localStorage.clear()` | 清空localStorage |
| `sessionStorage.set(key, value, signOutClear?)` | 设置sessionStorage |
| `sessionStorage.get(key, defaultValue?)` | 获取sessionStorage值 |
| `sessionStorage.remove(key)` | 删除sessionStorage项 |
| `sessionStorage.clear()` | 清空sessionStorage |
| `cookie.set(key, value, expiredays?, noStoreKey?)` | 设置cookie |
| `cookie.get(key, defaultValue?, noStoreKey?)` | 获取cookie值 |
| `cookie.remove(key, noStoreKey?)` | 删除cookie |
| `signOutClearKeys(storage)` | 退出登录清除缓存key集合操作 |
| `appStoreKeySuffix()` | 获取应用本地存储的key的后缀 |
| `getDomain(hostname?)` | 获取域名 |
| `clientStorage` | 客户端存储（根据配置自动选择localStorage或sessionStorage） |

## HTTP请求

| 方法名 | 作用 |
|--------|------|
| `http(options)` | HTTP请求方法（基于axios封装） |

**http 方法常用配置项：**
- `type` - 请求类型（get/post/put/delete等）
- `url` - 请求地址
- `data` - 请求数据
- `params` - URL参数
- `success` - 请求成功回调
- `error` - 请求失败回调
- `complete` - 请求完成回调（无论成功失败）
- `timeout` - 请求超时时间
- `headers` - 请求头信息
- `host` - 请求host
- `crossSite` - 是否跨域

## 数学统计

| 方法名 | 作用 |
|--------|------|
| `math.max(values, option)` | 求最大值，支持日期/整数/浮点类型 |
| `math.min(values, option)` | 求最小值，支持日期/整数/浮点类型 |
| `math.sum(values, option)` | 求和，支持整数/浮点类型 |
| `math.average(values, option)` | 求平均值，支持整数/浮点类型 |

## 函数工具

| 方法名 | 作用 |
|--------|------|
| `getSingleton(fn)` | 获取单例对象（仅执行一次的函数） |
| `delay(fn, callback, maxTime)` | 延迟执行fn函数 |
| `debounce(fn, delay, immediate?)` | 函数防抖 |
| `throttle(fn, interval)` | 函数节流 |
| `animate(opts)` | 动画执行 |
| `warn(msg, otherArgs?)` | 显示错误/警告消息 |

## 其他工具

| 方法名 | 作用 |
|--------|------|
| `matchPairElement(html, tagName)` | 匹配html代码中的成对标签元素 |
| `isOnlineAppUrl(url, client?)` | 判断url地址是否在线应用地址 |
| `appDir` | 获取虚拟目录名称（只读属性） |
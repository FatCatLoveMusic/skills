# 懒加载第三方库详解

web-framework 提供了多个第三方库的懒加载方法，按需加载以提高应用性能。

## 懒加载方法总览

| 方法 | 库名称 | 主要用途 |
|------|--------|----------|
| `Vue.$echartsLazy()` | ECharts | 图表绘制 |
| `Vue.$echartsMapChina` | ECharts 中国地图 | 中国地图可视化 |
| `Vue.$xlsxLazy()` | SheetJS (xlsx) | Excel 文件读写 |
| `Vue.$excelJSLazy()` | ExcelJS | Excel 文件生成 |
| `Vue.$jsoneditorLazy()` | JSONEditor | JSON 编辑器 |
| `Vue.$luckysheetLazy()` | Luckysheet | 在线表格 |
| `Vue.$tinymceLazy()` | TinyMCE | 富文本编辑器 |
| `Vue.$monacoEditorLazy()` | Monaco Editor | 代码编辑器 |

---

## ECharts 图表库

### Vue.$echartsLazy()

懒加载 ECharts 图表库。

**返回值：** Promise<echarts>

**使用示例：**

```javascript
// 基础柱状图
Vue.$echartsLazy().then((echarts) => {
  const chart = echarts.init(this.$refs.chartDom);

  const option = {
    title: { text: '销售数据' },
    tooltip: {},
    xAxis: {
      data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子']
    },
    yAxis: {},
    series: [{
      name: '销量',
      type: 'bar',
      data: [5, 20, 36, 10, 10, 20]
    }]
  };

  chart.setOption(option);

  // 窗口大小改变时自适应
  window.addEventListener('resize', () => {
    chart.resize();
  });
});
```

---

### Vue.$echartsMapChina()

懒加载 ECharts 中国地图数据。

**返回值：** Promise<chinaMapData>

**使用示例：**

```javascript
// 中国地图
Vue.$echartsLazy().then((echarts) => {
  return Vue.$echartsMapChina().then((chinaMap) => {
    echarts.registerMap('china', chinaMap);

    const chart = echarts.init(this.$refs.mapDom);

    const option = {
      title: { text: '全国销售分布' },
      tooltip: {
        trigger: 'item'
      },
      visualMap: {
        min: 0,
        max: 1000,
        left: 'left',
        top: 'bottom',
        text: ['高', '低'],
        calculable: true
      },
      series: [{
        name: '销量',
        type: 'map',
        map: 'china',
        data: [
          { name: '北京', value: 850 },
          { name: '上海', value: 720 },
          { name: '广东', value: 980 },
          { name: '四川', value: 450 }
        ]
      }]
    };

    chart.setOption(option);
  });
});
```

---

## Excel 处理库

### Vue.$xlsxLazy()

懒加载 SheetJS (xlsx) 库，用于读取 Excel 文件。

**返回值：** Promise<xlsx>

**使用示例：**

```javascript
// 读取 Excel 文件
Vue.$xlsxLazy().then((XLSX) => {
  const reader = new FileReader();

  reader.onload = (e) => {
    const data = new Uint8Array(e.target.result);
    const workbook = XLSX.read(data, { type: 'array' });

    // 获取第一个工作表
    const firstSheet = workbook.Sheets[workbook.SheetNames[0]];

    // 转换为 JSON
    const jsonData = XLSX.utils.sheet_to_json(firstSheet);

    console.log('Excel 数据:', jsonData);
    this.tableData = jsonData;
  };

  reader.readAsArrayBuffer(file);
});
```

---

### Vue.$excelJSLazy()

懒加载 ExcelJS 库，用于生成 Excel 文件。

**返回值：** Promise<ExcelJS>

**使用示例：**

```javascript
// 生成 Excel 文件
Vue.$excelJSLazy().then((ExcelJS) => {
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'Web Framework';
  workbook.created = new Date();

  // 添加工作表
  const worksheet = workbook.addWorksheet('用户列表');

  // 设置列
  worksheet.columns = [
    { header: 'ID', key: 'id', width: 10 },
    { header: '姓名', key: 'name', width: 20 },
    { header: '邮箱', key: 'email', width: 30 },
    { header: '部门', key: 'department', width: 20 }
  ];

  // 添加数据
  worksheet.addRows([
    { id: 1, name: '张三', email: 'zhangsan@example.com', department: '技术部' },
    { id: 2, name: '李四', email: 'lisi@example.com', department: '市场部' }
  ]);

  // 设置样式
  worksheet.getRow(1).font = { bold: true };
  worksheet.getRow(1).fill = {
    type: 'pattern',
    pattern: 'solid',
    fgColor: { argb: 'FFCCE5FF' }
  };

  // 导出
  workbook.xlsx.writeBuffer().then((buffer) => {
    const blob = new Blob([buffer], {
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    });

    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = '用户列表.xlsx';
    link.click();
    URL.revokeObjectURL(url);
  });
});
```

---

## JSON 编辑器

### Vue.$jsoneditorLazy()

懒加载 JSONEditor 库。

**返回值：** Promise<JSONEditor>

**使用示例：**

```javascript
// 创建 JSON 编辑器
Vue.$jsoneditorLazy().then((JSONEditor) => {
  const options = {
    mode: 'tree',        // 模式: tree, view, form, text, code
    modes: ['tree', 'code', 'text'],  // 允许的模式
    search: true,         // 启用搜索
    history: true,       // 启用撤销/重做
    name: 'root'         // 根节点名称
  };

  const editor = new JSONEditor(this.$refs.editorContainer, options);

  // 设置数据
  editor.set({
    name: '张三',
    age: 25,
    address: {
      city: '北京',
      street: '朝阳区'
    },
    hobbies: ['读书', '运动']
  });

  // 获取数据
  const data = editor.get();

  // 获取格式化后的 JSON 字符串
  const jsonString = JSON.stringify(editor.get(), null, 2);

  // 监听变更
  editor.on('change', () => {
    console.log('JSON 已变更:', editor.get());
  });

  // 销毁编辑器
  // editor.destroy();
});
```

---

## 在线表格

### Vue.$luckysheetLazy()

懒加载 Luckysheet（在线表格）库。

**返回值：** Promise<luckysheet>

**使用示例：**

```javascript
// 创建 Luckysheet 表格
Vue.$luckysheetLazy().then(() => {
  const options = {
    container: 'luckysheet',  // 容器 ID
    title: '在线表格',        // 表格标题
    lang: 'zh',               // 语言
    showinfobar: true,       // 显示信息栏
    showtoolbar: true,       // 显示工具栏
    showstatisticBar: true,  // 显示统计栏
    sheetSelectMode: 'cell', // 选择模式: cell, row, column
    data: [
      {
        name: 'Sheet1',
        color: '#f5f5f5',
        data: [
          [{ v: '姓名', c: 0, r: 0 }, { v: '年龄', c: 1, r: 0 }],
          [{ v: '张三', c: 0, r: 1 }, { v: 25, c: 1, r: 1 }],
          [{ v: '李四', c: 0, r: 2 }, { v: 30, c: 1, r: 2 }]
        ],
        settings: {
          frozenRow: 1,  // 冻结第一行
          frozenColumn: 0
        }
      }
    ]
  };

  luckysheet.create(options);
});

// 获取表格数据
const data = luckysheet.getAllSheets();

// 销毁表格
// luckysheet.destroy();
```

---

## 富文本编辑器

### Vue.$tinymceLazy()

懒加载 TinyMCE 富文本编辑器。

**返回值：** Promise<tinymce>

**使用示例：**

```javascript
// 创建 TinyMCE 编辑器
Vue.$tinymceLazy().then(() => {
  tinymce.init({
    selector: '#editor',
    height: 500,
    menubar: false,
    plugins: [
      'advlist', 'autolink', 'lists', 'link', 'image',
      'charmap', 'preview', 'anchor', 'searchreplace',
      'visualblocks', 'code', 'fullscreen',
      'insertdatetime', 'media', 'table', 'code',
      'help', 'wordcount'
    ],
    toolbar:
      'undo redo | blocks fontfamily | ' +
      'bold italic forecolor | alignleft aligncenter ' +
      'alignright alignjustify | bullist numlist outdent indent | ' +
      'removeformat | help',
    content_style: 'body { font-family:Helvetica,Arial,sans-serif; font-size:14px }',

    // 回调函数
    setup: (editor) => {
      editor.on('init', () => {
        console.log('TinyMCE 初始化完成');
      });

      editor.on('change', () => {
        this.content = tinymce.get('editor').getContent();
      });
    }
  });
});

// 获取内容
const content = tinymce.get('editor').getContent();

// 设置内容
tinymce.get('editor').setContent('<p>新内容</p>');

// 销毁编辑器
// tinymce.get('editor').destroy();
```

---

## 代码编辑器

### Vue.$monacoEditorLazy()

懒加载 Monaco Editor 代码编辑器。

**返回值：** Promise<monaco>

**使用示例：**

```javascript
// 创建 Monaco Editor
Vue.$monacoEditorLazy().then((monaco) => {
  const editor = monaco.editor.create(this.$refs.editorContainer, {
    value: `function hello() {
  console.log("Hello World!");
}`,
    language: 'javascript',
    theme: 'vs-dark',  // 主题: vs, vs-dark, hc-black
    fontSize: 14,
    fontFamily: 'Consolas, "Courier New", monospace',
    lineNumbers: 'on',        // 显示行号
    minimap: { enabled: true },  // 启用小地图
    automaticLayout: true,    // 自动调整布局
    scrollBeyondLastLine: false,
    wordWrap: 'on',          // 自动换行
    tabSize: 2,              // Tab 缩进
    formatOnPaste: true,     // 粘贴时格式化
    formatOnType: true,      // 输入时格式化
    folding: true,           // 启用代码折叠
    bracketPairColorization: { enabled: true }  // 括号配对着色
  });

  // 获取代码
  const code = editor.getValue();

  // 设置代码
  editor.setValue('// new code');

  // 获取当前光标位置
  const position = editor.getPosition();

  // 设置光标位置
  editor.setPosition({ lineNumber: 1, column: 1 });

  // 监听内容变化
  editor.onDidChangeModelContent(() => {
    console.log('代码已变更:', editor.getValue());
  });

  // 监听光标位置变化
  editor.onDidChangeCursorPosition((e) => {
    console.log('光标位置:', e.position);
  });

  // 添加命令
  editor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyCode.KeyS, () => {
    this.saveCode();
  });

  // 设置装饰（高亮）
  editor.deltaDecorations([], [
    {
      range: new monaco.Range(1, 1, 1, 10),
      options: {
        isWholeLine: true,
        className: 'highlighted-line',
        glyphMarginClassName: 'highlighted-glyph'
      }
    }
  ]);

  // 销毁编辑器
  // editor.dispose();
});
```

---

## 综合使用示例

### 动态加载图表组件

```vue
<template>
  <div class="chart-container">
    <div v-if="loading" class="loading">加载中...</div>
    <div v-else ref="chartRef" class="chart" />
  </div>
</template>

<script>
export default {
  props: {
    chartType: {
      type: String,
      default: 'bar',
      validator: (val) => ['bar', 'line', 'pie'].includes(val)
    }
  },

  data() {
    return {
      loading: true,
      chartInstance: null
    }
  },

  mounted() {
    this.initChart();
  },

  beforeDestroy() {
    // 销毁图表实例
    if (this.chartInstance) {
      this.chartInstance.dispose();
    }
  },

  methods: {
    async initChart() {
      this.loading = true;

      try {
        const echarts = await Vue.$echartsLazy();

        this.$nextTick(() => {
          this.chartInstance = echarts.init(this.$refs.chartRef);

          const option = this.getChartOption();
          this.chartInstance.setOption(option);

          // 响应窗口大小变化
          window.addEventListener('resize', this.handleResize);
        });
      } catch (error) {
        console.error('图表初始化失败:', error);
        Vue.errorMsg('图表加载失败');
      } finally {
        this.loading = false;
      }
    },

    getChartOption() {
      const baseOption = {
        title: { text: this.chartType === 'pie' ? '占比分析' : '趋势分析' },
        tooltip: { trigger: 'axis' },
        legend: { data: ['数据'] },
        xAxis: {
          type: 'category',
          data: ['周一', '周二', '周三', '周四', '周五']
        },
        yAxis: { type: 'value' },
        series: [{
          name: '数据',
          type: this.chartType,
          data: [120, 200, 150, 80, 70]
        }]
      };

      // 饼图特殊配置
      if (this.chartType === 'pie') {
        return {
          ...baseOption,
          xAxis: undefined,
          yAxis: undefined,
          series: [{
            name: '数据',
            type: 'pie',
            radius: '55%',
            data: [
              { value: 120, name: '周一' },
              { value: 200, name: '周二' },
              { value: 150, name: '周三' }
            ]
          }]
        };
      }

      return baseOption;
    },

    handleResize() {
      if (this.chartInstance) {
        this.chartInstance.resize();
      }
    },

    // 更新图表数据
    updateChartData(data) {
      if (this.chartInstance) {
        this.chartInstance.setOption({
          series: [{ data }]
        });
      }
    }
  }
}
</script>

<style scoped>
.chart-container {
  width: 100%;
  height: 400px;
}

.chart {
  width: 100%;
  height: 100%;
}

.loading {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #999;
}
</style>
```

---

## 注意事项

1. **懒加载时机**
   - 懒加载的库只在首次使用时加载
   - 后续使用会复用已加载的实例

2. **Promise 处理**
   - 所有懒加载方法返回 Promise
   - 使用 `.then()` 或 `async/await` 等待加载完成

3. **实例销毁**
   - 在组件销毁前，确保清理编辑器实例
   - 避免内存泄漏

4. **依赖关系**
   - ECharts 中国地图依赖 ECharts
   - 使用前需先加载 ECharts
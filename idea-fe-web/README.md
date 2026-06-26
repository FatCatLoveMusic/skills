# idea-fe-web

web-framework 前端开发技能集合，为 AI 提供在 web-framework 项目中高效开发的能力。

## 技能列表

### 构建部署
| 技能 | 描述 |
|------|------|
| [build-dev-package](skills/build-dev-package/SKILL.md) | 打包 web-framework 开发包并部署到目标项目 |

### 组件模板
| 技能 | 描述 |
|------|------|
| [dialog-template](skills/dialog-template/SKILL.md) | 弹窗组件模板（基于 sapi-form-panel） |
| [list-template](skills/list-template/SKILL.md) | 列表页面模板（基于 sapi-list-layout） |

### 工具与 API
| 技能 | 描述 |
|------|------|
| [utils](skills/utils/SKILL.md) | `this.$utils` 公共工具方法索引（80+ 工具函数） |
| [userinfo](skills/userinfo/SKILL.md) | 获取当前登录用户信息（`this.$getBasicInfo()`） |

### 总入口
| 技能 | 描述 |
|------|------|
| [idea-fe-web](SKILL.md) | 技能集合总入口，提供全局规范和索引导航 |

## 安装

### Windows（推荐）

使用 PowerShell 运行安装脚本，一键创建所有技能的 Junction 链接：

```powershell
cd idea-fe-web
.\install.ps1
```

脚本会将 `skills/` 目录下的所有技能链接到 `~\.trae-cn\skills\`。

### 手动安装

为每个技能手动创建 Junction 链接：

```powershell
# 示例：安装 build-dev-package 技能
New-Item -ItemType Junction -Path "$env:USERPROFILE\.trae-cn\skills\build-dev-package" -Target "path\to\idea-fe-web\skills\build-dev-package"
```

### 安装后

重启 Trae，技能即可自动加载。

## 目录结构

```
idea-fe-web/
├── SKILL.md              # 主技能（总入口）
├── README.md             # 本文件
├── install.ps1           # 安装脚本
├── SKILL_SPEC.md         # 技能编写规范
└── skills/               # 所有技能
    ├── build-dev-package/
    ├── dialog-template/
    ├── list-template/
    ├── utils/
    └── userinfo/
```

## 设计原则

参照 [superpowers](https://github.com/obra/superpowers) 的技能管理方式：

- **扁平化结构**：每个技能都是独立的顶级目录，AI 可以直接发现和触发
- **精准触发**：每个技能的 description 包含丰富的关键词，确保高命中率
- **职责单一**：一个技能只做一件事
- **渐进式加载**：只有触发时才加载技能内容，节省 token

## 新增技能

1. 在 `skills/` 下创建新目录，目录名使用 kebab-case
2. 创建 `SKILL.md` 文件，Frontmatter 包含 `name` 和 `description`
3. `description` 中写满用户可能会说的触发关键词
4. 重新运行 `install.ps1` 创建链接

## License

MIT

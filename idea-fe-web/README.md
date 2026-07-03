# idea-fe-web

web-framework 前端开发技能集合，为 AI 提供在 web-framework 项目中高效开发的能力。

## 技能列表

### 构建部署
| 技能 | 描述 |
|------|------|
| [build-dev-package](skills/build-dev-package/SKILL.md) | 打包 web-framework 开发包并部署到目标项目 |

### 代码模板
| 技能 | 描述 |
|------|------|
| [code-templates](skills/code-templates/SKILL.md) | Web-framework代码模板集合，包含弹窗模板、列表页面模板等 |

### 全局方法
| 技能 | 描述 |
|------|------|
| [global-methods](skills/global-methods/SKILL.md) | web-framework全局方法统一访问入口，包含 $utils、$getBasicInfo、HTTP请求、消息提示、跨标签页通信等 |

### 总入口
| 技能 | 描述 |
|------|------|
| [idea-fe-web](SKILL.md) | 技能集合总入口，提供全局规范和索引导航 |

## 安装

### Trae

使用 PowerShell 运行安装脚本，一键创建所有技能的 Junction 链接：

```powershell
cd idea-fe-web
.\install-trae.ps1
```

脚本会将 `idea-fe-web` 总入口和 `skills/` 目录下的所有技能链接到 `~\.trae-cn\skills\`。

### Codex/Claude Code

使用 pi-package 格式，链接到目标项目的 `.skills/` 目录：

```powershell
cd idea-fe-web
.\install-codex.ps1 -TargetProject "C:\Projects\my-webapp"
```

确保目标项目的 `package.json` 中包含：
```json
"pi": { "skills": [".skills"] }
```

### 安装后

重启对应 IDE（Trae 或 Codex/Claude Code），技能即可自动加载。

## 目录结构

```
idea-fe-web/
├── SKILL.md               # 主技能（总入口）
├── README.md              # 本文件
├── package.json           # pi-package 配置（Codex/Claude Code）
├── install-trae.ps1       # Trae 安装脚本
├── install-codex.ps1      # Codex/Claude Code 安装脚本
└── skills/                # 所有子技能
    ├── build-dev-package/
    ├── code-templates/
    └── global-methods/
```

## 设计原则

参照 [superpowers](https://github.com/obra/superpowers) 的技能管理方式：

- **多平台支持**：同时支持 Trae 的扁平技能目录和 Codex/Claude Code 的 pi-package 格式
- **精准触发**：每个技能的 description 包含丰富的关键词，确保高命中率
- **职责单一**：一个技能只做一件事
- **渐进式加载**：只有触发时才加载技能内容，节省 token

## 新增技能

1. 在 `skills/` 下创建新目录，目录名使用 kebab-case
2. 创建 `SKILL.md` 文件，Frontmatter 包含 `name` 和 `description`
3. `description` 中写满用户可能会说的触发关键词
4. 重新运行对应安装脚本创建链接

## License

MIT

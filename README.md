# AbyssPath - AI驱动的个性化学习路径生成器

## 项目概述
AbyssPath 是一个基于 AI 的个性化学习路径生成器，旨在帮助用户制定科学、合理的学习计划。通过分析用户的学习目标、当前水平和目标水平，生成个性化的学习路径。

## 技术栈
- 前端：Flutter 3.24.4
- 后端：FastAPI
- 数据库：Supabase + PostgreSQL
- AI：DeepSeek-V3

## 已完成功能
- [x] 用户身份系统
  - [x] 注册/登录
  - [x] 个人信息管理
- [x] 学习路径生成
  - [x] 基于 DeepSeek-V3 的路径生成
  - [x] 路径数据持久化
  - [x] 路径展示和编辑
- [x] 学习进度追踪
  - [x] 进度记录
  - [x] 完成度统计
  - [x] 学习时长统计

## 待开发功能
- [ ] 学习资源推荐
  - [ ] 基于用户兴趣的资源推荐
  - [ ] 资源收藏和分类
- [ ] 学习社区
  - [ ] 用户互动
  - [ ] 经验分享
- [ ] 数据分析
  - [ ] 学习效果分析
  - [ ] 学习习惯分析

## 环境配置
1. 克隆项目
```bash
git clone https://github.com/Xander-94/AbyssPath.git
cd AbyssPath
```

2. 安装依赖
```bash
flutter pub get
```

3. 配置环境变量
创建 `.env` 文件并添加以下配置：
```env
DEEPSEEK_API_KEY=your_api_key
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. 运行项目
```bash
flutter run
```

## 项目结构
```
lib/
  ├── core/           # 核心功能
  │   ├── constants/  # 常量定义
  │   ├── theme/      # 主题配置
  │   ├── utils/      # 工具类
  │   └── widgets/    # 公共组件
  ├── features/       # 功能模块
  │   ├── auth/       # 认证模块
  │   ├── learning_path/  # 学习路径模块
  │   └── profile/    # 个人资料模块
  ├── l10n/          # 国际化
  └── main.dart      # 入口文件
```

## 最近更新
- 2024-03-31: 升级到 DeepSeek-V3 API
  - 优化 API 调用结构
  - 改进错误处理机制
  - 优化提示词设计
  - 添加 JSON 格式验证

## DeepSeek API 集成说明
### API 配置
- 环境变量：`DEEPSEEK_API_KEY`
- 基础 URL：`https://api.deepseek.com/v1`
- 模型：`deepseek-chat-v3`

### 功能特性
- 支持 JSON 格式输出
- 智能提示词优化
- 完善的错误处理
- 请求重试机制

### 路径生成示例
```json
{
  "path_id": "unique_id",
  "user_id": "user_id",
  "goal": "学习目标",
  "current_level": "当前水平",
  "target_level": "目标水平",
  "estimated_duration": "预计学习时长",
  "steps": [
    {
      "id": "step_id",
      "title": "步骤标题",
      "description": "步骤描述",
      "duration": "预计时长",
      "resources": ["资源链接"],
      "prerequisites": ["前置要求"]
    }
  ]
}
```

### 错误处理
- 网络错误：自动重试
- API 错误：友好提示
- 格式错误：JSON 验证

### 性能优化
- 请求缓存
- 并发控制
- 数据压缩

## 开发指南
1. 代码规范
   - 遵循 Flutter 官方代码规范
   - 使用统一的代码格式化工具
   - 保持代码注释完整

2. 提交规范
   - feat: 新功能
   - fix: 修复问题
   - docs: 文档更新
   - style: 代码格式
   - refactor: 代码重构
   - test: 测试相关
   - chore: 其他修改

3. 分支管理
   - main: 主分支
   - develop: 开发分支
   - feature/*: 功能分支
   - bugfix/*: 修复分支
   - release/*: 发布分支

## 贡献指南
1. Fork 项目
2. 创建功能分支
3. 提交更改
4. 发起 Pull Request

## 许可证
MIT License

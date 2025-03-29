# 认证模块表现层

本目录负责认证模块的UI展示和用户交互。

## 职责
- 实现用户界面
- 处理用户交互
- 管理页面状态
- 展示业务数据

## 目录结构
### pages/
- `login_page.dart`: 登录页面
- `register_page.dart`: 注册页面
- `forgot_password_page.dart`: 忘记密码页面
- `verify_email_page.dart`: 邮箱验证页面
- `profile_page.dart`: 个人资料页面

### widgets/
- `login_form.dart`: 登录表单
- `register_form.dart`: 注册表单
- `password_field.dart`: 密码输入框
- `email_field.dart`: 邮箱输入框
- `profile_avatar.dart`: 头像组件

### bloc/
- `auth_bloc.dart`: 认证状态管理
- `login_bloc.dart`: 登录状态管理
- `register_bloc.dart`: 注册状态管理
- `profile_bloc.dart`: 资料状态管理

## 页面状态
### 登录页面
- 初始状态
- 加载状态
- 成功状态
- 失败状态
- 验证状态

### 注册页面
- 表单填写
- 验证码发送
- 提交处理
- 注册成功
- 注册失败

### 个人资料
- 资料展示
- 编辑状态
- 保存状态
- 上传头像
- 更新成功

## 开发规范
1. 使用Riverpod状态管理
2. 遵循iOS设计规范
3. 实现响应式布局
4. 支持深色模式
5. 支持国际化
6. 必须处理加载状态
7. 必须处理错误状态
8. 必须实现表单验证

## 交互设计
- 流畅的动画过渡
- 清晰的错误提示
- 友好的加载提示
- 合理的操作反馈
- 直观的表单验证
- 优雅的错误处理

## 性能优化
- 延迟加载
- 图片优化
- 状态缓存
- 输入防抖
- 列表优化 
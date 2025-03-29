# 认证模块领域层

本目录定义认证模块的核心业务逻辑。

## 职责
- 定义领域实体
- 定义业务规则
- 定义仓库接口
- 实现用例逻辑

## 目录结构
### entities/
- `user.dart`: 用户实体
- `auth_token.dart`: 认证令牌实体
- `user_profile.dart`: 用户资料实体

### repositories/
- `auth_repository.dart`: 认证仓库接口

### usecases/
- `register_user.dart`: 用户注册
- `login_user.dart`: 用户登录
- `logout_user.dart`: 用户登出
- `reset_password.dart`: 重置密码
- `verify_email.dart`: 验证邮箱
- `update_profile.dart`: 更新资料
- `change_password.dart`: 修改密码

## 业务规则
### 注册规则
- 邮箱格式验证
- 密码强度要求
- 用户名规范
- 重复注册检查

### 登录规则
- 账号锁定策略
- 登录失败处理
- 多设备登录控制
- 会话管理

### 安全规则
- 密码加密存储
- 令牌有效期
- 权限控制
- 敏感操作验证

## 开发规范
1. 实体必须不可变
2. 方法必须纯函数
3. 依赖必须抽象
4. 错误必须类型化
5. 必须包含单元测试

## 注意事项
- 领域逻辑内聚
- 避免技术细节
- 保持简单清晰
- 考虑扩展性
- 注重可测试性 
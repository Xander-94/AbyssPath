# 工具类目录

本目录用于存放全局通用工具类。

## 职责
- 提供通用功能支持
- 封装第三方库
- 提供辅助方法

## 文件说明
- `logger.dart`: 日志工具类
- `http_client.dart`: 网络请求工具
- `storage_util.dart`: 存储工具类
- `date_util.dart`: 日期工具类
- `string_util.dart`: 字符串工具类
- `validator.dart`: 验证工具类
- `device_util.dart`: 设备信息工具
- `permission_util.dart`: 权限管理工具
- `file_util.dart`: 文件操作工具
- `image_util.dart`: 图片处理工具

## 开发规范
1. 工具类必须是无状态的
2. 方法必须是纯函数
3. 必须添加完整注释
4. 必须包含单元测试
5. 错误处理必须规范
6. 避免重复造轮子

## 注意事项
- 优先使用Flutter官方API
- 合理封装第三方库
- 保持向后兼容
- 考虑性能优化
- 处理平台差异 
# 常量配置目录

本目录用于存放应用全局常量配置。

## 职责
- 集中管理所有全局常量
- 提供统一的常量访问接口
- 避免魔法数字和字符串

## 文件说明
- `app_constants.dart`: 应用基础配置常量
- `api_constants.dart`: API相关常量
- `theme_constants.dart`: 主题相关常量
- `route_constants.dart`: 路由相关常量
- `storage_constants.dart`: 存储相关常量

## 开发规范
1. 所有常量必须使用static const声明
2. 常量命名必须清晰表意
3. 必须添加中文注释说明用途
4. 按功能模块分类组织
5. 避免重复定义相同含义的常量 
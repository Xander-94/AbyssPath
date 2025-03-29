# 公共组件目录

本目录用于存放全局共用的UI组件。

## 职责
- 提供基础UI组件
- 统一交互体验
- 提高代码复用性
- 确保组件一致性

## 组件分类
### 基础组件
- `loading_indicator.dart`: 加载指示器
- `error_view.dart`: 错误视图
- `empty_view.dart`: 空状态视图
- `toast.dart`: 提示框

### 表单组件
- `custom_text_field.dart`: 文本输入框
- `custom_button.dart`: 按钮
- `custom_checkbox.dart`: 复选框
- `custom_radio.dart`: 单选框
- `custom_dropdown.dart`: 下拉选择框

### 列表组件
- `refresh_list.dart`: 刷新列表
- `load_more_list.dart`: 加载更多列表
- `grid_view.dart`: 网格视图
- `section_list.dart`: 分组列表

### 弹窗组件
- `dialog.dart`: 对话框
- `bottom_sheet.dart`: 底部弹窗
- `popup_menu.dart`: 弹出菜单
- `action_sheet.dart`: 操作表

## 开发规范
1. 组件必须支持主题定制
2. 必须处理异常状态
3. 必须支持无障碍
4. 必须优化性能
5. 必须添加完整注释
6. 必须编写组件文档
7. 必须包含单元测试

## 组件设计原则
- 单一职责
- 接口简单
- 易于扩展
- 高内聚低耦合
- 性能优先
- 可复用性强 
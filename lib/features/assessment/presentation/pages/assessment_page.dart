import 'package:flutter/material.dart'; // 导入Flutter基础库
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 导入Riverpod
import '../bloc/assessment_notifier.dart'; // 导入评估状态管理器
import '../bloc/assessment_state.dart'; // 导入评估状态

class AssessmentPage extends ConsumerStatefulWidget { // 评估页面
  const AssessmentPage({super.key}); // 构造函数

  @override
  ConsumerState<AssessmentPage> createState() => _AssessmentPageState(); // 创建状态
}

class _AssessmentPageState extends ConsumerState<AssessmentPage> { // 评估页面状态
  final _responseController = TextEditingController(); // 回答控制器

  @override
  void initState() { // 初始化状态
    super.initState();
    ref.read(assessmentNotifierProvider.notifier).startAssessment(); // 开始评估
  }

  @override
  void dispose() { // 释放资源
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold( // 构建方法
        appBar: AppBar( // 应用栏
          title: const Text('能力评估'), // 标题
        ),
        body: ref.watch(assessmentNotifierProvider).when( // 监听状态
          initial: () => const Center(child: CircularProgressIndicator()), // 初始状态
          loading: () => const Center(child: CircularProgressIndicator()), // 加载状态
          inProgress: (session, currentQuestion, progress) => Padding( // 进行中状态
            padding: const EdgeInsets.all(16),
            child: Column( // 列布局
              children: [
                LinearProgressIndicator(value: progress), // 进度条
                const SizedBox(height: 16),
                Text( // 问题文本
                  currentQuestion,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                TextField( // 回答输入框
                  controller: _responseController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: '请输入您的回答...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (response) { // 提交回答
                    if (response.isNotEmpty) { // 回答不为空
                      ref.read(assessmentNotifierProvider.notifier) // 处理回答
                          .handleResponse(response);
                      _responseController.clear(); // 清空输入框
                    }
                  },
                ),
              ],
            ),
          ),
          completed: (session) => Center( // 完成状态
            child: SingleChildScrollView( // 滚动视图
              padding: const EdgeInsets.all(16),
              child: Column( // 列布局
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text( // 完成文本
                    '评估完成！',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  if (session.userProfile != null) ...[ // 如果有用户画像
                    Text( // 总结文本
                      session.userProfile!.summary,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text( // 技能种类标题
                      '技能种类',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap( // 技能种类标签
                      spacing: 8,
                      runSpacing: 8,
                      children: session.userProfile!.skillTypes.map((skill) => Chip(
                        label: Text(skill),
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                    Text( // 技能熟练程度标题
                      '技能熟练程度',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap( // 技能熟练程度标签
                      spacing: 8,
                      runSpacing: 8,
                      children: session.userProfile!.skillProficiency.entries.map((entry) => Chip(
                        label: Text('${entry.key}(${(entry.value * 100).toStringAsFixed(0)}%)'),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                    Text( // 兴趣爱好标题
                      '兴趣爱好',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap( // 兴趣爱好标签
                      spacing: 8,
                      runSpacing: 8,
                      children: session.userProfile!.interests.map((interest) => Chip(
                        label: Text(interest),
                        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                      )).toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton( // 查看结果按钮
                    onPressed: () {
                      // TODO: 导航到结果页面
                    },
                    child: const Text('查看结果'),
                  ),
                ],
              ),
            ),
          ),
          error: (message) => Center( // 错误状态
            child: Text('错误：$message'), // 错误文本
          ),
        ),
      );
} 
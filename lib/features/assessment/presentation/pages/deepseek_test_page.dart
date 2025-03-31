import 'package:flutter/material.dart'; // 导入Flutter基础库
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 导入Riverpod
import '../../../../core/config/env_config.dart'; // 导入环境配置
import 'package:dio/dio.dart'; // 导入网络请求库
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart'; // 添加图表库

class DeepseekTestPage extends ConsumerStatefulWidget { // 评估页面
  const DeepseekTestPage({super.key}); // 构造函数

  @override
  ConsumerState<DeepseekTestPage> createState() => _DeepseekTestPageState(); // 创建状态
}

class _DeepseekTestPageState extends ConsumerState<DeepseekTestPage> { // 评估页面状态
  final _textController = TextEditingController(); // 文本输入控制器
  final _scrollController = ScrollController(); // 滚动控制器
  final List<Map<String, dynamic>> _messages = []; // 消息列表
  bool _isLoading = false; // 加载状态

  @override
  void dispose() { // 释放资源
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildRadarChart(Map<String, double> scores) => SizedBox( // 构建雷达图
    height: 300,
    child: RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        ticksTextStyle: const TextStyle(color: Colors.transparent),
        gridBorderData: const BorderSide(color: Colors.grey),
        titleTextStyle: const TextStyle(fontSize: 10),
        getTitle: (index, angle) {
          final titles = ['专业技能', '问题解决', '技术更新', '实践应用', '学习能力', '思维能力',
                         '自我管理', '适应能力', '沟通能力', '领导力', '团队协作', '人际关系'];
          return RadarChartTitle(text: titles[index], angle: angle);
        },
        dataSets: [
          RadarDataSet(
            fillColor: Colors.blue.withAlpha(51),
            borderColor: Colors.blue,
            dataEntries: [
              RadarEntry(value: scores['专业技能水平'] ?? 0),
              RadarEntry(value: scores['问题解决能力'] ?? 0),
              RadarEntry(value: scores['技术更新能力'] ?? 0),
              RadarEntry(value: scores['实践应用能力'] ?? 0),
              RadarEntry(value: scores['学习能力'] ?? 0),
              RadarEntry(value: scores['思维能力'] ?? 0),
              RadarEntry(value: scores['自我管理能力'] ?? 0),
              RadarEntry(value: scores['适应能力'] ?? 0),
              RadarEntry(value: scores['沟通能力'] ?? 0),
              RadarEntry(value: scores['领导力'] ?? 0),
              RadarEntry(value: scores['团队协作能力'] ?? 0),
              RadarEntry(value: scores['人际关系能力'] ?? 0),
            ],
          ),
        ],
        tickCount: 5,
      ),
    ),
  );

  Future<void> _sendMessage() async { // 发送消息方法
    if (_textController.text.trim().isEmpty) return; // 如果输入为空则返回

    final message = _textController.text; // 获取输入文本
    _textController.clear(); // 清空输入框

    setState(() { // 更新状态
      _messages.add({ // 添加用户消息
        'role': 'user',
        'content': message,
      });
      _isLoading = true; // 设置加载状态
    });

    try {
      final dio = Dio(); // 创建Dio实例
      dio.options.headers['Authorization'] = 'Bearer ${EnvConfig.deepseekApiKey}'; // 设置请求头
      dio.options.baseUrl = EnvConfig.deepseekBaseUrl; // 设置基础URL

      final response = await dio.post( // 发送请求
        '/chat/completions',
        data: {
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': '''你是一个专业的职业规划顾问，请根据用户的描述进行分析并给出建议。
请以JSON格式返回分析结果，包含以下字段：
{
  "scores": {
    "专业技能水平": 0.0-1.0,
    "问题解决能力": 0.0-1.0,
    "技术更新能力": 0.0-1.0,
    "实践应用能力": 0.0-1.0,
    "学习能力": 0.0-1.0,
    "思维能力": 0.0-1.0,
    "自我管理能力": 0.0-1.0,
    "适应能力": 0.0-1.0,
    "沟通能力": 0.0-1.0,
    "领导力": 0.0-1.0,
    "团队协作能力": 0.0-1.0,
    "人际关系能力": 0.0-1.0
  },
  "analysis": {
    "优势领域": ["列出3-5个最突出的优势"],
    "改进建议": ["列出3-5个具体的改进建议"],
    "发展方向": "一段对职业发展方向的建议"
  }
}''',
            },
            ..._messages.map((m) => { // 添加历史消息
              'role': m['role'],
              'content': m['content'],
            }),
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        },
      );

      final content = response.data['choices'][0]['message']['content']; // 获取响应内容
      final jsonStart = content.indexOf('{');
      final jsonEnd = content.lastIndexOf('}') + 1;
      final jsonStr = content.substring(jsonStart, jsonEnd);
      final result = json.decode(jsonStr);

      setState(() { // 更新状态
        _messages.add({ // 添加AI回复
          'role': 'assistant',
          'content': content,
          'result': result,
        });
        _isLoading = false; // 重置加载状态
      });

      // 滚动到底部
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      setState(() => _isLoading = false); // 重置加载状态
      if (mounted) { // 如果组件还在树中
        ScaffoldMessenger.of(context).showSnackBar( // 显示错误提示
          SnackBar(content: Text('发送失败：$e')),
        );
      }
    }
  }

  Widget _buildResultCard(Map<String, dynamic> result) => Card( // 构建结果卡片
    margin: const EdgeInsets.all(16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '能力评估结果',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRadarChart(Map<String, double>.from(result['scores'])), // 构建雷达图
          const SizedBox(height: 16),
          const Text(
            '优势领域',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...List<String>.from(result['analysis']['优势领域']).map( // 构建优势领域列表
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(s)), // 显示优势领域
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '改进建议',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...List<String>.from(result['analysis']['改进建议']).map( // 构建改进建议列表
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(s)), // 显示改进建议
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '发展方向',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(result['analysis']['发展方向']), // 显示发展方向
        ],
      ),
    ),
  );

  Widget _buildGuideCard() => Card( // 构建指引卡片
    margin: const EdgeInsets.all(16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '职业能力评估指南',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '请描述您的以下情况：',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text('1. 您的专业背景和技能特长'),
          Text('2. 您的工作经验和项目经历'),
          Text('3. 您的个人特质和职业目标'),
          SizedBox(height: 8),
          Text(
            '系统将根据您的描述进行全面分析，并提供详细的能力评估报告。',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold( // 构建方法
        appBar: AppBar( // 添加应用栏
          title: const Text('能力评估'),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('提示'),
                    content: const Text('评估结果将包含能力雷达图、优势分析、改进建议和发展方向。'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('了解'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.help_outline),
            ),
          ],
        ),
        body: Column( // 列布局
          children: [
            if (_messages.isEmpty) _buildGuideCard(), // 如果没有消息则显示指引卡片
            Expanded( // 消息列表
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message['role'] == 'user';

                  if (!isUser && message.containsKey('result')) {
                    return _buildResultCard(message['result']);
                  }

                  return Align( // 消息气泡
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container( // 消息容器
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text( // 消息文本
                        message['content'],
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading) // 加载指示器
              const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            Container( // 输入框容器
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: SafeArea( // 确保输入区域不被系统UI遮挡
                child: Row( // 输入区域
                  children: [
                    Expanded( // 输入框
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: '请输入您的情况...',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                    ),
                    IconButton( // 发送按钮
                      onPressed: _isLoading ? null : _sendMessage,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
} 
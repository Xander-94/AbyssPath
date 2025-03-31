import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/learning_path_repository.dart';
import '../../data/datasources/learning_path_remote_datasource.dart';
import '../../../../core/services/supabase_service.dart';
import 'learning_path_notifier.dart';
import 'learning_path_state.dart';

final learningPathRepositoryProvider = Provider<LearningPathRepository>((ref) {
  final dataSource = LearningPathRemoteDataSource(SupabaseService.client);
  return LearningPathRepository(dataSource);
});

final learningPathNotifierProvider = StateNotifierProvider<LearningPathNotifier, LearningPathState>((ref) {
  final repository = ref.watch(learningPathRepositoryProvider);
  return LearningPathNotifier(repository);
}); 
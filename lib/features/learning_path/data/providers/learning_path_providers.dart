import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/learning_path_remote_data_source.dart';
import '../../domain/repositories/learning_path_repository.dart';
import '../repositories/learning_path_repository_impl.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final learningPathRemoteDataSourceProvider = Provider<LearningPathRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return LearningPathRemoteDataSource(client);
});

final learningPathRepositoryProvider = Provider<LearningPathRepository>((ref) {
  final remoteDataSource = ref.watch(learningPathRemoteDataSourceProvider);
  return LearningPathRepositoryImpl(remoteDataSource);
}); 
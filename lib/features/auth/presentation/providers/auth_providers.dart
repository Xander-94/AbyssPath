import 'package:flutter_riverpod/flutter_riverpod.dart'; // 导入Riverpod
import '../../data/repositories/auth_repository_impl.dart'; // 导入认证仓库实现
import '../../domain/repositories/auth_repository.dart'; // 导入认证仓库接口
import '../../data/datasources/auth_remote_data_source.dart'; // 导入认证远程数据源

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) { // 创建认证远程数据源提供者
  return AuthRemoteDataSource(); // 返回认证远程数据源实例
});

final authRepositoryProvider = Provider<AuthRepository>((ref) { // 创建认证仓库提供者
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider); // 获取认证远程数据源
  return AuthRepositoryImpl(remoteDataSource); // 返回认证仓库实现
}); 
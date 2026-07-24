import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_cache_service.dart';
import '../../core/network/shia_api_client.dart';
import '../../api/aladhan_api.dart';
import '../../features/hadith_shia/data/datasources/hadith_remote_datasource.dart';

final apiCacheServiceProvider = Provider<ApiCacheService>((ref) {
  return ApiCacheService(maxConcurrent: 3);
});

final shiaApiClientProvider = Provider<ShiaApiClient>((ref) {
  return ShiaApiClient(cache: ref.watch(apiCacheServiceProvider));
});

final aladhanApiProvider = Provider<AladhanApi>((ref) {
  return AladhanApi(cache: ref.watch(apiCacheServiceProvider));
});

final hadithRemoteDataSourceProvider = Provider<HadithRemoteDataSource>((ref) {
  return HadithRemoteDataSource(client: ref.watch(shiaApiClientProvider));
});

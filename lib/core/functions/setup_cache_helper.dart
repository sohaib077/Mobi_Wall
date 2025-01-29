
import '../helpers/cache_helper.dart';

Future<void> setupCacheHelper() async {
  await CacheHelper.init();
}

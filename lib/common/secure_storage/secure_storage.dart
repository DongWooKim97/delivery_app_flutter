import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 이 Provider 값이 생성이 될 때 반환이 되면, 이 하나의 값을 갖고서 계속 돌려서 사용할 것.
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) => FlutterSecureStorage());

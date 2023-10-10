import 'package:actual/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  // 1) 요청을 보낼때
  // 요청이 보내질 때 마다 만약에 요청의 헤더에 accessToken = 'true'값이 있다면 실제 토큰을 스토리지에서 가져와서 authorization : 'Bearer $token'값으로 변경한다.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] : [${options.method}] -> [${options.uri}]');

    // accessToken
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    // refreshToken
    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    return super.onRequest(options, handler);
  }
}

// on * 3
// 1) 요청을 보낼때
// 2) 응답을 받을때
// 3) 에러가 났을 때
// 이러한 상황에서, 요청, 응답, 에러 중 하나를 가로채서 또 다른 무언가를 반환해서 보여줄 수 있음.

/*
print('[REQ] : [${options.method}] -> [${options.uri}]');
출력 : I/flutter ( 7468): [REQ] : [GET] -> [http://10.0.2.2:3000/restaurant/5ac83bfb-f2b5-55f4-be3c-564be3f01a5b]
홈에서는 안나옴. 요청을 보낼때 -> 디테일이니까 디테일에 들어가야만 요청이 나가서 이런식으로 출력됨.
보다시피 로그로서의 성격도 가지고있음.
 */

// 우리끼리의 사인은 accessToken이지만, 실제 토큰을 사용하기 위해서는 header의 authorization 에 넣어야한다. Bearer와 합쳐서 !
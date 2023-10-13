import 'package:actual/common/const/data.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Dio와 스토리지를 같은 인스턴스로 사용할 수 있으면 매번 Dio안에다가 인터셉터를 생성해주는 반복적인 작업을 하지 않아도 된다.
// ref를 사용하면,  ★ 또 다른 프로바이더를 불러올 수 있다는 사실!! ★
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider); // ★★ 다른 프로바이더를 불러옴 ★★

  dio.interceptors.add(
    CustomInterceptor(storage: storage),
  );

  return dio;
  //반환되는 위의 dio는 하나의 Dio의 인스턴스를 갖고서 스토리지도 SeucreStorageProvider안에서 제공을 해주는 하나의 인스턴스의 스토리지를 사용해서 DIO를 생성해서,
  // 똑같은 DO를 배번 반환해줄 수있다. !!!
});

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

  // 3) 에러가 났을때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401 에러가 났을 때
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면 다시 새로운 토큰을 요청한다.

    print('[err] : [${err.requestOptions.method}] -> [${err.requestOptions.uri}]');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    // refreshToken이 없으면 당연히 에러를 던지는 곳
    if (refreshToken == null) {
      // 에러를 던질 때는 handler.reject를 사용한다.
      return handler.reject(err);
    }

    // requestOptions = > 요청의 모든 값들을 알 수 있는 것
    // reponse = > 응답의 모든 값들을 알 수 있는 것
    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh =
        err.requestOptions.path == '/auth/token'; // 이 에러는 토큰을 리프레시 하려다가 에러가 났다는 것.

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );
        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        //토큰 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        // 요청 재전송
        final response = await dio.fetch(options); // 실제로 요청을 보낼 때 requestOptions안에 다있다.
        return handler.resolve(response);
      } on DioError catch (e) {
        return handler.reject(e);
      }
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RESP] : [${response.requestOptions.method}] -> [${response.requestOptions.uri}]');
    return super.onResponse(response, handler);
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

/*
  요청onRequest는 요청 보내는 함수가 실행이 되고 요청이 보내지기 전에 , 요청을 가로채는 순간에 실행된다.
  실제로 이 요청을 가로챈다음에 요청이 보내지는 곳은 맨아래 리턴하는 곳이다.
  그 마지막 리턴할 때(가로챈 후 보내질떄) 어떠한 상황이 벌어지냐면
  핸들러를 갖고서 요청을 보낼지 또는 에러를 생성을 시킬지에 대한 결정이 일어나고있다.
  또 에러를 생성시키는 방법은 onError에서 마찬가지로 handler.reject함수에서 에러를 발생시킨다.
  에러없이 끝내고 싶으면 handler.resolver(response)하면 된다.
 */

/*
  만약에 401에러가 나고 새로 발급받는 요청이 아니었다면,
  새로 토큰을 발급을 받은 다음에 새로 토큰을 헤더에 넣어가지고 원래 요청을 토큰만 변경시킨채 다시 보내는 것.
  또 이에 대한 응답이 온다. 실제로는 onError가 실행됐지만, 실제로 반환해줘야하는 값은 응답이 잘 왔다고 받은 응답을 다시 보내줘야함.
  그래서 에러 막판에 handler.resolve(response)하는 이유다.

  그러나, 여기서는 새로 보낸 요청에 대한 응답을 받아가지고 resolve를 하면 에러가 난 상황에 똑같은 요청을 토큰만 바꿔서 ㅊ요청한다음 성공 반환값을 돌려줄 수가 있다.
 */

import 'package:actual/common/model/cursor_pagination.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

import '../model/restaurant_detail_model.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  //인스턴스화가 안되게 추상클래스로 만들어야한다.
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) = _RestaurantRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<RestaurantModel>> paginate();

  @GET('/{id}')
  @Headers({'accessToken': 'true'})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}

// 추상클래스로 만들었기 때문에 인스턴스화가 안됨. 그래서 결국 함수들의 바디를 정의해줄 필요가 없다.
// 어떤 값이 들어가야하는지랑 반환되는지를 입력해줘야함.

// 실제로 응답을 받는 형태와 완전히 똑같은 형태의 클래스를 반환값으로 넣어줘야한다. 이게 레트로핏에서 가장 중요한 점!
// id라는 이 패스안에 있는 변수를 자동으로 우리가 이 안에다가 이 파라미터 안에 넣은 값으로 대체할 수 있다.
// 현재 GET요청으로 {id}라는 변수가 필요한데, @Path 하고 붙인 named 파라미터가 이 값을 대체할 수 있다.
// 이름과 똑같은 변수로 대체할 수 있다.  만약 다르다면 대체할 변수명을 직접 넣어줘야함.

// 토큰을 자동으로 관리하는 방법을 알아보자.
// 자동관리란 로그인을 하면 새로운 토큰 2개를 발급받는다. 근데 액세스 토큰이 만료과 됐을 때 저희가 리프레쉬 토큰을 사용해서 자동으로 액세스 토큰
// 토큰을 다시 발급받은 다음에 storage에 자동으로 갱신/저장시키는 방법을 알아보자!! ---->> interceptor를 이용해서 짜보자

// 제네릭에 들어가는 이름만 대체해주면 이 구조를 그대로 유지하고서 리스트안에 어떤 타입이 들어가는지만 변경을 할 수가 있는것임.

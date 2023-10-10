import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

import '../model/restaurant_detail_model.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  //인스턴스화가 안되게 추상클래스로 만들어야한다.
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) = _RestaurantRepository;

  // http://$ip/restaurant/
  // @GET('/')
  // paginate();

  // http://$ip/restaurant/:id/
  @GET('/{id}')
  @Headers({
    'authorization' : 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoiYWNjZXNzIiwiaWF0IjoxNjk2OTI0NTE0LCJleHAiOjE2OTY5MjQ4MTR9.O_-mkp6oQ-s6SeOBF_gH0bDt0qDO27aEiwSiQvZ4Tlk'
  })
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

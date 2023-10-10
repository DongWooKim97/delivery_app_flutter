import '../const/data.dart';

class DataUtils {
  // 무조건 static이여야한다. @JsonKey에 들어갈 함수면
  // @JsonKey로 어노테이션 지정해준 필드가 파라미터로 들어온다. 파라미터명이 달라도, 같은 파라미터라고 이해해야한다. 또한 알아서 들어오기 때문에 함수명만 사용해도됨.
  static pathToUrl(String value) {
    return 'http://$ip$value';
  }
}

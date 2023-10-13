import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination.g.dart';

//상태를 클래스로 구분할 때는 항상 base class를 만든다.
// 추상은 인스턴스로 만들지 못하게 할거다란 의미와도 같음
abstract class CursorPaginationBase {}

class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

// 로딩상태일 땐 아무것도 넣지 않아도 된다.
class CursorPaginationLoading extends CursorPaginationBase {}

//테스트를 했을 때 CursorPaginationBase라는 타입으로 나오는게 중요하기 때문에 extends해줬다!!
@JsonSerializable(genericArgumentFactories: true)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

// 새로고침할때
// 데이터가 존재한다고 100% 확신할 떄 사용할것
// instance is CursorPagination      - T
// instance is CursorPaaginationBase - T
class CursorPaginationRefetching extends CursorPagination {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

//리스트의 맨 아래로 내려서 추가 데이터를 요청하는 중일때 로딩중일 경우
class CursorPaginationFetchingMore extends CursorPagination {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}

// JsonSerializable에서 generic을 쓰게되면 해당 어노테이션 안의 파라미터에 genericArgumentFactories: true 를 넘겨야 사용할 수 있다.
// 제네릭으로 T를 썼기 때문에, 생성을 할 때 어떤 타입을 우리가 넣게 될지 알수가 없으니까 타입들을 json으로 부터 어떻게 인스턴스화 시킬지 정의해줘야함.
// 그래서 런타임에 T값을 json으로부터 인스턴스화 하는 방법을 주입시킬 수 있다.

// CursorPaginationBsae의 자식은 CursorPagination이고, CursorPagination의 자식은 CursorPaginationRefetching인것이다.

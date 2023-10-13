import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class CursorPagination<T> {
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

// JsonSerializable에서 generic을 쓰게되면 해당 어노테이션 안의 파라미터에 genericArgumentFactories: true 를 넘겨야 사용할 수 있다.
// 제네릭으로 T를 썼기 때문에, 생성을 할 때 어떤 타입을 우리가 넣게 될지 알수가 없으니까 타입들을 json으로 부터 어떻게 인스턴스화 시킬지 정의해줘야함.
// 그래서 런타임에 T값을 json으로부터 인스턴스화 하는 방법을 주입시킬 수 있다.

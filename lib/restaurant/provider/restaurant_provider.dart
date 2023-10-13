import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/restaurant_repository.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, List<RestaurantModel>>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

// 캐시를 관리하는 provider들은 무조건 모두다 StateNotifierProvider로 만들 것이다.
class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super([]) {
    paginate();
  }

  // 실제 페이지네이션을 진행하고서 우리가 값을 반환해주는게 아니고 상태 안에다가 응답받은 리스트로된 레스토랑 모델을 집어넣을 것이다.
  // 위젯에서는 이 상태를 바라보고 있다가 이 상태가 변경이 되면 화면에 새로운 값을 렌더링 할 것이다.
  paginate() async {
    final resp = await repository.paginate();
    state = resp.data;
  }
}

// 홈페이지든 로그인을 할 때든 클래스가 생성이 되면 페이지네이션을 무조건 바로 요청해야함.
// 그래서 이 클래스(=StateNotifier)가 Provider안에 가서 인스턴스화 될 때 바로 페이지네이션을 바로 실행해버리게해야함.
// -> super 생성자에 바로 넣어버림~
// 이런식으로 사용하지 않으면 매번 UI에서 RestaurantStateNotifier를 실행할 때 필요한 함수들이 실행이 됐는지 확인을 하면서 로직을 짜줘야함.
// 불편하잖아? 그니까 생성자에 넣어서 바로바로 실행시킬 수 있도록함.

// 이제부터 중요한건 이 class를 프로바이더 안에 넣어야함. 여태까지는 늘 그렇듯 StateNotifier를 만든것이고, 이 만든 StateNotifier를 provider안에 넣어야함.

import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/data.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;
  final String name;

  const RestaurantDetailScreen({
    required this.id,
    required this.name,
    Key? key,
  }) : super(key: key);

  // dioProvider를 넣어서 반환받은 이 dio는 어디에서 불러와도
  // 맨 처음에  dioProvider가 빌드됐을 떄 항상 같은 인터셉터가 적용이 된 Dio가 무조건 받을 수 있다고 장담할 수 있다.
  // 값 변경전에 사용하던 것처럼 직접 불러와서하는건 별로 좋게 보이지 않는다. 왜 ? 여긴 UI적인 코드를 작성하는 곳이므로 UI적인 코드만 있는게 맞다.
  // 또한 restaurantRepositoryProvider에는 dio에 repository까지 넣은 상태이므로, 가져다 쓰기만 하면 된다. (3 Line -> 1 Line)
  // 아래의 future의 파라미터에 넣은 값을 확인!

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: name,
      child: FutureBuilder<RestaurantDetailModel>(
        future: ref.watch(restaurantRepositoryProvider).getRestaurantDetail(id: id),
        builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomScrollView(
            slivers: [
              renderTop(model: snapshot.data!),
              renderLabel(),
              renderProducts(products: snapshot.data!.products),
            ],
          );
        },
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];

            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(model: model),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}

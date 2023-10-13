import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 홈 화면에서 보는 리스트로 된 데이터!
    final data = ref.watch(restaurantProvider);

    if (data.isEmpty) {
      // 에러 , 로딩 , 페이지 네이션 등등..
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        separatorBuilder: (_, index) {
          return SizedBox(height: 16.0);
        },
        itemCount: data.length,
        itemBuilder: (_, index) {
          final pItem = data[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(
                    id: pItem.id,
                    name: pItem.name,
                  ),
                ),
              );
            },
            child: RestaurantCard.fromModel(model: pItem),
          );
        },
      ),
    );
  }
}

// 현재로썬 왜 pItem을 만들어가면서 데이터를 파싱해 사용하는지 궁금.

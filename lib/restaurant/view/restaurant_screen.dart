import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio();
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get('http://$ip/restaurant',
        options: Options(
          headers: {
            'authorization': 'Bearer $accessToken',
          },
        ));

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List>(
              future: paginateRestaurant(),
              builder: (context, AsyncSnapshot<List> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    final item = snapshot.data![index];
                    final pItem = RestaurantModel.fromJson(
                      json: item,
                    );
                    return RestaurantCard(
                      image: Image.network(pItem.thumbUrl),
                      name: pItem.name,
                      tags: pItem.tags,
                      ratingsCount: pItem.ratingsCount,
                      deliveryTime: pItem.deliveryTime,
                      deliveryFee: pItem.deliveryFee,
                      ratings: pItem.ratings,
                    );
                  },
                  separatorBuilder: (_, index) {
                    return SizedBox(height: 16.0);
                  },
                );
              },
            )),
      ),
    );
  }
}

// 현재로썬 왜 pItem을 만들어가면서 데이터를 파싱해 사용하는지 궁금.

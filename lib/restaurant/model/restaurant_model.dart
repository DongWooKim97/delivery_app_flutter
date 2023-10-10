import 'package:actual/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/const/data.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange { expensive, medium, cheap }

@JsonSerializable()
class RestaurantModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel(
      {required this.id,
      required this.name,
      required this.thumbUrl,
      required this.tags,
      required this.priceRange,
      required this.ratings,
      required this.ratingsCount,
      required this.deliveryTime,
      required this.deliveryFee});

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);


}

// json으로부터 인스턴스를 만드는 것과 json으로 인스턴스를 변환하는거 두가지 자동화. fromJson . toJson
// toJson이 실행이 될 때 json으로 변경이 될 때 실행하고 싶은 함수는 toJson에 넣으면 되고
// fromJson이 실행이 됐을 때, json으로 부터 인스턴스를 만들 때 실행하고 싶은 함수는 fromJson에다 넣는다. 상단에 @JsonKey값에

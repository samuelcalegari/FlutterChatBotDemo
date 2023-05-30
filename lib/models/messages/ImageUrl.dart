import 'package:hive/hive.dart';
part 'ImageUrl.g.dart';

@HiveType(typeId: 6)
class ImageUrlList {
  @HiveField(0)
  final List<ImageUrl> imgs;

  ImageUrlList({
    required this.imgs,
  });
  ImageUrlList.fromJson(List<dynamic> json)
      : imgs = json
            .map((dynamic e) => ImageUrl.fromJson(e as Map<String, dynamic>))
            .toList();
}

@HiveType(typeId: 5)
class ImageUrl {
  @HiveField(0)
  final String url;

  ImageUrl({required this.url});

  factory ImageUrl.fromJson(Map<String, dynamic> json) {
    return ImageUrl(url: json['url']);
  }
}

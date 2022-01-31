import 'package:intl/intl.dart';

class PostModel {
  late String name;
  late String uId;
  late String image;
  late String dateTime;
  late String text;
  late String postImage;

  PostModel(
      this.name,
      this.uId,
      this.image,
      this.dateTime,
      this.text,
      this.postImage
      );

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    text = json['text'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'dateTime': dateTime,
      'text': text,
      'postImage': postImage,
    };
  }
}
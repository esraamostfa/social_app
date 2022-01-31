import 'package:intl/intl.dart';

class UserModel {
  late String name;
  late String email;
  late String phone;
  late String uId;
  late String image;
  late String cover;
  late String bio;
  late bool isEmailVerified;

  UserModel(
      this.name,
      this.email,
      this.phone,
      this.uId,
      this.image,
      this.cover,
      this.bio,
      this.isEmailVerified,
      );

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'image': image,
      'cover': cover,
      'bio': bio,
      'isEmailVerified': isEmailVerified,
    };
  }
}
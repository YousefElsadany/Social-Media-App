class UserModel {
  String? uid;
  late String name;
  late String email;
  late String phone;
  String? image;
  String? cover;
  late String bio;
  late bool isEmailVerify;
  UserModel({
    this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    this.cover,
    required this.bio,
    required this.isEmailVerify,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    isEmailVerify = json['isEmailVerify'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'cover': cover,
      'bio': bio,
      'isEmailVerify': isEmailVerify,
    };
  }
}

// class Data {
//   late final id;
//   late String name;
//   late String email;
//   late String phone;
//   late String image;
//   late String token;

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     email = json['email'];
//     phone = json['phone'];
//     image = json['image'];
//     token = json['token'];
//   }

// }
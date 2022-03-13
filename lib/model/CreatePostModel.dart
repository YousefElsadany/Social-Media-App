class CreatePostModel {
  String? uid;
  String? name;
  String? image;
  String? text;
  String? dateTime;
  String? postImage;

  CreatePostModel({
    this.uid,
    this.name,
    this.image,
    this.text,
    this.dateTime,
    this.postImage,
  });

  CreatePostModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    image = json['image'];
    text = json['text'];
    dateTime = json['dateTime'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'image': image,
      'text': text,
      'dateTime': dateTime,
      'postImage': postImage,
    };
  }
}

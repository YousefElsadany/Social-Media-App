import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/SocialApp/Cubit/states.dart';
import 'package:social_app/model/CreatePostModel.dart';
import 'package:social_app/model/MessagesModel.dart';
import 'package:social_app/model/UserModel.dart';
import 'package:social_app/module/ChatsPage/chats.dart';
import 'package:social_app/module/HomePage/Home.dart';
import 'package:social_app/module/ProfilePage/profile.dart';
import 'package:social_app/module/SettingsPage/settings.dart';
import 'package:social_app/shared/componants/constants.dart';
import 'package:social_app/shared/style/icon_broken.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screen = [
    HomeScreen(),
    ChatsScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  List<IconData> bottomsIcons = [
    IconBroken.Home,
    IconBroken.Chat,
    IconBroken.Profile,
    IconBroken.Setting,
  ];

  void changeNavBar(index) {
    if (index == 1) {
      getUsers();
    }
    currentIndex = index;
    emit(SocialChangeNavBar());
  }

  UserModel? userModel;
  Future<void> getUser() async {
    emit(LoadingGetUserState());
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
        .then((value) {
      //print(value.data());
      userModel = UserModel.fromJson(value.data()!);
      emit(SuccessGetUserState());
    }).catchError(
      (error) {
        printFullText('Error Get User ' + error.toString());
        emit(ErrorGetUserState(error.toString()));
      },
    );
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SuccessProfileImagePickedState());
    } else {
      print('No image selected.');
      emit(ErrorProfileImagePickedState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SuccessCoverImagePickedState());
    } else {
      print('No image selected.');
      emit(ErrorCoverImagePickedState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String email,
    required String phone,
    required String bio,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
          'users/${Uri.file(profileImage!.path).pathSegments.last}',
        )
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SuccessUploadProfileImageState());

        print('Success Upload Profile Image ' + value);
        updateUesrData(
          name: name,
          email: email,
          phone: phone,
          bio: bio,
          image: value,
        );
      }).catchError((error) {
        emit(ErrorUploadProfileImageState());
        printFullText('Error Upload Profile Image ' + error.toString());
      });
    }).catchError((error) {
      emit(ErrorUploadProfileImageState());
      printFullText('Error Profile Image Picked ' + error.toString());
    });
  }

  void uploadCoverImage({
    required String name,
    required String email,
    required String phone,
    required String bio,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
          'users/${Uri.file(coverImage!.path).pathSegments.last}',
        )
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SuccessUploadCoverImageState());
        print('Success Upload Cover Image ' + value);
        updateUesrData(
          name: name,
          email: email,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error) {
        emit(ErrorUploadCoverImageState());
        printFullText('Error Upload Cover Image ' + error.toString());
      });
    }).catchError((error) {
      emit(ErrorUploadCoverImageState());
      printFullText('Error Cover Image Picked ' + error.toString());
    });
  }

  // void updateUesr({
  //   required String name,
  //   required String email,
  //   required String phone,
  //   required String bio,
  // }) {
  //   emit(LoadingUpdateUsersState());
  //   if (profileImage != null && coverImage != null) {
  //     uploadProfileImage();
  //     uploadCoverImage();
  //   } else if (coverImage != null) {
  //     uploadCoverImage();
  //   } else if (profileImage != null) {
  //     uploadProfileImage();
  //   } else {
  //     updateUesrData(
  //       name: name,
  //       email: email,
  //       phone: phone,
  //       bio: bio,
  //     );
  //   }
  // }

  void updateUesrData({
    required String name,
    required String email,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) {
    emit(LoadingUpdateUsersState());

    UserModel? model = UserModel(
      name: name,
      email: email,
      phone: phone,
      cover: cover ?? userModel!.cover,
      image: image ?? userModel!.image,
      bio: bio,
      isEmailVerify: false,
      uid: userModel!.uid,
    );
    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .update(model.toMap())
        .then((value) {
      getUser();
    }).catchError((error) {
      emit(ErrorUpdateUsersState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(CreateImagePostSuccessState());
    } else {
      print('No image selected.');
      emit(CreateImagePostErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(RemoveImagePostSuccessState());
  }

  void uploadImagePost({
    required String text,
    required String dateTime,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
          'posts/${Uri.file(postImage!.path).pathSegments.last}',
        )
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(CreatePostSuccessState());
        print('Success Upload Post Image ' + value);
        createNewPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
        );
      }).catchError((error) {
        emit(CreatePostErrorState());
        printFullText('Error Upload Post Image ' + error.toString());
      });
    }).catchError((error) {
      emit(CreatePostErrorState());
      printFullText('Error Post Image Picked ' + error.toString());
    });
  }

  void createNewPost({
    required String text,
    required String dateTime,
    String? postImage,
  }) {
    emit(LoadingUpdateUsersState());

    CreatePostModel? model = CreatePostModel(
      name: userModel!.name,
      image: userModel!.image,
      uid: userModel!.uid,
      text: text,
      dateTime: dateTime,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      print('Post successful');
      emit(CreatePostSuccessState());
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  List<CreatePostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int> comments = [];

  void getPosts() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(
            CreatePostModel.fromJson(
              element.data(),
            ),
          );
        }).catchError((error) {});

        element.reference.collection('comments').get().then((value) {
          comments.add(value.docs.length);
        }).catchError((error) {});
      });
      print('Get Posts successful');
      emit(SuccessGetPostsState());
    }).catchError(
      (error) {
        emit(ErrorGetPostsState(error.toString()));
      },
    );
  }

  void addLikePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uid)
        .set({'like': true}).then((value) {
      print('SUCCESS ADD LIKE ');
      emit(SuccessLikePostState());
    }).catchError((error) {
      printFullText('ERROR ADD LIKE ' + error.toString());
      emit(ErrorLikePostState(error));
    });
  }

  void addCommentPost(String postId, String comment) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userModel!.uid)
        .set({'comment': comment, 'postId': postsId}).then((value) {
      print('SUCCESS ADD COMMENT ');
      emit(SuccessCommentPostState());
    }).catchError((error) {
      printFullText('ERROR ADD COMMENT ' + error.toString());
      emit(ErrorCommentPostState(error));
    });
  }

  List<UserModel> users = [];

  void getUsers() {
    if (users.length == 0)
      FirebaseFirestore.instance.collection('user').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uid'] != userModel!.uid)
            users.add(
              UserModel.fromJson(
                element.data(),
              ),
            );
        });
        emit(SuccessGetAllUsersState());
      }).catchError(
        (error) {
          emit(ErrorGetAllUsersState(error.toString()));
        },
      );
  }

  void sendMessages({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessagesModel model = MessagesModel(
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: userModel!.uid,
      text: text,
    );

    // set my chat

    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    // set receiver chat

    FirebaseFirestore.instance
        .collection('user')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uid)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<MessagesModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessagesModel.fromJson(element.data()));
      });
      emit(GetMessagesSuccessState());
    });
  }
}

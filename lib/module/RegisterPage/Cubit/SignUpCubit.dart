import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/model/SignUpModel.dart';
import 'package:social_app/model/UserModel.dart';
import 'package:social_app/module/RegisterPage/Cubit/SignUpStates.dart';
import 'package:social_app/shared/network/EndPoint.dart';
import 'package:social_app/shared/network/remote/DioHelper.dart';

class ShopSignUpCubit extends Cubit<ShopSignUpStates> {
  ShopSignUpCubit() : super(ShopSignUpInitialStates());

  static ShopSignUpCubit get(context) => BlocProvider.of(context);

  void userSignUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    emit(ShopSignUpLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      createUser(
        name: name,
        email: email,
        phone: phone,
        uid: value.user!.uid,
      );
      emit(ShopSignUpSuccesState());
    }).catchError((error) {
      print('ERROR SIGNUP' + error.toString());
      emit(ShopSignUpErrorState(error.toString()));
    });
  }

  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uid,
  }) {
    emit(ShopCreateUserLoadingState());
    UserModel? model = UserModel(
      uid: uid,
      name: name,
      email: email,
      phone: phone,
      image: 'https://i.stack.imgur.com/l60Hf.png',
      cover:
          'https://image.freepik.com/free-photo/studio-shot-positive-african-american-woman-points-finger-copy-space-excited-by-good-information-smiles-pleasantly-wears-yellow-jacket-stands-ripped-paper-hole_273609-33954.jpg',
      bio: 'Write your bio ...',
      isEmailVerify: false,
    );

    FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .set(
          model.toMap(),
        )
        .then((value) {
      // print(value.user!.email);
      // print(value.user!.uid);

      emit(ShopCreateUserSuccesState());
    }).catchError((error) {
      print('ERROR CREATE USER' + error.toString());
      emit(ShopCreateUserErrorState(error.toString()));
    });
  }

  IconData suffinx = Icons.visibility;
  bool isShow = true;

  void changePasswordIcon() {
    isShow = !isShow;
    suffinx = isShow ? Icons.visibility : Icons.visibility_off;
    emit(ShopSignUpChangePasswordIconState());
  }
}

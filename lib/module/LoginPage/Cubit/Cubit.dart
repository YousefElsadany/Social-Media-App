import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/model/LoginModel.dart';
import 'package:social_app/module/LoginPage/Cubit/States.dart';
import 'package:social_app/shared/network/EndPoint.dart';
import 'package:social_app/shared/network/remote/DioHelper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginIntialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print('LOGIN SUCCESS ' + value.user!.email!);
      print(value.user!.uid);
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      print('ERROR LOGIN' + error.toString());
      emit(LoginErrorState(error.toString()));
    });
  }

  IconData suffinx = Icons.visibility;
  bool isShow = true;

  void changePasswordIcon() {
    isShow = !isShow;
    suffinx =
        isShow ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordIconState());
  }
}

import 'package:social_app/model/SignUpModel.dart';

abstract class ShopSignUpStates {}

class ShopSignUpInitialStates extends ShopSignUpStates {}

class ShopSignUpChangePasswordIconState extends ShopSignUpStates {}

class ShopSignUpLoadingState extends ShopSignUpStates {}

class ShopSignUpSuccesState extends ShopSignUpStates {}

class ShopSignUpErrorState extends ShopSignUpStates {
  final String error;

  ShopSignUpErrorState(this.error);
}

class ShopCreateUserLoadingState extends ShopSignUpStates {}

class ShopCreateUserSuccesState extends ShopSignUpStates {}

class ShopCreateUserErrorState extends ShopSignUpStates {
  final String error;

  ShopCreateUserErrorState(this.error);
}

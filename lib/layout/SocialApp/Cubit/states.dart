abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class SocialChangeNavBar extends SocialStates {}

// get user information

class LoadingGetUserState extends SocialStates {}

class SuccessGetUserState extends SocialStates {}

class ErrorGetUserState extends SocialStates {
  final String error;

  ErrorGetUserState(this.error);
}

// get user Chat

class LoadingGetAllUsersState extends SocialStates {}

class SuccessGetAllUsersState extends SocialStates {}

class ErrorGetAllUsersState extends SocialStates {
  final String error;

  ErrorGetAllUsersState(this.error);
}

// get posts

class LoadingGetPostsState extends SocialStates {}

class SuccessGetPostsState extends SocialStates {}

class ErrorGetPostsState extends SocialStates {
  final String error;

  ErrorGetPostsState(this.error);
}

// Like Post

class SuccessLikePostState extends SocialStates {}

class ErrorLikePostState extends SocialStates {
  final String error;

  ErrorLikePostState(this.error);
}

// Comment Post

class SuccessCommentPostState extends SocialStates {}

class ErrorCommentPostState extends SocialStates {
  final String error;

  ErrorCommentPostState(this.error);
}

// get profile and cover images by image picker

class SuccessProfileImagePickedState extends SocialStates {}

class ErrorProfileImagePickedState extends SocialStates {}

class SuccessCoverImagePickedState extends SocialStates {}

class ErrorCoverImagePickedState extends SocialStates {}

// upload profile and cover images

class SuccessUploadProfileImageState extends SocialStates {}

class ErrorUploadProfileImageState extends SocialStates {}

class SuccessUploadCoverImageState extends SocialStates {}

class ErrorUploadCoverImageState extends SocialStates {}

// update users

class LoadingUpdateUsersState extends SocialStates {}

class ErrorUpdateUsersState extends SocialStates {}

// create post

class CreatePostLoadingState extends SocialStates {}

class CreatePostSuccessState extends SocialStates {}

class CreatePostErrorState extends SocialStates {}

class CreateImagePostSuccessState extends SocialStates {}

class CreateImagePostErrorState extends SocialStates {}

class RemoveImagePostSuccessState extends SocialStates {}

// chat

class SendMessageSuccessState extends SocialStates {}

class SendMessageErrorState extends SocialStates {}

class GetMessagesSuccessState extends SocialStates {}

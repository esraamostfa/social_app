abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class GetUserLoadingState extends SocialStates {}
class GetUserSuccessState extends SocialStates {}
class GetUserErrorState extends SocialStates {
  final String error;
  GetUserErrorState(this.error);
}

class ChangeBottomNavState extends SocialStates {}

//class AddNewPostState extends SocialStates {}

class ProfileImagePickedSuccessState extends SocialStates {}
class ProfileImagePickedErrorState extends SocialStates {}
class CoverImagePickedSuccessState extends SocialStates {}
class CoverImagePickedErrorState extends SocialStates {}

class UploadProfileImageSuccessState extends SocialStates {}
class UploadProfileImageErrorState extends SocialStates {}
class UploadCoverImageSuccessState extends SocialStates {}
class UploadCoverImageErrorState extends SocialStates {}

class UserUpdateLoadingState extends SocialStates {}
class UserUpdateErrorState extends SocialStates {}

//create post
class CreatePostLoadingState extends SocialStates {}
class CreatePostSuccessState extends SocialStates {}
class CreatePostErrorState extends SocialStates {
  final String error;
  CreatePostErrorState(this.error);
}

class PostImagePickedSuccessState extends SocialStates {}
class PostImagePickedErrorState extends SocialStates {}

class UploadPostImageSuccessState extends SocialStates {}
class UploadPostImageErrorState extends SocialStates {}

class RemovePostImageState extends SocialStates {}

//get posts

class GetPostsLoadingState extends SocialStates {}
class GetPostsSuccessState extends SocialStates {}
class GetPostsErrorState extends SocialStates {
  final String error;
  GetPostsErrorState(this.error);
}

class LikePostSuccessState extends SocialStates {}
class LikePostErrorState extends SocialStates {
  final String error;
  LikePostErrorState(this.error);
}

class AddCommentLoadingState extends SocialStates {}
class AddCommentSuccessState extends SocialStates {}
class AddCommentErrorState extends SocialStates {
  final String error;
  AddCommentErrorState(this.error);
}

class GetCommentsLoadingState extends SocialStates {}
class GetCommentsSuccessState extends SocialStates {}
class GetCommentsErrorState extends SocialStates {
  final String error;
  GetCommentsErrorState(this.error);
}

class GetUserByIdSuccessState extends SocialStates {}
class GetUserByIdErrorState extends SocialStates {
  final String error;

  GetUserByIdErrorState(this.error);
}

class GetAllUsersLoadingState extends SocialStates {}
class GetAllUsersSuccessState extends SocialStates {}
class GetAllUsersErrorState extends SocialStates {
  final String error;
  GetAllUsersErrorState(this.error);
}



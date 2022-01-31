//import 'dart:html';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/states.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? user;

  void getUserData() {
    emit(GetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      user = UserModel.fromJson(value.data()!);
      print(value.data());
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState(error.toString()));
      print(error.toString());
    });
  }

  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Chats'),
    BottomNavigationBarItem(icon: Icon(null), label: ''),
    BottomNavigationBarItem(
        icon: Icon(Icons.location_on_outlined), label: 'Users'),
    BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined), label: 'Settings'),
  ];

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    Spacer(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = ['Home', 'Chats', '', 'Users', 'Settings'];

  void changeBottomNaveBarIndex(index) {
    //if(index == 2) {
    //emit(AddNewPostState());
    //} else {
    currentIndex = index;
    emit(ChangeBottomNavState());
    //}
  }

  File? profileImage;
  var picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(
        pickedFile.path,
      );
      emit(ProfileImagePickedSuccessState());
    } else {
      print('image not selected');
      emit(ProfileImagePickedErrorState());
    }
  }

  File? coverImage;

  Future getCoverImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(
        pickedFile.path,
      );
      emit(CoverImagePickedSuccessState());
    } else {
      print('image not selected');
      emit(CoverImagePickedErrorState());
    }
  }



  Future<String> uploadProfileImage() async {

    late String profileImageUrl;

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value;
        //print(value);
        //emit(UploadProfileImageSuccessState());
      }).catchError((error) {
        UploadProfileImageErrorState();
      });
    }).catchError((error) {
      UploadProfileImageErrorState();
    });

    return profileImageUrl;
  }



  Future<String> uploadCoverImage() async {

    late String coverImageUrl;

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${user!.uId}/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;
        //emit(UploadCoverImageSuccessState());
      }).catchError((error) {
        UploadCoverImageErrorState();
      });
    }).catchError((error) {
      UploadCoverImageErrorState();
    });

    return coverImageUrl;
  }

  Future updateUserData(String name, String phone, String bio) async {
    emit(UserUpdateLoadingState());

    late UserModel userUpdated;

    if(profileImage != null && coverImage != null) {
      userUpdated =  UserModel(
        name,
        user!.email,
        phone,
        user!.uId,
        await uploadProfileImage(),
        await uploadCoverImage(),
        bio,
        user!.isEmailVerified,
      );


    } else if(profileImage != null && coverImage == null) {
      uploadProfileImage().then((value){
        userUpdated =  UserModel(
          name,
          user!.email,
          phone,
          user!.uId,
          value,
          user!.cover,
          bio,
          user!.isEmailVerified,
        );
      }).catchError((error){print('error uploading profile image: $error');});

    } else if(profileImage == null && coverImage != null) {
      uploadCoverImage().then((value){
        userUpdated =  UserModel(
          name,
          user!.email,
          phone,
          user!.uId,
          user!.image,
          value,
          bio,
          user!.isEmailVerified,
        );
      }).catchError((error){});

    } else if(profileImage == null && coverImage == null) {
      userUpdated = UserModel(
        name,
        user!.email,
        phone,
        user!.uId,
        user!.image,
        user!.cover,
        bio,
        user!.isEmailVerified,
      );
    }

      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uId)
          .update(userUpdated.toJson())
          .then((value) {
        getUserData();
      }).catchError((error) {
        emit(UserUpdateErrorState());
      });
  }

  File? postImage;

  Future getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(
        pickedFile.path,
      );
      emit(PostImagePickedSuccessState());
    } else {
      print('image not selected');
      emit(PostImagePickedErrorState());
    }
  }

  void uploadPostImage(
      String dateTime,
      String text,
  ) {

    emit(CreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
        'posts/${user!.uId}/${Uri.file(postImage!.path)
            .pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createNewPost(dateTime, text, value);

        emit(UploadPostImageSuccessState());
      }).catchError((error) {
        UploadPostImageErrorState();
      });
    }).catchError((error) {
      UploadPostImageErrorState();
    });
  }

  void createNewPost(
      String dateTime,
      String text,
      String? postImageUrl
      ) {

    emit(CreatePostLoadingState());

    late PostModel postModel;

      postModel =  PostModel(
          user!.name,
          user!.uId,
          user!.image,
          dateTime,
          text,
          postImageUrl?? '');

    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toJson())
        .then((value) {
      emit(CreatePostSuccessState());
    }).catchError((error) {
      print('create post error: ${error.toString()}');
      emit(CreatePostErrorState(error.toString()));
    });

  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }

  List<PostModel> posts = [];
  List<String> postsIds = [];
  List<int> likes = [];
  List<int> commentsNum = [];

  Future getPosts() async {

    emit(GetPostsLoadingState());

    FirebaseFirestore.instance.collection('posts').get()
        .then((value) {
          value.docs.forEach((element) {
            element.reference.collection('likes').get().then((value) {
              likes.add(value.docs.length);
              element.reference.collection('comments').get()
              .then((value){
                commentsNum.add(value.docs.length);

                posts.add(PostModel.fromJson(element.data()));
                postsIds.add(element.id);
              })
                  .catchError((error){});
            }).catchError((error) {

            });
          });
          emit(GetPostsSuccessState());
    })
        .catchError((error) {
          emit(GetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId){
    FirebaseFirestore.instance.collection('posts').doc(postId)
        .collection('likes').doc(user!.uId).set(
        {
          'like' : true,
        }
        )
        .then((value){
          getPostLike(postId);
          emit(LikePostSuccessState());
    })
        .catchError((error){
          emit(LikePostErrorState(error.toString()));
    });
  }

  void addComment(String postId, String commentText){

    emit(AddCommentLoadingState());

    FirebaseFirestore.instance.collection('posts').doc(postId)
        .collection('comments').add(
        {
          '${user!.uId}' : commentText,
        }
        )
        .then((value){
          emit(AddCommentSuccessState());
    })
        .catchError((error){
          emit(AddCommentErrorState(error.toString()));
    });
  }

  List<Map<String, dynamic>> comments = [];
  List<UserModel> commentsUsers = [];

  Future getPostComments (String postId) async {

    emit(GetCommentsLoadingState());
    FirebaseFirestore.instance.collection('posts')
        .doc(postId).collection('comments')
        .orderBy('dateTime').snapshots()
    .listen((event) {

      //comments = [];
      //commentsUsers = [];

      event.docs.forEach((element) {
        FirebaseFirestore.instance.collection('users').doc(element.data().keys.first).get()
            .then((value) {
          emit(GetUserByIdSuccessState());
          commentsUsers.add(UserModel.fromJson(value.data()!));
          comments.add(element.data());
          emit(GetCommentsSuccessState());
          print(comments);
        })
            .catchError((error) {
          emit(GetUserByIdErrorState(error.toString()));
        });

      });
    });
  }

  // Future<UserModel> getUserById(String userId) async {
  //
  //   UserModel commentUser;
  //
  //   FirebaseFirestore.instance.collection('users').doc(userId).get()
  //       .then((value) {
  //     emit(GetUserByIdSuccessState());
  //         commentUser = UserModel.fromJson(value.data()!);
  //   })
  //       .catchError((error) {
  //     emit(GetUserByIdErrorState(error.toString()));
  //     commentUser = user!;
  //
  //   });
  //
  //   return commentUser;
  // }

  void getPostLike(String postId) {
    FirebaseFirestore.instance.collection('posts').doc(postId)
        .collection('likes').get()
        .then((value) {
          print('like value: $value');

    })
        .catchError((error){

    });
  }



}

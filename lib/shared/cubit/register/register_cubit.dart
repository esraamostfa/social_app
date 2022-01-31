//import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/cubit/register/register_states.dart';


class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister(
      String name,
      String email,
      String password,
      String phone) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
        .then((value){
          createUser(name, email, phone, value.user!.uid, value.user!.emailVerified);
          print(value.user!.email);
          print(value.user!.uid);
      //emit(RegisterSuccessState());
    }).catchError((error){
      emit(RegisterErrorState(error.toString()));
    });
  }



  void createUser(String name, String email, String phone, String uId, bool isEmailVerified) {
    emit(RegisterLoadingState());

    UserModel user = UserModel(
        name, email, phone, uId,
        'https://pm1.narvii.com/6564/d25f1023ef16fa75d92f537a0f6196e8bb58b242_hq.jpg',
        'http://cdn.wallpaperhi.com/1920x1080/20120521/hanasaku%20iroha%20matsumae%20ohana%20tsurugi%20minko%20oshimizu%20nako%202000x1370%20wallpaper_www.wallpaperhi.com_50.jpg',
        'write your bio here...',
        isEmailVerified);

    FirebaseFirestore.instance.collection('users').doc(uId).set(user.toJson())
        .then((value){
      emit(CreateUserSuccessState(uId));
    }).catchError((error){
      emit(CreateUserErrorState(error.toString()));
    });
  }

  bool isPassShown = false;

  void changePasswordVisibility() {
    isPassShown = !isPassShown;
    emit(RegisterPassVisibilityState());
  }

}
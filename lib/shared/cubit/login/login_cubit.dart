//import 'dart:html';

//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin(String email, String password) {
    emit(LoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          print(value.user!.email);
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }

  bool isPassShown = false;

  void changePasswordVisibility() {
    isPassShown = !isPassShown;
    emit(LoginPassVisibilityState());
  }

}

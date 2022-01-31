//import 'dart:html';

//import 'dart:html';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/home_layout.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/login/login_cubit.dart';
import 'package:social_app/shared/cubit/login/login_states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if(state is LoginErrorState) {
            showToast(state.error, ToastStates.ERROR);
          }
          if(state is LoginSuccessState) {
            showToast('signed in successfully', ToastStates.SUCCESS);
            CacheHelper.saveData(key: 'uId', value: state.uID).then((value) {
              navigateAndFinish(context, HomeLayout());
            });
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(21.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4!
                              .copyWith(
                              color: Colors.black
                          ),
                        ),
                        Text(
                          'Login now to communicate with your friends',
                          style: Theme.of(context).textTheme.bodyText1!
                              .copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 29,),
                        defaultTextForm(
                            controller: emailController,
                            textInputType: TextInputType.emailAddress,
                            label: 'Email Address',
                            validator: (String value) {
                              if(value.isEmpty){
                                return 'please enter your email address';
                              } else {
                                return null;
                              }
                            },
                            prefixIcon: Icons.email_outlined
                        ),
                        SizedBox(height: 15,),
                        defaultTextForm(
                            controller: passwordController,
                            textInputType: TextInputType.visiblePassword, label: 'Password',
                            validator: (String value) {
                              if(value.isEmpty){
                                return 'password is too short';
                              } else {
                                return null;
                              }
                            },
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: cubit.isPassShown? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            onSuffixPressed: () {
                              cubit.changePasswordVisibility();
                            },
                            isPassword: !cubit.isPassShown,

                            onSubmit: (value) {
                              if(formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                    emailController.text,
                                    passwordController.text);
                              }
                            }
                        ),
                        SizedBox(height: 29,),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => defaultButton(
                              text: 'login',
                              isUpperCase: true,
                              function: () {
                                if(formKey.currentState!.validate()) {
                                  LoginCubit.get(context).userLogin(
                                      emailController.text,
                                      passwordController.text);
                                }
                              }),
                          fallback: (context) => Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                naveTo(context, RegisterScreen());
                              },
                              child: Text('register now'.toUpperCase()),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

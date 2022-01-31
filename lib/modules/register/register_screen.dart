//import 'dart:html';

//import 'dart:html';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/register/register_cubit.dart';
import 'package:social_app/shared/cubit/register/register_states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var nameController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneController = TextEditingController();

    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterErrorState) {
            showToast(state.error, ToastStates.ERROR);
          }

          if (state is CreateUserSuccessState) {
            showToast('Registered successfully', ToastStates.SUCCESS);
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              navigateAndFinish(context, HomeLayout());
            });
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);

          return Scaffold(
            appBar: AppBar(),
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
                          'REGISTER',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'Register now to communicate your friends',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(height: 29,),
                        defaultTextForm(
                            controller: nameController,
                            textInputType: TextInputType.name,
                            label: 'Name',
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'please enter your name';
                              } else {
                                return null;
                              }
                            },
                            prefixIcon: Icons.person),
                        const SizedBox(height: 15,),
                        defaultTextForm(
                            controller: emailController,
                            textInputType: TextInputType.emailAddress,
                            label: 'Email Address',
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'please enter your email address';
                              } else {
                                return null;
                              }
                            },
                            prefixIcon: Icons.email_outlined),
                        SizedBox(
                          height: 15,
                        ),
                        defaultTextForm(
                            controller: phoneController,
                            textInputType: TextInputType.phone,
                            label: 'Phone',
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'please enter your phone number';
                              } else {
                                return null;
                              }
                            },
                            prefixIcon: Icons.phone_android),
                        SizedBox(
                          height: 15,
                        ),
                        defaultTextForm(
                            controller: passwordController,
                            textInputType: TextInputType.visiblePassword,
                            label: 'Password',
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'password is too short';
                              } else {
                                return null;
                              }
                            },
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: cubit.isPassShown
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            onSuffixPressed: () {
                              cubit.changePasswordVisibility();
                            },
                            isPassword: !cubit.isPassShown,
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                cubit.userRegister(
                                    nameController.text,
                                    emailController.text,
                                    phoneController.text,
                                    passwordController.text);
                              }
                            }),
                        SizedBox(
                          height: 29,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (context) => defaultButton(
                              text: 'register',
                              isUpperCase: true,
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.userRegister(
                                      nameController.text,
                                      emailController.text,
                                      passwordController.text,
                                      phoneController.text);
                                }
                              }),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('already have an account?'),
                            TextButton(
                              onPressed: () {
                                navigateAndFinish(context, LoginScreen());
                              },
                              child: Text('login'.toUpperCase()),
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

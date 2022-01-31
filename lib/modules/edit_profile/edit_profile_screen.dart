import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class EditProfileScreen extends StatelessWidget {

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        var userModel = cubit.user;

        nameController.text = userModel!.name;
        phoneController.text = userModel.phone;
        bioController.text = userModel.bio;

        File? profileImage = cubit.profileImage;
        File? coverImage = cubit.coverImage;
      return Scaffold(
          appBar: defaultAppBar(
              context,
              title: 'Edit Profile',
              actions: [
                TextButton(
                  onPressed: (){
                    cubit.updateUserData(
                        nameController.text,
                        phoneController.text,
                        bioController.text).then((value){
                          navigateAndFinish(context, SettingsScreen());
                    }).catchError((error){
                      print('error updating user: ${error.toString()}');
                    });
                  },
                  child: Text('UPDATE'),
                ),
                SizedBox(width: 15,),
              ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                children: [
                  if(state is UserUpdateLoadingState)
                  LinearProgressIndicator(),
                  SizedBox(height: 9,),
                  Container(
                    height: 211,
                    child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        topLeft: Radius.circular(5),)
                                  ),
                                  child: Image(
                                    image: coverImage == null ? NetworkImage('${userModel.cover}') : FileImage(coverImage) as ImageProvider,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 155,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: CircleAvatar(
                                    radius: 19,
                                      child: IconButton(
                                          onPressed: (){
                                            cubit.getCoverImage().then((value) {
                                            });
                                          },
                                          icon: Icon(
                                              Icons.camera_alt_outlined,
                                          size: 19,)
                                      )
                                  ),
                                )
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 65,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 59.9,
                                  backgroundImage: profileImage == null ? NetworkImage('${userModel.image}') : FileImage(profileImage) as ImageProvider,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: CircleAvatar(
                                  radius: 19,
                                    child: IconButton(
                                        onPressed: (){
                                          cubit.getProfileImage().then((value){

                                          });
                                        },
                                        icon: Icon(
                                            Icons.camera_alt_outlined,
                                        size: 19,)
                                    )
                                ),
                              )
                            ],
                          ),
                        ]
                    ),
                  ),
                  SizedBox(height: 19,),
                  defaultTextForm(
                      controller: nameController,
                      textInputType: TextInputType.name,
                      label: 'Name',
                      validator: (String value){
                        if(value.isEmpty) {
                          return 'Name can\'t be empty';
                        }
                        return null;
                  },
                      prefixIcon: Icons.person
                  ),
                  SizedBox(height: 19,),
                  defaultTextForm(
                      controller: phoneController,
                      textInputType: TextInputType.number,
                      label: 'Name',
                      validator: (String value){
                        if(value.isEmpty) {
                          return 'Phone can\'t be empty';
                        }
                        return null;
                      },
                      prefixIcon: Icons.phone_android_outlined
                  ),

                  SizedBox(height: 9,),
                  defaultTextForm(
                      controller:  bioController,
                      textInputType: TextInputType.text,
                      label: 'Bio',
                      validator: (String value){
                        if(value.isEmpty) {
                          return 'Bio can\'t be empty';
                        }
                        return null;
                      },
                      prefixIcon: Icons.info_outline
                  ),
                ],
              ),
            ),
          ),
      );
    },);
  }
}

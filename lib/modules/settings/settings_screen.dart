import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colores.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state) {},
        builder: (context, state) {

        var userModel = SocialCubit.get(context).user;

        return Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: [
              Container(
                height: 211,
                child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5),)
                          ),
                          child: Image(
                            image: NetworkImage(
                                '${userModel!.cover}'),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 155,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 65,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 59.9,
                          backgroundImage: NetworkImage('${userModel.image}'),
                        ),
                      ),
                    ]
                ),
              ),
              SizedBox(height: 5,),
              Text(
                '${userModel.name}',
                style: Theme.of(context).textTheme.headline6,),
              Text(
                '${userModel.bio}',
                style: Theme.of(context).textTheme.caption,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 19.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '111',
                              style: Theme.of(context).textTheme.subtitle2,),
                            Text(
                              'post',
                              style: Theme.of(context).textTheme.caption,),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '55',
                              style: Theme.of(context).textTheme.subtitle2,),
                            Text(
                              'Photos',
                              style: Theme.of(context).textTheme.caption,),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '15k',
                              style: Theme.of(context).textTheme.subtitle2,),
                            Text(
                              'Followers',
                              style: Theme.of(context).textTheme.caption,),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '13k',
                              style: Theme.of(context).textTheme.subtitle2,),
                            Text(
                              'Followings',
                              style: Theme.of(context).textTheme.caption,),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      child: Text('Add Photos'),
                    onPressed: (){},),
                  ),
                  IconButton(
                      onPressed: (){
                        naveTo(context, EditProfileScreen());
                      },
                      icon: Icon(Icons.edit),
                  color: defaultColor,)
                ],
              ),
              SizedBox(height: 5,),
              OutlinedButton(
                child: Text('Sign out'),
                onPressed: (){
                  uId = null;
                  navigateAndFinish(context, LoginScreen());
                },),
            ],
          ),
        );
        },
    );
  }
}

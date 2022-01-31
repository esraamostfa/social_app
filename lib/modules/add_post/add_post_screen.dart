import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class AddPostScreen extends StatelessWidget {

  TextEditingController newPostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state){},
      builder: (context, state){

        var cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: defaultAppBar(context,
              title: 'Create Post',
              actions: [TextButton(
                onPressed: (){
                  if(cubit.postImage == null) {
                    cubit.createNewPost(DateTime.now().toString(), newPostController.text, null);
                  } else {
                    cubit.uploadPostImage(DateTime.now().toString(), newPostController.text);
                  }
                },
                child: Text('Post'),
              ),
              ]
          ),
          body: Padding(
            padding: const EdgeInsets.all(19.0),
            child: Column(
              children: [
                if(state is CreatePostLoadingState)
                LinearProgressIndicator(),
                if(state is CreatePostLoadingState)
                SizedBox(height: 9,),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                          '${cubit.user!.image}'),
                    ),
                    SizedBox(
                      width: 19,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Esraa Mostfa'),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: newPostController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                    hintText: 'What is on your mind, ',
                    border: InputBorder.none,
                  ),
                  ),
                ),
                SizedBox(
                  width: 19,
                ),
                if(cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: Image(
                          image: FileImage(cubit.postImage!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 175,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: CircleAvatar(
                            radius: 19,
                            child: IconButton(
                                onPressed: (){
                                  cubit.removePostImage();
                                },
                                icon: Icon(
                                  Icons.close,
                                  size: 19,)
                            )
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  width: 19,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: (){cubit.getPostImage();},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined),
                              SizedBox(width: 5,),
                              Text('add photo')
                            ],
                          )
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: (){},
                          child: Text('@ tags')),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

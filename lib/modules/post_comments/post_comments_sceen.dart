import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colores.dart';

class PostCommentsScreen extends StatelessWidget {

  final int index;
  PostCommentsScreen(this.index);

  TextEditingController addCommentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state){
          if(state is AddCommentSuccessState) addCommentController.text = '';
        },
        builder: (context, state){

          var cubit = SocialCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(19.0),
              child: Column(
                children: [
                  Expanded(
                      child: Center(
                          child: ConditionalBuilder(
                            condition: cubit.comments.length != 0 && cubit.commentsUsers.length != 0,
                            builder: (context) => ListView.separated(
                                itemBuilder: (context, index) => buildCommentItem(cubit.comments[index].values.first,cubit.commentsUsers[index], context),
                                separatorBuilder: (context, index) => SizedBox(height: 9,),
                                itemCount: cubit.comments.length) ,
                            fallback: (context) => Text('comments will appear here'),
                          )
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.all(Radius.circular(9)),
                            ),
                            child: TextFormField(
                              controller: addCommentController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Write a comment',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 9,),
                        ConditionalBuilder(
                            condition: state is! AddCommentLoadingState,
                            builder: (context) => InkWell(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.send,
                                    color: defaultColor,
                                    size: 25,
                                  ),
                                  SizedBox(width: 5,),
                                ],
                              ),
                              onTap: () {
                                cubit.addComment(cubit.postsIds[index], addCommentController.text);
                              },
                            ),
                          fallback: (context) => CircularProgressIndicator(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
        );
  }

  Widget buildCommentItem(String commentText, UserModel commentUser, context) => Row(
    children: [
      CircleAvatar(
        radius: 25.0,
        backgroundImage: NetworkImage(
            '${commentUser.image}'),
      ),
      const SizedBox(width: 9,),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(9.0),
          width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: defaultColor.withOpacity(0.2),
            borderRadius: BorderRadius.all(Radius.circular(9)),
        ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${commentUser.name}',
                style: Theme.of(context).textTheme.bodyText1,),
              const SizedBox(height: 5,),
              Text(commentText),
            ],
          ),
        ),
      ),
    ],
  );
}

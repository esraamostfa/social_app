//import 'dart:html';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/post_comments/post_comments_sceen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colores.dart';

class FeedsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {

        List<PostModel> posts = SocialCubit.get(context).posts;

        return ConditionalBuilder(
            condition: posts.length != 0,
            builder: (context) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5,
                    margin: EdgeInsets.all(9.0),
                    child: Stack(alignment: AlignmentDirectional.topCenter, children: [
                      Image(
                        image: NetworkImage(
                            'https://image.freepik.com/free-vector/flat-international-friendship-day-illustration_23-2148965601.jpg'),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 199,
                      ),
                      Container(
                        height: 25,
                        padding: EdgeInsets.all(5.0),
                        color: Colors.deepPurple,
                        child: Text(
                          'Communicate with Friends',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(color: Colors.white),
                        ),
                      )
                    ]),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildPostItem(context, posts[index], index),
                      separatorBuilder: (context, index) => SizedBox(height: 9,),
                      itemCount: posts.length),
                  SizedBox(height: 9,),
                ],
              ),
            ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildPostItem(context, PostModel post, int index) {

    var cubit = SocialCubit.get(context);
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 9),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                    '${post.image}'),
              ),
              const SizedBox(width: 19,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text('${post.name}'),
                    const SizedBox(width: 5,),
                    Icon(
                      Icons.check_circle,
                      color: defaultColor,
                      size: 15,
                    ),
                  ]),
                  Text(
                    '${post.dateTime}',
                    style: Theme
                        .of(context)
                        .textTheme
                        .caption,
                  ),
                ],
              ),
              //SizedBox(width: 15,),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_horiz,
                    size: 19,
                  ))
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
          Text('${post.text}',),
          Container(
            margin: EdgeInsets.only(bottom: 9, top: 5),
            width: double.infinity,
            child: Wrap(
              children: [
                Container(
                  height: 21,
                  margin: EdgeInsetsDirectional.only(end: 5),
                  child: MaterialButton(
                      height: 25,
                      minWidth: 1,
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: Text(
                        '#Anime',
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption
                            ?.copyWith(color: defaultColor),
                      )),
                ),
                Container(
                  height: 21,
                  margin: EdgeInsetsDirectional.only(end: 5),
                  child: MaterialButton(
                      height: 25,
                      minWidth: 1,
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: Text(
                        '#Attack_on_Titan',
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption
                            ?.copyWith(color: defaultColor),
                      )),
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(end: 5),
                  height: 21,
                  child: MaterialButton(
                      height: 25,
                      minWidth: 1,
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: Text(
                        '#Shingeki_no_Kyojin',
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption
                            ?.copyWith(color: defaultColor),
                      )),
                ),
              ],
            ),
          ),
          if(post.postImage != '')
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              width: double.infinity,
              height: 141,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.9),
                image: DecorationImage(
                    image: NetworkImage(
                        '${post.postImage}'),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                            size: 17,
                          ),
                          const SizedBox(width: 5,),
                          Text(
                            '${cubit.likes[index]}',
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption,),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.mode_comment_outlined,
                            color: Colors.amber,
                            size: 17,
                          ),
                          const SizedBox(width: 5,),
                          Text(
                            '${cubit.commentsNum[index]}',
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption,),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 11),
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(
                              '${SocialCubit.get(context).user!.image}'
                          ),
                        ),
                        SizedBox(
                          width: 19,
                        ),
                        Text(
                          'Write a comment',
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption,
                        ),
                      ]
                  ),
                  onTap: () {
                    cubit.getPostComments(cubit.postsIds[index])
                        .then((value){
                      naveTo(context, PostCommentsScreen(index));
                    }).
                    catchError((error){});

                  },
                ),
              ),
              InkWell(
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 17,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      'Like',
                      style: Theme
                          .of(context)
                          .textTheme
                          .caption,),
                  ],
                ),
                onTap: () {
                  cubit.likePost(cubit.postsIds[index]);
                },
              ),
            ],
          )
        ]),
      ),
    );
  }
}

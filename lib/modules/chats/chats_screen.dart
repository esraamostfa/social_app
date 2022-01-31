import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chat_details.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/chats/chats_cubit.dart';
import 'package:social_app/shared/cubit/chats/chats_state.dart';

class ChatsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var cubit = ChatsCubit.get(context);

    return BlocConsumer<ChatsCubit, ChatsStates>(
        listener: (context, state) {},
        builder: (context, state) => ConditionalBuilder(
                condition: cubit.users.length > 0,
                builder: (context) => ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) =>
                            buildChatItem(cubit.users[index], context),
                        separatorBuilder: (context, index) =>
                            buildItemsDivider(),
                        itemCount: cubit.users.length),
                fallback: (context) => Center(child: CircularProgressIndicator()),
    )
    );
  }

  Widget buildChatItem(UserModel user, context) =>
      InkWell(
        onTap: () {
          ChatsCubit.get(context).getChatMessages(user.uId);
          naveTo(context, ChatDetailsScreen(user));
        },
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('${user.image}'),
                radius: 25,
              ),
              SizedBox(width: 15,),
              Text('${user.name}')
            ],
          ),
        ),
      );
}

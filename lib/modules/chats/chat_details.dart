import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/chats/chats_cubit.dart';
import 'package:social_app/shared/cubit/chats/chats_state.dart';
import 'package:social_app/shared/styles/colores.dart';

class ChatDetailsScreen extends StatelessWidget {

  final UserModel chatUser;
  ChatDetailsScreen(this.chatUser);

  TextEditingController chatTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    var cubit = ChatsCubit.get(context);

    return BlocConsumer<ChatsCubit, ChatsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('${chatUser.image}'),
                  radius: 19,
                ),
                SizedBox(width: 15,),
                Text('${chatUser.name}',
                style: Theme.of(context).textTheme.bodyText1,)
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(19.0),
            child: Column(
              children: [
                Expanded(
                  child: ConditionalBuilder(
                    condition: cubit.chatMessages.length > 0,
                    builder: (context) => ListView.separated(
                        itemBuilder: (context, index) {
                                if(cubit.chatMessages[index].senderId == uId)
                                  return buildSenderChatItem(cubit.chatMessages[index]);
                                return buildReceiverChatItem(cubit.chatMessages[index]);
                        },
                        separatorBuilder: (context, index) => SizedBox(height: 9,),
                        itemCount: cubit.chatMessages.length),
                    fallback: (context) => Center(child: Text('Start chatting!')),
                  ),
                ),

                Row(
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
                          controller: chatTextController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Write a message...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9,),
                    InkWell(
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
                        if(chatTextController.text != ''){
                          cubit.sendMessage(chatTextController.text, DateTime.now().toString(), chatUser.uId);
                          chatTextController.text = '';
                        }
                        },
                    ),
                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildReceiverChatItem(ChatModel chatModel) => Align(
    alignment: AlignmentDirectional.topStart,
    child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(9),
              topEnd: Radius.circular(9),
              bottomEnd: Radius.circular(9),
            )
        ),
        child: Text(chatModel.chatText)
    ),
  );
  Widget buildSenderChatItem(ChatModel chatModel) =>  Align(
    alignment: AlignmentDirectional.topEnd,
    child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
            color: defaultColor.withOpacity(0.2),
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(9),
              topEnd: Radius.circular(9),
              bottomStart: Radius.circular(9),
            )
        ),
        child: Text(chatModel.chatText)
    ),
  );
}

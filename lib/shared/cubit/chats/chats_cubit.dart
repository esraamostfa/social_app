import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';

import 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsStates> {
  ChatsCubit() : super(ChatsInitialState());

  static ChatsCubit get(context) => BlocProvider.of(context);

  List<UserModel> users = [];

  Future getAllUser() async {
    emit(GetAllUsersLoadingState());

    FirebaseFirestore.instance.collection('users').get().then((value) {
      emit(GetAllUsersSuccessState());

      value.docs.forEach((element) {
        if (element.data()['uId'] != uId) {
          users.add(UserModel.fromJson(element.data()));
        }
      });
    }).catchError((error) {
      emit(GetAllUsersErrorState(error.toString()));
    });
  }

  void sendMessage(String messageText, String dateTime, String receiverId) {
    ChatModel chatModel = ChatModel(dateTime, uId!, receiverId, messageText);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(chatModel.toJson())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(error.toString()));
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(chatModel.toJson())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(error.toString()));
    });
  }

  List<ChatModel> chatMessages = [];

  Future getChatMessages(String receiverId) async {

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      emit(GetChatMessagesSuccessState());
      chatMessages = [];
      event.docs.forEach((element) {
        chatMessages.add(ChatModel.fromJson(element.data()));
      });
    });
  }
}

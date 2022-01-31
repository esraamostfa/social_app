abstract class ChatsStates {}

class ChatsInitialState extends ChatsStates {}

class GetAllUsersLoadingState extends ChatsStates {}
class GetAllUsersSuccessState extends ChatsStates {}
class GetAllUsersErrorState extends ChatsStates {
  final String error;
  GetAllUsersErrorState(this.error);
}

class SendMessageLoadingState extends ChatsStates {}
class SendMessageSuccessState extends ChatsStates {}
class SendMessageErrorState extends ChatsStates {
  final String error;
  SendMessageErrorState(this.error);
}

class GetChatMessagesLoadingState extends ChatsStates {}
class GetChatMessagesSuccessState extends ChatsStates {}
class GetChatMessagesErrorState extends ChatsStates {
  final String error;
  GetChatMessagesErrorState(this.error);
}
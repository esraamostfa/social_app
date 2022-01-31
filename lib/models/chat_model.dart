class ChatModel {

  late String dateTime;
  late String senderId;
  late String receiverId;
  late String chatText;

  ChatModel(
      this.dateTime,
      this.senderId,
      this.receiverId,
      this.chatText
      );

  ChatModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    chatText = json['chatText'];
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime' : dateTime,
      'senderId' : senderId,
      'receiverId' : receiverId,
      'chatText' : chatText
    };
  }



}
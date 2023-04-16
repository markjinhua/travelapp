class MessageModel {
  String message;
  String answer;
  String dateTime;
  bool sentByMe;
  String? id;


  MessageModel({
    required this.message,
    required this.sentByMe,
    required this.dateTime,
    required this.answer,
    this.id
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      MessageModel(
          message: json['message'],
        dateTime: json['dateTime'],
        answer: json['answer'],
          sentByMe: json['sentByMe'],
        id: json['id'],


      );

  Map<String, dynamic> toJson() => {
    'message': message,
    'sentByMe': sentByMe,
    'answer': answer,
    'dateTime': dateTime,
    'id': id,
  };


}
List<MessageModel> historyList = [];
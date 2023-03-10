import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_care/modules/chat_details/cubit/states.dart';

import '../../../models/message_model.dart';
import '../../../shared/constants/constants.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesStates>{

  ChatMessagesCubit():super(InitChatMessagesStats());

  static ChatMessagesCubit get(BuildContext context) => BlocProvider.of(context);

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String textMessage,
  }){
    MessageModel model = MessageModel(
      senderId: uId!,
      receiverId: receiverId,
      dateTime: dateTime,
      messageText: textMessage,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId!)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(uId!)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
  required String receiverId
}){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
          messages = [];
          event.docs.forEach((element) {
              messages.add(MessageModel.fromJson(element.data()));
          });
          emit(GetMessageSuccessState());
    });
  }
}
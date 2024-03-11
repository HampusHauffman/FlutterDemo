import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

part 'chat_provider.g.dart';

@JsonSerializable()
class Message {
  Message({
    required this.email,
    required this.message,
  });

  final String email;
  final String message;

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

@riverpod
class Chat extends _$Chat {
  final _docRef = FirebaseFirestore.instance.collection("chat").doc("open");

  void addMessage(Message message) {
    _docRef.update({const Uuid().v8().toString(): message.toJson()});
  }

  @override
  Map<String, Message> build() {
    _docRef.snapshots().listen(
      (event) {
        debugPrint("current data: ${event.data().toString()}");
        state = event
            .data()!
            .map((key, value) => MapEntry(key, Message.fromJson(value)));
      },
      onError: (error) => debugPrint("Listen failed: $error"),
    );
    return Map.of({});
  }
}

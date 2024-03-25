import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_talk/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

part 'chat_provider.g.dart';
part 'chat_provider.freezed.dart';

//////////////////////////
// Provider for the current message in the text field
/////////////////////////
@riverpod
class CurrentMessage extends _$CurrentMessage {
  @override
  String build() => "";
  void set(String message) => state = message;
}

//////////////////////////
// Providers for the chat messages
/////////////////////////
@Freezed()
class Message with _$Message {
  factory Message({
    required String uid,
    required String message,
    required DateTime timestamp,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

@riverpod
class Chat extends _$Chat {
  final _docRef = FirebaseFirestore.instance.collection("chat").doc("open");

  Future<void> addMessage(String message) async {
    _docRef.update({
      const Uuid().v8().toString(): Message(
        uid: (await ref.read(authProvider.future))!.uid,
        message: message,
        timestamp: DateTime.now(),
      ).toJson(),
    });
  }

  @override
  List<Message> build() {
    _docRef.snapshots().listen((event) {
      state = event
          .data()!
          .map((key, value) => MapEntry(key, Message.fromJson(value)))
          .values
          .sorted((a, b) => a.timestamp.compareTo(b.timestamp));
    });
    return List.of([]);
  }
}

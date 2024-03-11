import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_talk/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

part 'chat_provider.g.dart';
part 'chat_provider.freezed.dart';

@Freezed()
class Message with _$Message {
  factory Message({
    required String uid,
    required String message,
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
              uid: (await ref.read(authProvider.future)).uid, message: message)
          .toJson(),
    });
  }

  @override
  Map<String, Message> build() {
    _docRef.snapshots().listen(
      (event) {
        state = event
            .data()!
            .map((key, value) => MapEntry(key, Message.fromJson(value)));
      },
    );
    return Map.of({});
  }
}

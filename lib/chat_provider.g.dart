// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      email: json['email'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'email': instance.email,
      'message': instance.message,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatHash() => r'c9115c284ee023bed6e04bfb5447e40db7ba1826';

/// See also [Chat].
@ProviderFor(Chat)
final chatProvider =
    AutoDisposeNotifierProvider<Chat, Map<String, Message>>.internal(
  Chat.new,
  name: r'chatProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Chat = AutoDisposeNotifier<Map<String, Message>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      uid: json['uid'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'message': instance.message,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatHash() => r'66617cbdb1eaaef455885c3c386f56e41481da8b';

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

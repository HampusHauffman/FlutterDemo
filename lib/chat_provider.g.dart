// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      uid: json['uid'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentMessageHash() =>
    r'4baf3faf191c1a23de4e2bc66c4ab45102ab9e59'; //////////////////////////
/////////////////////////
///
/// Copied from [CurrentMessage].
@ProviderFor(CurrentMessage)
final currentMessageProvider =
    AutoDisposeNotifierProvider<CurrentMessage, String>.internal(
  CurrentMessage.new,
  name: r'currentMessageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMessageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentMessage = AutoDisposeNotifier<String>;
String _$chatHash() => r'28878c1f5ce516600f60a891658c8450fbd31793';

/// See also [Chat].
@ProviderFor(Chat)
final chatProvider = AutoDisposeNotifierProvider<Chat, List<Message>>.internal(
  Chat.new,
  name: r'chatProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Chat = AutoDisposeNotifier<List<Message>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

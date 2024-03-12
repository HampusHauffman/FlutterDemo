import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_talk/auth_provider.dart';
import 'package:flutter_talk/chat_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'firebase_options.dart';

part 'main.g.dart';

// current message provider
@riverpod
class CurrentMessage extends _$CurrentMessage {
  @override
  String build() => "";

  void set(String message) {
    state = message;
    debugPrint("message: $state");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            // login button
            leading: IconButton(
              icon: const Icon(Icons.login),
              onPressed: () async {
                await ref.read(authProvider.notifier).signIn();
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("Flutter Demo")),
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: ref
                    .watch(chatProvider)
                    .map((entrie) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // add spacer on the correct side depending on uid
                              entrie.uid == (ref.watch(authProvider).value)?.uid
                                  ? const Spacer()
                                  : Container(),
                              Text(entrie.message),
                              Text(entrie.timestamp.toString()),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (t) {
                  ref.watch(currentMessageProvider.notifier).set(t);
                },
                decoration: InputDecoration(
                  hintText: "Enter your message",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      String message = ref.watch(currentMessageProvider);
                      debugPrint("message2: $message");
                      ref.watch(chatProvider.notifier).addMessage(message);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

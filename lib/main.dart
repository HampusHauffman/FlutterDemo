import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_talk/chat_provider.dart';
import 'firebase_options.dart';

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
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("Flutter Demo")),
        // Create the view for a chat app where you can enter text and chat
        // At the bottom is the text input and the rest of the screen is the chat
        body: Column(
          children: [
            Expanded(
                child: Text(ref
                    .watch(chatProvider)
                    .values
                    .map((e) => e.message)
                    .toString())),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter your message",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      debugPrint("Send message");
                      ref
                          .read(chatProvider.notifier)
                          .addMessage(Message(email: "awd", message: "HELLO"));
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

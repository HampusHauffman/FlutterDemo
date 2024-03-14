import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

extension ToggleBrightness on Brightness {
  Brightness toggle() =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;

  ThemeMode toThemeMode() =>
      this == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
}

@riverpod
class LightMode extends _$LightMode {
  @override
  // get the mode of the pc
  Brightness build() =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  void toggle() => state = state.toggle();
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
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(lightModeProvider).toThemeMode(),
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple, brightness: Brightness.dark),
      ),
      home: Scaffold(
        appBar: AppBar(
            elevation: 3,
            backgroundColor: Theme.of(context).primaryColor,
            leadingWidth: 130,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                label: const Text("Login"),
                icon: const Icon(Icons.account_box),
                onPressed: () async {
                  await ref.read(authProvider.notifier).signIn();
                },
              ),
            ),
            actions: [
              Switch(
                  thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                      (Set<MaterialState> _) => Icon(
                          ref.watch(lightModeProvider) == Brightness.light
                              ? Icons.sunny
                              : Icons.brightness_3)),
                  value: ref.watch(lightModeProvider) == Brightness.dark,
                  onChanged: (value) {
                    ref.read(lightModeProvider.notifier).toggle();
                  }),
            ],
            title: const Text("Flutter Demo")),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  children: ref
                      .watch(chatProvider)
                      .map((entrie) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MessageWidget(entrie),
                          ))
                      .toList(),
                ),
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
                      ref.watch(chatProvider.notifier).addMessage(message);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends ConsumerWidget {
  final Message entrie;
  const MessageWidget(this.entrie, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool left = entrie.uid == (ref.watch(authProvider).value)?.uid;

    return Row(
      children: [
        left ? const Spacer() : Container(),
        Column(
          crossAxisAlignment:
              left ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(entrie.message),
              ),
            ),
            Text(
                "${DateTime.now().difference(entrie.timestamp).inMinutes} minutes ago",
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}

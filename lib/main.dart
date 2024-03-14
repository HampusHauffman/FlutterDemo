import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_talk/auth_provider.dart';
import 'package:flutter_talk/chat_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'firebase_options.dart';

part 'main.g.dart';

//////////////////////////
// Routing
/////////////////////////
final _router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const Home(),
  ),
]);

//////////////////////////
// Providers
/////////////////////////
@riverpod
class CurrentMessage extends _$CurrentMessage {
  @override
  String build() => "";
  void set(String message) => state = message;
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
  Brightness build() =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  void toggle() => state = state.toggle();
}

//////////////////////////
// Main class and entry
// point for the app
/////////////////////////
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(lightModeProvider).toThemeMode(),
      routerConfig: _router,
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple, brightness: Brightness.dark),
      ),
    );
  }
}

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
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
          Padding(padding: const EdgeInsets.all(16.0), child: TextInput())
        ],
      ),
    );
  }
}

//////////////////////////
// Widget for the text input
/////////////////////////
class TextInput extends ConsumerWidget {
  TextInput({super.key});

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: _textController,
      onChanged: (t) => ref.watch(currentMessageProvider.notifier).set(t),
      decoration: InputDecoration(
        hintText: "Enter your message",
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            String message = ref.watch(currentMessageProvider);
            ref.watch(chatProvider.notifier).addMessage(message);
            ref.watch(currentMessageProvider.notifier).set("");
            _textController.clear();
          },
        ),
      ),
    );
  }
}

//////////////////////////
// Widget for showing the messages
/////////////////////////
class MessageWidget extends ConsumerWidget {
  const MessageWidget(this.entrie, {super.key});

  final Message entrie;

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

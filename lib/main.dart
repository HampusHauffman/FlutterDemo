import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state++;
}

void main() {
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
    int counter = ref.watch(counterProvider);

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("Flutter Demo")),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the button this many times:'),
                Text('$counter',
                    style: Theme.of(context).textTheme.headlineMedium)
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => ref.read(counterProvider.notifier).increment(),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          )),
    );
  }
}

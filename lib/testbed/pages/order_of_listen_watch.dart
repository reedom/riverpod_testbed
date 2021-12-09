import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_testbed/testbed/widgets/count_tile.dart';

class OrderOfListenWatchPage extends StatefulHookConsumerWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<OrderOfListenWatchPage> {
  int _built = 0;

  List<String> _history = [];

  final _stateNotifierProvider =
      StateNotifierProvider<_StateNotifier, int>((_) => _StateNotifier());

  final _anotherProvider =
      StateNotifierProvider<_StateNotifier, int>((_) => _StateNotifier());

  @override
  Widget build(BuildContext context) {
    ++_built;

    final value = ref.watch(_stateNotifierProvider);
    _history.add('watch($value)');

    ref.listen(_stateNotifierProvider, (_, value) {
      _history.add('listen($value)');
      ref.read(_anotherProvider.notifier).update();
    });

    ref.watch(_anotherProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('ref.listen and ref.watch'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Text(
                'Tapping button updates a state of StateNotifier.\n'
                'In what order do ref.listen and ref.watch occur'
                ' respectively?',
                style: TextStyle(color: Colors.blueGrey)),
          ),
          TextButton(
              onPressed: () {
                _history = [];
                ref.read(_stateNotifierProvider.notifier).update();
              },
              child: Text('Tap here to test')),
          CountTile(label: 'Build', count: _built),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              padding: EdgeInsets.all(8),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_history.length, (i) => i)
                    .map((i) => Text('${i + 1} - ${_history[i]}',
                        style: TextStyle(
                          fontFeatures: [FontFeature.tabularFigures()],
                        )))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StateNotifier extends StateNotifier<int> {
  _StateNotifier() : super(0);

  void update() => state = state + 1;
}

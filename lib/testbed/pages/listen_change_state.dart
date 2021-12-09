import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_testbed/testbed/controllers/periodic_value_controller.dart';
import 'package:riverpod_testbed/testbed/controllers/provider_state_controller.dart';
import 'package:riverpod_testbed/testbed/widgets/count_tile.dart';
import 'package:riverpod_testbed/testbed/widgets/provider_state_tile.dart';

class ListenChangeStatePage extends StatefulHookConsumerWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<ListenChangeStatePage> {
  int _built = 0;

  final _stateProvider = StateProvider<int>((_) => 0);
  final _stateNotifierProvider =
      StateNotifierProvider<_StateNotifier, int>((_) => _StateNotifier());

  @override
  Widget build(BuildContext context) {
    ++_built;

    ref.watch(_stateProvider.notifier);
    ref.watch(_stateNotifierProvider.notifier);

    final stateProviderState =
        ref.watch(providerStateProvider('stateProvider'));
    ref.listen(periodicValueProvider('stateProvider'), (prev, next) {
      try {
        ref.read(_stateProvider.notifier).state++;
      } catch (err) {
        ref
            .read(providerStateProvider('stateProvider').notifier)
            .gotException();
      }
    });

    final stateNotifierProviderState =
        ref.watch(providerStateProvider('stateNotifierProvider'));
    ref.listen(periodicValueProvider('stateNotifierProvider'), (prev, next) {
      try {
        ref.read(_stateNotifierProvider.notifier).update();
      } catch (err) {
        ref
            .read(providerStateProvider('stateNotifierProvider').notifier)
            .gotException();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Listen and change state'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Text(
                'No exception means it is safe to change state in a '
                'ref.listen callback',
                style: TextStyle(color: Colors.blueGrey)),
          ),
          CountTile(label: 'Build', count: _built),
          ProviderStateTile(label: 'stateProvider', state: stateProviderState),
          ProviderStateTile(
              label: 'stateNotifierProvider',
              state: stateNotifierProviderState),
        ],
      ),
    );
  }
}

class _StateNotifier extends StateNotifier<int> {
  _StateNotifier() : super(0);

  void update() => state = state + 1;
}

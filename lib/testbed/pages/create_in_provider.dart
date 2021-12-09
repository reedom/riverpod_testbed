import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_testbed/testbed/controllers/periodic_value_controller.dart';
import 'package:riverpod_testbed/testbed/controllers/provider_state_controller.dart';
import 'package:riverpod_testbed/testbed/widgets/count_tile.dart';
import 'package:riverpod_testbed/testbed/widgets/provider_state_tile.dart';

class CreateInProviderPage extends StatefulHookConsumerWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<CreateInProviderPage> {
  int _built = 0;

  @override
  Widget build(BuildContext context) {
    ++_built;
    ref.watch(_readStateNotifier('read'));
    final readState = ref.watch(providerStateProvider('read'));

    ref.watch(_watchStateNotifier('watch'));
    final watchState = ref.watch(providerStateProvider('watch'));

    ref.watch(_listenStateNotifier('listen'));
    final listenState = ref.watch(providerStateProvider('listen'));

    return Scaffold(
      appBar: AppBar(
        title: Text('Create providers in providers'),
      ),
      body: Column(
        children: [
          CountTile(label: 'Build', count: _built),
          ProviderStateTile(label: 'read', state: readState),
          ProviderStateTile(label: 'watch', state: watchState),
          ProviderStateTile(label: 'listen', state: listenState),
        ],
      ),
    );
  }
}

final _readStateNotifier = Provider.family.autoDispose<int, String>((ref, id) {
  ref.read(periodicValueProvider(id).notifier);
  return 0;
});

final _watchStateNotifier = Provider.family.autoDispose<int, String>((ref, id) {
  ref.watch(periodicValueProvider(id).notifier);
  return 0;
});

final _listenStateNotifier =
    Provider.family.autoDispose<int, String>((ref, id) {
  ref.listen(periodicValueProvider(id).notifier, (prev, next) {});
  return 0;
});

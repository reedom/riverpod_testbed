import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_testbed/testbed/controllers/periodic_value_controller.dart';
import 'package:riverpod_testbed/testbed/controllers/provider_state_controller.dart';
import 'package:riverpod_testbed/testbed/widgets/count_tile.dart';
import 'package:riverpod_testbed/testbed/widgets/provider_state_tile.dart';

class CreateInWidgetPage extends StatefulHookConsumerWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<CreateInWidgetPage> {
  int _built = 0;

  @override
  Widget build(BuildContext context) {
    ++_built;
    ref.read(periodicValueProvider('read-state'));
    final readState = ref.watch(providerStateProvider('read-state'));

    ref.read(periodicValueProvider('read-notifier').notifier);
    final readNotifierState = ref.watch(providerStateProvider('read-notifier'));

    ref.watch(periodicValueProvider('watch'));
    final watchState = ref.watch(providerStateProvider('watch'));

    ref.listen(periodicValueProvider('listen'), (prev, next) {});
    final listenState = ref.watch(providerStateProvider('listen'));

    return Scaffold(
      appBar: AppBar(
        title: Text('Create providers in a Widget'),
      ),
      body: Column(
        children: [
          CountTile(label: 'Build', count: _built),
          ProviderStateTile(label: 'read-state', state: readState),
          ProviderStateTile(label: 'read-notifier', state: readNotifierState),
          ProviderStateTile(label: 'watch', state: watchState),
          ProviderStateTile(label: 'listen', state: listenState),
        ],
      ),
    );
  }
}

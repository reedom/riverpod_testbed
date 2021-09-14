import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_testbed/testbed/riverpod_test_providers.dart';

class RiverpodTestAccessWidget extends HookWidget {
  const RiverpodTestAccessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = useState(1);
    debugPrint('-=' * 60);
    debugPrint('RiverpodTestWidget: build, id = ${id.value}');

    useEffect(() {
      void handler() {
        Future<void>.delayed(Duration.zero).then((_) {
          id.value++;
          debugPrint(
              'RiverpodTestWidget: invoked by the timer, id = ${id.value}');
          debugPrint('[timer end] ${'-' * 30}');
        });
      }

      final timer =
          Timer.periodic(const Duration(seconds: 5), (_) => handler());
      return timer.cancel;
    }, []);

    useProvider(riverpodTestFamilyStateNotifierProvider(id.value));
    final value =
        useProvider(riverpodTestFamilyStateNotifierWatcherProvider(id.value));
    debugPrint('RiverpodTestWidget: read a value from the watcher, '
        'value = $value');
    useProvider(riverpodTestFamilyStreamNotifierWatcherProvider(id.value));
    useProvider(riverpodTestFamilyProvider(id.value));
    debugPrint('[build end] ${'-' * 30}');
    return const SizedBox.shrink();
  }
}

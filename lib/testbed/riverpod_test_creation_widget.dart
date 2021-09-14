import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_testbed/testbed/riverpod_test_providers.dart';

class RiverpodTestCreationWidget extends HookWidget {
  const RiverpodTestCreationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      var id = 0;
      var i = 0;
      void handler() {
        ++i;
        if (i == 5) {
          i = 0;
          ++id;
        }

        debugPrint('-=' * 60);
        debugPrint(
            'RiverpodTestCreationWidget: invoked by the timer($id) begin');
        Future<void>.delayed(Duration.zero).then((_) {
          context
            ..read(riverpodTestFamilyProvider(id))
            ..read(riverpodTestFamilyStreamProvider(id))
            ..read(riverpodTestFamilyStreamNotifierWatcherProvider(id));
          debugPrint(
              'RiverpodTestCreationWidget: invoked by the timer($id) end');
          debugPrint('-' * 30);
        });
        // id.value++;
      }

      final timer =
          Timer.periodic(const Duration(seconds: 1), (_) => handler());
      return timer.cancel;
    }, []);
    return const SizedBox.shrink();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_testbed/testbed/riverpod_test_providers.dart';

class RiverpodTestCreateFromProviderWidget extends HookWidget {
  const RiverpodTestCreateFromProviderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('-=' * 60);
    debugPrint('RiverpodTestCreateFromProviderWidget: build');
    useProvider(_readStateNotifier);
    useProvider(_watchStateNotifier);
    useProvider(_readNotifier);
    useProvider(_watchNotifier);
    return const SizedBox.shrink();
  }
}

final _watchStateNotifier = Provider.autoDispose<int>((ref) {
  final value = ref.watch(riverpodTestFamilyStateNotifierProvider(0));
  debugPrint('_watchStateNotifier: value = $value');
  ref.onDispose(() => debugPrint('_watchStateNotifier: disposed'));
  return value;
});

final _readStateNotifier = Provider.autoDispose<int>((ref) {
  final value = ref.read(riverpodTestFamilyStateNotifierProvider(1));
  debugPrint('_readStateNotifier: value = $value');
  ref.onDispose(() => debugPrint('_readStateNotifier: disposed'));
  return value;
});

final _watchNotifier = Provider.autoDispose<void>((ref) {
  ref.watch(riverpodTestFamilyStateNotifierProvider(2).notifier);
  ref.onDispose(() => debugPrint('_watchNotifier: disposed'));
});

final _readNotifier = Provider.autoDispose<void>((ref) {
  ref.read(riverpodTestFamilyStateNotifierProvider(3).notifier);
  ref.onDispose(() => debugPrint('_readNotifier: disposed'));
});

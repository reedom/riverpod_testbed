import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_testbed/testbed/controllers/periodic_value_controller.dart';

/// Test whether a Provider can be created while the app is in the background.
final riverpodTestFamilyProvider =
    Provider.family.autoDispose<int, int>((ref, int id) {
  debugPrint('riverpodTestFamilyProvider($id): created');
  ref.onDispose(() => 'riverpodTestFamilyProvider($id): disposed');
  return id;
});

/// Test whether a StreamNotifierProvider can be created while the app is in
/// the background.
///
/// And:
/// - The StateNotifier changes its state 1time/1sec.
/// - The StateNotifier omits new stream value 1time/1sec.
final riverpodTestFamilyStateNotifierProvider = StateNotifierProvider.family
    .autoDispose<PeriodicValueController, int, int>((ref, int id) {
  debugPrint('StateNotifierProvider($id): created');
  final controller = PeriodicValueController(ref.read, '$id')..startTimer();
  ref.onDispose(controller.dispose);
  return controller;
});

/// Test whether a StreamProvider can be created while the app is in
/// the background.
///
/// And also test, as a provider, whether it omits new value as the source
/// stream omits new one (1time/sec)
///
/// And also test as a raw stream handler, whether it receives new stream value
/// from the source.
///  -
final riverpodTestFamilyStreamProvider =
    StreamProvider.family.autoDispose<String, int>((ref, int id) {
  debugPrint('StreamProvider($id): created');
  final stream = ref
      .read(riverpodTestFamilyStateNotifierProvider(id).notifier)
      .valueStream;
  final s = stream.listen((value) {
    debugPrint('StreamProvider($id): stream.listen() handled: $value');
  });
  ref.onDispose(() {
    debugPrint('StreamProvider($id): disposed');
    s.cancel();
  });
  return stream;
});

/// Test whether ref.watch(StateNotifierProvider) works while the app is in
/// the background.
final riverpodTestFamilyStateNotifierWatcherProvider =
    Provider.family.autoDispose<int, int>((ref, int id) {
  final value = ref.watch(riverpodTestFamilyStateNotifierProvider(id));
  debugPrint('StreamNotifierProvider watcher($id): value = $value');

  final subscription = ref
      .read(riverpodTestFamilyStateNotifierProvider(id).notifier)
      .stream
      .listen((state) {
    debugPrint('StreamNotifierProvider($id).stream.listen(): received, '
        'value = $state');
  });

  ref.onDispose(() {
    subscription.cancel();
    debugPrint('StreamNotifierProvider watcher($id): disposed');
  });
  return value;
});

/// Test whether ref.watch(StreamNotifierProvider) works while the app is in
/// the background.
final riverpodTestFamilyStreamNotifierWatcherProvider =
    Provider.family.autoDispose<void, int>((ref, int id) {
  final value = ref.watch(riverpodTestFamilyStreamProvider(id));
  debugPrint('StreamProvider watcher($id): value = $value');
  ref.onDispose(() => debugPrint('StreamProvider watcher($id): disposed'));
});

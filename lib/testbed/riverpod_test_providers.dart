import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    .autoDispose<_StateNotifierController, int, int>((ref, int id) {
  debugPrint('StateNotifierProvider($id): created');
  final controller = _StateNotifierController(id)..startTimer();
  ref.onDispose(() => debugPrint('StateNotifierProvider($id): disposed'));
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

class _StateNotifierController extends StateNotifier<int> {
  _StateNotifierController(int id)
      : _id = '$id',
        super(0);

  final String _id;
  final _streamController = StreamController<String>.broadcast();

  Stream<String> get valueStream => _streamController.stream;

  Timer? _timer;

  @override
  void dispose() {
    debugPrint('_StateNotifierController($_id): disposed');
    _streamController.close();
    cancelTimer();
    super.dispose();
  }

  Future<void> startTimer() async {
    try {
      if (!mounted) {
        debugPrint(
            '_StateNotifierController.startTimer: it\'s been unmounted!');
        return;
      }
      debugPrint('_StateNotifierController($_id): startTimer');
      _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          debugPrint('_StateNotifierController($_id): invoked by the timer '
              'but it\'s been unmounted!');
          return;
        }

        state = state + 1;
        debugPrint('_StateNotifierController($_id): invoked by the timer, '
            'state = $state');
        _streamController.add('stream($_id, $state)');
      });

      await Future<void>.delayed(const Duration(milliseconds: 10));
      debugPrint('_StateNotifierController($_id): async task done');
      if (!mounted) {
        debugPrint('_StateNotifierController($_id): it\'s been unmounted!');
      }
      Future<void>.delayed(Duration.zero).then((_) => 'done');
      // ignore: avoid_catches_without_on_clauses
    } catch (err) {
      debugPrint(
          '_StateNotifierController($_id): startTime cought an exception!');
    }
  }

  void cancelTimer() {
    try {
      debugPrint('_StateNotifierController($_id): timer is cancelled, '
          'state = $state');
      _timer?.cancel();
      _timer = null;
      // ignore: avoid_catches_without_on_clauses
    } catch (err) {
      debugPrint(
          '_StateNotifierController($_id): cancelTime cought an exception!');
    }
  }
}

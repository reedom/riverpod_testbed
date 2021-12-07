import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_testbed/testbed/controllers/provider_state_controller.dart';

/// - The StateNotifier changes its state 1time/1sec.
/// - The StateNotifier omits new stream value 1time/1sec.

final periodicValueProvider = StateNotifierProvider.family
    .autoDispose<PeriodicValueController, int, String>(
        (ref, id) => PeriodicValueController(ref.read, id)..startTimer());

class PeriodicValueController extends StateNotifier<int> {
  PeriodicValueController(this._read, this.id) : super(0) {
    debugPrint('PeriodicValueController($id): created');
    Future.delayed(Duration.zero)
        .then((_) => _read(providerStateProvider(id).notifier).created());
  }

  final Reader _read;
  final String id;
  final _streamController = StreamController<String>.broadcast();

  Stream<String> get valueStream => _streamController.stream;

  Timer? _timer;

  @override
  void dispose() {
    cancelTimer();
    _streamController.close();
    _read(providerStateProvider(id).notifier).disposed();
    debugPrint('PeriodicValueController($id): disposed');
    super.dispose();
  }

  Future<void> startTimer() async {
    try {
      if (!mounted) {
        debugPrint('PeriodicValueController.startTimer: it\'s been unmounted!');
        return;
      }
      debugPrint('PeriodicValueController($id): startTimer');
      _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          debugPrint('PeriodicValueController($id): invoked by the timer '
              'but it\'s been unmounted!');
          return;
        }

        state = state + 1;
        _read(providerStateProvider(id).notifier).updateValue(state);
        debugPrint('PeriodicValueController($id): invoked by the timer, '
            'state = $state');
        _streamController.add('stream($id, $state)');
      });

      await Future<void>.delayed(const Duration(milliseconds: 10));
      debugPrint('PeriodicValueController($id): async task done');
      if (!mounted) {
        debugPrint('PeriodicValueController($id): it\'s been unmounted!');
      }
      Future<void>.delayed(Duration.zero).then((_) => 'done');
      // ignore: avoid_catches_without_on_clauses
    } catch (err) {
      debugPrint(
          'PeriodicValueController($id): startTime cought an exception!');
    }
  }

  void cancelTimer() {
    try {
      debugPrint('PeriodicValueController($id): timer is cancelled, '
          'state = $state');
      _timer?.cancel();
      _timer = null;
      // ignore: avoid_catches_without_on_clauses
    } catch (err) {
      debugPrint(
          'PeriodicValueController($id): cancelTime cought an exception!');
    }
  }
}

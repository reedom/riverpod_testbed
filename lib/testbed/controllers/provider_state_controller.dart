import 'package:hooks_riverpod/hooks_riverpod.dart';

final providerStateProvider = StateNotifierProvider.family
    .autoDispose<ProviderStateController, ProviderState, String>(
        (ref, id) => ProviderStateController(id));

class ProviderStateController extends StateNotifier<ProviderState> {
  ProviderStateController(String id) : super(ProviderState(id: id));

  void updateValue(int value) {
    state = state.copyWith(value: value);
  }

  void created() {
    state = state.copyWith(createdTimes: state.createdTimes + 1);
  }

  void disposed() {
    state = state.copyWith(disposedTimes: state.disposedTimes + 1);
  }

  void gotException() {
    state = state.copyWith(exceptionTimes: state.exceptionTimes + 1);
  }
}

class ProviderState {
  ProviderState({
    required this.id,
    this.value = 0,
    this.createdTimes = 0,
    this.disposedTimes = 0,
    this.exceptionTimes = 0,
  });

  final String id;
  final int value;
  final int createdTimes;
  final int disposedTimes;
  final int exceptionTimes;

  ProviderState copyWith({
    int? value,
    int? createdTimes,
    int? disposedTimes,
    int? exceptionTimes,
  }) {
    return ProviderState(
      id: id,
      value: value ?? this.value,
      createdTimes: createdTimes ?? this.createdTimes,
      disposedTimes: disposedTimes ?? this.disposedTimes,
      exceptionTimes: exceptionTimes ?? this.exceptionTimes,
    );
  }
}

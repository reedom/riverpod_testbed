Flutter/Widget/Riverpodの挙動に関して
=================================

### アプリがバックグラウンドにいる場合

__Flutter/Widget__
- Widget.build()は呼ばれない
- Timerハンドラは呼ばれ続ける
- Streamハンドラは呼ばれ続ける

__Riverpod__
- Providerの中身は呼ばれない
    - watchしているStreamNotifierやStateNotifierの更新も検知しない  
- StateNotifier.stateの読み書きは可能
    - stateの内容は即座に更新される


### アプリがバックグラウンドから復帰した場合

__Flutter/Widget__
- Widget.build()が呼ばれる
    - ただしバックグラウンド中に発生した更新イベントは無視（破棄）されている

__Riverpod__
- Widget.build()を契機に処理が走る
    - ただしバックグラウンド中に発生した更新イベントは無視（破棄）されている


### イベントハンドラ内でProviderを生成した場合

__Provider__
- 生成可能。ただしFlutterの次処理フレームで自動破棄される
- StateNotifierProviderは、自動破棄されるまでは`mount`された状態
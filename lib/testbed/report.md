Flutter/Widget/Riverpodの挙動に関して
=================================

### Provider内から他のProviderを生成

__生成できるか__
- read/watchともに生成可能

__挙動__
- readの場合、Flutterの次処理フレームで自動破棄される
  - StateNotifierProviderは、自動破棄されるまでは`mount`された状態
- watchの場合、生成インスタンスは生き続ける
- state/notifierのどちらを参照しても寿命は一緒

### イベントハンドラ内から他のProviderを生成

__生成できるか__
- read/watchともに生成可能
 
__挙動__
- Flutterの次処理フレームで自動破棄される
- StateNotifierProviderは、自動破棄されるまでは`mount`された状態

### 通常の挙動

__生存管理__
- read(provider)した場合、参照は保持され続けない
  - readした時点で対象インスタンスの生成または参照+1が行われ、実行フレームが終了すると参照-1される 
- watch(provider)した場合、参照は保持され続ける
- watch(stateNotifierProvider.notifier)も、同様に参照は保持され続ける

__変更監視__
- watch(stateNotifierProvider.notifier)した場合、stateが変化しても検知はしない
  - よって`Widget.build`やprovider内処理の再実行は発生しない

### アプリがバックグラウンドにいる場合の挙動

__Flutter/Widget__
- Widget.build()は呼ばれない
- Timerハンドラは呼ばれ続ける
- Streamハンドラは呼ばれ続ける

__Riverpod__
- Providerの中身は呼ばれない
    - watchしているStreamNotifierやStateNotifierの更新も検知しない  
- StateNotifier.stateの読み書きは可能
    - stateの内容は即座に更新される


### アプリがバックグラウンドから復帰した場合の挙動

__Flutter/Widget__
- Widget.build()が呼ばれる
    - ただしバックグラウンド中に発生した更新イベントは無視（破棄）されている

__Riverpod__
- Widget.build()を契機に処理が走る
    - ただしバックグラウンド中に発生した更新イベントは無視（破棄）されている

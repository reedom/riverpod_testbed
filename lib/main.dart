import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_testbed/testbed/riverpod_test_access_widget.dart';
import 'package:riverpod_testbed/testbed/riverpod_test_create_from_provider.dart';
import 'package:riverpod_testbed/testbed/riverpod_test_creation_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod testbed',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Riverpod testbed'),
    );
  }
}

enum TestCase {
  none,
  assessing,
  creation,
  createFromProvider,
}

class MyHomePage extends HookWidget with WidgetsBindingObserver {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final state = useState(TestCase.none);
    final theme = Theme.of(context);
    final activeColor = theme.primaryColor;
    final inactiveColor = theme.primaryColorLight;

    useEffect(() {
      WidgetsBinding.instance!.addObserver(this);
      return () => WidgetsBinding.instance!.removeObserver(this);
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ProviderScope(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => state.value = TestCase.none,
                child: Text('STOP',
                    style: TextStyle(
                        color: state.value == TestCase.none
                            ? theme.errorColor
                            : theme.errorColor.withAlpha(40))),
              ),
              SizedBox(width: 20),
              OutlinedButton(
                onPressed: () => state.value = TestCase.assessing,
                child: Text('accessing',
                    style: TextStyle(
                        color: state.value == TestCase.assessing
                            ? activeColor
                            : inactiveColor)),
              ),
              SizedBox(width: 20),
              OutlinedButton(
                onPressed: () => state.value = TestCase.creation,
                child: Text('creation',
                    style: TextStyle(
                        color: state.value == TestCase.creation
                            ? activeColor
                            : inactiveColor)),
              ),
              SizedBox(width: 20),
              OutlinedButton(
                onPressed: () => state.value = TestCase.createFromProvider,
                child: Text('create from provider',
                    style: TextStyle(
                        color: state.value == TestCase.createFromProvider
                            ? activeColor
                            : inactiveColor)),
              ),
              if (state.value == TestCase.assessing)
                RiverpodTestAccessWidget()
              else if (state.value == TestCase.creation)
                RiverpodTestCreationWidget()
              else if (state.value == TestCase.createFromProvider)
                RiverpodTestCreateFromProviderWidget()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('[resumed]');
        break;
      case AppLifecycleState.inactive:
        debugPrint('[inactive]');
        break;
      case AppLifecycleState.paused:
        debugPrint('[paused]');
        break;
      case AppLifecycleState.detached:
        debugPrint('[detached]');
        break;
    }
  }
}

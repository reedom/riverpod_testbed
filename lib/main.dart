import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_testbed/testbed/create_in_provider.dart';
import 'package:riverpod_testbed/testbed/create_in_widget.dart';
import 'package:riverpod_testbed/testbed/widgets/menu.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
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
      body: Center(
        child: ListView(
          children: [
            Menu(
              'Create providers in a Widget',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateInWidgetPage(),
                ),
              ),
            ),
            Menu(
              'Create providers in providers',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateInProviderPage(),
                ),
              ),
            ),
          ],
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

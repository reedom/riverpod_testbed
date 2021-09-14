import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_testbed/testbed/riverpod_test_access_widget.dart';
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

class MyHomePage extends HookWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final state = useState(true);
    final theme = Theme.of(context);
    final activeColor = theme.primaryColor;
    final inactiveColor = theme.primaryColorLight;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ProviderScope(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => state.value = true,
                    child: Text('Test accessing',
                        style: TextStyle(
                            color: state.value ? activeColor : inactiveColor)),
                  ),
                  SizedBox(width: 20),
                  OutlinedButton(
                    onPressed: () => state.value = false,
                    child: Text('Test creation',
                        style: TextStyle(
                            color: !state.value ? activeColor : inactiveColor)),
                  ),
                ],
              ),
              if (state.value)
                RiverpodTestAccessWidget()
              else
                RiverpodTestCreationWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

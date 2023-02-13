import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:libsu_flutter/libsu_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _shell = Shell.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _shell.getPlatformVersion() ?? 'Unknown platform version';

      await _shell.configure(mountMaster: false, debug: true);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('libsu_flutter example'),
        ),
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text('Running on: $_platformVersion\n')),
                ElevatedButton(
                  onPressed: () async {
                    snackbar(bool? res) => showSnackbar(
                        context, 'isAppGrantedRoot: ${res.toString()}');
                    final res = await _shell.isAppGrantedRoot();
                    snackbar(res);
                  },
                  child: const Text('isAppGrantedRoot'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    snackbar(String res) =>
                        showSnackbar(context, 'createShell: ${res.toString()}');
                    final res = await _shell.createShell();
                    snackbar(res.toString());
                  },
                  child: const Text('createShell'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    snackbar(ShellStatus? res) => showSnackbar(
                        context, 'getShellStatus: ${res.toString()}');
                    final res = await _shell.getShellStatus();
                    snackbar(res);
                  },
                  child: const Text('getShellStatus'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    snackbar(String? res) => showSnackbar(
                        context, 'waitForeverAndClose: ${res.toString()}');
                    await _shell.waitForeverAndClose();
                    snackbar('Closed');
                  },
                  child: const Text('waitForeverAndClose'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    snackbar(bool? res) => showSnackbar(
                        context, 'waitAndClose: ${res.toString()}');
                    final res =
                        await _shell.waitAndClose(const Duration(seconds: 10));
                    snackbar(res);
                  },
                  child: const Text('waitAndClose'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    snackbar(String? res) =>
                        showSnackbar(context, 'close: ${res.toString()}');
                    final res = await _shell.close();
                    snackbar('Closed');
                  },
                  child: const Text('close'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

void showSnackbar(BuildContext context, String data) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(data)));

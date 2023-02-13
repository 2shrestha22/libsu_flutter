import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:libsu_flutter/pigeon.dart';

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
  final _libSuApi = LibSuApi();

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
          await _libSuApi.getPlatformVersion() ?? 'Unknown platform version';
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
          title: const Text('Plugin example app'),
        ),
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Running on: $_platformVersion\n'),
                TextButton(
                  onPressed: () async {
                    snackbar(bool? res) =>
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Root Grant Status: ${res.toString()}'),
                          ),
                        );
                    final res = await _libSuApi.isAppGrantedRoot();
                    snackbar(res);
                  },
                  child: const Text('Check root permission'),
                ),
                TextButton(
                  onPressed: () async {
                    snackbar(int res) =>
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Shell Status: ${res.toString()}'),
                          ),
                        );
                    final res = await _libSuApi.createShell();
                    snackbar(res);
                  },
                  child: const Text('Create a Shell.'),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

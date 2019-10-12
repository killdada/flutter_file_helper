import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_file_helper/flutter_file_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    print('-------------------------------');
    print(await FileHelper.getApplicationDocumentsDirectory());
    print(await FileHelper.getTemporaryDirectory());
    print(await FileHelper.getExternalStorageDirectory());
    print(await FileHelper.getAvailableSize());
    print(await FileHelper.getTotalSize());
    print(await FileHelper.mkdirs(
        '${(await FileHelper.getExternalStorageDirectory()).path}/aaaa_aaaa_test'));

    // Platform messages may fail, so we use a try/catch PlatformException.

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
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}

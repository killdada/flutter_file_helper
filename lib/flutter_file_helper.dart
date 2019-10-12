// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library flutter_file_helper;

import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('plugins.mysoft/file_helper');

class FileHelper {
  FileHelper._();

  static Future<Directory> getTemporaryDirectory() async {
    final String path = await _channel.invokeMethod('getTemporaryDirectory');
    if (path == null) {
      return null;
    }
    return Directory(path);
  }

  static Future<Directory> getApplicationDocumentsDirectory() async {
    final String path =
        await _channel.invokeMethod('getApplicationDocumentsDirectory');
    if (path == null) {
      return null;
    }
    return Directory(path);
  }

  static Future<Directory> getExternalStorageDirectory() async {
    if (Platform.isIOS)
      throw UnsupportedError("Functionality not available on iOS");
    final String path = await _channel.invokeMethod('getStorageDirectory');
    if (path == null) {
      return null;
    }
    return Directory(path);
  }

  static Future<bool> mkdirs(String path) async {
    assert(path != null);
    return await _channel.invokeMethod('mkdirs', path);
  }

  /// byte
  static Future<double> getAvailableSize() async {
    return await _channel.invokeMethod('getAvailableSize');
  }

  /// byte
  static Future<double> getTotalSize() async {
    return await _channel.invokeMethod('getTotalSize');
  }
}

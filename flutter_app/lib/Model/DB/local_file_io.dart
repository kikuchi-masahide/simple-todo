import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

mixin LocalFileIO {
  ///ディレクトリからのパスで指定したファイルの内容を読み込む
  Future<dynamic> readFile(String filepath) async {
    final File file = await _getFile(filepath);
    final fileStr = file.readAsStringSync();
    return jsonDecode(fileStr);
  }

  ///ディレクトリからのパスで指定したファイルにオブジェクトのJSONエンコードを書き込む
  Future<void> writeFile(String filepath, dynamic obj) async {
    final File file = await _getFile(filepath);
    file.writeAsStringSync(jsonEncode(obj));
    return;
  }

  ///ディレクトリからのパスで指定したファイルのオブジェクトFILEを作成
  Future<File> _getFile(String filepath) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$filepath');
    return file;
  }
}

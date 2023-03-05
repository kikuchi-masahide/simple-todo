import 'package:flutter_app/model/db/db_proxy.dart';
import 'package:flutter_app/model/types/Task.dart';

/**
 * 単一のトークンに対するデータ処理
 */
class TaskDataService {
  String _token;
  final DBProxy _dbProxy;
  List<Task> _tasks;

  TaskDataService(this._token, this._dbProxy) : _tasks = [];

  Future<void> initTasks() async {
    //test
    await new Future.delayed(Duration(seconds: 3));
    _tasks = await _dbProxy.getAllTasks(_token);
  }

  List<Task> getReadonlyTasksList() {
    return _tasks.map((e) => e).toList();
  }
}

import 'package:flutter_app/Model/DB/db_proxy.dart';

class LocalDB extends DBProxy
{
  LocalDB();
  @override
  String name()
  {
    return 'LocalDB';
  }
}
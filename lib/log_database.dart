import 'package:hive_flutter/hive_flutter.dart';

class LogDatabase {
  final _user = Hive.box('user');
  List user = [];
  void loadData() {
    user = _user.get('user');
  }

  void updateData() {
    _user.put('USER', user);
  }

  void deleteData() {
    _user.delete('USER');
  }
}

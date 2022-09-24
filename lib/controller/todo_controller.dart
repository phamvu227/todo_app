import 'package:flutter/material.dart';

import '../models/todo_model.dart';

class TodoController with ChangeNotifier {
  final List<TodoModel?> _allItem = [];

  List<TodoModel?> get allItem => [..._allItem];

  void addItem(TodoModel item) {
    _allItem.add(item);
    notifyListeners();
  }

  removeItem(String id) {
    _allItem.removeWhere((element) => element!.id == id);
    notifyListeners();
  }
}
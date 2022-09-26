import 'package:flutter/material.dart';

import '../models/todo_model.dart';

class TodoController with ChangeNotifier {
  final List<TodoModel> _allItem = [];

  List<TodoModel> get allItem => [..._allItem];

  void addItem(TodoModel item) {
    _allItem.add(item);
    notifyListeners();
  }

  void editItem(TodoModel editTodo, int id) {
    _allItem[id] = editTodo;
    notifyListeners();
  }

  removeItem(int id) {
    _allItem.removeAt(id);
    notifyListeners();
  }

  sortAZ() {
    _allItem.sort((a, z) {
      return a.title!.compareTo(z.title!);
    });
    notifyListeners();
  }


}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/screens/search_screen.dart';

import '../controller/todo_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _desController = TextEditingController();

  TodoController get _watchTodoController => context.watch<TodoController>();
  TodoController get _readTodoController => context.read<TodoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: Search(),
                );
              },
              icon: Icon(Icons.search)),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('A -> Z'),
                value: _readTodoController.sortAZ(),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: _watchTodoController.allItem.length,
          itemBuilder: (BuildContext context, int index) => Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListTile(
                      title: Text(
                        'Title ' + _watchTodoController.allItem[index].title!,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        'Description: ' +
                            _watchTodoController.allItem[index].des!,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              editItemDialog(
                                  Provider.of<TodoController>(context,
                                          listen: false)
                                      .allItem
                                      .elementAt(index),
                                  index);
                              print('Edit');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteItemDialog(context, index);
                            },
                          ),
                        ],
                      )),
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: addItemDialog,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void addItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TodoController _controller =
            Provider.of<TodoController>(context, listen: false);

        return AlertDialog(
          title: const Text('Add Item'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'title is required';
                      }
                      return null;
                    },
                    controller: _titleController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'description is required';
                      }
                      return null;
                    },
                    controller: _desController,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'.toUpperCase()),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _controller.addItem(TodoModel(
                      title: _titleController.text, des: _desController.text));
                  print(_controller.allItem.length);
                  _titleController.clear();
                  _desController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text('OK'.toUpperCase()),
            ),
          ],
        );
      },
    );
  }

  editItemDialog(TodoModel? todoModel, int? id) {
    if (todoModel != null) {
      _titleController.text = todoModel.title!;
      _desController.text = todoModel.des!;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Item'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'title is required';
                        }
                        return null;
                      },
                      controller: _titleController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'description is required';
                        }
                        return null;
                      },
                      controller: _desController,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'.toUpperCase()),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (todoModel != null) {
                      context.read<TodoController>().editItem(
                          TodoModel(
                            title: _titleController.text,
                            des: _desController.text,
                          ),
                          id!);
                    }
                    _titleController.clear();
                    _desController.clear();
                    Navigator.pop(context);
                  }
                },
                child: Text('OK'.toUpperCase()),
              ),
            ],
          );
        });
  }

  deleteItemDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete"),
          content: Text("Are you sure you want to delete?"),
          actions: <Widget>[
            TextButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.pop(context);
                _readTodoController.removeItem(index);
                print("Delete");
              },
            ),
          ],
        );
      },
    );
  }
}

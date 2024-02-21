import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

class TaskTile extends StatelessWidget {
  TaskTile({required this.taskModel});

  final TaskModel taskModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: Image.network(taskModel.image ?? '', fit: BoxFit.cover),
          title: Text(taskModel.title ?? ''),
          subtitle: Text(taskModel.desc ?? ''),
        ),
      ),
    );
  }
}

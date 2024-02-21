import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/firestore_db.dart';
import 'package:todo_app/ui/home/widgets/task_tile.dart';
import 'package:todo_app/ui/home/widgets/task_update.dart';

class TaskList extends StatefulWidget {
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<List<TaskModel>?>(context) ?? [];
    FirestoreServiceDb db = FirestoreServiceDb();

    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Slidable(
              endActionPane: ActionPane(
                motion: DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (v) async {
                      await db.deleteTask(
                          uid: tasks[index].id!, imageUrl: tasks[index].image!);
                      setState(() {});
                    },
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                  SlidableAction(
                    onPressed: (v) async {
                       showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.white),
                              child: Container(
                                height: 800,
                                  width: double.infinity,
                                  margin: EdgeInsets.all(20),
                                  child: TaskUpdate(
                                    taskModel: tasks[index],
                                  )),
                            );
                          });
                    },
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                ],
              ),
              child: TaskTile(taskModel: tasks[index]));
        });
  }
}

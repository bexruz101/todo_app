import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/firestore_db.dart';
import 'package:todo_app/ui/home/widgets/task_adding_panel.dart';
import 'package:todo_app/ui/home/widgets/task_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    _showAddingPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.white),
              child: Container(
                  height: 800,
                  width: double.infinity,
                  margin:const EdgeInsets.all(20),
                  child: TaskAdd(),),
            );
          });
    }

    return StreamProvider<List<TaskModel>>.value(
      value: FirestoreServiceDb().tasks,
      initialData:const [],
      child: Scaffold(
          drawer: Drawer(
            child: TextButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.logout),
                label: Text('LogOut')),
          ),
          appBar: AppBar(
            title: Text(
              'TO DO LIST',
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500),
            ),
            centerTitle: true,
            actions: [
              TextButton(
                  onPressed: () {
                    _showAddingPanel();
                  },
                  child: Icon(
                    Icons.add,
                  )),
            ],
          ),
          body: Container(
            child: TaskList(),
          )),
    );
  }
}

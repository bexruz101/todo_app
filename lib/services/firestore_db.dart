import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:todo_app/models/task.dart';

class FirestoreServiceDb {
  final CollectionReference todoCollection =
      FirebaseFirestore.instance.collection('tasks');

  List<TaskModel> _taskListSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return TaskModel(
        id: e.get('id'),
          title: e.get('title'),
          desc: e.get('desc'),
        image: e.get('image'),
          );
    }).toList();
  }

  Stream<List<TaskModel>> get tasks {
    return todoCollection.snapshots().map(_taskListSnapshots);
  }

  Future addTask({required TaskModel taskModel}) async {
    try {
     DocumentReference first = await todoCollection.add(taskModel.toMap());
     TaskModel taskUpdatedModel = taskModel.copyWith(id: first.id.toString());
     return  await todoCollection.doc(first.id).update(taskUpdatedModel.toMap());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future updateTask({required TaskModel taskModel,}) async {
    try {
      return await todoCollection.doc(taskModel.id).update(taskModel.toMap());
    } catch (e) {
      print(e);
      return null;
    }
  }

  
  Future deleteTask({required String uid,required String imageUrl}) async {
    Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
    try {
      await imageRef.delete();
      var result =  await todoCollection.doc(uid).delete();
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

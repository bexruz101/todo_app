import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/firestore_db.dart';
import 'package:todo_app/services/upload_service.dart';
import 'package:todo_app/ui/auth/pages/widgets/input.dart';
import 'package:todo_app/utils/loading.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Model extends ChangeNotifier {
  TaskModel taskModel = TaskModel();
}

class TaskAdd extends StatefulWidget {
  @override
  createState() => _TaskAddState();

  void addImage() async {
    
  }
}

class _TaskAddState extends State<TaskAdd> {
  final _formKey = GlobalKey<FormState>();
  TaskModel taskModel = TaskModel();
  ImagePicker imagePicker = ImagePicker();
  FileUploader fileUploader = FileUploader();
  String? imageUrl;
  String error = '';
  bool loading = false;

  void addImage() async {
    XFile? file = await _selectedType(context);
    setState(() => loading = true);
    if (file != null) {
      String? image = await fileUploader.imageUploader(file);
      if (image != null) {
        taskModel.image = image;
        setState(() => loading = false);
      }
    } else {
      print('ERRRORRR IMAGE:${file}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Provider.value(
            value: this,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Title',
                        hintStyle: const TextStyle(color: Colors.grey)),
                    validator: (v) => v!.isEmpty ? 'Enter title' : null,
                    onChanged: (v) => setState(() => taskModel.title = v),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLines: 5,
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Description',
                        hintStyle: TextStyle(color: Colors.grey)),
                    validator: (v) => v!.isEmpty ? 'Enter description' : null,
                    onChanged: (v) => setState(() => taskModel.desc = v),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 50,
                      width: 220,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.cyan),
                      child: ZoomTapAnimation(
                        onTap: () async {
                          context.read();
                        },
                        child: const Center(
                          child: Text(
                            'Take Image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 55,
                    width: 250,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.teal.withOpacity(0.6)),
                    child: ZoomTapAnimation(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (taskModel.image != null) {
                            await FirestoreServiceDb()
                                .addTask(taskModel: taskModel);
                            Navigator.pop(context);
                          } else {
                            error = 'PLease Select Image';
                          }
                        }
                      },
                      child: const Center(
                        child: Text(
                          'Add Task',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  _selectedType(BuildContext context) async {
    XFile? selectedFile;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(
                children: [
                  TextButton.icon(
                      onPressed: () async {
                        selectedFile = await imagePicker.pickImage(
                            source: ImageSource.camera);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.camera_alt_outlined),
                      label: const Text('Camera')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton.icon(
                      onPressed: () async {
                        selectedFile = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.photo),
                      label: const Text('Gallery')),
                ],
              ),
            ),
          );
        });
    return selectedFile;
  }
}

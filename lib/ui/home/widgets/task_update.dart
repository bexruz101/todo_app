import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/firestore_db.dart';
import 'package:todo_app/services/upload_service.dart';
import 'package:todo_app/ui/auth/pages/widgets/input.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class TaskUpdate extends StatefulWidget {
  final TaskModel taskModel;
  TaskUpdate({required this.taskModel});
  @override
  createState() => _TaskAddState();
}

class _TaskAddState extends State<TaskUpdate> {
  final _formKey = GlobalKey<FormState>();
  ImagePicker imagePicker = ImagePicker();
  FileUploader fileUploader = FileUploader();
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: widget.taskModel.title,
            decoration: textInputDecoration.copyWith(hintText: 'Title',hintStyle: const TextStyle(color: Colors.grey)),
            validator: (v) => v!.isEmpty ? 'Enter title' : null,
            onChanged: (v) => setState(() => widget.taskModel.title = v),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            maxLines: 5,
            initialValue: widget.taskModel.desc,
            decoration: textInputDecoration.copyWith(hintText: 'Description',hintStyle: const TextStyle(color: Colors.grey)),
            validator: (v) => v!.isEmpty ? 'Enter description' : null,
            onChanged: (v) => setState(() =>widget.taskModel.desc = v),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 50,
              width: 220,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.cyan),
              child: ZoomTapAnimation(
                onTap: () async {
                  XFile? file = await _selectedType(context);
                  if (file != null) {
                    String? imageUrl = await fileUploader.updateImage(url: widget.taskModel.image!, file: file);
                    if(imageUrl != null){
                      widget.taskModel.image =  imageUrl;
                    } else {
                      print('ERRRORRR IMAGE:${file}');
                    }
                  }
                },
                child: const Center(
                  child: Text(
                    'Take Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
          SizedBox(
            height: 40,
          ),
          Container(
              height: 55,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.teal),
              child: ZoomTapAnimation(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.taskModel.image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select an image')));
                    } else {
                      await FirestoreServiceDb().updateTask(taskModel: widget.taskModel);
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Center(
                  child: Text(
                    'Update Task',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
        ],
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


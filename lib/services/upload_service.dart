import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FileUploader{
 Reference storageRoot = FirebaseStorage.instance.ref();
 String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();


 Future<String?> imageUploader(XFile? imageFile)async{
    Reference storageDirImage = storageRoot.child('images');
    Reference refImagetoUpload = storageDirImage.child(uniqueFileName);
    try{
     await refImagetoUpload.putFile(File(imageFile!.path));
     String downloadUrl = await refImagetoUpload.getDownloadURL();
     return downloadUrl;
    }catch(e){
      print('Image Upload ERROR:${e}');
      return null;
    }
  }

 Future  updateImage({required String url,required XFile? file})async{
   Reference referenceImageUpload = FirebaseStorage.instance.refFromURL(url);
   try{
     await referenceImageUpload.putFile(File(file!.path));
     String imageUrl = await referenceImageUpload.getDownloadURL();
     return imageUrl;
   }catch(e){
     print('UPDATE IMAGE ERROR:${e}');
     return null;
   }
 }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SubBoxPage extends StatefulWidget {
  const SubBoxPage({super.key});

  @override
  State<SubBoxPage> createState() => _SubBoxPageState();
}

class _SubBoxPageState extends State<SubBoxPage> {
  File? image;

  void getImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void getImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void getImageFromStorage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return;
      File image = File(result.files.first.name);
      setState(() => this.image = image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void uploadImage() async {
    try {
      if (image == null) return;
      final ref = FirebaseStorage.instance.ref('subpics');
      await ref.putFile(image!);
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SubBoxPage'),
        ),
        body: Center(
          child: Column(children: [
            MaterialButton(
                color: Colors.blue,
                child: Text('Pick Image From Gallery'),
                onPressed: () => getImageFromGallery()),
            MaterialButton(
                color: Colors.blue,
                child: Text('Pick Image From Camera'),
                onPressed: () => getImageFromCamera()),
            MaterialButton(
                color: Colors.blue,
                child: Text('Pick Image From Storage'),
                onPressed: () => getImageFromStorage()),
            MaterialButton(
                color: Colors.blue,
                child: Text('Upload Image'),
                onPressed: () => uploadImage()),
          ]),
        ));
  }
}

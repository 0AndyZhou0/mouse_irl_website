import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SubBoxPage extends StatefulWidget {
  const SubBoxPage({super.key});

  @override
  State<SubBoxPage> createState() => _SubBoxPageState();
}

class _SubBoxPageState extends State<SubBoxPage> {
  XFile? image;
  String imageUrl = '';
  var logger = Logger();

  void getImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() => this.image = image);
    } on PlatformException catch (e) {
      logger.log(Level.error, 'Failed to pick image: $e');
    }
  }

  void getImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      setState(() => this.image = image);
    } on PlatformException catch (e) {
      logger.log(Level.error, 'Failed to pick image: $e');
    }
  }

  void uploadImage() async {
    try {
      if (image == null) return;

      final ref = FirebaseStorage.instance.ref('subpics');

      Reference imageRef =
          ref.child(DateTime.now().millisecondsSinceEpoch.toString());

      // TODO: Make upload to users subfolder
      if (kIsWeb) {
        logger.log(Level.debug, image!.mimeType);
        await imageRef.putData(
            await image!.readAsBytes(),
            SettableMetadata(
              contentType: image!.mimeType,
            ));
      } else {
        imageRef.putFile(File(image!.path));
      }
      // imageUrl = await imageRef.getDownloadURL();
    } on FirebaseException catch (e) {
      logger.log(Level.error, e);
    } catch (e) {
      logger.log(Level.error, e);
    }
  }

  Widget showImage() {
    if (image != null) {
      if (kIsWeb) {
        return Image.network(image!.path);
      } else {
        return Image.file(File(image!.path));
      }
    }
    return const Center(
      child: Text('Select an Image'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SubBoxPage'),
        ),
        body: Center(
          child: ListView(children: [
            MaterialButton(
                color: Colors.blue,
                child: const Text('Pick Image From Gallery'),
                onPressed: () => getImageFromGallery()),
            if (!kIsWeb)
              MaterialButton(
                  color: Colors.blue,
                  child: const Text('Pick Image From Camera'),
                  onPressed: () => getImageFromCamera()),
            // MaterialButton(
            //     color: Colors.blue,
            //     child: Text('Pick Image From Storage'),
            //     onPressed: () => getImageFromStorage()),
            MaterialButton(
                color: Colors.blue,
                child: const Text('Upload Image'),
                onPressed: () => uploadImage()),
            showImage(),
          ]),
        ));
  }
}

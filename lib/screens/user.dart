import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mouse_irl_website/auth.dart';
import 'package:mouse_irl_website/database.dart';
import 'package:mouse_irl_website/screens/admin_event.dart';
import 'package:mouse_irl_website/screens/admin_time.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';

// TODO: merge user page with home page
// Profile goes in the corner
// Edit buttons directly on voting boxes

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _logger = Logger('UserPage');

  final User? user = Auth().currentUser;

  Widget _userEmail() {
    return Text(user?.email ?? '');
  }

  Widget _userProfilePicture() {
    return CircleAvatar(
      radius: 20,
      backgroundImage: NetworkImage(user?.photoURL ?? ''),
    );
  }

  Widget _userName() {
    return Text(user?.displayName ?? '');
  }

  Widget _userProfileEditButton() {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final TextEditingController controller = TextEditingController();
            XFile? profilePic;
            final ImagePicker picker = ImagePicker();
            String? imageUrl;

            return StatefulBuilder(
              builder: (context, setState) {
                Future pickImage() async {
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 200,
                    maxHeight: 200,
                  );
                  if (image != null) {
                    setState(() {
                      profilePic = image;
                    });
                  }
                }

                Future uploadPic() async {
                  if (profilePic != null) {
                    String fileName = user!.uid;
                    Reference ref = FirebaseStorage.instance
                        .ref()
                        .child("profiles/$fileName");
                    try {
                      TaskSnapshot taskSnapshot;
                      if (kIsWeb) {
                        taskSnapshot = await ref.putData(
                          await profilePic!.readAsBytes(),
                          SettableMetadata(
                            contentType: profilePic!.mimeType,
                          ),
                        );
                      } else {
                        taskSnapshot =
                            await ref.putFile(File(profilePic!.path));
                      }
                      imageUrl = await taskSnapshot.ref.getDownloadURL();
                      Auth().updateUserProfilePic(imageUrl!);
                      _logger.finer('Uploaded profile picture: $imageUrl');
                    } catch (e) {
                      _logger.severe('Error occurred while uploading file: $e');
                    }
                  }
                }

                Widget profilePreview() {
                  if (profilePic != null) {
                    if (kIsWeb) {
                      return CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(profilePic!.path),
                      );
                    } else {
                      return CircleAvatar(
                        radius: 15,
                        backgroundImage: FileImage(File(profilePic!.path)),
                      );
                    }
                  }
                  return const Text('Select Image');
                }

                return AlertDialog(
                  title: const Text('Edit Profile'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        decoration: const InputDecoration(
                            hintText: "Enter new username"),
                        controller: controller,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              pickImage();
                            },
                            child: const Text('Pick Image'),
                          ),
                          const SizedBox(width: 16),
                          Center(
                            child: profilePreview(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        uploadPic();
                        Auth().updateUserName(controller.text);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Update'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      icon: const Icon(Icons.edit),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }

  Widget _userSignOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        Auth().signOut();
      },
      child: const Text('Sign Out'),
    );
  }

  Widget _adminEventsPageButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EventsAdminPage()),
        );
      },
      child: const Text('Edit Events'),
    );
  }

  Widget _adminTimesPageButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TimesAdminPage()),
        );
      },
      child: const Text('Edit Times'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _userProfilePicture(),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _userName(),
                        _userEmail(),
                      ],
                    ),
                    _userProfileEditButton(),
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                  future: Database().isAdmin(user!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data == true) {
                      return Column(children: [
                        _adminEventsPageButton(),
                        const SizedBox(height: 20),
                        _adminTimesPageButton(),
                      ]);
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  initialData: const Text('Loading :3'),
                ),
                const SizedBox(height: 20),
                _userSignOutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wasteagram/widgets/homepage.dart';
import 'package:wasteagram/widgets/new_entry.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/detail-screen';

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File image;
  final picker = ImagePicker();

  Future getImage() async {
    String unique = DateTime.now().toString();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      // setting state outside this conditional breaks app if user hits cancel
      StorageReference storageRef =
          FirebaseStorage.instance.ref().child('$unique');
      StorageUploadTask uploadTask = storageRef.putFile(image);
      await uploadTask.onComplete;
      final purl = await storageRef.getDownloadURL();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NewEntry(url: purl)));
    } else {
      // handle case of user not selecting a photo
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        accentColor: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: Semantics(
            button: true,
            enabled: true,
            onTapHint: 'Go back to homepage.',
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Text('Choose Photo'),
        ),
        // database takes a while to load so we should have a loading circle
        // before page redirects to NewEntry()
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

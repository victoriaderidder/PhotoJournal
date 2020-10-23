import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:PhotoJournal/widgets/homepage.dart';
import 'package:PhotoJournal/models/posts.dart';
import 'package:flutter/services.dart';

class NewEntry extends StatefulWidget {
  String url;
  NewEntry({Key key, this.url}) : super(key: key);
  static const routeName = '/new-entry';

  @override
  _NewEntryState createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  LocationData locationData;
  final formKey = GlobalKey<FormState>();
  Post post = Post();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    setState(() {});
  }

  Widget build(BuildContext context) {
    if (locationData == null) {
      return Center(child: CircularProgressIndicator());
    } else {
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
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                ),
              ),
            ),
            title: Text('New Entry'),
          ),
          body: Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                // this is here so I don't get pixel overflows when using
                // the keyboard (cmd + k to show it on iOS emulator)
                child: Column(
                  children: [
                    Container(
                        height: 350.0,
                        width: 350.0,
                        child: Image.network(widget.url)),
                    Container(
                      width: 300.0,
                      margin: const EdgeInsets.only(bottom: 25.0),
                      child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 20.0,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Give your photo a brief title"),
                          validator: (value) =>
                              value.isEmpty ? "Title cannot be blank" : null,
                          onSaved: (value) {
                            post.title = value;
                          }),
                    ),
                    Container(
                      width: 300.0,
                      margin: const EdgeInsets.only(bottom: 25.0),
                      child: TextFormField(
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 20.0,
                          ),
                          decoration: new InputDecoration(
                              labelText: "What's this photo's story?"),
                          validator: (value) =>
                              value.isEmpty ? "Story cannot be blank" : null,
                          onSaved: (value) {
                            post.story = value;
                          }),
                    ),
                    Semantics(
                      button: true,
                      enabled: true,
                      onTapHint: 'Upload post to database',
                      child: RaisedButton(
                          color: Colors.blueGrey,
                          child: Text('Upload'),
                          onPressed: () async {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              addPostData();
                              Firestore.instance
                                  .collection('posts')
                                  .document()
                                  .setData({
                                'story': post.story,
                                'title': post.title,
                                'date': post.date,
                                'latitude': post.latitude,
                                'longitude': post.longitude,
                                'imageURL': post.imageURL,
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()));
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  void addPostData() {
    post.latitude = locationData.latitude;
    post.longitude = locationData.longitude;
    post.date = DateTime.now();
    post.imageURL = widget.url;
  }
}

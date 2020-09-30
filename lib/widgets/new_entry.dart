import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:wasteagram/widgets/homepage.dart';
import 'package:wasteagram/models/posts.dart';

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
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 20.0,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Number of items wasted"),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          validator: (value) =>
                              value.isEmpty ? "Quantity cannot be blank" : null,
                          onSaved: (value) {
                            post.quantity = int.parse(value);
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
                                'quantity': post.quantity,
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

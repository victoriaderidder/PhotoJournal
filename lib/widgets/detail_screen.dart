import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  static const routeName = '/detail-screen';
  DocumentSnapshot document;
  DetailScreen({Key key, this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // get date from database & format it in advance
    DateTime displayDate = document['date'].toDate();
    String formattedDate = DateFormat('EEEE, MMM d, y').format(displayDate);
    return MaterialApp(
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blueGrey,
          accentColor: Colors.amber,
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
            title: Text(document['title'].toString()),
          ),
          body: Center(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              Container(
                  // get some spacing for my date
                  margin: const EdgeInsets.only(top: 25.0),
                  child: Text(formattedDate.toString(),
                      style: TextStyle(fontSize: 25.0))),
              Container(
                  // spacing for lat & long
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text('Location: (' +
                      document['latitude'].toString() +
                      ', ' +
                      document['longitude'].toString() +
                      ')')),
              Container(
                  // image fits just within vertical screen
                  height: 350.0,
                  width: 350.0,
                  child: Image.network(document['imageURL'])),
              // just didn't feel like I needed spacing for this
              Text(document['story'].toString(),
                  style: TextStyle(fontSize: 18.0)),
            ],
          ))),
        ));
  }
}

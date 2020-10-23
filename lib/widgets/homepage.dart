import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PhotoJournal/widgets/detail_screen.dart';
import 'package:PhotoJournal/widgets/camera_screen.dart';

class MyHomePage extends StatelessWidget {
  static const routeName = '/homepage';
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    //DateTime now = document['date'].toDate();
    return Semantics(
        button: true,
        enabled: true,
        onTapHint: 'Visit post\'s detail screen.',
        child: new Card(
          // this makes my entries distinct
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    document['title'].toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailScreen(document: document)),
              );
            },
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // following line stops back button from appearing on homepage,
          // which I don't want
          automaticallyImplyLeading: false,
          title: StreamBuilder(
              stream: Firestore.instance.collection('posts').snapshots(),
              builder: (context, snapshot) {
                return Text('PhotoJournal');
              })),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('posts')
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data.documents != null &&
                snapshot.data.documents.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data.documents[index]),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: Semantics(
          button: true,
          enabled: true,
          onTapHint: 'New Post Button. Requests Photo permissions.',
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraScreen()),
              );
            },
            child: Icon(Icons.photo_camera),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

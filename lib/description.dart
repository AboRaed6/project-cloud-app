import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Description extends StatefulWidget {
  const Description();

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final userRef = FirebaseFirestore.instance.collection('video-desc');
  String videoUrl = "";
  String desc = '';

  getData() async {
    userRef.get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        print(doc.data());
        print(doc.id);
        setState(() {
          var data = doc.data();
          videoUrl = data['video'];
          desc = data['desc'];
          print(desc);
        });
      });
    });
  }

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=B4xLDrD8Ftw"),
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            'معلومات عن القدس',
            style: TextStyle(
                fontSize: 25,
                color: Colors.orange,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              desc,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}

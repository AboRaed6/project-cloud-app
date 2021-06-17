import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_app/detalsePost.dart';

import 'createPoct.dart';

class HomeTap extends StatefulWidget {
  const HomeTap();
  @override
  _HomeTapState createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> {
  FirebaseFirestore query;

  @override
  void initState() {
    query = FirebaseFirestore.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sizeHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: query.collection('posts').snapshots(),
          builder: (context, stream) {
            if (stream.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (stream.hasError) {
              return Center(child: Text(stream.error.toString()));
            }

            QuerySnapshot querySnapshot = stream.data;

            return ListView.builder(
              itemCount: querySnapshot?.size,
              itemBuilder: (context, index) =>
                  itempost(sizeHeight, index, querySnapshot),
            );
          },
        ),
        Positioned(
          bottom: 3,
          right: 3,
          child: Container(
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.orange,
            ),
            child: FlatButton.icon(
              label: Text("اضافة منشور",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: Colors.white)),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AddnewPost())),
            ),
          ),
        ),
      ],
    );
  }

  Container itempost(
      double sizeHeight, int index, QuerySnapshot querySnapshot) {
    return Container(
        child: Column(
      children: [
        GestureDetector(
          child: Container(
            margin: EdgeInsets.all(10),
            height: sizeHeight / 2.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(17)),
              color: Colors.amber,
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Image.network(
                  '${querySnapshot.docs[index].get('image')}',
                  fit: BoxFit.cover,
                )),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Datalsesecreen(
                      '${querySnapshot.docs[index].get('image')}',
                      '${querySnapshot.docs[index].get('name')}',
                      '${querySnapshot.docs[index].get('desc')}'),
                ));
          },
        ),
        Directionality(
          child: Text('الموضوع :${querySnapshot.docs[index].get('name')}'),
          textDirection: TextDirection.rtl,
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'الوصف :${querySnapshot.docs[index].get('desc')}',
            maxLines: 1,
          ),
        )
      ],
    ));
  }
}

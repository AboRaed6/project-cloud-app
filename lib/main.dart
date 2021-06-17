import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_app/description.dart';

import 'button_tap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: ButtomTab(),
    );
  }
}

final userRef = FirebaseFirestore.instance.collection('testing');

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String time;
  String name;

  void getData() async {
    // final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
    //     .collection('testing')
    //     .doc('G5PBPVafU22SNHscEEaG')
    //     .get();
    userRef.get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        print(doc.data());
        print(doc.id);
      });
    });
    // setState(() {
    //   time = documentSnapshot['timestamp'];
    //   print('Time:$time');
    // });
  }

  getDataById() async {
    final String id = 'UbmZ6jxgxO0oYZ9oyMMN';
    final DocumentSnapshot snapshot = await userRef.doc(id).get();
    print(snapshot.data());
    setState(() {
      var data = snapshot.data();
      name = data['name'];
    });
    print(snapshot.id);
  }

  @override
  void initState() {
    getData();
    getDataById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name'),
      ),
      body: FutureBuilder(
        future: userRef.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('It\'s Error!');
          }
          // <3> Retrieve `List<DocumentSnapshot>` from snapshot
          List<DocumentSnapshot> documents = snapshot.data.docs;
          return ListView(
              children: documents
                  .map((doc) => Card(
                        child: ListTile(
                          title: Text(doc['name']),
                          //subtitle: Text(doc['timestamp']),
                        ),
                      ))
                  .toList());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => FirebaseFirestore.instance.collection('testing').add({
          'timestamp': Timestamp.fromDate(DateTime.now()),
          'name': 'mohamed'
        }),
        child: Icon(Icons.add),
      ),
    );
  }
}

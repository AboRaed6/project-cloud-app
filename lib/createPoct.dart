import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddnewPost extends StatefulWidget {
  const AddnewPost();
  @override
  _AddnewPostState createState() => _AddnewPostState();
}

class _AddnewPostState extends State<AddnewPost> {
  FirebaseFirestore fri;
  FirebaseStorage firebaseStorage;

  @override
  void initState() {
    fri = FirebaseFirestore.instance;
    firebaseStorage = FirebaseStorage.instance;
    super.initState();
  }

  File _image;
  String dicreptioon = 'initdata';
  String titel = 'data';

  final picker = ImagePicker();

  bool visible = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var heightImage = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Post'),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                      height: heightImage * 0.4,
                      child: _image == null
                          ? GestureDetector(
                              onTap: () async {
                                getImage();
                                print('image click');
                              },
                              child: Image.asset(
                                'images/add.png',
                                fit: BoxFit.cover,
                              ))
                          : Image.file(
                              _image,
                              fit: BoxFit.cover,
                            )),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: TextField(
                      maxLines: 1,
                      decoration: InputDecoration(hintText: 'Enter a Title'),
                      onChanged: (data) {
                        titel = data;
                      },
                    ),
                  ),
                  Container(
                    color: Colors.orangeAccent,
                    margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: 5,
                        decoration:
                            InputDecoration(hintText: 'Enter a Descreption'),
                        onChanged: (data) {
                          dicreptioon = data;
                        },
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      loadProgress();
                      if (_image != null) {
                        var snapShote = await firebaseStorage
                            .ref()
                            .child('folderName/imageName${DateTime.now()}')
                            .putFile(_image)
                            .whenComplete(() => () {
                                  print('UplodeFinash');
                                });
                        String x = await snapShote.ref.getDownloadURL();

                        print('aaaaaaaaaaaaaaaaaaaa');
                        fri.collection('posts').add({
                          'image': x,
                          'desc': titel,
                          'name': dicreptioon
                        }).whenComplete(() {
                          loadProgress();

                          final snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Yay! A SnackBar!'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ));

                          Scaffold.of(context).showSnackBar(snackBar);
                        }).catchError(() {
                          loadProgress();
                        });
                      }
                    },
                    child: Text("add"),
                  )
                ],
              ),
              Visibility(
                visible: visible,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loadProgress() {
    if (visible == true) {
      setState(() {
        visible = false;
        dicreptioon = '';
        _image = null;
      });
    } else {
      setState(() {
        visible = true;
      });
    }
  }
}

class SnackBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: Text('Yay! A SnackBar!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
        },
        child: Text('Show SnackBar'),
      ),
    );
  }
}

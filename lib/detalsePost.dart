import 'package:flutter/material.dart';

class Datalsesecreen extends StatefulWidget {
  final String image;
  final String desc;
  final String titel;

  Datalsesecreen(this.image, this.desc, this.titel);

  @override
  _DatalsesecreenState createState() => _DatalsesecreenState();
}

class _DatalsesecreenState extends State<Datalsesecreen> {
  @override
  Widget build(BuildContext context) {
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Post'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Image.network(
            '${widget.image}',
            fit: BoxFit.cover,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
            width: sizeWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.amber,
            ),
            child: Text(
              'Title :\n${widget.titel}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
            width: sizeWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.green,
            ),
            child: Text(
              'Description :\n${widget.desc}',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

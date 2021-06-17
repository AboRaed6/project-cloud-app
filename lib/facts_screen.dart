import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FactsScreen extends StatefulWidget {
  const FactsScreen();

  @override
  _FactsScreenState createState() => _FactsScreenState();
}

class _FactsScreenState extends State<FactsScreen> {
  FirebaseFirestore query;
  @override
  void initState() {
    query = FirebaseFirestore.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sizeHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                'حقائق عن القدس',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: query.collection('facts').snapshots(),
              builder: (context, stream) {
                if (stream.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (stream.hasError) {
                  return Center(child: Text(stream.error.toString()));
                }

                QuerySnapshot querySnapshot = stream.data;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: querySnapshot?.size,
                  itemBuilder: (context, index) =>
                      itemfact(sizeHeight, index, querySnapshot),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Container itemfact(
      double sizeHeight, int index, QuerySnapshot querySnapshot) {
    return Container(
      child: ExpansionTile(
        childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
        initiallyExpanded: false,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text('${querySnapshot.docs[index].get('title')}'),
        ),
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              '${querySnapshot.docs[index].get('desc')}',
              style: TextStyle(fontSize: 18, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

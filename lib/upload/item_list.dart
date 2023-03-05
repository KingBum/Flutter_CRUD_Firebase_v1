import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_item.dart';
import 'item_details.dart';

class ItemList extends StatelessWidget {
  ItemList({Key? key}) : super(key: key) {}

  final CollectionReference _Students =
      FirebaseFirestore.instance.collection('shopping_list');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
      ),
      body: StreamBuilder(
        stream: _Students.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: GestureDetector(
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            child:
                                Image.network('${documentSnapshot['image']}'),
                          ),
                          Text('ID: ' +
                              documentSnapshot.reference.id.toString()),
                          Text('Ma Sinh Vien: ' + documentSnapshot['name']),
                          Text('Ngay Sinh: ' + documentSnapshot['quantity']),
                          // Text('Gioi Tinh: '+documentSnapshot['gioiTinh']),
                          // Text('Que Quan: '+documentSnapshot['queQuan']),
                        ],
                      )),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ItemDetails(
                                documentSnapshot.reference.id.toString())));
                      },
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

      //Display a list // Add a FutureBuilder
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddItem()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

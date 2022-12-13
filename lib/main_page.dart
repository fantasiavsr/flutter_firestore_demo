import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_demo/item_card.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          /* title: StreamBuilder<DocumentSnapshot>(
              stream: users.doc('DWqS4mYpnHARhXFCky5O').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!['name']);
                } else {
                  return const Text('Loading...');
                }
              }), */
          title: const Text('Firestore Demo'),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              children: [
                //// VIEW DATA HERE
                // note: 1x
                /* FutureBuilder<QuerySnapshot>(
                  future: users.get(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!.docs.map((document) {
                          return ItemCard(
                            document['name'],
                            document['age'],
                            onUpdate: () {
                              users.doc(document.id).update({
                                'name': 'Updated Name',
                                'age': 99,
                              });
                            },
                            onDelete: () {
                              users.doc(document.id).delete();
                            },
                          );
                        }).toList(),
                      );
                    } else {
                      return const Text('Loading');
                    }
                  },
                ), */
                StreamBuilder(
                  stream: users
                      .where('age', isGreaterThan: 0)
                      .orderBy('age', descending: true)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!.docs.map((document) {
                          return ItemCard(
                            document['name'],
                            document['age'],
                            onUpdate: () {
                              users.doc(document.id).update({
                                'name': 'Updated Name',
                                'age': 99,
                              });
                            },
                            onDelete: () {
                              users.doc(document.id).delete();
                            },
                          );
                        }).toList(),
                      );
                    } else {
                      return const Text('Loading');
                    }
                  },
                ),
                const SizedBox(
                  height: 150,
                ),
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(-5, 0),
                        blurRadius: 15,
                        spreadRadius: 3)
                  ]),
                  width: double.infinity,
                  height: 130,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: nameController,
                              decoration:
                                  const InputDecoration(hintText: "Name"),
                            ),
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: ageController,
                              decoration:
                                  const InputDecoration(hintText: "Age"),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 130,
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue[900]),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)))),
                            child: Text(
                              'Add Data',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              //// ADD DATA HERE
                              users.add({
                                'name': nameController.text,
                                'age': int.tryParse(ageController.text) ?? 0,
                              });
                              nameController.clear();
                              ageController.clear();
                            }),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}

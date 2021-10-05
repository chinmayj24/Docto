import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docto/constants.dart';
import 'package:docto/models/request.dart';
import 'package:docto/screens/request_view.dart';
import 'package:flutter/material.dart';

class Requests extends StatefulWidget {
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> patientName(String uid) async {
    DocumentSnapshot res =
        await firestore.collection(UniversalVariables.patient).doc(uid).get();
    return res.data()["name"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F6FE),
      appBar: AppBar(
        backgroundColor: Color(0xFFF2F6FE),
        elevation: 0.1,
        centerTitle: true,
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.17,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFE8E9FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                            MediaQuery.of(context).size.width * 0.03),
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.menu,
                    color: Color(0xFF585CE5),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 8.0,
                    child: Image.asset("assets/images/logo4.jpeg")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn.icon-icons.com/icons2/2643/PNG/512/male_man_people_person_avatar_white_tone_icon_159363.png"),
                // AssetImage(
                //     "assets/person.jpg"), // TODO: Network image of the user
                radius: MediaQuery.of(context).size.height * 0.03,
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
              stream: firestore
                  .collection(UniversalVariables.REQUESTS_COLLECTION)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  var reqList = snapshot.data.docs;
                  if (reqList.isEmpty) {
                    return Container();
                  }
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(7),
                    itemCount: reqList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Request_View(
                        request: Request(
                          uid: reqList[index]['request_id'],
                          adddedOn: reqList[index]['added_on'],
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}

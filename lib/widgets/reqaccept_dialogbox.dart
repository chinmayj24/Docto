import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../resources/firebase_methods.dart';

class ReqAcceptDialogBox extends StatefulWidget {
  final String title, desc, text, doctorUid, patientUid;
  final Image img;

  ReqAcceptDialogBox(
      {this.title,
      this.desc,
      this.text,
      this.img,
      this.doctorUid,
      this.patientUid});

  @override
  _ReqAcceptDialogBoxState createState() =>
      _ReqAcceptDialogBoxState(doctorUid: doctorUid, patientUid: patientUid);
}

class _ReqAcceptDialogBoxState extends State<ReqAcceptDialogBox> {
  String doctorUid, patientUid;
  _ReqAcceptDialogBoxState({this.doctorUid, this.patientUid});
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.desc,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () async {
                      //When doc accepts request, adding doctor and patient as a contact
                      await _firebaseMethods.addToContact(
                          role: UniversalVariables.doctor,
                          senderId: doctorUid,
                          receiverId: patientUid);

                      //Deleting the request since it is accepted
                      await firestore
                          .collection(UniversalVariables.REQUESTS_COLLECTION)
                          .doc(patientUid)
                          .delete();

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.text,
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(45)),
              child: Image.network(
                  "https://assets-global.website-files.com/6005fac27a49a9cd477afb63/60576840e7d265198541a372_bavassano_homepage_gp.jpg"),
            ),
          ),
        ),
      ],
    );
  }
}

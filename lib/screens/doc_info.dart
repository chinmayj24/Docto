import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docto/models/doctor.dart';
import 'package:docto/models/message.dart';
import 'package:docto/provider/patient_provider.dart';
import 'package:docto/resources/firebase_methods.dart';
import 'package:docto/screens/media_screen.dart';
import 'package:flutter/material.dart';
import 'package:docto/constants.dart';
import 'package:docto/screens/main_chatpage.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class DocInfoPage extends StatefulWidget {
  final String docUid, docDescription, docName, docUrl;

  DocInfoPage({
    this.docUid,
    this.docDescription,
    this.docUrl,
    this.docName,
  });
  @override
  _DocInfoPageState createState() => _DocInfoPageState();
}

class _DocInfoPageState extends State<DocInfoPage> {
  String docUid, docDescription, docName, docUrl;
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  Doctor doctor;
  Message _message;

  @override
  void initState() {
    docUid = widget.docUid;
    docDescription = widget.docDescription;
    docName = widget.docName;
    docUrl = widget.docUrl;
    _firebaseMethods
        .getDoctorDetailsById(docUid)
        .then((value) => doctor = value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PatientProvider patientProvider = Provider.of<PatientProvider>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf200ff), UniversalVariables.gradientColorEnd],
            begin: Alignment(0, -1.15),
            end: Alignment(0, 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Image.asset('assets/images/docinfo/bg1.png'),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      MediaQuery.of(context).size.height * 0.06),
                  topRight: Radius.circular(
                      MediaQuery.of(context).size.height * 0.06),
                ),
                color: UniversalVariables.bgColor,
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(docUrl),
                              backgroundColor: Colors.transparent,
                              radius: MediaQuery.of(context).size.height * 0.04,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Dr.$docName",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.04,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "About the Doctor",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              docDescription,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Text(
                              'Number Of Patients Treated',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              doctor.patientCounter != null
                                  ? doctor.patientCounter.toString()
                                  : 0,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                            GestureDetector(
                                onTap: () {
                                  _message = Message(
                                    receiverId: docUid,
                                    senderId: patientProvider.getPatient.uid,
                                    message:
                                        patientProvider.getPatient.symptoms,
                                    timestamp: Timestamp.now(),
                                    type: 'text',
                                  );
                                  _firebaseMethods.addToContact(
                                      role: UniversalVariables.patient,
                                      senderId: patientProvider.getPatient.uid,
                                      receiverId: docUid);
                                  _firebaseMethods.addMessageToDb(
                                    _message,
                                    patientProvider.getPatient.uid,
                                    docUid,
                                  );
                                  incrementPatient();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainChatPage(
                                        doctor: doctor,
                                        role: UniversalVariables.patient,
                                      ),
                                    ),
                                  );
                                },
                                child: selectDocWidget()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void incrementPatient() async {
    QuerySnapshot res = await firestore
        .collection(UniversalVariables.doctor)
        .doc(docUid)
        .collection(UniversalVariables.CONTACTS_COLLECTION)
        .get();

    int totalPatients = res.docs.length;
    _firebaseMethods.updateDataToDb(
        UniversalVariables.doctor, docUid, "patientCounter", totalPatients);
  }

  Container selectDocWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(MediaQuery.of(context).size.height * 0.03)),
          color: UniversalVariables.docContentBgColor),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.height * 0.1,
              child: IconButton(
                icon: Image.asset('assets/images/docinfo/doctor.png'),
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.03,
            ),
            Text(
              "Select This Doctor",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.035,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docto/constants.dart';
import 'package:docto/models/doctor.dart';
import 'package:docto/models/patient.dart';
import 'package:docto/provider/doctor_provider.dart';
import 'package:flutter/material.dart';


final FirebaseFirestore firestore = FirebaseFirestore.instance;

class MediaScreen extends StatefulWidget {
  final String role;
  final Patient patient;
  final Doctor doctor;

  MediaScreen({
    this.role,
    this.patient,
    this.doctor,
  });

  @override
  _MediaScreenState createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  String role, patientUid, doctorUid;
  Patient patient;
  Doctor doctor;
  DoctorProvider doctorProvider;
  List<String> symptoms = [];

  List<String> reports = [];
  List<String> prescriptions = [];

  @override
  void initState() {
    role = widget.role;
    patient = widget.patient;
    patientUid = patient.uid;
    doctor = widget.doctor;
    doctorUid = doctor.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // doctorProvider = Provider.of<DoctorProvider>(context);
    symptoms = patient.symptoms != null ? patient.symptoms.split(",") : [];

    return Scaffold(
      backgroundColor: Color(0xFFF2F6FE),
      appBar: AppBar(
        backgroundColor: Color(0xFFF2F6FE),
        elevation: 0.1,
        centerTitle: true,
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.17,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 15.0,
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF585CE5),
                ),
              ),
            ),
            Text(
              role == UniversalVariables.patient ? doctor.name : patient.name,
              style: TextStyle(
                color: Color(0xFF585CE5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(MediaQuery.of(context).size.width * 0.02),
                    ),
                  ),
                  child: Image.asset("assets/images/img.jpeg"),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
              Text(
                "  Symptoms",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color(0xFF585CE5),
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(MediaQuery.of(context).size.width * 0.03),
                    ),
                  ),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(7),
                      itemCount: symptoms.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.only(right: 6),
                          child: Text(
                            symptoms[index],
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        );
                      }),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              MainContainer(
                type: "Reports",
                urls: reports,
                patientUid: patientUid,
                doctorUid: doctorUid,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              MainContainer(
                type: "Prescriptions",
                urls: prescriptions,
                patientUid: patientUid,
                doctorUid: doctorUid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainContainer extends StatelessWidget {
  MainContainer(
      {@required this.type,
      @required this.urls,
      @required this.patientUid,
      @required this.doctorUid});

  final String type, patientUid, doctorUid;
  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(MediaQuery.of(context).size.width * 0.03),
        ),
      ),
      padding: EdgeInsets.only(top: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "  $type",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color(0xFF585CE5),
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width * 0.02),
              ),
            ),
            child: StreamBuilder(
                stream: firestore
                    .collection(UniversalVariables.MESSAGES_COLLECTION)
                    .doc(patientUid)
                    .collection(doctorUid)
                    .where("type",
                        isEqualTo:
                            type == "Reports" ? "Report" : "Prescription")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      padding: EdgeInsets.all(6),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  MediaQuery.of(context).size.width * 0.02),
                            ),
                          ),
                          padding: EdgeInsets.only(right: 4),
                          child: Image(
                            image: NetworkImage(
                                snapshot.data.docs[index]["photoUrl"]),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}

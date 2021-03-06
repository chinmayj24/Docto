import 'package:docto/constants.dart';
import 'package:docto/models/patient.dart';
import 'package:docto/models/request.dart';
import 'package:docto/resources/firebase_methods.dart';
import 'package:docto/widgets/reqaccept_dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/doctor_provider.dart';

class Request_View extends StatelessWidget {
  final Request request;
  Request_View({this.request});
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    Patient patient;
    return FutureBuilder(
        future: _firebaseMethods.getPatientDetailsById(request.uid),
        builder: (context, snapshot) {
          patient = snapshot.data;
          return RequestLayout(
            patient: patient,
          );
        });
  }
}

class RequestLayout extends StatelessWidget {
  final Patient patient;
  RequestLayout({this.patient});
  DoctorProvider doctorProvider;

  @override
  Widget build(BuildContext context) {
    doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width * 0.03),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://cdn.icon-icons.com/icons2/2643/PNG/512/male_man_people_person_avatar_white_tone_icon_159363.png"),
                    radius: MediaQuery.of(context).size.height * 0.033,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment(-1, 0),
                    child: Text(
                      patient.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF585CE5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                              MediaQuery.of(context).size.width * 0.015),
                        ),
                      ),
                    ),
                    onPressed: () {
                      //TODO: Add to contacts and send msg from doc to patient
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ReqAcceptDialogBox(
                              title: "Accept Request?",
                              desc:
                                  "This will accept the request and connect you with the patient.",
                              text: "Yes",
                              doctorUid: doctorProvider.getDoctor.uid,
                              patientUid: patient.uid,
                            );
                          });
                    },
                    child: Text(
                      "Start",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
        ],
      ),
    );
  }
}

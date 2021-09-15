import 'package:docto/constants.dart';
import 'package:docto/models/contacts.dart';
import 'package:docto/models/doctor.dart';
import 'package:docto/models/patient.dart';
import 'package:docto/provider/doctor_provider.dart';
import 'package:docto/provider/patient_provider.dart';
import 'package:docto/resources/firebase_methods.dart';
import 'package:docto/screens/chatscreens/widgets/lastmessagecontainer.dart';
import 'package:docto/screens/main_chatpage.dart';
import 'package:docto/widgets/customtile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final String role;
  ContactView({this.contact, this.role});
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    Doctor doctor;
    Patient patient;
    return FutureBuilder(
        future: role == UniversalVariables.patient
            ? _firebaseMethods.getDoctorDetailsById(contact.uid)
            : _firebaseMethods.getPatientDetailsById(contact.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (role == UniversalVariables.patient) {
              doctor = snapshot.data;
              return ViewLayout(
                doctor: doctor,
                role: role,
              );
            } else {
              patient = snapshot.data;
              return ViewLayout(
                patient: patient,
                role: role,
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class ViewLayout extends StatelessWidget {
  final FirebaseMethods _firebaseMethods = FirebaseMethods();
  final String role;
  final Doctor doctor;
  final Patient patient;
  ViewLayout({this.doctor, this.patient, this.role});
  @override
  Widget build(BuildContext context) {
    PatientProvider patientProvider = Provider.of<PatientProvider>(context);
    DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);
    return CustomTile(
      mini: false,
      onTap: () {
        if (role == UniversalVariables.patient) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainChatPage(
                role: role,
                doctor: doctor,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainChatPage(
                role: role,
                patient: patient,
              ),
            ),
          );
        }
      },
      title: Text(
        role == UniversalVariables.patient ? doctor.name : patient.name,
        style:
            TextStyle(color: Colors.black, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _firebaseMethods.fetchLastMessageBetween(
            senderId: role == UniversalVariables.patient
                ? patientProvider.getPatient.uid
                : doctorProvider.getDoctor.uid,
            receiverId:
                role == UniversalVariables.patient ? doctor.uid : patient.uid),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey.shade700,
              backgroundImage: role == UniversalVariables.patient
                  ? doctor.profilePhoto
                  : NetworkImage(
                      "https://www.woolha.com/media/2020/03/flutter-circleavatar-basic.jpg"),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 13,
                width: 13,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: UniversalVariables.onlineDotColor,
                    border: Border.all(
                        color: UniversalVariables.blackColor, width: 2)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docto/constants.dart';
import 'package:docto/models/call.dart';
import 'package:docto/provider/doctor_provider.dart';
import 'package:docto/provider/patient_provider.dart';
import 'package:docto/screens/pickup/pickup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../resources/call_methods.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();
  final String role;

  PickupLayout({
    @required this.scaffold,
    @required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final PatientProvider patientProvider =
        Provider.of<PatientProvider>(context);
    final DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);
    if (role == UniversalVariables.doctor) {
      return (doctorProvider != null && doctorProvider.getDoctor != null)
          ? StreamBuilder<DocumentSnapshot>(
              stream: callMethods.callStream(uid: doctorProvider.getDoctor.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.data() != null) {
                  Call call = Call.fromMap(snapshot.data.data());
                  if(!call.hasDialled){
                    return PickupScreen(call: call,role: UniversalVariables.doctor,);
                  }
                  return scaffold;
                }
                return scaffold;
              })
          : Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
    } else {
      return (patientProvider != null && patientProvider.getPatient != null)
          ? StreamBuilder<DocumentSnapshot>(
              stream:
                  callMethods.callStream(uid: patientProvider.getPatient.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.data() != null) {

                  Call call = Call.fromMap(snapshot.data.data());
                  return PickupScreen(call: call,role: UniversalVariables.patient,);
                }
                return scaffold;
              })
          : Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
    }
  }
}

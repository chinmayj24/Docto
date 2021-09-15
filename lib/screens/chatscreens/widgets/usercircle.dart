import 'package:docto/constants.dart';
import 'package:docto/provider/doctor_provider.dart';
import 'package:docto/provider/patient_provider.dart';
import 'package:docto/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCircle extends StatelessWidget {
  final String role;
  UserCircle({this.role});
  DoctorProvider doctorProvider;
  PatientProvider patientProvider;
  @override
  Widget build(BuildContext context) {
    doctorProvider = Provider.of<DoctorProvider>(context);
    patientProvider = Provider.of<PatientProvider>(context);
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: UniversalVariables.separatorColor,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              Utils.getInitials(role == UniversalVariables.patient
                  ? patientProvider.getPatient.name
                  : doctorProvider.getDoctor.name),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: UniversalVariables.lightBlueColor,
                fontSize: 13,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: UniversalVariables.blackColor,
                  width: 2,
                ),
                color: UniversalVariables.onlineDotColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

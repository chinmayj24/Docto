import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../resources/firebase_repository.dart';

class PatientProvider with ChangeNotifier {
  Patient _patient;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  Patient get getPatient => _patient;

  void refreshPatient() async {
    Patient patient = await _firebaseRepository.getPatientDetails();
    _patient = patient;
    notifyListeners();
  }
}

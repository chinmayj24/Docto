import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../resources/firebase_repository.dart';

class DoctorProvider with ChangeNotifier {
  Doctor _doctor;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  Doctor get getDoctor => _doctor;

  void refreshDoctor() async {
    Doctor doctor = await _firebaseRepository.getDoctorDetails();
    _doctor = doctor;
    notifyListeners();
  }
}

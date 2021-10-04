import 'dart:io';
import 'package:docto/provider/image_upload_provider.dart';
import 'package:docto/resources/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:docto/models/message.dart';
import 'package:flutter/cupertino.dart';
import '../models/doctor.dart';
import '../models/patient.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<User> currentUser() => _firebaseMethods.currentUser();

  Future<Patient> getPatientDetails() => _firebaseMethods.getPatientDetails();
  Future<Doctor> getDoctorDetails() => _firebaseMethods.getDoctorDetails();

  Future<User> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(User user, String role) =>
      _firebaseMethods.authenticateUser(user, role);

  Future<void> addDataToDbDoctor(User user, String name, String photoUrl,
          String description, String gender, String age, String location) =>
      _firebaseMethods.addDataToDbDoctor(
          user, name, photoUrl, description, gender, age, location);

  Future<void> addDataToDbPatient(
          User user, String name, String age, String gender, String location) =>
      _firebaseMethods.addDataToDbPatient(user, name, age, gender, location);

  Future<void> updateDataToDb(String role, String uid, String key, var data) =>
      _firebaseMethods.updateDataToDb(role, uid, key, data);

  Future<void> addMessageToDb(
          Message message, String senderUid, String receiverUid) =>
      _firebaseMethods.addMessageToDb(message, senderUid, receiverUid);

  void uploadImage({
    @required File image,
    @required String receiverId,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider,
    @required String type
  }) =>
      _firebaseMethods.uploadImage(
          image, receiverId, senderId, imageUploadProvider,type);
}

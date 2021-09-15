import 'package:docto/models/contacts.dart';
import 'package:docto/provider/image_upload_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docto/models/doctor.dart';
import 'package:docto/models/patient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:docto/constants.dart';
import 'package:docto/models/message.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../constants.dart';

import '../models/doctor.dart';

import '../models/patient.dart';

class FirebaseMethods {
  String _imageUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  static final CollectionReference _patientCollection =
      firestore.collection(UniversalVariables.patient);

  static final CollectionReference _doctorCollection =
      firestore.collection(UniversalVariables.doctor);

  Patient patient = Patient();
  Doctor doctor = Doctor();

  Future<User> currentUser() async {
    User currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<Patient> getPatientDetails() async {
    User currentPatient = await currentUser();

    DocumentSnapshot documentSnapshot =
        await _patientCollection.doc(currentPatient.uid).get();

    return Patient.fromMap(documentSnapshot.data());
  }

  Future<Doctor> getDoctorDetails() async {
    User currentDoctor = await currentUser();

    DocumentSnapshot documentSnapshot =
        await _doctorCollection.doc(currentDoctor.uid).get();

    return Doctor.fromMap(documentSnapshot.data());
  }

  Future<Patient> getPatientDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _patientCollection.doc(id).get();
      return Patient.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Doctor> getDoctorDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot = await _doctorCollection.doc(id).get();
      return Doctor.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);

    UserCredential result = await _auth.signInWithCredential(credential);
    return result.user;
  }

  Future<bool> authenticateUser(User user, String role) async {
    QuerySnapshot result = await firestore
        .collection(role)
        .where("email", isEqualTo: user.email)
        .get();

    List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0

    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDbDoctor(User currentUser, String name, String photoUrl,
      String description, String gender, String age, String location) async {
    doctor = Doctor(
      uid: currentUser.uid,
      name: name,
      email: currentUser.email,
      description: description,
      gender: gender,
      profilePhoto: photoUrl,
      age: age,
      location: location,
    );

    firestore
        .collection(UniversalVariables.doctor)
        .doc(currentUser.uid)
        .set(doctor.toMap(doctor));
  }

  Future<void> addDataToDbPatient(User currentUser, String name, String age,
      String gender, String location) async {
    patient = Patient(
      uid: currentUser.uid,
      email: currentUser.email,
      gender: gender,
      name: name,
      age: age,
      location: location,
    );

    firestore
        .collection(UniversalVariables.patient)
        .doc(currentUser.uid)
        .set(patient.toMap(patient));
  }

  addToContact({String role, String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();
    if (role == UniversalVariables.patient) {
      await addToSenderContact(
          role: UniversalVariables.patient,
          senderId: senderId,
          receiverId: receiverId,
          currentTime: currentTime);
      await addToReceiverContact(
          role: UniversalVariables.doctor,
          senderId: senderId,
          receiverId: receiverId,
          currentTime: currentTime);
    } else {
      await addToSenderContact(
          role: UniversalVariables.doctor,
          senderId: senderId,
          receiverId: receiverId,
          currentTime: currentTime);
      await addToReceiverContact(
          role: UniversalVariables.patient,
          senderId: senderId,
          currentTime: currentTime,
          receiverId: receiverId);
    }
  }

  Future<void> addToSenderContact(
      {String role,
      String senderId,
      String receiverId,
      Timestamp currentTime}) async {
    DocumentSnapshot senderSnapshot = await getContactsDocument(
            role: role, of: senderId, forContact: receiverId)
        .get();
    if (!senderSnapshot.exists) {
      Contact receiverContact = Contact(uid: receiverId, adddedOn: currentTime);
      var receiverMap = receiverContact.toMap(receiverContact);
      await getContactsDocument(
              role: role, of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiverContact(
      {String role,
      String senderId,
      String receiverId,
      Timestamp currentTime}) async {
    DocumentSnapshot receiverSnapshot = await getContactsDocument(
            role: role, of: receiverId, forContact: senderId)
        .get();
    if (!receiverSnapshot.exists) {
      Contact senderContact = Contact(uid: senderId, adddedOn: currentTime);
      var senderMap = senderContact.toMap(senderContact);
      await getContactsDocument(
              role: role, of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  DocumentReference getContactsDocument(
          {String role, String of, String forContact}) =>
      firestore
          .collection(role)
          .doc(of)
          .collection(UniversalVariables.CONTACTS_COLLECTION)
          .doc(forContact);

  Future<void> updateDataToDb(
      String role, String uid, String key, var data) async {
    firestore.collection(role).doc(uid).update({key: data});
  }

  Future<void> addMessageToDb(
      Message message, String senderUid, String receiverUid) async {
    var map = message.toMap();

    await firestore
        .collection(UniversalVariables.MESSAGES_COLLECTION)
        .doc(senderUid)
        .collection(receiverUid)
        .add(map);

    await firestore
        .collection(UniversalVariables.MESSAGES_COLLECTION)
        .doc(receiverUid)
        .collection(senderUid)
        .add(map);
  }

  Future uploadImageToStorage(File image) async {
    try {
      var _storageReference =
          _storage.ref().child('${DateTime.now().millisecondsSinceEpoch}');

      var snapshot = await _storageReference.putFile(image);
      await snapshot.ref.getDownloadURL().then((String result) {
        _imageUrl = result;
      });
    } catch (e) {
      print(e);
      _imageUrl = null;
    }
  }

  void setImageMsg(
      String url, String receiverId, String senderId, String type) async {
    Message _message;

    _message = Message.imageMessage(
      message: "IMAGE",
      receiverId: receiverId,
      senderId: senderId,
      photoUrl: url,
      timestamp: Timestamp.now(),
      type: type,
    );

    var map = _message.toImageMap();

    await firestore
        .collection(UniversalVariables.MESSAGES_COLLECTION)
        .doc(senderId)
        .collection(receiverId)
        .add(map);

    await firestore
        .collection(UniversalVariables.MESSAGES_COLLECTION)
        .doc(receiverId)
        .collection(senderId)
        .add(map);
  }

  void uploadImage(File image, String receiverId, String senderId,
      ImageUploadProvider imageUploadProvider, String type) async {
    imageUploadProvider.setToLoading();
    await uploadImageToStorage(image);

    imageUploadProvider.setToIdle();

    setImageMsg(_imageUrl, receiverId, senderId, type);
  }

  Stream<QuerySnapshot> fetchContactsOfPatients({String userId}) => firestore
      .collection(UniversalVariables.patient)
      .doc(userId)
      .collection(UniversalVariables.CONTACTS_COLLECTION)
      .snapshots();
  Stream<QuerySnapshot> fetchContactsOfDoctors({String userId}) => firestore
      .collection(UniversalVariables.doctor)
      .doc(userId)
      .collection(UniversalVariables.CONTACTS_COLLECTION)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String senderId,
    @required String receiverId,
  }) =>
      firestore
          .collection(UniversalVariables.MESSAGES_COLLECTION)
          .doc(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}

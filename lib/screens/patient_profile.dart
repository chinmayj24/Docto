import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docto/provider/patient_provider.dart';
import 'package:docto/resources/firebase_repository.dart';
import 'package:docto/screens/chatscreens/chatlist_screen.dart';
import 'package:docto/screens/patient_homepage.dart';
import 'package:docto/screens/symptoms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class PatientProfile extends StatefulWidget {
  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  TextEditingController _name = TextEditingController();
  TextEditingController _gender = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _email = TextEditingController();
  String _uid;
  String patient = UniversalVariables.patient;

  PatientProvider patientProvider;
  FirebaseRepository _repository = FirebaseRepository();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    patientProvider = Provider.of<PatientProvider>(context, listen: false);
    _uid = patientProvider.getPatient.uid;
    _name = TextEditingController()..text = patientProvider.getPatient.name;
    _gender = TextEditingController()..text = patientProvider.getPatient.gender;
    _age = TextEditingController()..text = patientProvider.getPatient.age;
    _location = TextEditingController()
      ..text = patientProvider.getPatient.location;
    _email = TextEditingController()..text = patientProvider.getPatient.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back_outlined,
          color: Colors.black,
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 35,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.39,
                height: MediaQuery.of(context).size.width * 0.39,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 3,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, 10))
                  ],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/img.jpeg"),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              bTextField("Full Name", _name),
              bTextField("E-mail", _email),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      child: bTextField("Age", _age),
                      width: MediaQuery.of(context).size.width * 0.45,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: bTextField("Gender", _gender),
                    ),
                  ],
                ),
              ),
              bTextField("Location", _location),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.16,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 120,
                ),
                height: MediaQuery.of(context).size.height * 0.05,
                child: submitButton(),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  // boxShadow: [
                  //   BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                  // ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        MediaQuery.of(context).size.width * 2.0),
                    topRight: Radius.circular(
                        MediaQuery.of(context).size.width * 2.0),
                  ),
                  child: BottomNavigationBar(
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    backgroundColor: Colors.white,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: GestureDetector(
                          child: Icon(
                            Icons.medical_services_outlined,
                            color: Color(0xFF595BDE),
                            size: MediaQuery.of(context).size.width * 0.08,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientHomePage(),
                              ),
                            );
                          },
                        ),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: GestureDetector(
                          onTap: () {
                            chat(context);
                          },
                          child: Icon(
                            Icons.chat,
                            color: Color(0xFF595BDE),
                            size: MediaQuery.of(context).size.width * 0.08,
                          ),
                        ),
                        label: 'Chats',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.person_outline,
                          color: Color(0xFF595BDE),
                          size: MediaQuery.of(context).size.width * 0.08,
                        ),
                        label: 'Profile',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bTextField(String label, TextEditingController textEditingController) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 25,
      ),
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.only(
                left: 15,
              ),
              margin: EdgeInsets.only(
                top: 7,
                left: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.5,
                  color: Colors.grey.shade400,
                ),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(25),
                ),
              ),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              alignment: Alignment.center,
            ),
            Container(
              child: Text(
                label,
                style: TextStyle(
                  backgroundColor: Colors.white,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              margin: EdgeInsets.only(
                left: 34,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void chat(BuildContext context) async {
    QuerySnapshot result = await firestore
        .collection(UniversalVariables.patient)
        .doc(patientProvider.getPatient.uid)
        .collection(UniversalVariables.CONTACTS_COLLECTION)
        .get();

    if (result.docs.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatListScreen(
            role: UniversalVariables.patient,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Symptoms(),
        ),
      );
    }
  }

  Widget submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
      ),
      onPressed: () async => updateProfile(),
      child: Text('Submit'),
    );
  }

  void updateProfile() {
    _repository.updateDataToDb(patient, _uid, "name", _name);
    _repository.updateDataToDb(patient, _uid, "email", _email);
    _repository.updateDataToDb(patient, _uid, "age", _age);
    _repository.updateDataToDb(patient, _uid, "gender", _gender);
    _repository.updateDataToDb(patient, _uid, "location", _location);
  }
}

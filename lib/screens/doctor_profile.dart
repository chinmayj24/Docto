import 'package:docto/constants.dart';
import 'package:docto/provider/doctor_provider.dart';
import 'package:docto/resources/firebase_repository.dart';
import 'package:docto/screens/chatscreens/chatlist_screen.dart';
import 'package:docto/screens/doctor_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorProfile extends StatefulWidget {
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _email = TextEditingController();
  String _uid;
  String doc = UniversalVariables.doctor;

  DoctorProvider doctorProvider;
  FirebaseRepository _repository = FirebaseRepository();

  @override
  void initState() {
    super.initState();
    doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    _uid = doctorProvider.getDoctor.uid;
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
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Center(
                child: Stack(
                  children: <Widget>[
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
                          image: NetworkImage(
                            doctorProvider.getDoctor.profilePhoto,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.1,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2.5,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Colors.green,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              bTextField("FULL NAME", doctorProvider.getDoctor.name, _name),
              bTextField("E-MAIL ID", doctorProvider.getDoctor.email, _email),
              bTextField("DESCRIPTION", doctorProvider.getDoctor.description,
                  _description),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child:
                          bTextField("AGE", doctorProvider.getDoctor.age, _age),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: bTextField(
                          "GENDER", doctorProvider.getDoctor.gender, _gender),
                    ),
                  ],
                ),
              ),
              bTextField(
                  "LOCATION", doctorProvider.getDoctor.location, _location),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 120,
                ),
                height: MediaQuery.of(context).size.height * 0.05,
                child: submitButton(),
              ),
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
                                builder: (context) => DoctorHomePage(),
                              ),
                            );
                          },
                        ),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatListScreen(
                                  role: UniversalVariables.doctor,
                                ),
                              ),
                            );
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

  Widget bTextField(String label, String placeholder,
      TextEditingController textEditingController) {
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
                  hintText: placeholder,
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade400,
                  ),
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
    _repository.updateDataToDb(doc, _uid, "name", _name);
    _repository.updateDataToDb(doc, _uid, "email", _email);
    _repository.updateDataToDb(doc, _uid, "description", _description);
    _repository.updateDataToDb(doc, _uid, "age", _age);
    _repository.updateDataToDb(doc, _uid, "gender", _gender);
    _repository.updateDataToDb(doc, _uid, "location", _location);
  }
}

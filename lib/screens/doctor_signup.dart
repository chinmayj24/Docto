import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docto/screens/doctor_profilepic.dart';
import 'package:flutter/material.dart';
import 'package:docto/resources/firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';

class DoctorSignUpPage extends StatefulWidget {
  final User user;
  DoctorSignUpPage({this.user});

  @override
  State<StatefulWidget> createState() {
    return _DoctorSignUpState(user: this.user);
  }
}

class _DoctorSignUpState extends State<DoctorSignUpPage> {
  bool _hasBeenPressed = false;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _referralCode = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _location = TextEditingController();
  TextEditingController _email = TextEditingController();
  String _gender;

  Color maleBtnColor = inactiveButtonColor;
  Color femaleBtnColor = inactiveButtonColor;
  static final activeButtonColor = Colors.blue;
  static final inactiveButtonColor = Colors.white;

  String _imageUrl = "";
  String ref;
  User user;
  QuerySnapshot result;
  FirebaseRepository _repository = FirebaseRepository();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  _DoctorSignUpState({this.user});

  @override
  void initState() {
    _email = new TextEditingController(text: user.email);
    getUser();
    super.initState();
  }
  void showAlertDialogOnOkCallback(){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Error',
      desc:'Your referal code doesn\'t match',


      btnOkOnPress: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
      onDissmissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },

    ).show();
  }
  Future<String> getAvailableDoctors() async {
    result = await firestore.collection(UniversalVariables.doctor).get();

    return result.docs.length.toString();
  }

  getUser() async {
    await _repository.currentUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  void updateBtnColor({String gender}) {
    if (gender == "Male") {
      maleBtnColor = activeButtonColor;
      femaleBtnColor = inactiveButtonColor;
    } else {
      //gender = female
      maleBtnColor = inactiveButtonColor;
      femaleBtnColor = activeButtonColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(5),
          width: 50,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.grey.withOpacity(0.5),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: EdgeInsets.only(top: 30, left: 30, right: 30),
            child: Image.asset('assets/images/img.jpeg'),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: Colors.grey.withOpacity(0.3),
              ),
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                child: ListView(
                  children: <Widget>[
                    buildlabel("Full Name"),
                    SizedBox(
                      height: 10,
                    ),
                    buildInputContainer("Yash Mastud", _name),
                    SizedBox(
                      height: 20,
                    ),
                    buildlabel("Email Address"),
                    SizedBox(
                      height: 10,
                    ),
                    buildInputContainer("mastud.yash7@gmail.com", _email),
                    SizedBox(
                      height: 20,
                    ),
                    buildlabel("Description"),
                    SizedBox(
                      height: 10,
                    ),
                    buildInputContainer("MBBS", _description),
                    SizedBox(
                      height: 20,
                    ),
                    buildlabel("Age"),
                    SizedBox(
                      height: 10,
                    ),
                    buildInputContainer("19", _age),
                    SizedBox(
                      height: 20,
                    ),
                    buildlabel("Gender"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildElevatedButtonMale("  Male  ", "Male"),
                        buildElevatedButtonFemale("Female", "Female"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildlabel("Location"),
                    SizedBox(
                      height: 10,
                    ),
                    buildInputContainer("Thane", _location),
                    SizedBox(
                      height: 20,
                    ),
                    buildlabel("Referral"),
                    SizedBox(
                      height: 10,
                    ),
                    buildInputContainer("123456", _referralCode),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xffff38f1), Color(0xffba00ff)],
                            stops: [0, 1],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: InkWell(

                        onTap: () async {

                          getAvailableDoctors().then((value) => ref=value);
                          if(ref==_referralCode.text){
                            _repository.addDataToDbDoctor(
                                user,
                                _name.text,
                                _imageUrl,
                                _description.text,
                                _gender,
                                _age.text,
                                _location.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DoctorProfilePic()),
                            );
                          }
                          else{
                            showAlertDialogOnOkCallback();
                          }

                        },
                        child: Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ElevatedButton buildElevatedButtonMale(String buttonText, String gender) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0.5,
        primary: maleBtnColor,
        padding: EdgeInsets.symmetric(horizontal: 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () => {
        setState(() {
          updateBtnColor(gender: "Male");
          _hasBeenPressed = !_hasBeenPressed;
          _gender = gender;
        })
      },
      child: Text(buttonText,
          style:
              TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.black)),
    );
  }

  ElevatedButton buildElevatedButtonFemale(String buttonText, String gender) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0.5,
        primary: femaleBtnColor,
        padding: EdgeInsets.symmetric(horizontal: 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () => {
        setState(() {
          updateBtnColor(gender: "Female");
          _hasBeenPressed = !_hasBeenPressed;
          _gender = gender;
        })
      },
      child: Text(buttonText,
          style:
              TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.black)),
    );
  }

  Container buildInputContainer(
      hintText, TextEditingController textEditingController) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: TextField(
        controller: textEditingController,
        style: TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),
        decoration:
            InputDecoration(hintText: hintText, border: InputBorder.none),
      ),
    );
  }

  Container buildlabel(String labelText) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        labelText,
        style: TextStyle(
          color: Colors.black.withOpacity(0.7),
          fontSize: 15,
        ),
      ),
    );
  }
}

import 'package:docto/screens/doctor_home_page.dart';
import 'package:docto/screens/patient_homepage.dart';
import 'package:flutter/material.dart';
import 'package:docto/constants.dart';
import 'package:docto/resources/firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'doctor_signup.dart';
import 'package:docto/screens/patient_signup.dart';

class SignIn extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInState(),
      routes: {
        /*'/DoctorSignUpPage': (context) => DoctorSignUpPage(),
        '/PatientSignUpPage': (context) => PatientSignUpPage(),*/
      },
    );
  }
}

class SignInState extends StatefulWidget {
  @override
  _SignInStateState createState() => _SignInStateState();
}

class _SignInStateState extends State<SignInState> {
  FirebaseRepository _repository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Center(
              child: Text(
                "Welcome",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.07,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: EdgeInsets.all(30),
              child: Image.asset('assets/images/img.jpeg'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.075,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffff38f1), Color(0xffba00ff)],
                  stops: [0, 1],
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: InkWell(
                onTap: () => performLogin(0),
                child: Center(
                  child: Text(
                    "Sign up as a Patient",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize:  MediaQuery.of(context).size.height * 0.023,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.075,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Color(0xffebebeb),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: InkWell(
                onTap: () => performLogin(1),
                child: Center(
                  child: Text(
                    "Sign up as a Doctor",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize:  MediaQuery.of(context).size.height * 0.023,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void performLogin(int role) {
    print("Trying to perform login");
    if (role == 1) {
      //Doctor has logged in
      _repository.signIn().then((User user) {

        if (user != null) {
          authenticateUserDoctor(user);
        } else {
          print("There was an error");
        }
      });
    } else {
      //Patient has logged in
      _repository.signIn().then((User user) {

        if (user != null) {
          print(user.uid);
          authenticateUserPatient(user);
        } else {
          print("There was an error");
        }
      });
    }
  }

  void authenticateUserDoctor(User user) {
    _repository
        .authenticateUser(user, UniversalVariables.doctor)
        .then((bool isNewUser) {
      if (isNewUser) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorSignUpPage(
              user: user,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return DoctorHomePage();
          }),
        );
      }
    });
  }

  void authenticateUserPatient(User user) {
    _repository
        .authenticateUser(user, UniversalVariables.patient)
        .then((isNewUser) {
      if (isNewUser) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientSignUpPage(
              user: user,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return PatientHomePage();
          }),
        );
      }
    });
  }

  /*void openPatientSignUp() {
    Navigator.pushNamed(context, '/PatientSignUpPage');
  }

  void openDoctorSignUp() {
    Navigator.pushNamed(context, '/DoctorSignUpPage');
  }*/
}

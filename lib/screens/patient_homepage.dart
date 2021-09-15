import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docto/constants.dart';
import 'package:docto/provider/patient_provider.dart';
import 'package:docto/screens/chatscreens/chatlist_screen.dart';
import 'package:docto/screens/patient_profile.dart';
import 'package:docto/screens/pickup/pickup_layout.dart';
import 'package:docto/screens/symptoms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class PatientHomePage extends StatefulWidget {
  @override
  _PatientHomePageState createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  PatientProvider patientProvider;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    patientProvider = Provider.of<PatientProvider>(context, listen: false);
    patientProvider.refreshPatient();

    return PickupLayout(
      role: UniversalVariables.patient,
      scaffold: Scaffold(
        backgroundColor: Color(0xFFF2F6FE),
        appBar: AppBar(
          backgroundColor: Color(0xFFF2F6FE),
          elevation: 0.1,
          centerTitle: true,
          titleSpacing: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.17,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFE8E9FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                              MediaQuery.of(context).size.width * 0.03),
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.menu,
                      color: Color(0xFF585CE5),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 8.0,
                    child: Image.asset("assets/images/logo4.jpeg"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://cdn.icon-icons.com/icons2/2643/PNG/512/male_man_people_person_avatar_white_tone_icon_159363.png"),
                  radius: MediaQuery.of(context).size.height * 0.03,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.015,
              ),
              Align(
                alignment: Alignment(-1, 0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Dashboard",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.015,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height * 0.28,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/plant2.jpeg"),
                  ),
                  color: Color(0xFF585CE5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(MediaQuery.of(context).size.width * 0.025),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Welcome _____",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.040,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.040,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        "Lets check your health with us, Care with your health from now to get more live better.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.040,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF54C1FB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  MediaQuery.of(context).size.width * 0.01),
                            ),
                          ),
                        ),
                        onPressed: () {
                          chat(context);
                        },
                        child: Text(
                          "Consult",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.035,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                            MediaQuery.of(context).size.width * 0.02),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.volunteer_activism,
                          color: Color(0xFF595BDE),
                          size: MediaQuery.of(context).size.width * 0.08,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Text(
                          "Book scan and test",
                          style: TextStyle(
                            color: Color(0xFF595BDE),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                            MediaQuery.of(context).size.width * 0.02),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.medical_services_rounded,
                          color: Color(0xFF595BDE),
                          size: MediaQuery.of(context).size.width * 0.08,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Text(
                          "Medical shops nearby",
                          style: TextStyle(
                            color: Color(0xFF595BDE),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                            MediaQuery.of(context).size.width * 0.02),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.question_answer_outlined,
                          color: Color(0xFF595BDE),
                          size: MediaQuery.of(context).size.width * 0.08,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Text(
                          "FAQ",
                          style: TextStyle(
                            color: Color(0xFF595BDE),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    // width: MediaQuery.of(context).size.width * 0.001,
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                            MediaQuery.of(context).size.width * 0.02),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.help_center_rounded,
                          color: Color(0xFF595BDE),
                          size: MediaQuery.of(context).size.width * 0.08,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Text(
                          "Help",
                          style: TextStyle(
                            color: Color(0xFF595BDE),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                        icon: Icon(
                          Icons.medical_services_outlined,
                          color: Color(0xFF595BDE),
                          size: MediaQuery.of(context).size.width * 0.08,
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
                        icon: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientProfile(),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.person_outline,
                            color: Color(0xFF595BDE),
                            size: MediaQuery.of(context).size.width * 0.08,
                          ),
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

  void chat(BuildContext context) async {
    QuerySnapshot result = await firestore
        .collection(UniversalVariables.patient)
        .doc(patientProvider.getPatient.uid)
        .collection(UniversalVariables.CONTACTS_COLLECTION)
        .get();
    print('result.docs = ' + result.docs.toString());

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
}

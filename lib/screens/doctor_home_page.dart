import 'package:docto/models/request.dart';
import 'package:docto/provider/doctor_provider.dart';
import 'package:docto/screens/chatscreens/chatlist_screen.dart';
import 'package:docto/screens/doctor_profile.dart';
import 'package:docto/screens/pickup/pickup_layout.dart';
import 'package:docto/screens/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../resources/firebase_repository.dart';
import 'pickup/pickup_layout.dart';

class DoctorHomePage extends StatefulWidget {
  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  DoctorProvider doctorProvider;
  bool available = true;
  FirebaseRepository _repository = FirebaseRepository();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      doctorProvider.refreshDoctor();
    });
    super.initState();
  }

  void updateAvailableInfo(String uid, String key, bool value) {
    _repository.updateDataToDb(UniversalVariables.doctor, uid, key, value);
  }

  @override
  Widget build(BuildContext context) {
    doctorProvider = Provider.of<DoctorProvider>(context, listen: false);

    return PickupLayout(
      role: UniversalVariables.doctor,
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
                  backgroundImage: doctorProvider.getDoctor.profilePhoto == null
                      ? NetworkImage(
                          "https://cdn.icon-icons.com/icons2/2643/PNG/512/male_man_people_person_avatar_white_tone_icon_159363.png")
                      : NetworkImage(doctorProvider.getDoctor.profilePhoto),
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
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
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
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Available",
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.021,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 6),
                        FlutterSwitch(
                          height: MediaQuery.of(context).size.height * 0.032,
                          width: MediaQuery.of(context).size.width * 0.125,
                          inactiveColor: Colors.grey.shade400,
                          toggleSize: 22,
                          value: available,
                          onToggle: (val) {
                            setState(() {
                              available = val;
                              updateAvailableInfo(doctorProvider.getDoctor.uid,
                                  "availability", available);
                            });
                          },
                        ),
                        SizedBox(width: 6),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.055,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Requests(),
                            ),
                          );
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
                        icon: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorProfile(),
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
}

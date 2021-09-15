import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docto/constants.dart';
import 'package:docto/models/patient.dart';
import 'package:docto/provider/patient_provider.dart';
import 'package:docto/resources/firebase_repository.dart';
import 'package:docto/screens/doctor_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const activeColour = Colors.grey;
const inactiveColour = Colors.white;

class Symptoms extends StatefulWidget {
  @override
  _SymptomsState createState() => _SymptomsState();
}

class _SymptomsState extends State<Symptoms> {
  TextEditingController extraSymptoms = TextEditingController();
  PatientProvider patientProvider;
  String patientUid;
  // Patient patient = Patient();
  FirebaseRepository _repository = FirebaseRepository();

  String symptoms;
  bool flagCough = false;
  bool flagCold = false;
  bool flagFever = false;
  bool flagFatigue = false;
  bool flagBreathingProblems = false;
  bool flagVaccine = false;

  @override
  Widget build(BuildContext context) {
    patientProvider = Provider.of<PatientProvider>(context, listen: false);
    patientProvider.refreshPatient();
    patientUid = patientProvider.getPatient.uid;

    return Scaffold(
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
              width: MediaQuery.of(context).size.width * 0.1,
              // child: TextButton(
              //   child: Icon(
              //     Icons.arrow_back_ios,
              //     color: Color(0xFF585CE5),
              //   ),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        flagCough = !flagCough;
                      });
                    },
                    child: Card(
                      title: "Cough",
                      imageUrl: "assets/images/cough.jpeg",
                      col: flagCough ? activeColour : inactiveColour,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        flagCold = !flagCold;
                      });
                    },
                    child: Card(
                      title: "Cold",
                      imageUrl: "assets/images/cold.jpeg",
                      col: flagCold ? activeColour : inactiveColour,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        flagFever = !flagFever;
                      });
                    },
                    child: Card(
                      title: "Fever",
                      imageUrl: "assets/images/fever.jpeg",
                      col: flagFever ? activeColour : inactiveColour,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        flagFatigue = !flagFatigue;
                      });
                    },
                    child: Card(
                      title: "Fatigue",
                      imageUrl: "assets/images/fatigue.jpeg",
                      col: flagFatigue ? activeColour : inactiveColour,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        flagBreathingProblems = !flagBreathingProblems;
                      });
                    },
                    child: Card(
                      title: "Breathing Problems",
                      imageUrl: "assets/images/breathing problems.jpeg",
                      col:
                          flagBreathingProblems ? activeColour : inactiveColour,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        flagVaccine = !flagVaccine;
                      });
                    },
                    child: Card(
                      title: "Taken the vaccine?",
                      imageUrl: "assets/images/vaccine.jpeg",
                      col: flagVaccine ? activeColour : inactiveColour,
                    ),
                  ),
                ],
              ),
              SizedBox(
                // width: MediaQuery.of(context).size.width * 0.001,
                height: MediaQuery.of(context).size.height * 0.020,
              ),
              Text(
                "Other symptoms",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height * 0.020,
                ),
              ),
              SizedBox(
                // width: MediaQuery.of(context).size.width * 0.001,
                height: MediaQuery.of(context).size.height * 0.020,
              ),
              Align(
                alignment: Alignment(-1, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextField(
                      controller: extraSymptoms,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                            'Enter extra symptoms(Each separated by a comma)',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                // width: MediaQuery.of(context).size.width * 0.001,
                height: MediaQuery.of(context).size.height * 0.020,
              ),
              Align(
                alignment: Alignment(0, 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF585CE5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height * 0.025),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          symptoms = addSymptoms();
                        });
                        addSymptomsToFirebase();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DocList(
                                // symptoms: symptoms,
                                ),
                          ),
                        );
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String addSymptoms() {
    String temp = "";
    if (flagCough == true) {
      temp += "Cough,";
    }
    if (flagCold == true) {
      temp += "Cold,";
    }
    if (flagFever == true) {
      temp += "Fever,";
    }
    if (flagFatigue == true) {
      temp += "Fatigue,";
    }
    if (flagBreathingProblems == true) {
      temp += "Breathing Problems,";
    }
    if (flagVaccine == true) {
      temp += "Vaccination DONE,";
    } else {
      temp += "Vaccination NOT DONE,";
    }
    temp += extraSymptoms.text;
    return temp;
  }

  void addSymptomsToFirebase() async {
    await _repository.updateDataToDb(
        UniversalVariables.patient, patientUid, "symptoms", symptoms);
  }
}

class Card extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color col;

  Card({@required this.title, @required this.imageUrl, @required this.col});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.40,
      height: MediaQuery.of(context).size.height * 0.18,
      decoration: BoxDecoration(
        color: col,
        borderRadius: BorderRadius.all(
          Radius.circular(MediaQuery.of(context).size.width * 0.02),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child: Image(
              image: AssetImage(
                imageUrl,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.01,
          ),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF595BDE),
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:docto/models/contacts.dart';
import 'package:docto/provider/patient_provider.dart';
import 'package:docto/screens/patient_homepage.dart';
import 'package:docto/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:docto/screens/doc_info.dart';
import 'package:docto/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class DocList extends StatefulWidget {
  @override
  _DocListState createState() => _DocListState();
}

class _DocListState extends State<DocList> with TickerProviderStateMixin {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  AnimationController animationController;
  QuerySnapshot result;

  Future getAvailableDoctors() async {
    result = await firestore
        .collection(UniversalVariables.doctor)
        .where("availability", isEqualTo: true)
        .get();
    print(result.docs[0]);
    return result.docs;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: new Duration(microseconds: 1), vsync: this);
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final PatientProvider patientProvider =
        Provider.of<PatientProvider>(context);
    return FutureBuilder(
      future: getAvailableDoctors(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data.toString());
          return Scaffold(
            backgroundColor: UniversalVariables.bgColor,
            body: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CustomPaint(
                    painter: PathPainter(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: Icon(
                          Icons.menu,
                          color: Colors.black,
                          size: MediaQuery.of(context).size.height * 0.05,
                        ),
                        actions: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: [
                                  Color(0xFA66ABD5),
                                  Color(0xff3978c6),
                                ], stops: [
                                  0,
                                  1
                                ])),
                            child: Center(
                              child: Text(
                                Utils.getInitials(
                                    patientProvider.getPatient.name),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.035,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 14, right: 10, top: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Select a Doctor",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.05,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Text(
                              "Chief Doctors",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.035,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.006,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.68,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DocInfoPage(
                                            docUid: result.docs[index]['uid'],
                                            docName: result.docs[index]['name'],
                                            docDescription: result.docs[index]
                                                ['description'],
                                            docUrl: result.docs[index]
                                                ['profile_photo'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: createDocWidget(
                                      result.docs[index]['profile_photo'],
                                      result.docs[index]['name'],
                                      result.docs[index]['description'],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Contact contact = Contact(
                uid: patientProvider.getPatient.uid, adddedOn: Timestamp.now());
            firestore
                .collection('requests')
                .doc(patientProvider.getPatient.uid)
                .set(contact.toMap(contact));
            return AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Alert',
              desc:
                  'Currently there are no available doctors. Whenever one becomes available, he/she will revert to you. Sorry for the inconvenience caused.',
              btnOkOnPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PatientHomePage()));
              },
            );
          });
        }
        return Center(
          child: CircularProgressIndicator(
            valueColor: animationController.drive(
                ColorTween(begin: Colors.blueAccent, end: Colors.purpleAccent)),
          ),
        );
      },
    );
  }

  Container createDocWidget(
      String imgName, String docName, String description) {
    return Container(
      child: InkWell(
        child: Container(
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(MediaQuery.of(context).size.height * 0.017),
            ),
            color: UniversalVariables.docContentBgColor,
          ),
          child: Container(
            padding: EdgeInsets.all(3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(imgName),
                  backgroundColor: Colors.transparent,
                  radius: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 13.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Dr. $docName",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.026,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.0225,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint();
    paint.color = Color(0x413F70D8);

    Path path = new Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.3, 0);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.03,
        size.width * 0.42, size.height * 0.17);
    path.quadraticBezierTo(
        size.width * 0.35, size.height * 0.32, 0, size.height * 0.29);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

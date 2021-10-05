import 'package:docto/models/contacts.dart';
import 'package:docto/provider/doctor_provider.dart';
import 'package:docto/provider/patient_provider.dart';
import 'package:docto/resources/firebase_methods.dart';
import 'package:docto/screens/chatscreens/widgets/contact_view.dart';
import 'package:docto/screens/chatscreens/widgets/usercircle.dart';
import 'package:docto/screens/doctor_home_page.dart';
import 'package:docto/screens/doctor_profile.dart';
import 'package:flutter/material.dart';
import 'package:docto/constants.dart';
import 'package:docto/widgets/appbar.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  final String role;
  ChatListScreen({this.role});

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Color(0xFF585CE5),
        ),
        onPressed: () {},
      ),
      title: UserCircle(role: role),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F6FE), //add in constants
      appBar: customAppBar(context),
      body: ChatListContainer(role: role),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final String role;
  ChatListContainer({this.role});
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);
    PatientProvider patientProvider = Provider.of<PatientProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          color: Color(0xFFF2F6FE),
          height: MediaQuery.of(context).size.height * 0.815,
          child: StreamBuilder(
              stream: role == UniversalVariables.patient
                  ? _firebaseMethods.fetchContactsOfPatients(
                      userId: patientProvider.getPatient.uid)
                  : _firebaseMethods.fetchContactsOfDoctors(
                      userId: doctorProvider.getDoctor.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var docList = snapshot.data.docs;
                  if (docList.isEmpty) {
                    /*return QuietBox();*/
                    return Container();
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.01,
                    ),
                    itemCount: docList.length,
                    itemBuilder: (context, index) {
                      /*Contact contact = Contact.fromMap(docList[index].data);*/
                      return ContactView(
                        contact: Contact(
                          uid: docList[index]['contact_id'],
                          adddedOn: docList[index]['added_on'],
                        ),
                        role: role,
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
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
              topLeft: Radius.circular(MediaQuery.of(context).size.width * 2.0),
              topRight:
                  Radius.circular(MediaQuery.of(context).size.width * 2.0),
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
                  icon: Icon(
                    Icons.chat,
                    color: Color(0xFF595BDE),
                    size: MediaQuery.of(context).size.width * 0.08,
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
    );
  }
}

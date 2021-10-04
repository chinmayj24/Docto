import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docto/constants.dart';
import 'package:docto/enum/view_state.dart';
import 'package:docto/models/doctor.dart';
import 'package:docto/models/patient.dart';
import 'package:docto/popup_button_chatpage.dart';
import 'package:docto/provider/doctor_provider.dart';
import 'package:docto/provider/image_upload_provider.dart';
import 'package:docto/provider/patient_provider.dart';
import 'package:docto/screens/doctor_home_page.dart';
import 'package:docto/screens/media_screen.dart';
import 'package:docto/screens/patient_homepage.dart';
import 'package:docto/utils/call_utilities.dart';
import 'package:docto/utils/permissions.dart';
import 'package:docto/utils/utilities.dart';
import 'package:docto/widgets/appbar.dart';
import 'package:docto/widgets/customtile.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:docto/resources/firebase_repository.dart';
import 'package:docto/models/message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/message.dart';

class MainChatPage extends StatefulWidget {
  final String role;
  final Patient patient;
  final Doctor doctor;

  MainChatPage({this.role, this.doctor, this.patient});

  @override
  _MainChatPageState createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> {
  Patient patient;
  Doctor doctor;
  FirebaseRepository _repository = FirebaseRepository();
  TextEditingController textFieldController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  PatientProvider patientProvider;
  DoctorProvider doctorProvider;

  bool isWriting = false;
  bool showEmojiPicker = false;
  String role, type;
  ImageUploadProvider _imageUploadProvider;

  FocusNode textFieldFocus = FocusNode();

  @override
  void initState() {
    role = widget.role;

    if (role == UniversalVariables.patient) {
      doctor = widget.doctor;
      type = 'Report';
    } else {
      patient = widget.patient;
      type = 'Prescription';
    }
    super.initState();
  }

  pickImage({@required ImageSource source, @required String type}) async {
    File selectedImage = await Utils.pickImage(source: source);
    _repository.uploadImage(
      type: type,
      image: selectedImage,
      receiverId: role == UniversalVariables.patient ? doctor.uid : patient.uid,
      senderId: role == UniversalVariables.patient
          ? patientProvider.getPatient.uid
          : doctorProvider.getDoctor.uid,
      imageUploadProvider: _imageUploadProvider,
    );
  }

  showKeyboard() => textFieldFocus.requestFocus();
  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    patientProvider = Provider.of<PatientProvider>(context);
    doctorProvider = Provider.of<DoctorProvider>(context);

    if (patient != null || doctor != null) {
      return Scaffold(
        backgroundColor: Color(0xFFF2F6FE),
        appBar: customAppBar(context),
        body: Column(
          children: <Widget>[
            Flexible(
              child: messageList(),
            ),
            _imageUploadProvider.getViewState == ViewState.LOADING
                ? Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 15),
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            chatControls(),
            showEmojiPicker ? Container(child: emojiContainer()) : Container(),
          ],
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });
        textFieldController.text = textFieldController.text + emoji.emoji;
      },
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: firestore
          .collection(UniversalVariables.MESSAGES_COLLECTION)
          .doc(role == UniversalVariables.patient
              ? patientProvider.getPatient.uid
              : doctorProvider.getDoctor.uid)
          .collection(
              role == UniversalVariables.patient ? doctor.uid : patient.uid)
          .orderBy(UniversalVariables.TIMESTAMP_FIELD, descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.docs.length,
          reverse: true,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data.docs[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    patientProvider = Provider.of<PatientProvider>(context);
    doctorProvider = Provider.of<DoctorProvider>(context);
    Message _message = Message.fromMap(snapshot.data());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId ==
                (role == UniversalVariables.patient
                    ? patientProvider.getPatient.uid
                    : doctorProvider.getDoctor.uid)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId ==
                (role == UniversalVariables.patient ? doctor.uid : patient.uid)
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Color(0xFF6d71f9),
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    return message.type != UniversalVariables.MESSAGE_TYPE_IMAGE
        ? Text(
            message.message,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0, //TODO: change font
            ),
          )
        : Image.network(message.photoUrl);
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: Colors.white,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: Icon(
                          Icons.close,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20, //TODO: change font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          pickImage(source: ImageSource.gallery, type: type);
                        },
                        child: ModalTile(
                          title: type,
                          subtitle: "Share $type",
                          icon: Icons.image_outlined,
                        ),
                      ),
                      ModalTile(
                          title: type,
                          subtitle: "Share files",
                          icon: Icons.camera_alt_outlined),
                    ],
                  ),
                ),
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.add,
                size: MediaQuery.of(context).size.height * 0.05,
                color: Color(0xFF6d71f9),
              ),
            ),
          ),
          SizedBox(
            width: 5, //TODO:change
          ),
          Expanded(
            child: Stack(alignment: Alignment.bottomRight, children: [
              TextField(
                controller: textFieldController,
                focusNode: textFieldFocus,
                onTap: () => hideEmojiContainer(),
                style: TextStyle(
                  color: Colors.black,
                ),
                onChanged: (val) {
                  (val.length > 0 && val.trim() != "")
                      ? setWritingTo(true)
                      : setWritingTo(false);
                },
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(
                    color: UniversalVariables.greyColor,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                            MediaQuery.of(context).size.height * 0.25),
                      ),
                      borderSide: BorderSide.none),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  filled: true,
                  fillColor: Colors.white, //UniversalVariables.separatorColor,
                ),
              ),
              IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () {
                  if (!showEmojiPicker) {
                    //keyboard is visible
                    hideKeyboard();
                    showEmojiContainer();
                  } else {
                    //keyboard is hidden
                    showKeyboard();
                    hideEmojiContainer();
                  }
                },
                icon: Icon(
                  Icons.emoji_emotions_outlined,
                  color: Color(0xFF6d71f9),
                ),
              ),
            ]),
          ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF6d71f9),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.02),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: Colors.white,
                    ),
                    onPressed: () => sendMessage(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  sendMessage() {
    var text = textFieldController.text;
    Message _message = Message(
      receiverId: role == UniversalVariables.patient ? doctor.uid : patient.uid,
      senderId: role == UniversalVariables.patient
          ? patientProvider.getPatient.uid
          : doctorProvider.getDoctor.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text',
    );
    setState(() {
      isWriting = false;
    });
    textFieldController.text = "";
    _repository.addMessageToDb(
        _message,
        role == UniversalVariables.patient
            ? patientProvider.getPatient.uid
            : doctorProvider.getDoctor.uid,
        role == UniversalVariables.patient ? doctor.uid : patient.uid);
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Color(0xFF6d71f9),
          size: MediaQuery.of(context).size.height * 0.035,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: GestureDetector(
        child: Text(
          role == UniversalVariables.patient
              ? "Dr." + doctor.name
              : patient.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.height * 0.03,
            fontWeight: FontWeight.w400,
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MediaScreen(
                  role: role,
                  patient: role == UniversalVariables.patient
                      ? patientProvider.getPatient
                      : patient,
                  doctor: role == UniversalVariables.doctor
                      ? doctorProvider.getDoctor
                      : doctor,
                ),
              ));
        },
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.videocam_outlined,
              color: Color(0xFF6d71f9),
              size: MediaQuery.of(context).size.height * 0.035,
            ),
            onPressed: () async {
              if (role == UniversalVariables.patient) {
                await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? CallUtils.dialPatientToDoctor(
                        from: patientProvider.getPatient,
                        to: doctor,
                        context: context)
                    : {};
              } else {
                await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? CallUtils.dialDoctorToPatient(
                        from: doctorProvider.getDoctor,
                        to: patient,
                        context: context)
                    : {};
              }
            }),
        IconButton(
          icon: Icon(
            Icons.local_phone_outlined,
            color: Color(0xFF6d71f9),
            size: MediaQuery.of(context).size.height * 0.035,
          ),
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF6d71f9),
          ),
          onSelected: choiceAction,
          itemBuilder: (BuildContext context) {
            return PopupButtonChatPage.choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  void choiceAction(String choice) {
    if (choice == PopupButtonChatPage.EndDiagnosis) {
      endDiagnosis();
    }
  }

  void endDiagnosis() async {
    if (role == UniversalVariables.patient) {
      String senderUid = patientProvider.getPatient.uid;
      String receiverUid = doctor.uid;

      //Emptying Symptoms
      await _repository.updateDataToDb(
          UniversalVariables.patient, senderUid, "symptoms", "");

      //Deleting Contacts
      await firestore
          .collection(UniversalVariables.patient)
          .doc(senderUid)
          .collection(UniversalVariables.CONTACTS_COLLECTION)
          .doc(receiverUid)
          .delete();

      await firestore
          .collection(UniversalVariables.doctor)
          .doc(receiverUid)
          .collection(UniversalVariables.CONTACTS_COLLECTION)
          .doc(senderUid)
          .delete();

      //Deleting Messages
      await firestore
          .collection(UniversalVariables.MESSAGES_COLLECTION)
          .doc(senderUid)
          .collection(receiverUid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      await firestore
          .collection(UniversalVariables.MESSAGES_COLLECTION)
          .doc(receiverUid)
          .collection(senderUid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      if (role == UniversalVariables.doctor) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DoctorHomePage()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PatientHomePage()));
      }
    } else {
      String senderUid = doctorProvider.getDoctor.uid;
      String receiverUid = patient.uid;

      //Emptying Symptoms
      await _repository.updateDataToDb(
          UniversalVariables.patient, receiverUid, "symptoms", "");

      //Deleting Contacts
      await firestore
          .collection(UniversalVariables.doctor)
          .doc(senderUid)
          .collection(UniversalVariables.CONTACTS_COLLECTION)
          .doc(receiverUid)
          .delete();

      await firestore
          .collection(UniversalVariables.patient)
          .doc(receiverUid)
          .collection(UniversalVariables.CONTACTS_COLLECTION)
          .doc(senderUid)
          .delete();

      //Deleting Messages
      await firestore
          .collection(UniversalVariables.MESSAGES_COLLECTION)
          .doc(senderUid)
          .collection(receiverUid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      await firestore
          .collection(UniversalVariables.MESSAGES_COLLECTION)
          .doc(receiverUid)
          .collection(senderUid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      if (role == UniversalVariables.doctor) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DoctorHomePage()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PatientHomePage()));
      }
    }
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(icon,
              color: Color(0xFF6d71f9),
              size: MediaQuery.of(context).size.height * 0.05),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: MediaQuery.of(context).size.height * 0.02,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.height * 0.03,
          ),
        ),
      ),
    );
  }
}

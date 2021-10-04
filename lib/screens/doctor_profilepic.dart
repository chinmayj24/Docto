import 'dart:io';
import 'package:docto/constants.dart';
import 'package:docto/resources/firebase_repository.dart';
import 'package:docto/screens/doctor_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DoctorProfilePic extends StatefulWidget {
  @override
  _DoctorProfilePicState createState() => _DoctorProfilePicState();
}

class _DoctorProfilePicState extends State<DoctorProfilePic> {
  User user;
  FirebaseRepository _repository = FirebaseRepository();

  String _imageUrl;
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    await _repository.currentUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  _imgFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _imgFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.bgColor,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CustomPaint(
                  painter: PathPainter(),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 17, top: 25, right: 17),
                child: ListView(
                  children: [
                    Text(
                      "Profile Picture",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: CircleAvatar(
                              radius: 100,
                              backgroundColor: Color(0xffCFE3F7),
                              child: _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(90),
                                      child: Image.file(
                                        _image,
                                        width: 190,
                                        height: 190,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(90)),
                                      width: 182,
                                      height: 182,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[800],
                                        size: 45,
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.blue,
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
                      height: 30,
                    ),
                    Text(
                      "Please select an image to Display",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xffff38f1), Color(0xffba00ff)],
                          stops: [0, 1],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: InkWell(
                        onTap: () async {
                          await uploadProfPicImageToFirebase();
                          _repository.updateDataToDb(UniversalVariables.doctor,
                              user.uid, "profile_photo", _imageUrl);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorHomePage()),
                          );
                        },
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Container(
  //       height: MediaQuery.of(context).size.height,
  //       width: MediaQuery.of(context).size.width,
  //       padding: EdgeInsets.only(left: 17, top: 25, right: 17),
  //       child: ListView(
  //         children: [
  //           Text(
  //             "Profile Picture",
  //             style: TextStyle(
  //               fontSize: 30,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           SizedBox(
  //             height: 25,
  //           ),
  //           Center(
  //             child: Stack(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     _showPicker(context);
  //                   },
  //                   child: CircleAvatar(
  //                     radius: 100,
  //                     backgroundColor: Color(0xffCFE3F7),
  //                     child: _image != null
  //                         ? ClipRRect(
  //                             borderRadius: BorderRadius.circular(90),
  //                             child: Image.file(
  //                               _image,
  //                               width: 190,
  //                               height: 190,
  //                               fit: BoxFit.fitHeight,
  //                             ),
  //                           )
  //                         : Container(
  //                             decoration: BoxDecoration(
  //                                 color: Colors.grey[200],
  //                                 borderRadius: BorderRadius.circular(90)),
  //                             width: 182,
  //                             height: 182,
  //                             child: Icon(
  //                               Icons.camera_alt,
  //                               color: Colors.grey[800],
  //                               size: 45,
  //                             ),
  //                           ),
  //                   ),
  //                 ),
  //                 Positioned(
  //                   bottom: 0,
  //                   right: 0,
  //                   child: Container(
  //                     height: 35,
  //                     width: 35,
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       border: Border.all(
  //                         width: 2,
  //                         color: Theme.of(context).scaffoldBackgroundColor,
  //                       ),
  //                       color: Colors.blue,
  //                     ),
  //                     child: Icon(
  //                       Icons.edit,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: 28,
  //           ),
  //           Text(
  //             "Please select an image to Display",
  //             style: TextStyle(
  //               fontSize: 19,
  //               fontWeight: FontWeight.w200,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           Container(
  //             height: 50,
  //             width: MediaQuery.of(context).size.width * 0.3,
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 colors: [Color(0xffff38f1), Color(0xffba00ff)],
  //                 stops: [0, 1],
  //               ),
  //               borderRadius: BorderRadius.all(Radius.circular(15)),
  //             ),
  //             child: InkWell(
  //               onTap: () async {
  //                 await uploadProfPicImageToFirebase();
  //                 _repository.updateDataToDb(UniversalVariables.doctor,
  //                     user.uid, "profile_photo", _imageUrl);
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => DoctorHomePage()),
  //                 );
  //               },
  //               child: Center(
  //                 child: Text(
  //                   "Sign Up",
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: 15,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  uploadProfPicImageToFirebase() async {
    String fileName = user.uid;
    firebase_storage.Reference firebaseStorageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('profilePics/$fileName');
    var snapshot = await firebaseStorageRef.putFile(_image);
    await snapshot.ref.getDownloadURL().then((String result) {
      setState(() {
        _imageUrl = result;
      });
    });
  }
}

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint();

    paint.color = UniversalVariables.path1Color;
    paint.style = PaintingStyle.fill;
    var path = new Path();

    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.35, size.height * 0.40,
        size.width * 0.58, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.72, size.height * 0.8,
        size.width * 0.92, size.height * 0.8);
    path.quadraticBezierTo(
        size.width * 0.98, size.height * 0.8, size.width, size.height * 0.82);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:docto/provider/doctor_provider.dart';
import 'package:docto/provider/image_upload_provider.dart';
import 'package:docto/provider/patient_provider.dart';
import 'package:provider/provider.dart';
import 'provider/image_upload_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:docto/screens/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DoctoApp());
}

class DoctoApp extends StatefulWidget {
  @override
  _DoctoAppState createState() => _DoctoAppState();
}

class _DoctoAppState extends State<DoctoApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
      ],
      child: MaterialApp(
        title: 'Docto App',
        debugShowCheckedModeBanner: false,
        home: SignIn(),
      ),
    );
  }
}

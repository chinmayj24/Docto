import 'dart:math';

import 'package:docto/constants.dart';
import 'package:docto/models/call.dart';
import 'package:docto/models/doctor.dart';
import 'package:docto/models/patient.dart';
import 'package:docto/resources/call_methods.dart';
import 'package:docto/screens/callscreens/call_screen.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final url =
      'data:image/png;base64,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';
  static final CallMethods callMethods = CallMethods();
  static dialPatientToDoctor({Patient from, Doctor to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: url,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );
    bool callMade = await callMethods.makeCall(call);
    call.hasDialled = true;
    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CallScreen(call: call, role: UniversalVariables.patient)));
    }
  }

  static dialDoctorToPatient({Doctor from, Patient to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: url,
      channelId: Random().nextInt(1000).toString(),
    );
    bool callMade = await callMethods.makeCall(call);
    call.hasDialled = true;
    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CallScreen(call: call, role: UniversalVariables.doctor)));
    }
  }
}

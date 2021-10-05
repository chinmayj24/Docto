import 'package:flutter/material.dart';

class UniversalVariables {
  static final Color blueColor = Color(0xff2b9ed4);
  static final Color blackColor = Color(0xff19191b);
  static final Color greyColor = Color(0xff8f8f8f);
  static final Color userCircleBackground = Color(0xff2b2b33);
  static final Color onlineDotColor = Color(0xff46dc64);
  static final Color lightBlueColor = Color(0xff0077d7);
  static final Color separatorColor = Color(0xff272c35);

  static final Color gradientColorStart = Color(0xff00b6f3);
  static final Color gradientColorEnd = Color(0xff0184dc);

  static final Color senderColor = Color(0xff2b343b);
  static final Color receiverColor = Color(0xff1e2225);
  static final Color bgColor = Color(0xffF9F9F9);
  static final Color path1Color = Color(0xffE4E2FF);
  static final Color getStartedColorStart = Color(0xff54D579);
  static final Color getStartedColorEnd = Color(0xff00AABF);
  static final Color path2Color = Color(0xffcef4e8);
  static final Color docBgColor = Color(0xffE9B5FF);
  static final Color docContentBgColor = Color(0xffECF0F5);
  static final Color dateBgColor = Color(0xffD5E0FA);
  static final Color dateColor = Color(0xff3479C0);

  static final mPrimaryTextColor = Color(0xFF25257E);
  static final mTitleTextColor = Color(0xFF25257E);
  static final mBackgroundColor = Color(0xFFFDFCFF);
  static final mSecondBackgroundColor = Color(0xFFBCCBF3);
  static final mButtonColor = Color(0xFF5063FF);
  static final mYellowColor = Color(0xFFFB7B11);

  static final Gradient fabGradient = LinearGradient(
    colors: [gradientColorStart, gradientColorEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final String doctor = "doctors";
  static final String patient = "patients";

  // ignore: non_constant_identifier_names
  static final String MESSAGES_COLLECTION = "messages";
  // ignore: non_constant_identifier_names
  static final String CONTACTS_COLLECTION = "contacts";
  // ignore: non_constant_identifier_names
  static final String TIMESTAMP_FIELD = "timestamp";
  // ignore: non_constant_identifier_names
  static final String CALL_COLLECTION = "calls";
  // ignore: non_constant_identifier_names
  static final String MESSAGE_TYPE_IMAGE = "image";
  // ignore: non_constant_identifier_names
  static final String REQUESTS_COLLECTION = "requests";
}

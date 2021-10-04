import 'package:docto/models/call.dart';
import 'package:docto/resources/call_methods.dart';
import 'package:docto/screens/callscreens/call_screen.dart';
import 'package:docto/utils/permissions.dart';
import 'package:flutter/material.dart';

class PickupScreen extends StatelessWidget {
  final CallMethods callMethods = CallMethods();
  final Call call;
  final String role;

  PickupScreen({@required this.call, @required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Incoming...',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Image.network(
              call.callerPic,
              height: 150,
              width: 150,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              call.callerName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    await callMethods.endCall(call: call);
                  },
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                ),
                SizedBox(
                  width: 25,
                ),
                IconButton(
                  onPressed: () async =>
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CallScreen(call: call, role: role),
                              ),
                            )
                          : {},
                  icon: Icon(Icons.call),
                  color: Colors.green,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

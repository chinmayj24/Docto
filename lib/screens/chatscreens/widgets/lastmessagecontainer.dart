import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docto/models/message.dart';
import 'package:docto/provider/doctor_provider.dart';
import 'package:docto/provider/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LastMessageContainer extends StatelessWidget {
  final stream;
  LastMessageContainer({@required this.stream});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: stream,
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            var docList = snapshot.data.docs;
            if(docList.isNotEmpty){
              Message message = Message.fromMap(docList.last.data());
              return SizedBox(
                width: MediaQuery.of(context).size.width*0.6,
                child: Text(
                  message.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(

                    color: Colors.grey,
                    fontSize: 14,
                    
                  ),
                ),
              );
            }
            return Text("No message",style: TextStyle(

              color: Colors.grey,
              fontSize: 14,

            ),);
          }
          return Text("...",style: TextStyle(

            color: Colors.grey,
            fontSize: 14,

          ),);

        });
  }
}

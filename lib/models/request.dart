import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  String uid;
  Timestamp adddedOn;
  Request({
    this.uid,
    this.adddedOn,
  });
  Map toMap(Request contact) {
    var data = Map<String, dynamic>();
    data['request_id'] = contact.uid;
    data['added_on'] = contact.adddedOn;
    return data;
  }

  Request.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['request_id'];
    this.adddedOn = mapData['added_on'];
  }
}

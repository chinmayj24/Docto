import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String uid;
  Timestamp adddedOn;
  Contact({
    this.uid,
    this.adddedOn,
  });
  Map toMap(Contact contact) {
    var data = Map<String, dynamic>();
    data['contact_id'] = contact.uid;
    data['added_on'] = contact.adddedOn;
    return data;
  }

  Contact.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['contact_id'];
    this.adddedOn = mapData['added_on'];
  }
}

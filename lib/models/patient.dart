class Patient {
  String uid;
  String name;
  String age;
  String email;
  String gender;
  String location;
  String symptoms;

  Patient({
    this.uid,
    this.name,
    this.email,
    this.gender,
    this.age,
    this.location,
    this.symptoms,
  });

  Map toMap(Patient patient) {
    var data = Map<String, dynamic>();
    data['uid'] = patient.uid;
    data['name'] = patient.name;
    data['email'] = patient.email;
    data["gender"] = patient.gender;
    data["age"] = patient.age;
    data["location"] = patient.location;
    data["symptoms"] = patient.symptoms;

    return data;
  }

  Patient.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.gender = mapData['gender'];
    this.age = mapData['age'];
    this.location = mapData["location"];
    this.symptoms = mapData["symptoms"];
  }
}

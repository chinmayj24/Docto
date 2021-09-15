class Doctor {
  String uid;
  String name;
  String email;
  String description;
  String gender;
  String profilePhoto;
  String age;
  bool availability;
  String location;
  int patientCounter;

  Doctor({
    this.uid,
    this.name,
    this.email,
    this.description,
    this.gender,
    this.profilePhoto,
    this.age,
    this.location,
    this.availability = true,
    this.patientCounter,
  });

  Map toMap(Doctor user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['description'] = user.description;
    data["gender"] = user.gender;
    data["age"] = user.age;
    data["location"] = user.location;
    data["profile_photo"] = user.profilePhoto;
    data["availability"] = user.availability;
    data["patientCounter"] = 0;
    return data;
  }

  Doctor.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.description = mapData['description'];
    this.gender = mapData['gender'];
    this.age = mapData['age'];
    this.location = mapData['location'];
    this.profilePhoto = mapData['profile_photo'];
    this.availability = mapData['availability'];
    this.patientCounter = mapData['patientCounter'];
  }
}

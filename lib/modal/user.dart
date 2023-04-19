class OurUser {
  String? uid = "";
  String? name = "";
  String? mobile = "";
  String? email = "";
  List? crops = [];
  List? sensorData = [];

  OurUser({
    required this.uid,
    required this.mobile,
    required this.email,
    required this.crops,
    required this.sensorData,
  });
}
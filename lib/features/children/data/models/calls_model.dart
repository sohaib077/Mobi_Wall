
class CallsModel {
  String number;
  String? name;
  Duration duration;
  String type;
  DateTime date;

  CallsModel({
    required this.number,
    required this.name,
    required this.duration,
    required this.type,
    required this.date,
  });

  factory CallsModel.fromJson(Map<String, dynamic> json) {
    return CallsModel(
      number: json['number'],
      name: json['name'],
      duration: Duration(seconds: int.parse(json['duration'])),
      type: json['type'],
      date: DateTime.fromMillisecondsSinceEpoch(int.parse(json['date'])),
    );
  }
}

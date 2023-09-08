class NotificationModel {
  List<Waktu>? waktu;

  NotificationModel({this.waktu});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['waktu'] != null) {
      waktu = <Waktu>[];
      json['waktu'].forEach((v) {
        waktu!.add(Waktu.fromJson(v));
      });
    }
  }

}

class Waktu {
  String? time;
  String? kondisihari;
  List<Pesan>? pesan;

  Waktu({this.time, this.kondisihari, this.pesan});

  Waktu.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    kondisihari = json['Kondisihari'];
    if (json['pesan'] != null) {
      pesan = <Pesan>[];
      json['pesan'].forEach((v) {
        pesan!.add(Pesan.fromJson(v));
      });
    }
  }


}

class Pesan {
  int? id;
  String? time;
  String? title;
  String? description;
  String? condition;
  String? timenya;

  Pesan(
      {this.id,
      this.time,
      this.title,
      this.description,
      this.condition,
      this.timenya});

  Pesan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    title = json['title'];
    description = json['description'];
    condition = json['condition'];
    timenya = json['timenya'];
  }


}
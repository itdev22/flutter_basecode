class KotaModel {
  int? id;
  String? nama;

  KotaModel({this.id, this.nama});

  factory KotaModel.fromJson(Map<String, dynamic> data) =>
      KotaModel(id: data['id'], nama: data['nama']);
}

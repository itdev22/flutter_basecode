class JenisPasarModel {
  int? id;
  String? nama;

  JenisPasarModel({
    this.id,
    this.nama,
  });

  factory JenisPasarModel.fromJson(Map<String, dynamic> data) =>
      JenisPasarModel(
        id: data['id'],
        nama: data['nama'],
      );
}

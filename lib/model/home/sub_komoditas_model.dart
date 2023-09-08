class SubKomoditasModel {
  int? id;
  int? komoditasId;
  String? nama;
  int? dk;
  int? dp;
  int? userId;
  String? tanggal;

  SubKomoditasModel(
      {this.id,
      this.komoditasId,
      this.nama,
      this.dk,
      this.dp,
      this.userId,
      this.tanggal});

  factory SubKomoditasModel.fromJson(Map<String, dynamic> data) =>
      SubKomoditasModel(
          id: data['id'],
          komoditasId: data['komoditas_id'],
          nama: data['nama'],
          dk: data['dk'],
          dp: data['dp'],
          userId: data['user_id'],
          tanggal: data['tanggal']);
}

class KomoditasModel {
  int? id;
  int? pasarId;
  int? kotaId;
  String? nama;
  int? dk;
  int? dp;

  KomoditasModel(
      {this.id, this.pasarId, this.kotaId, this.nama, this.dk, this.dp});

  factory KomoditasModel.fromJson(Map<String, dynamic> data) => KomoditasModel(
      id: data['id'],
      pasarId: data['pasar_id'],
      kotaId: data['kota_id'],
      nama: data['nama'],
      dk: data['dk'],
      dp: data['dp']);
}

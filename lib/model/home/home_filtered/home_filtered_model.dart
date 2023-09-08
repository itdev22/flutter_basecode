class HomeFilteredModel {
  int? id;
  int? pemilikId;
  int? harga;
  int? dk;
  int? dp;
  String? tanggal;
  String? klasifikasi;
  Persentase? persentase;
  Pemilik? pemilik;

  HomeFilteredModel(
      {this.id,
      this.pemilikId,
      this.harga,
      this.dk,
      this.dp,
      this.tanggal,
      this.klasifikasi,
      this.persentase,
      this.pemilik});

  HomeFilteredModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pemilikId = json['pemilik_id'];
    harga = json['harga'];
    dk = json['dk'];
    dp = json['dp'];
    tanggal = json['tanggal'];
    klasifikasi = json['klasifikasi'];
    persentase = json['persentase'] != null
        ? Persentase.fromJson(json['persentase'])
        : null;
    pemilik =
        json['pemilik'] != null ? Pemilik.fromJson(json['pemilik']) : null;
  }
}

class Persentase {
  String? opsi;
  String? sekarang;
  String? kemaren;
  PersentaseDetail? persentaseDetail;
  String? klasifikasi;

  Persentase(
      {this.opsi,
      this.sekarang,
      this.kemaren,
      this.persentaseDetail,
      this.klasifikasi});

  Persentase.fromJson(Map<String, dynamic> json) {
    opsi = json['opsi'];
    sekarang = json['sekarang'];
    kemaren = json['kemaren'];
    persentaseDetail = json['persentase'] != null
        ? PersentaseDetail.fromJson(json['persentase'])
        : null;
    klasifikasi = json["klasifikasi"];
  }
}

class PersentaseDetail {
  String? warna;
  int? value;

  PersentaseDetail({this.warna, this.value});

  PersentaseDetail.fromJson(Map<String, dynamic> json) {
    warna = json['warna'];
    value = json['value'];
  }
}

class Pemilik {
  int? id;
  int? kotaId;
  int? pasarId;
  Kota? kota;
  Subkomoditas? subkomoditas;

  Pemilik({this.id, this.kotaId, this.pasarId, this.kota, this.subkomoditas});

  Pemilik.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kotaId = json['kota_id'];
    pasarId = json['pasar_id'];
    kota = json['kota'] != null ? Kota.fromJson(json['kota']) : null;
    subkomoditas = json['subkomoditas'] != null
        ? Subkomoditas.fromJson(json['subkomoditas'])
        : null;
  }
}

class Kota {
  int? id;
  String? nama;

  Kota({
    this.id,
    this.nama,
  });

  Kota.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
  }
}

class Subkomoditas {
  int? id;
  int? komoditasId;
  String? nama;
  String? foto;
  String? tanggal;

  Subkomoditas({
    this.id,
    this.komoditasId,
    this.nama,
    this.foto,
    this.tanggal,
  });

  Subkomoditas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    komoditasId = json['komoditas_id'];
    nama = json['nama'];
    foto = json['foto'];
    tanggal = json['tanggal'];
  }
}

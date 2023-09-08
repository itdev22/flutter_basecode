import 'package:mobile_lapalapa/model/home/kota_model.dart';

class HistogramModel {
  int? id;
  int? komoditasId;
  int? subkomoditasId;
  int? kotaId;
  int? pasarId;
  Rekapharga? rekapharga;
  Persentase? persentase;
  KotaModel? kota;

  HistogramModel(
      {this.id,
      this.komoditasId,
      this.subkomoditasId,
      this.kotaId,
      this.pasarId,
      this.persentase,
      this.rekapharga,
      this.kota});

  HistogramModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    komoditasId = json['komoditas_id'];
    subkomoditasId = json['subkomoditas_id'];
    kotaId = json['kota_id'];
    pasarId = json['pasar_id'];
    persentase = json['persentase'] != null
        ? Persentase.fromJson(json['persentase'])
        : null;
    rekapharga = json['rekapharga'] != null
        ? Rekapharga.fromJson(json['rekapharga'])
        : null;
    kota = json['kota'] != null ? KotaModel.fromJson(json['kota']) : null;
  }
}

class Rekapharga {
  int? id;
  int? pemilikId;
  int? harga;
  int? dk;
  int? dp;
  String? tanggal;

  Rekapharga({
    this.id,
    this.pemilikId,
    this.harga,
    this.dk,
    this.dp,
    this.tanggal,
  });

  Rekapharga.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pemilikId = json['pemilik_id'];
    harga = json['harga'];
    dk = json['dk'];
    dp = json['dp'];
    tanggal = json['tanggal'];
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

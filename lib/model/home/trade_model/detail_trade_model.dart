import 'package:mobile_lapalapa/model/home/kota_model.dart';

class DetailTradeModel {
  int? id;
  int? komoditasId;
  String? nama;
  String? tanggal;
  List<Pemilik>? pemilik;
  Semuakota? semuakota;

  DetailTradeModel(
      {this.id,
      this.komoditasId,
      this.nama,
      this.tanggal,
      this.pemilik,
      this.semuakota});

  DetailTradeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    komoditasId = json['komoditas_id'];
    nama = json['nama'];
    tanggal = json['tanggal'];
    if (json['pemilik'] != null) {
      pemilik = <Pemilik>[];
      json['pemilik'].forEach((v) {
        pemilik!.add(Pemilik.fromJson(v));
      });
    }
    semuakota = json['semuakota'] != null
        ? Semuakota.fromJson(json['semuakota'])
        : null;
  }
}

class Pemilik {
  int? id;
  int? komoditasId;
  int? subkomoditasId;
  int? kotaId;
  int? pasarId;
  String? createdAt;
  String? updatedAt;
  List<Rekapharga>? rekapharga;
  List<TabelHarga>? tabelharga;
  Indicator? indicator;
  KotaModel? kota;

  Pemilik(
      {this.id,
      this.komoditasId,
      this.subkomoditasId,
      this.kotaId,
      this.pasarId,
      this.createdAt,
      this.updatedAt,
      this.rekapharga,
      this.tabelharga,
      this.indicator,
      this.kota});

  Pemilik.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    komoditasId = json['komoditas_id'];
    subkomoditasId = json['subkomoditas_id'];
    kotaId = json['kota_id'];
    pasarId = json['pasar_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['rekapharga'] != null) {
      rekapharga = <Rekapharga>[];
      json['rekapharga'].forEach((v) {
        rekapharga!.add(Rekapharga.fromJson(v));
      });
    }
    if (json['tabelharga'] != null) {
      tabelharga = <TabelHarga>[];
      json['tabelharga'].forEach((v) {
        tabelharga!.add(TabelHarga.fromJson(v));
      });
    }
    indicator = json['indicator'] != null
        ? Indicator.fromJson(json['indicator'])
        : null;
    kota = json['kota'] != null ? KotaModel.fromJson(json['kota']) : null;
  }
}

class TabelHarga {
  int? harga;
  String? tanggal;

  TabelHarga({this.harga, this.tanggal});

  TabelHarga.fromJson(Map<String, dynamic> json) {
    harga = json['harga'];
    tanggal = json['tanggal'];
  }
}

class Rekapharga {
  int? id;
  int? pemilikId;
  int? harga;
  int? dk;
  int? dp;
  String? tanggal;
  String? hari;

  Rekapharga({
    this.id,
    this.pemilikId,
    this.harga,
    this.dk,
    this.dp,
    this.tanggal,
    this.hari,
  });

  Rekapharga.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pemilikId = json['pemilik_id'];
    harga = json['harga'];
    dk = json['dk'];
    dp = json['dp'];
    tanggal = json['tanggal'];
    hari = json['hari'];
  }
}

class Indicator {
  String? status;
  int? harga;
  double? persentase;

  Indicator({this.status, this.harga, this.persentase});

  Indicator.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    harga = json['harga'];
    persentase = json['persentase'].toDouble();
  }
}

class Semuakota {
  List<Rekapharga>? rekapharga;
  Indicator? indicator;

  Semuakota({this.rekapharga, this.indicator});

  Semuakota.fromJson(Map<String, dynamic> json) {
    if (json['rekapharga'] != null) {
      rekapharga = <Rekapharga>[];
      json['rekapharga'].forEach((v) {
        rekapharga!.add(Rekapharga.fromJson(v));
      });
    }
    indicator = json['indicator'] != null
        ? Indicator.fromJson(json['indicator'])
        : null;
  }
}

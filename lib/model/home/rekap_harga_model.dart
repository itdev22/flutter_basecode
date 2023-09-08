import 'package:mobile_lapalapa/model/home/kota_model.dart';

class RekapHargaModel {
  String? namaSubKomoditas;
  KotaModel? kota;
  int? harga;
  String? tanggal;
  Pesentase? pesentase;

  RekapHargaModel(
      {this.namaSubKomoditas,
      this.kota,
      this.harga,
      this.tanggal,
      this.pesentase});

  factory RekapHargaModel.fromJson(Map<String, dynamic> data) =>
      RekapHargaModel(
          namaSubKomoditas: data['subkomoditas'],
          kota: data['kota'] == null ? null : KotaModel.fromJson(data['kota']),
          harga: data['harga'],
          tanggal: data['tanggal'],
          pesentase: data['pesentase'] != null
              ? Pesentase.fromJson(data['pesentase'])
              : null);
}

class Pesentase {
  String? opsi;
  String? sekarang;
  String? kemaren;
  Original? persentase;

  Pesentase({this.opsi, this.sekarang, this.kemaren, this.persentase});

  Pesentase.fromJson(Map<String, dynamic> json) {
    opsi = json['opsi'];
    sekarang = json['sekarang'];
    kemaren = json['kemaren'];
    persentase = json['original'] != null && json['original'] != ""
        ? Original.fromJson(json['original'])
        : null;
  }
}

class Original {
  String? warna;
  int? value;

  Original({this.warna, this.value});

  Original.fromJson(Map<String, dynamic> json) {
    warna = json['warna'];
    value = json['value'];
  }
}
